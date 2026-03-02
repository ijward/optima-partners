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

### [2026-03-02] Deployment — Auto-commit System for `.github\*` Changes

**What happened**: Automated commit/merge system established for `.github\*` changes. GitHub Actions workflow (`.github/workflows/auto-commit-github-changes.yml`) runs every 2 hours to detect uncommitted changes. A9 Deployment Manager can trigger immediate commits after agent tasks using MCP GitHub tools. All changes are committed via PR with auto-merge workflow for safety and audit trail. Files modified: `.github/agents/a9-deployment-manager.md` updated with workflow documentation.

**Root cause / reason**: Manual git operations for agent instruction updates and workflow/configuration changes introduce friction and potential for missed updates. Automated system reduces manual overhead while maintaining full audit trail through PR records.

**Recommendation**: A9 Deployment Manager should use `mcp_io_github_git_push_files` tool to trigger immediate commits after major agent tasks, rather than waiting for the 2-hour workflow cycle. Document any new configuration changes to `.github\*` in commit messages for audit purposes. All changes require PR approval before merge to maintain quality control.

**Applied to**: A9 Deployment Manager (all agents that modify `.github\*` should be aware of this system)

---

### [2026-03-02] Deployment — Reusable Auto-commit Workflow Template Available for Project Integration

**What happened**: Auto-commit workflow template made reusable and available across all Optima Partners projects. Template location: [`.github/workflow-templates/auto-commit-github-changes/`](.github/workflow-templates/auto-commit-github-changes/). The template includes a parameterized `workflow.yml` with configurable options: schedule frequency, target directory, commit message text, and auto-merge label criteria. Documentation with setup instructions provided for other projects. Template is accessible via GitHub workflow templates UI or direct file copy. The sync-agents workflow automatically propagates this template to other repositories.

**Root cause / reason**: Standardized workflow templates reduce setup time and ensure consistent automation practices across all repositories. Parameterization enables projects to customize behavior while maintaining a single source of truth for the workflow logic.

**Recommendation**: When onboarding new projects, offer the auto-commit template as a standard deployment automation option. Document in project onboarding checklists. Monitor sync-agents logs to verify template propagation across target repositories. Consider creating additional parameterized templates for common deployment patterns (e.g., scheduled deployments, environment-specific workflows, release automation).

**Applied to**: A9 Deployment Manager (all projects can leverage this template)

---

### [2026-03-02] Security — PowerShell Execution Policy Configured for .github/* Automation

**What happened**: PowerShell execution policy configured for `.github/*` automation scripts to enable seamless execution in both GitHub Actions and local Windows development. Created configuration file `.github/pwsh-config.ps1` with helper functions. Execution Policy set to `RemoteSigned` (CurrentUser scope) for trusted paths: `.github/scripts/`, `.github/workflows/`, `.github/setup/`. Scripts execute without permission prompts or elevation requirements. Related files created: `.github/scripts/example.ps1`, `.github/workflow-templates/powershell-automation/` directory. Updated documentation in `.github/agents/a9-deployment-manager.md` and `.github/README.md`.

**Root cause / reason**: PowerShell scripts require explicit execution policy configuration to run without permission dialogs. `RemoteSigned` policy balances security (local scripts trusted, downloaded scripts require signatures) with automation convenience across local dev and GitHub Actions environments.

**Recommendation**: Developers using PowerShell automation should reference `.github/pwsh-config.ps1` for available helper functions. New PowerShell scripts placed in `.github/scripts/` and workflows are automatically trusted under the configuration. Monitor for scripts requiring digital signatures (downloaded from internet) and apply signing when necessary. Document any new helper functions added to `pwsh-config.ps1` for team awareness.

**Applied to**: A9 Deployment Manager, all agents utilizing PowerShell automation in workflows

---

### [2026-03-02] General — Template initialised

**What happened**: A9 template created with core sub-agents: A9 Task Manager, A9 Learning Monitor, A9 Planning Manager, A9 Developer, A9 Developer Assistant, A9 Testing Manager, A9 Web Development Manager, A9 Security Manager, A9 Deployment Manager.
**Root cause / reason**: Initial setup.
**Recommendation**: Review sub-agent coverage after first full project cycle and add specialist sub-agents as needed (e.g. A9 Databricks Manager, A9 XML Validation Manager).
**Applied to**: all
