---
name: obsidian-knowledge-base
description: >
  This skill should be used when the user asks to ingest, query, or
  maintain the knowledge base, or mentions knowledge base operations
  in the Obsidian vault.
metadata:
  version: "0.4.0"
---

# Obsidian Knowledge Base

An agent-maintained knowledge base inside the Obsidian vault. Ingest sources, build interlinked knowledge pages, query, and run maintenance.

## Required Capabilities

This skill requires read-only file access to inspect vault instructions and shell access to execute `obsidian` CLI read commands (such as `obsidian vault info=path` or `obsidian read`) or `qmd` if available. Instruction discovery and inspection must remain read-only; do not modify vault guides or notes while gathering context.

## Locating the Vault

Determine the vault directory in this order:
1. If already known from memory or conversation context, use that path.
2. Try `obsidian vault info=path` (requires the `obsidian` CLI).
3. If the path is unknown, ask the user for the vault directory path.

## Reading Instructions

Before performing any knowledge base operation, read the instructions from the vault saved in `Knowledge Base.md`.
This is the single source of truth for all conventions, operations, frontmatter rules, page templates, and naming conventions. Always read it before executing any operation.

If you have `qmd` available, use it to query or search the knowledge base.