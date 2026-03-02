# Agents

This directory stores GitHub Copilot coding agent instruction files.

Each agent is defined as a Markdown (`.md`) file. Place your locally created agent files here to store and share them via GitHub.

## Available Agents

Located in this directory (`.github/agents/`):
- `a9-task-manager.md` — Orchestrates all project workflow phases
- `a9-developer.md` — Writes and modifies code
- `a9-developer-assistant.md` — Supports development tasks
- `a9-planning-manager.md` — Creates detailed project plans
- `a9-testing-manager.md` — Runs tests and validates code
- `a9-security-manager.md` — Performs security reviews
- `a9-deployment-manager.md` — Handles repository commits and deployment
- `a9-learning-log.md` — Project learning log (auto-maintained)
- `a9-learning-monitor.md` — Updates learning log after projects
- `a9-web-development-manager.md` — Creates web UIs and frontends

## Available Workflow Templates

Located in `.github/workflow-templates/`:
- **`auto-commit-github-changes/`** — Reusable workflow for automated configuration commits
  - Monitors directories for changes
  - Creates PRs on a configurable schedule (default: every 2 hours)
  - Auto-merges if configured
  - See [`.github/workflow-templates/auto-commit-github-changes/README.md`](../workflow-templates/auto-commit-github-changes/README.md) for integration guide

**Using Workflow Templates in Other Projects:**

To add the auto-commit workflow to any Optima Partners project:

```bash
# Step 1: Copy workflow to target project
cp /path/to/template/.github/workflow-templates/auto-commit-github-changes/workflow.yml \
   /path/to/target/.github/workflows/auto-commit.yml

# Step 2: Commit the file
cd /path/to/target
git add .github/workflows/auto-commit.yml
git commit -m "chore: add auto-commit workflow"
git push

# Step 3: Configure variables (optional)
# Go to Settings → Secrets and variables → Actions → Variables
# Set: SCHEDULE_FREQUENCY, DIRECTORY_TO_MONITOR, etc.

# Step 4: Enable auto-merge (optional)
# Go to Settings → General → Pull Requests
# Check "Allow auto-merge" and select merge method
```

For detailed instructions, see the [Auto-Commit Workflow README](../workflow-templates/auto-commit-github-changes/README.md).

## Usage

1. Copy your agent `.md` files into this directory.
2. Commit and push to GitHub as you would any other file.

For more information on creating and using agents, see the [GitHub Copilot documentation](https://docs.github.com/en/copilot/customizing-copilot/reusing-prompts-and-instructions-in-github-copilot#about-copilot-coding-agents).

## Keeping agents in sync across repositories

Two GitHub Actions workflows together keep agent files identical in every repository — changes made in **any** repo flow to **all** others automatically.

```
 ┌──────────────────────────────┐
 │  Any target repo             │
 │  .github/agents/*.md changed │
 └─────────────┬────────────────┘
               │ push-agents-to-central-template.yml
               ▼
 ┌──────────────────────────────┐
 │  ijward/optima-partners      │  ← central / source of truth
 │  .github/agents/ updated     │
 └─────────────┬────────────────┘
               │ sync-agents.yml (fan-out)
               ▼
 ┌──────────────────────────────┐
 │  All other repos updated     │
 └──────────────────────────────┘
```

### One-time setup

#### 1. Create a Personal Access Token (PAT)

Go to **GitHub → Settings → Developer settings → Personal access tokens** and create either:
- A **fine-grained token** with **Contents: Read and write** permission scoped to this central repository and every target repository, or
- A **classic token** with the `repo` scope.

Grant access to **this central repository and every target repository**.

#### 2. Add the PAT as a secret to every repository in the group

In **each** repository (including this one) go to **Settings → Secrets and variables → Actions → New repository secret**:
- Name: `SYNC_TOKEN`
- Value: your PAT from step 1.

#### 3. List target repositories (central repo only)

- Open `.github/sync-agents-targets.txt` in this repository.
- Add one `owner/repo` entry per line for every repository that should receive agent updates.

#### 4. Install the push-back workflow in each target repository

In **each target repository** (not this one), copy the template file and rename it:

```
.github/agents/push-agents-to-central-template.yml
         ↓  copy to
.github/workflows/push-agents-to-central.yml
```

Open the copy and update the `CENTRAL_REPO` variable at the top to match this repository (`ijward/optima-partners`).

---

Once set up, the sync works in both directions:

| Where the change is made | What happens |
|---|---|
| This central repo | `sync-agents.yml` pushes the update to every repo in `sync-agents-targets.txt` |
| Any target repo | `push-agents-to-central.yml` pushes the update to this central repo, which then fans it out to all other repos |

A loop-guard on both workflows means commits created by the sync bot will not trigger another sync cycle.

### Manual sync

You can also trigger a full fan-out at any time without making a code change:

1. Go to **Actions → Sync Agents to Target Repositories**.
2. Click **Run workflow**.
3. Optionally enable **Dry run** to preview what would be committed without actually pushing.
