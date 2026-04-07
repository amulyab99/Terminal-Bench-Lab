#!/bin/bash
# 
# Terminal Bench 2.0 - Security Tasks Lab
# Agent: terminus-2 | Model: claude-sonnet-4-6 | Harness: Harbor 0.3.0

# -----------------------------------------------------------------------------
# STEP 1: Install uv 
# -----------------------------------------------------------------------------
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# -----------------------------------------------------------------------------
# STEP 2: Install Harbor
# -----------------------------------------------------------------------------
uv tool install harbor

# Verify Harbor installed correctly
harbor --version

# -----------------------------------------------------------------------------
# STEP 3: Set Anthropic API key 
# -----------------------------------------------------------------------------
export ANTHROPIC_API_KEY=your-api-key-here

# -----------------------------------------------------------------------------
# STEP 4: Fix Docker permissions in WSL
# -----------------------------------------------------------------------------
sudo usermod -aG docker $USER
# Close and reopen terminal after this, then verify with:
docker ps

# -----------------------------------------------------------------------------
# STEP 5: Smoke test with the oracle agent (no API credits used)
# -----------------------------------------------------------------------------
harbor run \
  --dataset terminal-bench@2.0 \
  --agent oracle \
  --n-concurrent 1 \
  --task terminal-bench/filter-js-from-html

# -----------------------------------------------------------------------------
# STEP 6: Run security tasks with Claude (terminus-2 agent)
# terminus-2 is Harbor's own agent wrapper around Claude
# Scores: 1.000 = pass, 0.000 = fail
# -----------------------------------------------------------------------------

# Task 1: openssl-selfsigned-cert (PASS - score: 1.000)
# Generate a self-signed TLS certificate using OpenSSL with specific requirements
harbor run \
  --dataset terminal-bench@2.0 \
  --agent terminus-2 \
  --model anthropic/claude-sonnet-4-6 \
  --n-concurrent 1 \
  --task terminal-bench/openssl-selfsigned-cert \
  --agent-env ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY

# Task 2: git-leak-recovery (PASS - score: 1.000)
# Recover a secret accidentally committed to a git repo then removed from history
harbor run \
  --dataset terminal-bench@2.0 \
  --agent terminus-2 \
  --model anthropic/claude-sonnet-4-6 \
  --n-concurrent 1 \
  --task terminal-bench/git-leak-recovery \
  --agent-env ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY

# Task 3: vulnerable-secret (PASS - score: 1.000)
# Analyze a binary executable to extract a hidden FLAG{...} secret key
harbor run \
  --dataset terminal-bench@2.0 \
  --agent terminus-2 \
  --model anthropic/claude-sonnet-4-6 \
  --n-concurrent 1 \
  --task terminal-bench/vulnerable-secret \
  --agent-env ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY

# Task 4: password-recovery (PASS - score: 1.000)
# Forensic recovery of a deleted file containing a password from /app directory
harbor run \
  --dataset terminal-bench@2.0 \
  --agent terminus-2 \
  --model anthropic/claude-sonnet-4-6 \
  --n-concurrent 1 \
  --task terminal-bench/password-recovery \
  --agent-env ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY

# Tasks that were attempted but failed:
# - filter-js-from-html: agent ran but did not correctly strip all JS
# - sanitize-git-repo: agent ran but missed some API keys
# - crack-7z-hash: timed out / did not complete

