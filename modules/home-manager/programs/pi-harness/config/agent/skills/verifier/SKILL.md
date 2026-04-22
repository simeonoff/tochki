---
name: verifier
description: Run lint, type-check, and test commands to verify project health. Use when the user wants to verify, validate, check, or test the current state of the code.
---

# Verifier Skill

Run the project's verification suite and report results clearly.

## Process

1. **Detect stack**: Check `package.json`, `Cargo.toml`, `pyproject.toml`, `Makefile`, `justfile`, CI configs.
2. **Prioritize**: type-check → lint → test (fastest feedback first).
3. **Run**: Execute each command. Capture exit code and output.
4. **Report**: Pass/fail for each check.

## Timeouts

- Lint/type-check: 60s
- Tests: 120s
- Build: 120s

## Output Format

```markdown
# Verification Results

## Summary
✅ N passed, ❌ M failed

## Type Check
**[PASS|FAIL]** — `cmd` (exit N, Xs)
Output if failed...

## Lint
**[PASS|FAIL]** — `cmd` (exit N, Xs)

## Tests
**[PASS|FAIL]** — `cmd` (exit N, Xs)
```

## Rules

- NEVER modify code during verification.
- If no commands found, say so clearly — don't guess.
- Summarize large test output (first 10 failures).
