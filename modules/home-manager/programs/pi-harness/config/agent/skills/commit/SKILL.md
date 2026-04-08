---
name: commit
allowed-tools: git, ask_user
description: Uses the git tool to commit staged changes with a semantic commit message.
---

# Git Commit Skill

## Steps:
1. Review the staged changes using `git status` and `git diff --staged` to ensure that all changes are correct and ready to be committed.
2. Write a semantic commit message and commit the staged changes to the repository. The commit message should follow the format: <type>(<scope>): <description>. For example: feat(button): add new primary button style.
3. Ask the user to verify the commit message before finalizing the commit. If the user approves, proceed with the commit; otherwise, allow them to edit the message.
4. If the commit message is approved, use the `git commit` command to create the commit with the appropriate message.
