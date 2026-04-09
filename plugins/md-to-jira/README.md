# md-to-jira

Convert Markdown to Jira wiki markup syntax for use in Jira and Confluence.

## Skills

### md-to-jira

Converts GitHub-flavored Markdown to Jira wiki markup syntax. Handles:
- Headers, bold, italic, strikethrough
- Code blocks and inline code
- Links and images
- Lists (ordered and unordered, with nesting)
- Tables
- Blockquotes and horizontal rules

## Usage

```bash
/md-to-jira
```

Then provide markdown text or point to a markdown file to convert.

## Examples

**Convert inline markdown:**
```
User: Convert this to Jira: **Bold text** and *italic*
Assistant: *Bold text* and _italic_
```

**Convert a file:**
```
User: Convert README.md to Jira format
Assistant: [reads file, converts, outputs Jira markup]
```

## License

MIT
