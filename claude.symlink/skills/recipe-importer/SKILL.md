# Recipe Importer Skill

## Purpose

Fetch a recipe from a URL, convert it to Cooklang format, validate the syntax, and save it as a reference note in Obsidian.

## Trigger

Use this skill when the user provides a recipe URL and wants it saved to their notes, or says something like "add this recipe", "save this recipe", "import this recipe".

## Output Location

`/Users/andrewdt/workspace/obsidian-notes/notes/references/cooklang/<recipe-name>.cook`

Filename: lowercase, spaces replaced with hyphens, no special characters. E.g. "Miso Glazed Salmon" → `miso-glazed-salmon.cook`.

---

## Workflow

### Step 1: Fetch the Recipe

Use WebFetch on the provided URL. Extract:
- Recipe name
- Description/summary (1–2 sentences, if present)
- Ingredients with quantities and units
- Steps in order
- Source URL

### Step 2: Convert to Cooklang Format

Convert to Cooklang following the spec and the conventions in the user's existing recipes.

**File structure:**
```
-- tags: food, recipe
-- <One or two sentence description of the dish.>

-- <Section Name>
<Step text with Cooklang annotations>

-- <Section Name>
<Step text with Cooklang annotations>

-- References
-- [<source title>](<url>)
```

**Cooklang syntax rules:**

| Syntax | Meaning | Example |
|---|---|---|
| `@ingredient{qty%unit}` | Ingredient with quantity | `@garlic{3%cloves}` |
| `@ingredient{}` | Ingredient, quantity unspecified | `@olive oil{}` |
| `@ingredient` | Ingredient mentioned inline, no quantity block needed | `@salt` |
| `~{duration%unit}` | Anonymous timer | `~{10%minutes}` |
| `~name{duration%unit}` | Named timer | `~simmer{5%minutes}` |
| `#cookware{}` | Cookware | `#pan{}` |
| `-- text` | Comment or section header | `-- Sauce` |
| `{qty%unit}` | Quantity reference (re-use ingredient already named) | `{2%tbsp}` |

**Conventions from existing recipes:**
- Group steps into logical sections with `-- Section Name` headers (Setup, Cook, Adjust, etc.)
- Use `--` description line at the top before the first section
- Inline the ingredient annotation where it first appears naturally in the sentence
- Re-reference ingredients without repeating the full annotation (just `@ingredient{}` or plain text) in subsequent mentions
- Timers use `~` and should include a descriptive name if the timer is for a specific action (e.g. `~simmer{10%minutes}`, `~cook1{6%min}`)
- **Always use generic ingredient names — never brand names.** Strip brand prefixes and product names down to the general ingredient. Examples: "Bob's Red Mill Gluten-Free All-Purpose Baking Flour" → `gluten free all purpose baking flour`; "Heinz Tomato Ketchup" → `ketchup`; "Swanson Chicken Broth" → `chicken broth`.

### Step 3: Validate Cooklang Syntax

Before saving, check the generated content against these rules:

**Must pass:**
- [ ] Every `@ingredient` that has a quantity uses `{qty%unit}` or `{}` — no bare `@ingredient 2 cups` style
- [ ] Every `~timer` uses `{qty%unit}` format — e.g. `~{10%minutes}` not `~ 10 minutes`
- [ ] No unclosed `{` or `}` brackets
- [ ] Quantities use `%` as separator, not spaces or slashes — `{2%tbsp}` not `{2 tbsp}` or `{2/tbsp}`
- [ ] Units are written out or abbreviated consistently (don't mix `g` and `grams` in same file)
- [ ] File starts with `-- tags: food, recipe` (no YAML frontmatter)
- [ ] File has at least one `-- References` section with the source URL

If any check fails, fix the issue before saving. Do not save a file that fails validation.

### Step 4: Save the File

Write the file to `/Users/andrewdt/workspace/obsidian-notes/notes/references/<filename>.md`.

Then confirm to the user:
- File path saved to
- Number of ingredients found
- Number of sections
- Any notes about the conversion (e.g. missing quantities on the source, judgment calls made)
