# Auto-Commit Configuration Changes Workflow

A reusable GitHub Actions workflow that automatically detects changes in specified configuration directories, creates commits and pull requests, and optionally auto-merges them.

## 📋 What It Does

This workflow:

1. **Monitors** specified directories for uncommitted changes (default: `.github`)
2. **Detects** changes on a configurable schedule (default: every 2 hours)
3. **Creates** a new branch with timestamped naming (format: `auto-commit-{directory-name}-{unix-timestamp}`)
4. **Commits** changes with a customizable message prefix
5. **Creates** a pull request with clear descriptions and labels
6. **Auto-merges** the PR if configured in repository settings (with fallback to immediate merge)

Useful for:
- Keeping configuration files synchronized
- Automating infrastructure-as-code updates
- Centralizing GitHub Actions and workflows
- Reducing manual commit overhead for routine config changes
- Ensuring consistency across team workflows
- Maintaining `.github/agents/` files synchronized across projects

---

## 🚀 Quick Start Integration Guide

Follow these step-by-step instructions to add this reusable workflow to any Optima Partners project.

### Step 1: Copy the Workflow Template to Your Project

Copy the workflow file from the central template repository:

```bash
# Navigate to your project root
cd /path/to/your-project

# Create workflows directory if it doesn't exist
mkdir -p .github/workflows

# Copy the workflow template
curl -o .github/workflows/auto-commit.yml \
  https://raw.githubusercontent.com/ijward/optima-partners/main/.github/workflow-templates/auto-commit-github-changes/workflow.yml
```

Or, if you have local access to the template:
```bash
cp /path/to/optima-partners/.github/workflow-templates/auto-commit-github-changes/workflow.yml \
   .github/workflows/auto-commit.yml
```

### Step 2: Commit the Workflow to Your Repository

```bash
git add .github/workflows/auto-commit.yml
git commit -m "chore: add auto-commit workflow for configuration synchronization"
git push origin main
```

### Step 3: Configure Variables (Optional but Recommended)

Set GitHub Actions variables to customize the workflow behavior. Variables override the default values in the workflow.

**To set variables in GitHub UI:**

1. Open your repository on GitHub.com
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click the **Variables** tab
4. Click **New repository variable**
5. For each variable below, enter the name and your desired value, then click **Add variable**

| Variable | Purpose | Default | Example Values |
|----------|---------|---------|-----------------|
| `SCHEDULE_FREQUENCY` | Cron schedule for automated workflow runs | `0 */2 * * *` | `0 */4 * * *` (every 4 hours)<br>`0 0 * * *` (daily at midnight UTC)<br>`0 9 * * MON` (Mondays at 9 AM UTC) |
| `DIRECTORY_TO_MONITOR` | Directory path to scan for changes | `.github` | `config`<br>`infra`<br>`.github/workflows`<br>`terraform` |
| `COMMIT_MESSAGE_PREFIX` | Text prefix for commit messages | `Update` | `chore: Sync`<br>`[Auto]`<br>`ci: Update` |
| `AUTO_MERGE_LABEL` | Label applied to PRs for identification | `auto-merge` | `auto-merge-config`<br>`automation`<br>`auto` |
| `BASE_BRANCH` | Target branch for pull requests | `main` | `develop`<br>`staging`<br>`production` |

**Example configuration for a project monitoring `config/` every 4 hours:**
```
SCHEDULE_FREQUENCY = 0 */4 * * *
DIRECTORY_TO_MONITOR = config
COMMIT_MESSAGE_PREFIX = chore: Sync
AUTO_MERGE_LABEL = auto-merge
BASE_BRANCH = main
```

### Step 4: Enable Auto-Merge in Repository Settings

To enable automatic PR merging (optional but recommended):

1. In your GitHub repository, go to **Settings** → **General**
2. Scroll to **Pull Requests** section
3. Check ☑️ **Allow auto-merge**
4. Select your preferred merge method:
   - **Create a merge commit** (recommended) — preserves full commit history
   - **Squash and merge** — cleaner history for release branches
   - **Rebase and merge** — linear history for feature branches

