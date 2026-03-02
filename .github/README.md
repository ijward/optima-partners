# `.github` Documentation Hub

This directory contains all GitHub configuration, agents, automation workflows, and skills for the Optima Partners development system.

## 📑 Directory Structure

### 📂 `agents/`

GitHub Copilot agent definitions that orchestrate the A9 development system.

**Key files:**

- `a9-task-manager.md` — Main entry point; orchestrates all phases
- `a9-developer.md` — Code writing and modifications
- `a9-testing-manager.md` — Testing and validation
- `a9-deployment-manager.md` — CI/CD, branching, and deployment
- `a9-security-manager.md` — Security analysis
- `a9-learning-log.md` — Project experience log

See [agents/README.md](agents/README.md) for:

- How to use agents
- Agent sync setup across repositories
- Adding new agents
- Keeping agents synchronized

### 📂 `workflow-templates/`

Reusable GitHub Actions workflow templates for cross-project use.

**Available templates:**

- **`auto-commit-github-changes/`** — Automated configuration commits
  - Monitors directories for changes
  - Creates PRs on a schedule
  - Optionally auto-merges
  - Fully customizable via repository variables
  - [Full documentation](workflow-templates/auto-commit-github-changes/README.md)

- **`powershell-automation/`** — PowerShell-based automation (Windows runners)
  - Executes `.ps1` scripts without permission prompts
  - Configurable execution policies
  - Trusted script paths for security
  - [Full documentation](workflow-templates/powershell-automation/README.md)

**To use a template in another project:**

```bash
# Copy workflow to your project
mkdir -p .github/workflows
cp .github/workflow-templates/auto-commit-github-changes/workflow.yml \
   .github/workflows/auto-commit.yml

# Commit and push
git add .github/workflows/auto-commit.yml
git commit -m "chore: add auto-commit workflow"
git push
```

### 📂 `skills/`

Specialized skill modules extending agent capabilities.

Available skills:

- `web-ui/` — Web development and UI creation
- `xml/` — XML processing and validation
- `databricks/` — Databricks integration

### 📂 `workflows/`

Active GitHub Actions workflows for this repository.

**Key workflows:**

- `sync-agents.yml` — Synchronizes agents to target repositories (automatic on push to main)
- `push-agents-to-central.yml` — Pushes agent changes from target repos to central (reverse sync)

### 📄 Configuration Files

- **`sync-agents-targets.txt`** — List of target repositories for agent synchronization
  - One entry per line in format: `owner/repo-name`
  - Changes here trigger or skip automatic syncs

## 🚀 Quick Start

### To start a development project

1. Open VS Code with this repository
2. Press `Ctrl+Alt+I` (Windows/Linux) or `Cmd+Option+I` (Mac)
3. Switch to **Agent** mode
4. Select **A9 Task Manager** with `@`
5. Describe your project in natural language
6. Approve the plan and let the agents work

For detailed guidance, see [A9_TEMPLATE_GUIDE.md](../A9_TEMPLATE_GUIDE.md)

### To add automation to a project

1. Choose a workflow template from `workflow-templates/`
2. Copy the workflow file to your project's `.github/workflows/`
3. Commit and configure variables as needed
4. Automation runs automatically on schedule

For detailed templates and examples, see:

- [Auto-Commit Workflow Documentation](workflow-templates/auto-commit-github-changes/README.md)

## 🔄 Agent Synchronization

Agents are kept in sync across multiple repositories automatically.

**How it works:**

1. Central repo (ijward/optima-partners) is the source of truth
2. Changes here are automatically pushed to all target repos
3. Changes in target repos are pushed back to central, then fanned out to all others

**Setup required (one-time per repo):**

- Personal Access Token in repository secrets (named `SYNC_TOKEN`)
- Push-back workflow: `.github/workflows/push-agents-to-central.yml`
- Target repo listed in `sync-agents-targets.txt`

See [agents/README.md](agents/README.md) for complete setup instructions.

## 📖 Documentation

- **[A9_TEMPLATE_GUIDE.md](../A9_TEMPLATE_GUIDE.md)** — User guide for the A9 system (recommended starting point)
- **[agents/README.md](agents/README.md)** — How to create, use, and sync agents
- **[agents/a9-deployment-manager.md](agents/a9-deployment-manager.md)** — Deployment process and reusable templates
- **[workflow-templates/auto-commit-github-changes/README.md](workflow-templates/auto-commit-github-changes/README.md)** — Auto-commit workflow setup and troubleshooting

## 🔐 Security Considerations

- **Secrets Management:** All PATs and credentials must be added to repository secrets (Settings → Secrets and variables → Actions)
- **Sync Token:** The `SYNC_TOKEN` secret enables agent synchronization; keep it secure
- **Branch Protection:** Branch protection rules are recommended for the default branch
- **Code Review:** All agent changes should be reviewed before merging to `main`

### 🔐 PowerShell Permissions & Execution Policy

All PowerShell scripts in `.github/*` are configured to run **without permission prompts**, while maintaining security standards.

#### Quick Reference

| Use Case | Command |
| --- | --- |
| **Local Windows dev** | `. .\.github\pwsh-config.ps1` in PowerShell before running scripts |
| **GitHub Actions (Windows runner)** | Add `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force` to workflow step |
| **Run a script** | `. .\.\github\pwsh-config.ps1` then `& ".\.\github\scripts\script.ps1"` |

#### Execution Policy

- **Policy**: `RemoteSigned` (no prompts for local scripts)
- **Scope**: `CurrentUser` (no elevation required)
- **Applies to**: All scripts in `.github/scripts/`, `.github/workflows/`, `.github/setup/`

#### GitHub Actions Workflow Setup

Add this step at the start of any Windows job using PowerShell:

```yaml
- name: Configure PowerShell automation
  shell: pwsh
  run: |
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    . .\.github\pwsh-config.ps1
```

#### Configuration File

- **Location**: [`.github/pwsh-config.ps1`](pwsh-config.ps1)
- **Functions**: `Set-GitHubAutomationPolicy`, `Get-TrustedScriptPaths`, `Test-ScriptSignature`, `Invoke-TrustedScript`
- **Documentation**: See [agents/a9-deployment-manager.md](agents/a9-deployment-manager.md#security-configuration) → Security Configuration section

#### Trusted Script Paths

Scripts in these directories execute without permission checks:

- `.github/scripts/` — Automation and deployment scripts
- `.github/workflows/` — GitHub Actions workflow scripts
- `.github/setup/` — Environment configuration scripts

## 🐛 Common Issues & Solutions

| Issue | Solution |
| --- | --- |
| A9 Task Manager not visible | Ensure `.github/agents/a9-task-manager.md` exists; restart VS Code |
| Agents not syncing to other repos | Check `SYNC_TOKEN` is set in repository secrets; verify repo listed in `sync-agents-targets.txt` |
| Workflow not triggering on schedule | Verify scheduled workflows are enabled in repository settings; make a commit to "wake up" the scheduler |
| Auto-commit workflow failing | Check workflow has `contents: write` and `pull-requests: write` permissions; verify auto-merge settings |
| Link to agent/workflow not working | Links should use relative paths; verify file exists at target location |

## 📞 Support

For issues with:

- **Development workflow** → Tell A9 Task Manager in the chat
- **Specific workflow failures** → Check GitHub Actions → View logs
- **Agent changes** → Create a new issue describing the desired behavior
- **Setup/permissions** → See relevant documentation sections above

## 📅 Last Updated

March 2, 2026 — Comprehensive documentation audit and expansion
