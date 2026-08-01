# Shopping Skill

## Purpose

Help the user research and purchase items well. Identify the right dimensions to evaluate, surface high-quality options from trusted sources, present a clear comparison, then find the best place to buy.

## Trigger

Use this skill when the user wants to buy something, research a purchase, or asks for a recommendation on what to buy.

## Workflow

### Phase 1: Identify Dimensions of Consideration

Based on the item type, surface the relevant dimensions. **Cost is always one of them.**

Apply the cost philosophy:
- **Unsure how much I'll use it** → Recommend buying cheap to test. Note this explicitly.
- **Know I'll use it regularly** → Recommend balancing cost and utility. Note this explicitly.

Ask the user which cost scenario applies if unclear.

**Dimensions by category (use as a starting point, not an exhaustive list):**

| Category | Typical Dimensions |
|---|---|
| Electronics | Build quality, battery life, compatibility, repairability, portability, software/ecosystem |
| Kitchen gear | Ease of cleaning, durability, storage footprint, versatility, heat tolerance |
| Sports / fitness | Durability, weight, adjustability, safety, packability |
| Tools (hand/power) | Precision, ergonomics, durability, versatility, availability of replacement parts |
| Clothing / footwear | Fit, material quality, durability, breathability, care requirements |
| Furniture | Dimensions/fit in space, material durability, ease of assembly, repairability |
| Outdoor / camping | Weight, packability, weather resistance, durability, ease of setup |
| Audio / video | Sound/picture quality, form factor, connectivity, compatibility |
| Books / learning | Depth, accessibility, format (physical/digital/audio) |

After identifying the applicable dimensions, **ask the user which dimensions matter most for this purchase** before researching. Let them add or remove dimensions.

---

### Phase 2: Research Options

Search the internet for what options are available. The goal is to find what knowledgeable buyers and specialists consider the best choices — not what's merely popular or well-marketed.

**Source priority (highest to lowest):**
1. **Niche/specialist websites** — dedicated forums, fansites, and specialty publications with their own domain (e.g. BladeForums for knives, HomeBrewTalk for brewing gear, Head-Fi for headphones, Cycling Tips for bikes). These must be independent websites, not subreddits. These readers care deeply about the item and surface nuances that general review sites miss.
2. **Reddit** — search multiple threads and posts. Do not take a single post's upvotes at face value. Aggregate mentions across many different threads, deduplicating by item. An item mentioned positively across 8 threads with collective high upvotes outranks an item with one viral post.
3. **General review sites** (Wirecutter, RTINGS, etc.) — use negative reviews and test failures only. Ignore positive picks; these sites optimize for mainstream buyers and miss what specialists value.
4. **Amazon/retailer reviews** — use negative reviews only to identify recurring failure modes or dealbreakers. Ignore positive ratings; susceptible to manipulation.

**Sponsored/monetized content:** Before weighting any positive review, check whether the source runs affiliate links, accepts sponsored posts, or is otherwise monetized. If so, treat their positive recommendations with the same skepticism as general review sites — use them only for negative signals (failures, dealbreakers). Non-monetized independent sources and community forums are unaffected by this rule.

**What to look for:**
- Items that appear repeatedly across independent sources
- Specific praise or criticism tied to the dimensions identified in Phase 1
- "Hidden gem" options that specialist communities favor over mainstream picks
- Items with strong long-term ownership reports, not just first-impression reviews

---

### Phase 3: Present Options Table

Once research is complete, present options in a table. Columns should be:

1. **Item** (name + brief descriptor, linked to the product's official page or most authoritative listing)
2. **Cost** (approximate price range)
3. One column per dimension the user marked as important
4. **Notes** (anything that doesn't fit neatly in a column — caveats, "best for X type of buyer", etc.)

Every item in the table must have a link. Prefer the manufacturer's product page; fall back to the most reputable retailer if no official page exists. Always link to a singular item page, not a category, search results page, or multi-item listing.

Use a simple rating system per dimension: ✓ (good), ~ (acceptable), ✗ (weak), or a short phrase if binary doesn't capture it.

Below the table, include a **"Best for..."** summary — one sentence per option explaining who it's the right pick for.

---

### Phase 4: Find Purchase Options

After the user selects an item, search for the top 3 ways to buy it. Evaluate each on:

- **Cost** — total landed price including shipping, tax, and any membership costs
- **Feasibility** — is it actually in stock, available to ship to the user, no unusual barriers
- **Ease of receiving** — shipping speed, tracking, return policy, packaging reliability

Present as a short table:

| Source | Price | Feasibility | Ease of Receiving | Notes |
|---|---|---|---|---|

Give a clear recommendation on which option to use and why.

---

## Notes

- Always be explicit about which cost scenario applies (testing vs. known use) and how it shapes the recommendation.
- Do not recommend the most expensive option by default. The skill is about finding the right fit for the user, not the objectively "best" item.
- When aggregating Reddit data, cite the threads/posts you found so the user can verify.
- If a niche community has a clear consensus pick, lead with that and explain why specialists favor it.