**Note:** If auto-merge is not enabled in repository settings, the workflow will fall back to immediately merging the PR.

### Step 5: Verify the Workflow is Working

After completing the setup:

```bash
# Check workflow was added successfully
git log --oneline -n 5 | grep "auto-commit"

# Use GitHub CLI to manually trigger and test the workflow immediately
gh workflow run auto-commit.yml

# View workflow execution history
gh workflow view auto-commit.yml --limit 10
```

You can also verify in the GitHub UI:
- Open your repository → **Actions** tab
- Look for the "Auto-Commit Configuration Changes" workflow
- Recent runs should appear with status ✅ **Success** or ❌ **Failure**

---

## 📊 Configuration Examples

### Example 1: Basic Setup (Default 2-Hour Sweep of `.github/`)

This configuration is already in the workflow file by default. No variables need to be set.

- Runs every 2 hours
- Monitors `.github` directory
- Uses standard commit prefix "Update"
- Creates PRs with `auto-merge` label
- Targets `main` branch

### Example 2: 6-Hour Config Directory Sweep

Configure these variables:
```
SCHEDULE_FREQUENCY = 0 */6 * * *
DIRECTORY_TO_MONITOR = config
COMMIT_MESSAGE_PREFIX = chore: Sync
```

This configuration:
- Runs every 6 hours
- Monitors `config` directory
- Creates commits like "chore: Sync config configuration files"
- Useful for infrastructure-as-code or application configurations that change less frequently

### Example 3: Daily Workflow Updates (Advanced)

For a project that frequently updates GitHub workflows and wants daily consolidation:

```
SCHEDULE_FREQUENCY = 0 9 * * MON,WED,FRI
DIRECTORY_TO_MONITOR = .github/workflows
COMMIT_MESSAGE_PREFIX = [Automation]
BASE_BRANCH = develop
```

This configuration:
- Runs Monday, Wednesday, Friday at 9 AM UTC (you can adjust time zone by changing cron)
- Monitors `.github/workflows` directory only
- Creates commits like "[Automation] .github/workflows configuration files"
- Targets `develop` branch instead of `main`

### Example 4: Multiple Monitored Directories per Repository

**Note:** This workflow monitors ONE directory at a time. To monitor multiple directories:

**Option A:** Create multiple workflow files with different configurations
```
.github/workflows/auto-commit-github.yml   (monitors .github)
.github/workflows/auto-commit-config.yml   (monitors config)
.github/workflows/auto-commit-infra.yml    (monitors infra)
```

Each file can have its own schedule and settings via different variable names or by editing the cron directly in each workflow file.

**Option B:** Monitor a parent directory
If you want to monitor both `config/` and `infra/`, set:
```
DIRECTORY_TO_MONITOR = .
```
This monitors the entire repository root (use with caution on large repos).

---

## 🔒 Permissions Required

The workflow file includes the minimum required permissions:

```yaml
permissions:
  contents: write        # Allows creating branches, commits, and pushing
  pull-requests: write   # Allows creating and managing pull requests
```

**These permissions allow the workflow to:**
- Create and push a new branch
- Commit changes to the branch
- Create pull requests
- Apply labels to PRs
- Enable auto-merge

No elevated permissions are needed if auto-merge is already enabled in repository settings.

---

## 🔍 Variable Precedence and Behavior

The workflow uses this precedence (highest to lowest):

1. **GitHub repository variables** (set in Settings → Secrets and variables → Actions)
2. **Environment variables in the workflow file** (defaults hardcoded in `workflow.yml`)
3. **Fallback defaults** in the workflow syntax itself

**Example:** If `SCHEDULE_FREQUENCY` repository variable is set to `0 12 * * *`, it will override the default `0 */2 * * *` for all runs of this workflow.

---

## 🐛 Troubleshooting

### Issue: Workflow doesn't trigger on schedule

**Possible causes and solutions:**

1. **GitHub Actions might be disabled for this repository**
   - Go to **Settings → Actions → General**
   - Ensure **Actions permissions** is set to "Allow all actions and reusable workflows"

