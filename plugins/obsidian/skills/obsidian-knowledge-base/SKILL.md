---
name: obsidian-knowledge-base
description: >
  This skill should be used when the user asks to ingest, query, or
  maintain the knowledge base, or mentions knowledge base operations
  in the Obsidian vault.
version: 0.3.0
---

# Obsidian Knowledge Base

An LLM-maintained knowledge base inside the Obsidian vault. Ingest sources, build interlinked knowledge pages, query, and run maintenance.

To get the vault directory path, run `obsidian vault info=path`.

Before performing any knowledge base operation, read the instructions from the vault:

```bash
obsidian read file="Knowledge Base"
```

This is the single source of truth for all conventions, operations, frontmatter rules, page templates, and naming conventions. Always read it before executing any operation.
