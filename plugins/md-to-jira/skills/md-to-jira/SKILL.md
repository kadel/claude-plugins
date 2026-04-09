---
name: md-to-jira
description: Converts Markdown text to Jira wiki markup syntax. Use when the user asks to "convert markdown to jira", "format for jira", "jira markup", "md to jira", or has markdown content they want to paste into Jira/Confluence.
---

# Markdown to Jira Converter

Convert GitHub-flavored Markdown to Jira wiki markup syntax directly in the conversation.

## When to Use

- User asks to convert markdown to Jira format
- User wants to paste markdown content into Jira or Confluence
- User mentions "jira markup", "jira wiki syntax", or "md to jira"
- User has a markdown file they want reformatted for Jira

## Conversion Rules

Apply these transformations in order. First extract and protect code blocks and inline code from further transformation, then apply all other rules, then restore code.

### 1. Code Blocks (extract first, restore last)

Fenced code blocks with optional language:

````
```javascript
code here
```
````

becomes:

```
{code:javascript}
code here
{code}
```

Without language: `{code}...{code}`

### 2. Inline Code

`` `code` `` becomes `{{code}}`

### 3. Headers

```
# H1       →  h1. H1
## H2      →  h2. H2
### H3     →  h3. H3
#### H4    →  h4. H4
##### H5   →  h5. H5
###### H6  →  h6. H6
```

### 4. Bold and Italic

- `**bold**` or `__bold__` → `*bold*`
- `*italic*` → `_italic_`

**Important:** Process bold first (replace `**` with Jira `*`), then convert remaining single `*` italic to `_`.

### 5. Strikethrough

`~~text~~` → `-text-`

### 6. Images

`![alt](url)` → `!url|alt=alt!` (or `!url!` if no alt text)

### 7. Links

`[text](url)` → `[text|url]`

### 8. Blockquotes

`> text` → `bq. text`

### 9. Horizontal Rules

`---`, `***`, or `___` → `----`

### 10. Unordered Lists (with nesting)

Nesting is determined by indentation (2 spaces per level):

```
- item         →  * item
  - nested     →  ** nested
    - deeper   →  *** deeper
```

### 11. Ordered Lists (with nesting)

```
1. item          →  # item
   1. nested     →  ## nested
```

### 12. Tables

Markdown:
```
| H1 | H2 |
|----|-----|
| D1 | D2 |
```

Jira:
```
||H1||H2||
|D1|D2|
```

The separator row (`|---|---|`) is removed. Header cells use `||` delimiters, data cells use `|`.

## How to Apply

1. If the user provides markdown text directly, convert it and output the Jira markup.
2. If the user points to a markdown file, read it, convert, and output the result.
3. Always output the converted Jira markup in a code block so the user can copy it easily.
4. If the input is large, process it section by section to avoid errors.
