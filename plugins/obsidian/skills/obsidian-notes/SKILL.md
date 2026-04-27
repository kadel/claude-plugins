---
name: obsidian-notes
description: >
  This skill should be used when the user asks about vault structure,
  note organization, where to put notes, or needs context about how
  the Obsidian vault is organized.
version: 0.2.0
allowed-tools:
  - Bash(obsidian vault*)
  - Bash(obsidian read*)
  - Bash(which obsidian*)
  - Read
---

# Obsidian Notes — Understanding the Vault

Provides context about how the user's Obsidian vault is organized so the LLM can work with notes effectively — finding, reading, creating, and placing notes in the right location.

## Locating the Vault

Determine the vault directory in this order:
1. If already known from memory or conversation context, use that path.
2. Try `obsidian vault info=path` (requires the `obsidian` CLI).
3. If the path is unknown, ask the user for the vault directory path.

## Reading Vault Guides

Before working with notes, read the vault organization guides. These are the single source of truth for folder structure, placement rules, decision logic, frontmatter conventions, and metadata rules per note type. Always read them before creating or organizing notes.

- `Vault Organization.md` (vault root)
- `Resources/Frontmatter Conventions.md`
