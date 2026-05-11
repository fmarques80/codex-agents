#!/usr/bin/env bash

set -e

mkdir -p ~/.codex

cp AGENTS.md ~/.codex/

mkdir -p ~/.codex/agents
mkdir -p ~/.codex/rules
mkdir -p ~/.codex/playbooks

cp agents/*.md ~/.codex/agents/
cp rules/*.md ~/.codex/rules/
cp playbooks/*.md ~/.codex/playbooks/

echo "Codex governance instalada."
