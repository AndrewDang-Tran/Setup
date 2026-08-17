# Reddit Skill

## Purpose

Read Reddit posts and comments to get community opinions, long-term ownership reports, and specialist knowledge — sources that general review sites miss.

## Trigger

Use this skill whenever research would benefit from Reddit community data: product reliability, real-world experiences, niche recommendations, or any time WebFetch from reddit.com fails.

## Workflow

### Step 1: Find threads via Reddit RSS search

Use curl with a browser UA to search Reddit's RSS endpoint directly — WebFetch is blocked by Reddit, but curl with a real UA gets 200 every time:

```bash
curl -s \
  -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:140.0) Gecko/20100101 Firefox/140.0" \
  -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" \
  -H "Accept-Language: en-US,en;q=0.5" \
  "https://www.reddit.com/r/SUBREDDIT/search.rss?q=QUERY&sort=top&restrict_sr=1&limit=10"
```

Parse `<link href="..."/>` tags from the XML to extract thread URLs. You can also omit `restrict_sr=1` to search all of Reddit.

### Step 2: Fetch thread content

Run fetch.py for each URL:

```bash
python3 /Users/andrewdt/.claude/skills/reddit/fetch.py "<url>" [max_comments]
```

Default is 10 comments. Use 20–30 for popular threads with lots of signal.

### Step 3: Aggregate

Do not rely on a single thread. Aggregate mentions across threads:
- An item or opinion mentioned across 3+ threads outweighs a single highly-upvoted comment
- Note commenter context (repair tech, long-term owner, first-time buyer) when discernible
- Prefer comments with high scores and substantive content over short reactions

## Notes

- fetch.py handles Reddit's JS verification challenge automatically — no API key needed
- If a thread URL 404s or returns no data, skip it and try the next result
- Subreddits with strong signal for appliances: r/appliancerepair, r/Appliances, r/HomeImprovement
