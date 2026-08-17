#!/usr/bin/env python3
"""Fetch and parse Reddit posts."""

import http.cookiejar
import json
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime
from typing import Any

# Browser-like UA so Reddit serves the JS challenge instead of an API block.
BROWSER_UA = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:140.0) "
    "Gecko/20100101 Firefox/140.0"
)


def get_relative_time(timestamp: float) -> str:
    """Get relative time string from Unix timestamp."""
    seconds = int(datetime.now().timestamp() - timestamp)
    if seconds < 60:
        return "just now"
    if seconds < 3600:
        return f"{seconds // 60}m ago"
    if seconds < 86400:
        return f"{seconds // 3600}h ago"
    if seconds < 604800:
        return f"{seconds // 86400}d ago"
    if seconds < 2592000:
        return f"{seconds // 604800}w ago"
    return f"{seconds // 2592000}mo ago"


def parse_comment(raw: dict, max_depth: int = 5) -> dict:
    """Parse a Reddit comment with nested replies."""
    data = raw.get("data", raw)

    replies = []
    if data.get("replies") and isinstance(data["replies"], dict):
        children = data["replies"].get("data", {}).get("children", [])
        replies = [
            parse_comment(c, max_depth)
            for c in children
            if c.get("kind") == "t1" and c.get("data", {}).get("depth", 0) < max_depth
        ]

    return {
        "author": data.get("author", "[deleted]"),
        "body": data.get("body", ""),
        "score": data.get("score", 0),
        "age": get_relative_time(data.get("created_utc", 0)),
        "is_op": data.get("is_submitter", False),
        "depth": data.get("depth", 0),
        "replies": replies,
    }


def parse_post(raw: dict) -> dict:
    """Parse a Reddit post."""
    data = raw.get("data", raw)
    return {
        "title": data.get("title", ""),
        "author": data.get("author", "[deleted]"),
        "subreddit": data.get("subreddit", ""),
        "content": data.get("selftext", ""),
        "score": data.get("score", 0),
        "upvote_ratio": data.get("upvote_ratio", 0),
        "num_comments": data.get("num_comments", 0),
        "age": get_relative_time(data.get("created_utc", 0)),
        "url": data.get("url", ""),
        "permalink": f"https://reddit.com{data.get('permalink', '')}",
        "is_nsfw": data.get("over_18", False),
        "flair": data.get("link_flair_text"),
    }


def format_comment(comment: dict, indent: int = 0) -> str:
    """Format a comment for display."""
    prefix = "  " * indent
    op_tag = " [OP]" if comment["is_op"] else ""
    header = f"{prefix}**u/{comment['author']}**{op_tag} ({comment['score']}↑, {comment['age']})"
    body = "\n".join(f"{prefix}  {line}" for line in comment["body"].split("\n"))

    result = f"{header}\n{body}"
    for reply in comment.get("replies", []):
        result += "\n" + format_comment(reply, indent + 1)
    return result


def _solve_challenge(html: str, opener: urllib.request.OpenerDirector) -> None:
    """Solve Reddit's "Please wait for verification" JS challenge.

    The challenge page embeds a tiny script: solution = seed + seed (the
    async (e => e + e)(seed) call). We replay that and submit the hidden
    GET form, which sets clearance cookies on the opener's cookie jar.
    """
    seed_m = re.search(r'\(async e=>e\+e\)\("([0-9a-f]+)"\)', html)
    token_m = re.search(r'name="token"\s+value="([0-9a-f]+)"', html)
    action_m = re.search(r'<form[^>]*action="([^"]+)"', html)
    if not (seed_m and token_m and action_m):
        return  # Not a challenge page (or format changed) - nothing to solve.

    solution = seed_m.group(1) * 2
    params = urllib.parse.urlencode({
        "solution": solution,
        "js_challenge": "1",
        "token": token_m.group(1),
        "jsc_orig_r": "",
    })
    submit_url = "https://www.reddit.com" + action_m.group(1) + "?" + params
    req = urllib.request.Request(submit_url, headers={
        "User-Agent": BROWSER_UA,
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
    })
    opener.open(req).read()  # Cookies get stored in the jar automatically.


def _browser_get(url: str, opener: urllib.request.OpenerDirector,
                 accept: str) -> str:
    req = urllib.request.Request(url, headers={
        "User-Agent": BROWSER_UA,
        "Accept": accept,
        "Accept-Language": "en-US,en;q=0.5",
    })
    try:
        with opener.open(req) as response:
            return response.read().decode("utf-8", errors="replace")
    except urllib.error.HTTPError as e:
        # A 403 still carries the JS challenge page in its body - return it
        # so the caller can solve the challenge and retry.
        return e.read().decode("utf-8", errors="replace")


def fetch_post(url: str, max_comments: int = 10) -> dict:
    """Fetch and parse a Reddit post with comments."""
    # Normalize URL to JSON endpoint
    if not url.endswith(".json"):
        url = url.rstrip("/") + ".json"

    # Add limit parameter
    if "?" in url:
        url += f"&limit={max_comments}"
    else:
        url += f"?limit={max_comments}"

    # Shared cookie jar so the challenge clearance carries into the .json hit.
    jar = http.cookiejar.CookieJar()
    opener = urllib.request.build_opener(
        urllib.request.HTTPCookieProcessor(jar)
    )

    # Reddit gates the JSON API behind a JS verification page. The *simple*
    # solvable challenge is served on the HTML post URL (without .json), so
    # warm up there first to earn clearance cookies, then hit the JSON.
    html_url = url.split(".json")[0]
    page = _browser_get(html_url, opener,
                        "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
    if "js_challenge" in page or "e=>e+e" in page:
        _solve_challenge(page, opener)

    body = _browser_get(url, opener, "application/json, text/plain, */*")
    data = json.loads(body)

    # Parse post (first element)
    post = parse_post(data[0]["data"]["children"][0])

    # Parse comments (second element)
    comments = [
        parse_comment(c)
        for c in data[1]["data"]["children"]
        if c.get("kind") == "t1"
    ]

    return {"post": post, "comments": comments}


def main():
    if len(sys.argv) < 2:
        print("Usage: fetch.py <reddit_url> [max_comments]")
        sys.exit(1)

    url = sys.argv[1]
    max_comments = int(sys.argv[2]) if len(sys.argv) > 2 else 10

    result = fetch_post(url, max_comments)
    post = result["post"]

    # Print post
    print(f"# {post['title']}")
    print(f"**r/{post['subreddit']}** | u/{post['author']} | {post['score']}↑ ({post['upvote_ratio']:.0%}) | {post['num_comments']} comments | {post['age']}")
    if post["flair"]:
        print(f"Flair: {post['flair']}")
    print()
    if post["content"]:
        print(post["content"])
        print()

    # Print comments
    print("---")
    print(f"## Top Comments ({len(result['comments'])} shown)")
    print()
    for comment in result["comments"]:
        print(format_comment(comment))
        print()


if __name__ == "__main__":
    main()
