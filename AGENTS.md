# Agent Instructions

This repository contains a collection of agent-neutral skills managed with `npx skills`.

## Repository Structure & Skill Layout

- Every skill lives in its own root directory matching its canonical frontmatter `name`: `<skill-name>/SKILL.md`.
- Skills are self-contained. Any optional supporting resources live in subdirectories beneath `<skill-name>/` (such as `references/`, `examples/`, `scripts/`, or `assets/`).
- Do not introduce plugin wrapper directories, marketplaces, or shared root resource directories.

## Portable Metadata

- Every skill entrypoint is `<skill-name>/SKILL.md` with YAML frontmatter containing `name` and `description`.
- `name` must be kebab-case, match the directory name exactly, and remain unique across the repository.
- Version numbers, if included, belong under `metadata.version` as quoted strings (e.g., `metadata.version: "0.1.0"`).
- Skills and instructions must remain agent-neutral: do not assume a specific LLM harness, vendor, model-routing configuration, or client-specific tool permission lists.

## Management Interface

- Installation, discovery, updates, and scaffolding use `npx skills`.
- To discover skills locally: `npx skills add . --list`
- To scaffold a new skill: `npx skills init <skill-name>` from the repository root.

## Adding or Updating Skills

- When adding or renaming a skill, ensure the directory name matches `name` in frontmatter.
- Keep `README.md` updated: add new skills to the alphabetical catalog table with their canonical name, description, and link to `<skill-name>/SKILL.md`.
- Document new dependencies or prerequisites directly in the skill's instructions.

## Validation Expectations

- All 22 skills must resolve as `<canonical-name>/SKILL.md`.
- Ensure all bundled references and example files resolve locally.
- Validate with `npx skills add . --list` and run local installation tests in temporary directories outside this repository.
- Run `git diff --check` to ensure no whitespace or formatting issues.

## Working Tree & Change Hygiene

- Preserve unrelated working-tree changes.
- Never commit installed copies of skills, `.agents/`, `.codex/`, `.claude/`, or `skills-lock.json` artifacts into this repository.
