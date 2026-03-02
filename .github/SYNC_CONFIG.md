# 🔄 Sync Configuration Guide

**Central Repository**: ijward/optima-partners  
**Target Repositories**: ijward/xml_mapping, ijward/FootballTransferNews  
**Sync Manager**: A9 Planning Manager  
**Last Updated**: March 2, 2026

---

## Overview

This document defines the **exact** sync configuration for the A9 Copilot agent ecosystem. It specifies:
- ✅ What WILL be synced (source → targets)
- ❌ What MUST NOT be synced
- 🔍 How to validate sync accuracy
- 🛡️ Safeguards against incorrect syncs

---

## 1. SYNC LOGIC: WHAT GETS COPIED

### Source Files that WILL be Synced

**FROM: ijward/optima-partners**

| Path | Type | Scope | Details |
|------|------|-------|---------|
| `.github/agents/*.md` | Agent Definitions | All files | ✅ Syncs each agent (.md file) to all targets |
| `.github/skills/**/*` | Skill Files/Dirs | Recursive | ✅ Syncs entire skills directory structure |

**To: ijward/xml_mapping AND ijward/FootballTransferNews**

| Path | Type | Structure |
|------|------|-----------|
| `.github/agents/*.md` | Agent Files | Files appear at root of agents dir |
| `.github/skills/**/*` | Skill Files | Full directory structure preserved |

### Timeline: How Sync Happens

```
USER COMMITS TO ijward/optima-partners (main branch):
├─ Modifies .github/agents/a9-deployment-manager.md  ← TRIGGERS SYNC
├─ Modifies .github/skills/databricks/readme.md      ← TRIGGERS SYNC
│
└─→ GitHub detects push to .github/agents/**/*.md or .github/skills/**/*.md
    └─→ Triggers sync-agents.yml workflow
        └─→ For each target in sync-agents-targets.txt:
            ├─ Clone target repo
            ├─ Copy source agents/*.md → target/.github/agents/
            ├─ Copy source skills/* → target/.github/skills/
            ├─ Commit with message: "chore: sync Copilot agent and skills files"
            └─ Push to target
```

---

## 2. FILES THAT MUST NOT BE SYNCED

### Explicitly Excluded (Different Purpose)

| File/Directory | Reason | If Synced | Impact |
|---|---|---|---|
| `.github/workflows/*` | Target-specific automation | Would run in wrong context | 🔴 Agent syncs would break |
| `.github/pwsh-config.ps1` | Template-specific config | Would set wrong paths | 🔴 PowerShell scripts fail |
| `.github/scripts/*` | Template utilities | Not applicable to targets | 🟡 Unused files clutter repos |
| `.github/workflow-templates/*` | GitHub UI templates | Irrelevant to targets | 🟡 Unused files clutter repos |
| `SYNC_*.md` | Admin documentation | No value to targets | 🟡 Unused files clutter repos |
| `.github/agents/push-agents-to-central-template.yml` | Template (not agent) | Should be in workflows | 🟡 Breaks sync expectation |

**Current Sync Status**:
- ✅ Sync-agents.yml correctly excludes all these files
- ✅ Uses `*.md` filter to exclude .yml, .ps1, .txt files
- ⚠️ Must NOT modify the copy commands to use recursive glob patterns

---

## 3. DIRECTORY STRUCTURE REQUIREMENTS

### Template Repo (Source): ijward/optima-partners

```
.github/
├── agents/                              ← Agent definitions
│   ├── a9-deployment-manager.md        ✅ SYNCED
│   ├── a9-developer.md                 ✅ SYNCED
│   ├── a9-planning-manager.md          ✅ SYNCED
│   ├── a9-task-manager.md              ✅ SYNCED
│   ├── a9-testing-manager.md           ✅ SYNCED
│   ├── README.md                       ✅ SYNCED (documentation)
│   ├── push-agents-to-central-template.yml  ❌ NOT SYNCED (template)
│   └── junior_insightseeker.txt        ❌ NOT SYNCED (.txt file)
│
├── skills/                              ← Skills library
│   ├── databricks/                     ✅ SYNCED
│   ├── web-ui/                         ✅ SYNCED
│   ├── xml/                            ✅ SYNCED
│   └── skills-index.md                 ✅ SYNCED
│
├── workflows/                           ← Automation (NOT SYNCED)
│   ├── sync-agents.yml                 ❌ NOT SYNCED (admin)
│   └── auto-commit-github-changes.yml  ❌ NOT SYNCED (admin)
│
├── pwsh-config.ps1                      ❌ NOT SYNCED (template config)
├── README.md                            ❌ NOT SYNCED
├── sync-agents-targets.txt              ❌ NOT SYNCED (admin config)
└── scripts/                             ❌ NOT SYNCED (admin)
    └── example.ps1
```

