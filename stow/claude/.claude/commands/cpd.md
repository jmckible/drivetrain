---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git push:*), Bash(kamal deploy:*)
description: Commit, push to origin, and deploy
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -5`
- Working directory: !`pwd`

## Your task

Based on the above changes, commit, push, and deploy.

1. Stage all changes and create a single commit with an appropriate message
2. Push to origin
3. If the working directory is within `~/dev/vocal` (including worktrees like `~/dev/vocal--*`), SKIP the deploy step — deploys are handled by GitHub Actions
4. Otherwise, run `kamal deploy`

You have the capability to call multiple tools in a single response. Do as much as possible in a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.
