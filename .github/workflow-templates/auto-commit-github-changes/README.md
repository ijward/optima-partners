# Auto-Commit Configuration Changes Workflow

A reusable GitHub Actions workflow that automatically detects changes in specified configuration directories, creates commits and pull requests, and optionally auto-merges them.

## 📋 What It Does

This workflow:

1. **Monitors** specified directories for uncommitted changes (default: `.github`)
2. **Detects** changes on a configurable schedule (default: every 2 hours)
3. **Creates** a new branch with timestamped naming
4. **Commits** changes with a customizable message prefix
5. **Creates** a pull request for review
6. **Auto-merges** the PR if configured (with fallback to immediate merge)

Useful for:
- Keeping configuration files synchronized
- Automating infrastructure-as-code updates
- Centralizing GitHub Actions and workflows
- Reducing manual commit overhead for routine config changes

## 🚀 How to Use in Other Projects

### Step 1: Copy the Workflow File

Copy the workflow template to your project:

```bash
mkdir -p .github/workflows
cp .github/workflow-templates/auto-commit-github-changes/workflow.yml .github/workflows/auto-commit.yml
```

Or use this as a starting template and customize as needed.

### Step 2: Configure Variables (Optional)

Set GitHub Actions variables in your repository settings to customize behavior:

| Variable | Description | Default |
|----------|-------------|---------|
| `SCHEDULE_FREQUENCY` | Cron schedule for workflow runs | `0 */2 * * *` (every 2 hours) |
| `DIRECTORY_TO_MONITOR` | Directory path to monitor | `.github` |
| `COMMIT_MESSAGE_PREFIX` | Prefix for commit messages | `Update` |
| `AUTO_MERGE_LABEL` | Label for auto-merge detection | `auto-merge` |
| `BASE_BRANCH` | Base branch for PRs | `main` |

**Setting Variables in GitHub UI:**
1. Go to Settings → Secrets and variables → Actions
2. Select "Variables" tab
3. Click "New repository variable"
4. Add each variable with desired value

### Step 3: Enable Workflow

The workflow is automatically enabled once added to `.github/workflows/`.

You can also trigger it manually:
```bash
gh workflow run auto-commit.yml
```

## 📊 Available Parameters

### Schedule Frequency (Cron)

The `SCHEDULE_FREQUENCY` variable controls when the workflow runs. Examples:

- `0 */2 * * *` - Every 2 hours (default)
- `0 */4 * * *` - Every 4 hours
- `0 0 * * *` - Daily at midnight UTC
- `0 9 * * MON` - Every Monday at 9 AM UTC
- `*/30 * * * *` - Every 30 minutes

[Cron Expression Helper](https://crontab.guru/)

### Directory to Monitor

Set `DIRECTORY_TO_MONITOR` to any path in your repository:
- `.github` - GitHub configurations
- `config` - Application configuration
- `infra` - Infrastructure files
- etc.

### Commit Message Prefix

Customize commit messages via `COMMIT_MESSAGE_PREFIX`:
- `"Update"` → "Update .github configuration files"
- `"chore: Sync"` → "chore: Sync .github configuration files"
- `"[Auto]"` → "[Auto] .github configuration files"

### Auto-Merge Label

The workflow labels PRs with `AUTO_MERGE_LABEL` (default: `auto-merge`).

**To enable auto-merge in GitHub:**
1. Go to Settings → General
2. Scroll to "Pull Requests"
3. Check "Allow auto-merge"
4. Configure your preferred merge method

## 📝 Example Implementation

### Basic Setup (Using All Defaults)

```yaml
# .github/workflows/auto-commit.yml
name: Auto-Commit Configuration Changes

on:
  schedule:
    - cron: '0 */2 * * *'  # Every 2 hours
  workflow_dispatch:

jobs:
  auto-commit:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write

    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Check for uncommitted changes
        id: check-changes
        run: |
          if git status --short | grep -q "^\s*[AM].*\.github/"; then
            echo "has_changes=true" >> $GITHUB_OUTPUT
          else
            echo "has_changes=false" >> $GITHUB_OUTPUT
          fi

      - name: Commit and push changes
        if: steps.check-changes.outputs.has_changes == 'true'
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          
          TIMESTAMP=$(date +%s)
          BRANCH_NAME="auto-commit-github-changes-${TIMESTAMP}"
          
          git checkout -b $BRANCH_NAME
          git add .github/
          git commit -m "Update .github configuration files"
          git push origin $BRANCH_NAME
          
          echo "BRANCH_NAME=$BRANCH_NAME" >> $GITHUB_ENV

      - name: Create Pull Request
        if: steps.check-changes.outputs.has_changes == 'true'
        uses: actions/github-script@v7
        with:
          script: |
            const { BRANCH_NAME } = process.env;
            const pr = await github.rest.pulls.create({
              owner: context.repo.owner,
              repo: context.repo.repo,
              head: BRANCH_NAME,
              base: 'main',
              title: '[Auto] Update .github configuration files',
              body: 'Automated commit of .github directory changes.',
              labels: ['auto-merge']
            });
            core.setOutput('pr_number', pr.data.number);

      - name: Enable auto-merge
        if: steps.check-changes.outputs.has_changes == 'true'
        uses: actions/github-script@v7
        with:
          script: |
            const prNumber = ${{ steps.create-pr.outputs.pr_number }};
            try {
              await github.rest.pulls.enableAutoMerge({
                owner: context.repo.owner,
                repo: context.repo.repo,
                pull_number: prNumber,
                merge_method: 'merge'
              });
            } catch (error) {
              await github.rest.pulls.merge({
                owner: context.repo.owner,
                repo: context.repo.repo,
                pull_number: prNumber
              });
            }
```

### Advanced Setup (Custom Config Directory)

```yaml
# .github/workflows/sync-config.yml
name: Sync Configuration

on:
  schedule:
    - cron: '0 9 * * MON'  # Mondays at 9 AM
  workflow_dispatch:

env:
  DIRECTORY_TO_MONITOR: 'config'
  COMMIT_MESSAGE_PREFIX: 'chore: Sync'

jobs:
  # ... (rest of workflow template)
```

## 🔒 Permissions Required

The workflow requires:
- `contents: write` - To create commits and branches
- `pull-requests: write` - To create and manage pull requests

## 🐛 Troubleshooting

### "No changes detected" message
- Verify the monitored directory contains changes
- Check the cron schedule timing
- Run manually via `workflow_dispatch` to test immediately

### PR not auto-merging
- Ensure "Allow auto-merge" is enabled in repository settings
- Check branch protection rules aren't blocking auto-merge
- Verify the PR labels match `AUTO_MERGE_LABEL`

### Workflow not triggering on schedule
- GitHub Actions schedules are in UTC
- Adjust `SCHEDULE_FREQUENCY` cron expression
- Test manually first with `workflow_dispatch`

## 📚 References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Cron Expression Reference](https://crontab.guru/)
- [GitHub Script Action](https://github.com/actions/github-script)
- [Repository Variables](https://docs.github.com/en/actions/learn-github-actions/variables#creating-configuration-variables-for-a-repository)

## 📄 License

This workflow template is part of the A9 Deployment Manager infrastructure and is available for use across Optima Partners projects.

---

**Last Updated:** March 2, 2026
**Maintained by:** A9 Deployment Manager