### Target Repos (Destination): ijward/FootballTransferNews, ijward/xml_mapping

```
.github/
├── agents/                              ← SYNCED FROM TEMPLATE
│   ├── a9-deployment-manager.md        ✅
│   ├── a9-developer.md                 ✅
│   ├── a9-planning-manager.md          ✅
│   ├── a9-task-manager.md              ✅
│   ├── a9-testing-manager.md           ✅
│   └── README.md                       ✅
│
└── skills/                              ← SYNCED FROM TEMPLATE
    ├── databricks/                     ✅
    ├── web-ui/                         ✅
    ├── xml/                            ✅
    └── skills-index.md                 ✅

# NOTE: No other files from template appear here
# NOTE: No "optima-partners" parent directory exists
```

---

## 4. SYNC TRIGGERS

The sync-agents.yml workflow **automatically triggers** when:

### Trigger Condition 1: Changes to Agent Files
```
Push to ijward/optima-partners:main includes:
  - Modified .github/agents/**/*.md

Action: Sync those .md files to all targets
```

### Trigger Condition 2: Changes to Skills
```
Push to ijward/optima-partners:main includes:
  - Modified .github/skills/**/*.md

Action: Sync entire .github/skills/ directory to all targets
```

### Trigger Condition 3: Manual Override
```
Workflow can be triggered manually via GitHub Actions:
  - URL: Actions → Sync Agents to Target Repositories → Run workflow
  - Options: dry_run (see changes without pushing), verbose (show details)
```

### Trigger Condition 4: Loop Prevention
```
Workflow does NOT trigger if commit message contains:
  - "chore: sync Copilot agent"

Reason: Prevents infinite loop (sync creates commits with this message)
```

---

## 5. VALIDATION CHECKLIST

### Pre-Sync Validation (Automated in sync-agents.yml)

The workflow now validates:

- [ ] `.github/sync-agents-targets.txt` exists and has entries
- [ ] `.github/agents/` directory exists
- [ ] `.github/skills/` directory exists  
- [ ] Only .md files exist in `.github/agents/` (besides README.md)
- [ ] No forbidden files will be synced
- [ ] `SYNC_TOKEN` secret is configured

### Post-Sync Validation (Manual Check)

After each sync, verify in each target repo:

```bash
# 1. Check that agents are at correct location
ls .github/agents/a9-*.md  # Should list files

# 2. Check that skills are at correct location
ls .github/skills/          # Should list subdirectories

# 3. CRITICAL: Verify NO parent directory was created
ls -la optima-partners/     # Should give: "No such file or directory"
ls -la .github/optima-partners/  # Should give: "No such file or directory"

# 4. Count synced files
find .github/agents/ -name "*.md" | wc -l  # Should be 6+ files
find .github/skills/ -type f | wc -l       # Should be many files

# 5. Verify no workflow files were synced
ls .github/workflows/ | wc -l  # Should have 0 or target-specific workflows only
```

---

## 6. COMMON ISSUES & FIXES

### Issue: Agents appear in `optima-partners/.github/agents/`

**Symptoms**:
- Files at: `optima-partners/.github/agents/a9-*.md`
- Should be at: `.github/agents/a9-*.md`

**Root Cause**: Incorrect copy command (possibly using `cp -r` on parent dir)

**Fix**:
1. Delete entire `optima-partners/` directory from target repo
2. Reset target repo branch: `git reset --hard <upstream-commit-hash>`
3. Re-run sync workflow with DRY_RUN=true to verify
4. If correctly placed, commit and push

### Issue: Automation files synced (pwsh-config.ps1, auto-commit.yml)

**Symptoms**:
- `.github/pwsh-config.ps1` appears in target
- `.github/workflows/auto-commit-*.yml` appears in target

**Root Cause**: Sync command modified to use `cp -r .github/` instead of specific paths

**Fix**:
1. Review sync-agents.yml for modifications
2. Restore original copy commands:
   ```bash
   cp .github/agents/*.md "$WORK_DIR/.github/agents/"
   cp -r .github/skills/ "$WORK_DIR/.github/"
   ```
3. Delete unwanted files from target repos
4. Re-run sync

### Issue: Sync workflow doesn't trigger

