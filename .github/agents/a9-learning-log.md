# A9 Learning Log

This file is maintained by A9 Learning Monitor on behalf of A9 Task Manager. It records observations, outcomes and improvement recommendations from every project and milestone.

A9 Task Manager reviews this log at the start of every session before creating or updating a plan.

---

## How to Read This Log

Each entry follows this format:

```
### [YYYY-MM-DD] [Phase] — [Brief title]
**What happened**: ...
**Root cause / reason**: ...
**Recommendation**: ...
**Applied to**: [agent name or 'all']
```

Phases: `Planning` | `Development` | `Testing` | `Security` | `Deployment` | `General`

---

## Pending Sub-Agent Improvements

> A9 Learning Monitor updates this section whenever a recurring pattern suggests an agent's instructions need changing.
> A9 Task Manager applies the improvement to the relevant `.md` file and clears the entry.

*(No pending improvements yet)*

---

## Log Entries

### [2026-03-02] Testing — Proactive VS Code Diagnostics Monitoring

**What happened**: Markdown linting errors (229 issues) were found in skill files. Rather than waiting for user reports, A9 Testing Manager should scan for VS Code diagnostics proactively using the `get_errors` tool.

**Root cause / reason**: Quality issues can accumulate undetected if validation workflows only check syntax/structure but don't monitor IDE-level diagnostics (linting errors, formatting warnings, etc.).

**Recommendation**: A9 Testing Manager must include VS Code error checking as part of validation workflow. Use `get_errors` tool to scan files before declaring validation complete. This catches formatting issues, linting errors, and other problems before deployment.

**Applied to**: A9 Testing Manager

---

### [2026-03-02] Development — Skills Library Initialized (XML, DataBricks, Web/UI Flask)

**What happened**: A9 successfully created and deployed a core skills library containing 13 markdown files across 3 domains (XML, DataBricks, Web/UI Flask). Each skill file includes Purpose, When to Use, Core Concepts, Reference Examples, Common Pitfalls, Dependencies, and Limitations sections. Files were initially created, remediated for word-count compliance (2 files reduced from 700+ words to <500), validated, committed to main branch, and the sync workflow was updated to include `.github/skills/**` in the sync paths.

**Root cause / reason**: Skills library needed to support planned projects (XML validation, DataBricks efficiency, web mapping visualization). Template required structured, reusable knowledge assets for sub-agents to reference.

**Recommendation**: After first sub-agent usage of skills in a real project, capture feedback on:
1. Was the reference-card format ({Purpose, When to Use, Core Concepts, Reference Examples, Common Pitfalls, Dependencies, Limitations}) helpful?
2. Did sub-agents effectively find and reference the skills?
3. Should additional domains be added (e.g., Testing Patterns, Security Hardening, GitHub Workflows)?

**Applied to**: All sub-agents (especially A9 Developer, A9 Web Development Manager)

---

### [2026-03-02] General — Template initialised

**What happened**: A9 template created with core sub-agents: A9 Task Manager, A9 Learning Monitor, A9 Planning Manager, A9 Developer, A9 Developer Assistant, A9 Testing Manager, A9 Web Development Manager, A9 Security Manager, A9 Deployment Manager.
**Root cause / reason**: Initial setup.
**Recommendation**: Review sub-agent coverage after first full project cycle and add specialist sub-agents as needed (e.g. A9 Databricks Manager, A9 XML Validation Manager).
**Applied to**: all
