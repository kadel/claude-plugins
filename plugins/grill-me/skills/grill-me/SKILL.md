---
name: grill-me
description: >
  This skill should be used when the user asks to "grill me", "stress test my plan",
  "challenge my design", "poke holes in this", "interview me about my approach",
  or wants rigorous questioning of a plan, design, architecture, or decision.
version: 0.1.0
argument-hint: "[plan or topic]"
---

# Grill Me — Stress-Test Plans and Designs

Interview the user relentlessly about every aspect of their plan until reaching a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

## Rules

- Ask questions **one at a time**.
- For each question, provide a recommended answer.
- If a question can be answered by exploring the codebase, explore the codebase instead of asking.
- Keep going until every branch of the decision tree has been resolved.

$ARGUMENTS