**Symptoms**:
- Push to .github/agents/a9-*.md but no sync happens
- Manual trigger doesn't work

**Possible Causes**:
- `SYNC_TOKEN` secret not configured
- sync-agents-targets.txt is empty
- Workflow has been disabled

**Fix**:
1. Check that `SYNC_TOKEN` secret exists: Settings → Secrets and variables → Actions
2. Check that `.github/sync-agents-targets.txt` has target repos listed
3. Check that sync-agents.yml workflow isn't disabled
4. Manually re-run workflow: Actions → Workflow → Run workflow

---

## 7. DRY RUN: TEST BEFORE APPLYING

Use the DRY RUN feature to see what would be synced WITHOUT actually pushing:

```bash
1. Go to: Actions → Sync Agents to Target Repositories
2. Click: "Run workflow" button
3. Set: dry_run = true
4. Click: "Run workflow"
5. Wait for completion
6. Review the log to see:
   - What files would be copied
   - What commits would be created
   - What would be pushed (without actually pushing)
```

**Dry Run Output Shows**:
```
Pre-sync validation:
  Source files to be synced (agents): a9-deployment-manager.md, ...
  Source files to be synced (skills): 50+ files
  
For each target repo:
  [DRY RUN] Changes that would be synced: (diff output)
  [DRY RUN] Would push to: ijward/FootballTransferNews
```

---

## 8. ADDING NEW AGENTS OR SKILLS

### To Add a New Agent

1. Create file: `.github/agents/a9-new-agent-name.md`
2. Commit and push to ijward/optima-partners:main
3. Sync workflow automatically triggers
4. File appears in all target repos within 5 minutes

### To Add a New Skill

1. Create directory: `.github/skills/new-skill-name/`
2. Add files: `index.md`, `examples.md`, etc.
3. Commit and push to ijward/optima-partners:main
4. Sync workflow automatically triggers
5. Entire skillset appears in all target repos within 5 minutes

---

## 9. CONFIGURATION MANAGEMENT

### File: `.github/sync-agents-targets.txt`

**Purpose**: List all target repositories that should receive synced agents

**Format**:
```
# Comments start with #
# Blank lines are ignored
owner/repo-name

# Example:
ijward/xml_mapping
ijward/FootballTransferNews
```

**To Add Target Repo**:
1. Edit `.github/sync-agents-targets.txt`
2. Add: `owner/new-repo-name` on new line
3. Commit and push
4. Next agent/skill push will sync to new target

**To Remove Target Repo**:
1. Edit `.github/sync-agents-targets.txt`
2. Delete the line with target repo
3. Commit and push
4. Future syncs will no longer target that repo

---

## 10. PERMISSION & TOKEN SETUP

### SYNC_TOKEN Secret

**Required in**: ijward/optima-partners

**Setup**:
1. Go to: Settings → Secrets and variables → Actions
2. Click: New repository secret
3. Name: `SYNC_TOKEN`
4. Value: GitHub Personal Access Token with:
   - `repo` scope (full control of private repositories)
   - Access to all target repositories

**Why**: Workflow needs permission to clone and push to target repos

---

## 11. QUICK REFERENCE

| Need | Action | Location |
|------|--------|----------|
| Review sync config | Open this file | `.github/SYNC_CONFIG.md` |
| View sync history | Check workflow runs | Actions → Sync Agents to... |
| Test sync | Run workflow with dry_run | Actions → Run workflow |
| View synced files | Check target repo | `.github/agents/`, `.github/skills/` |
| Add target repo | Edit targets file | `.github/sync-agents-targets.txt` |
| Troubleshoot | Check validation | Run sync with verbose=true |

---

## Enforcement Rules

**These rules are CRITICAL and must be followed**:

1. ✅ **ONLY** `.github/agents/*.md` files are synced
2. ✅ **ONLY** `.github/skills/**/*` directory is synced
3. ❌ **NEVER** sync `.github/workflows/`, `.github/scripts/`, or other automation
4. ❌ **NEVER** sync `.github/pwsh-config.ps1` or template config files
5. ❌ **NEVER** include parent directories in the sync (no `optima-partners/`)
6. ✅ **ALWAYS** validate with DRY_RUN before production syncs
7. ✅ **ALWAYS** use explicit paths in copy commands (not recursive globs on `.github/`)

---

## Support

**Issues**: File an issue in ijward/optima-partners with `[sync]` tag  
**Questions**: Contact A9 Planning Manager  
**Documentation**: See `SYNC_ROOT_CAUSE_ANALYSIS.md` for detailed technical info

