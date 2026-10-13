# Copilot instructions

The single source of truth for AI agent guidance in this repo is [AGENTS.md](../AGENTS.md) — follow it for all chat, agent, and code review work.

Path-specific rules: [.github/instructions/](instructions/). Reusable workflows (skills): [.claude/skills/](../.claude/skills/).

When reviewing PRs, prioritise: no secrets or signing material in git, tokens only in secure storage, no tokens/PII in logs, every network error mapped to `ApiException` and rendered as a user-facing state, loading/empty/error states present, accessibility (labels, 48dp targets, text scaling), and tests for new behaviour.
