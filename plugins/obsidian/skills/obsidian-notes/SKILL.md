---
name: obsidian-notes
description: >
  This skill should be used when the user asks about vault structure,
  note organization, where to put notes, or needs context about how
  the Obsidian vault is organized.
version: 0.1.0
allowed-tools:
  - Bash(obsidian vault*)
  - Bash(obsidian read*)
---

# Obsidian Notes — Understanding the Vault

Provides context about how the user's Obsidian vault is organized so the LLM can work with notes effectively — finding, reading, creating, and placing notes in the right location.

To get the vault directory path, run `obsidian vault info=path`.

Before working with notes, read the vault organization guides:

```bash
obsidian read file="Vault Organization"
obsidian read file="Frontmatter Conventions"
```

These are the single source of truth for folder structure, placement rules, decision logic, frontmatter conventions, and metadata rules per note type. Always read them before creating or reorganizing notes.
