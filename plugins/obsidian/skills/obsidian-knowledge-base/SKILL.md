---
name: obsidian-knowledge-base
description: >
  This skill should be used when the user asks to ingest, query, or
  maintain the knowledge base, or mentions knowledge base operations
  in the Obsidian vault.
version: 0.4.0
allowed-tools:
  - Bash(obsidian vault*)
  - Bash(obsidian read*)
  - Bash(which obsidian*)
  - Read
---

# Obsidian Knowledge Base

An LLM-maintained knowledge base inside the Obsidian vault. Ingest sources, build interlinked knowledge pages, query, and run maintenance.

## Locating the Vault

Determine the vault directory in this order:
1. If already known from memory or conversation context, use that path.
2. Try `obsidian vault info=path` (requires the `obsidian` CLI).
3. If the path is unknown, ask the user for the vault directory path.

## Reading Instructions

Before performing any knowledge base operation, read the instructions from the vault. This is the single source of truth for all conventions, operations, frontmatter rules, page templates, and naming conventions. Always read it before executing any operation.

- `Knowledge Base.md` (vault root)