2. **Cron schedules are in UTC time**
   - The `SCHEDULE_FREQUENCY` uses UTC (Coordinated Universal Time)
   - If you want 9 AM EST, use `0 14 * * *` (14:00 UTC, accounting for EST = UTC-5)
   - Use [Crontab.guru](https://crontab.guru/) to verify your cron expression

3. **The workflow hasn't run yet**
   - GitHub doesn't run scheduled workflows on repositories with no recent activity
   - Make a commit to the repository to "wake up" the scheduler
   - Then wait for the scheduled time

**Test:** Manually trigger the workflow to verify it works:
```bash
gh workflow run auto-commit.yml
```

### Issue: "No changes detected" but you see uncommitted files

**Possible causes and solutions:**

1. **The monitored directory path is incorrect**
   - Verify `DIRECTORY_TO_MONITOR` matches the actual path (case-sensitive on Linux)
   - Check with: `git status | grep <directory-name>`

2. **Files are staged but not committed**
   - The workflow checks for uncommitted/untracked changes with `git status`
   - Files must appear in `git status --short` output
   - Check with: `git status --short | head`

3. **Files are ignored by .gitignore**
   - Changes to ignored files won't be committed
   - Verify with: `git check-ignore -v <file-path>`

4. **Running on a repository with minimal activity**
   - GitHub disables scheduled workflows on inactive repositories after ~60 days
   - Make a push to activate: `git commit --allow-empty -m "chore: activate workflows"`

### Issue: PR not auto-merging

**Possible causes and solutions:**

1. **Auto-merge not enabled in repository settings**
   - Go to **Settings → General → Pull Requests**
   - Check ☑️ **Allow auto-merge**
   - This is a required one-time setup

2. **Branch protection rules blocking the merge**
   - Go to **Settings → Branches → Branch protection rules**
   - Check if rules require status checks or approvals
   - The `auto-merge` label can be used to bypass some rules if configured

3. **PR label doesn't match `AUTO_MERGE_LABEL` variable**
   - Verify the label applied to the PR matches your `AUTO_MERGE_LABEL` setting
   - Default label is `auto-merge`
   - Check PR details on GitHub to see applied labels

4. **Merge method not configured**
   - After enabling auto-merge in settings, verify you selected a merge method
   - Choose: **Create a merge commit** (recommended), **Squash and merge**, or **Rebase and merge**

**Fallback behavior:** If auto-merge fails, the workflow attempts immediate merge. Check PR details if merge fails.

### Issue: Workflow runs but creates no commits

**Possible causes and solutions:**

1. **Monitored directory hasn't changed**
   - The workflow checks for changes before creating a branch
   - If there are no changes, it stops and logs "No changes detected"
   - This is normal behavior: no-op when there's nothing to commit

2. **Git configuration issues in the workflow**
   - The workflow sets: `git config user.name "github-actions[bot]"` and `git config user.email "github-actions[bot]@users.noreply.github.com"`
   - These are GitHub's official bot accounts and should work automatically

3. **Permission issues**
   - Verify the workflow has `permissions: contents: write`
   - Check if any branch protection rules prevent bot commits

### Issue: Getting "fatal: A branch with that name already exists"

**Possible causes and solutions:**

1. **Previous branch wasn't cleaned up**
   - The branch naming includes a Unix timestamp to ensure uniqueness
   - If you see this error, it means there's a stale branch from a previous run
   - Clean up old branches manually:
     ```bash
     git branch -D auto-commit-github-*
     git push origin --delete <old-branch-name>
     ```

2. **Race condition with multiple runs**
   - If `workflow_dispatch` was triggered manually while a scheduled run was in progress
   - Wait for the first run to complete before triggering another

---

## 📋 Branch & PR Naming Convention

The workflow follows a consistent naming pattern for traceability:

**Branch name:** `auto-commit-{directory-with-dashes}-{timestamp}`

Examples:
- `.github` → `auto-commit-github-1645103200`
- `config` → `auto-commit-config-1645103200`
- `.github/workflows` → `auto-commit--github-workflows-1645103200`

**PR title:** `[Auto] {COMMIT_MESSAGE_PREFIX} {directory} configuration files`

Examples:
- `[Auto] Update .github configuration files`
- `[Auto] chore: Sync config configuration files`
- `[Auto] [Automation] .github/workflows configuration files`

This naming makes it easy to:
- Identify auto-generated commits in git history
- Track which directory each PR addresses
- Link commits to workflow runs via timestamps

---

## 📈 Advanced Usage & Edge Cases

### Monitoring Large Directories

If monitoring a large or frequently-changing directory:

1. **Increase `SCHEDULE_FREQUENCY`** to reduce noise
   - Instead of every 2 hours, try every 6-12 hours
   - Example: `0 */12 * * *`

2. **Use a more specific subdirectory**
   - Instead of `.github`, monitor `.github/workflows` specifically
   - Reduces commits for unrelated `.github` changes

3. **Set up branch protection rules** to review changes before merge
   - Require at least 1 review before merge
   - Require status checks to pass
   - Allows stakeholders to see what changed before auto-merge

### Skipping Specific Runs

To prevent the workflow from creating a commit on a particular day:

1. Temporarily disable the workflow in **Actions → Auto-Commit Configuration Changes → Disable workflow**
2. Or, rename the workflow file temporarily to prevent scheduling
3. Re-enable when needed

### Handling Rate Limits

GitHub Actions has rate limits on API calls. For repositories that monitor frequently-changing directories:

1. **Increase the schedule interval** (e.g., every 4-6 hours instead of 2)
2. **Reduce the monitored scope** (specific subdirectory instead of entire `.github`)
3. **Implement caching** if you have many workflow dependencies (separate from this workflow)

### Integration with Branch Protection Rules

If your repository requires PR reviews before merge:

1. Set `AUTO_MERGE_LABEL` to a label that's recognized by your protection rules
2. Some organizations configure rules to allow auto-merge only for labeled PRs
3. Configure auto-merge to work alongside required reviews and status checks

---

## ✅ Verification Checklist

After setting up the workflow, verify each step:

- [ ] Workflow file is in `.github/workflows/auto-commit.yml`
- [ ] `git log` shows the workflow file was committed
- [ ] GitHub **Actions** tab shows the workflow listed
- [ ] Variables are set correctly in **Settings → Secrets and variables → Actions → Variables**
- [ ] Auto-merge is enabled in **Settings → General**
- [ ] Merge method is selected in auto-merge settings
- [ ] Manual trigger works: `gh workflow run auto-commit.yml`
- [ ] Recent workflow runs show as ✅ **Success** or ⏭️ **Skipped** (if no changes detected)
- [ ] At least one PR has been created and merged successfully

---

## 📚 Related Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Cron Expression Reference](https://crontab.guru/)
- [GitHub Script Action](https://github.com/actions/github-script)
- [Repository Variables Documentation](https://docs.github.com/en/actions/learn-github-actions/variables#creating-configuration-variables-for-a-repository)
- [Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [Auto-merge Pull Requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/automatically-merging-a-pull-request)

---

## 🔄 Template Distribution

This workflow template is maintained as a reusable template in the Optima Partners central repository. For project-specific distribution:

**In target project's A9 Deployment Manager:**
- Reference the template location: `.github/workflow-templates/auto-commit-github-changes/`
- Link to this documentation
- Configure project-specific variables as needed

**Sync to other repositories:**
- Changes to this template in the central repo are synchronized to all target projects
- See `.github/agents/README.md` for agent sync setup

---

## 📝 Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1.1 | March 2, 2026 | Comprehensive audit and documentation update. Added integration guide, examples for 2-hour/6-hour/custom sweeps, permissions table, extended troubleshooting, variable precedence, verification checklist, advanced edge cases, and PR naming conventions. |
| 1.0 | Earlier | Initial release |

---

**Last Updated:** March 2, 2026  
**Maintained by:** A9 Deployment Manager  
**License:** Available for use across Optima Partners projects
