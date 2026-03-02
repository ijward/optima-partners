# PowerShell Automation Workflow Template

This template provides a reusable GitHub Actions workflow for running PowerShell automation scripts without permission prompts.

## Overview

The workflow:

- Runs on Windows runners (`windows-latest`)
- Sets execution policy to `RemoteSigned` for the workflow duration
- Loads `.github/pwsh-config.ps1` for permission and security configuration
- Executes automation scripts from `.github/scripts/` without prompts
- Provides a foundation for custom PowerShell-based CI/CD tasks

## Quick Start

### 1. Copy to Your Project

```bash
# Copy the workflow template to your project
mkdir -p .github/workflows
cp .github/workflow-templates/powershell-automation/workflow.yml \
   .github/workflows/powershell-automation.yml
```

### 2. Customize

Edit `.github/workflows/powershell-automation.yml` and replace the "Run custom automation" step with your own:

```yaml
- name: Deploy application
  shell: pwsh
  run: |
    . .\.github\pwsh-config.ps1
    & ".\.github\scripts\deploy.ps1" -Environment "production"
```

### 3. Create Your Script

Add a PowerShell script in `.github/scripts/`:

```powershell
# .github/scripts/deploy.ps1
param([string]$Environment = "staging")

Write-Host "Deploying to $Environment..." -ForegroundColor Cyan

# Your automation logic here
$deploymentStatus = "success"

Write-Host "✓ Deployment complete" -ForegroundColor Green
```

### 4. Commit and Test

```bash
git add .github/workflow-templates/powershell-automation/ .github/scripts/deploy.ps1
git commit -m "chore: add PowerShell automation workflow"
git push
```

The workflow will run on the next push or can be triggered manually via GitHub Actions tab.

## Workflow Structure

### Triggers

```yaml
on:
  push:
    branches:
      - main
  pull_request:
  workflow_dispatch:  # Manual trigger in GitHub UI
```

Configure which branches trigger the workflow by modifying the `push` section.

### Key Steps

1. **Checkout** — Fetches repository code
2. **Configure PowerShell** — Sets execution policy and loads configuration
3. **Example Script** — Demonstrates running a script
4. **Custom Automation** — Your automation runs here

### Permissions

```yaml
permissions:
  contents: read
  pull-requests: read
```

Adjust based on what your scripts need:

- `contents: write` — if scripts modify repository files
- `pull-requests: write` — if scripts create/update PRs
- `actions: write` — if scripts trigger other workflows

## Execution Policy

The workflow uses `RemoteSigned` policy:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

This allows:

- ✅ Local scripts to run without prompts
- ✅ Remotely downloaded scripts that are signed
- ❌ Remotely downloaded unsigned scripts (requires signature)

**Why RemoteSigned?** It balances security (prevents accidental execution of untrusted remote code) with convenience (local scripts run without friction).

## Common Patterns

### Pattern 1: Multi-Step Automation

```yaml
- name: Build and test
  shell: pwsh
  run: |
    . .\.github\pwsh-config.ps1
    
    & ".\.github\scripts\build.ps1"
    & ".\.github\scripts\test.ps1"
    & ".\.github\scripts\package.ps1"
```

### Pattern 2: Conditional Execution

```yaml
- name: Deploy if tests pass
  shell: pwsh
  run: |
    . .\.github\pwsh-config.ps1
    
    if ($lastExitCode -eq 0) {
      & ".\.github\scripts\deploy.ps1" -Environment "staging"
    } else {
      Write-Host "Tests failed, skipping deployment" -ForegroundColor Red
      exit 1
    }
```

### Pattern 3: Environment-Specific Configuration

```yaml
- name: Deploy
  shell: pwsh
  env:
    ENVIRONMENT: ${{ github.ref == 'refs/heads/main' && 'production' || 'staging' }}
    BUILD_ARTIFACTS: ${{ github.workspace }}\build
  run: |
    . .\.github\pwsh-config.ps1
    & ".\.github\scripts\deploy.ps1"
```

### Pattern 4: Using Helper Functions

```yaml
- name: Verify and execute
  shell: pwsh
  run: |
    . .\.github\pwsh-config.ps1
    
    # Test script signature
    Test-ScriptSignature ".\.github\scripts\sensitive-operation.ps1"
    
    # Run with trusted path logging
    Invoke-TrustedScript ".\.github\scripts\sensitive-operation.ps1"
```

## Security Best Practices

1. **Keep scripts in trusted paths** — Use `.github/scripts/`, `.github/workflows/`, `.github/setup/`
2. **Version your scripts** — Commit scripts to the repository, don't download at runtime
3. **Use minimal runner permissions** — Only request permissions your scripts actually need
4. **Review automation scripts** — Like any code, PowerShell scripts should be reviewed before merge
5. **Test locally first** — Run scripts locally before adding to workflows:

   ```powershell
   . .\.github\pwsh-config.ps1
   & ".\.github\scripts\my-script.ps1"
   ```

## Troubleshooting

| Problem | Solution |
| --- | --- |
| **"is not digitally signed"** | Use `RemoteSigned` policy (included in template) or bypass for local scripts |
| **"Permission denied"** | Ensure `Set-ExecutionPolicy` runs before your script; check Windows runner permissions |
| **Script not found** | Verify path is correct; GitHub Actions runs from repository root |
| **Variable not available** | Pass via `env:` context in workflow YAML; access as `$env:VARIABLE_NAME` in PowerShell |
| **Script fails silently** | Add error checking: `if ($LASTEXITCODE -ne 0) { exit 1 }` |

## Extending the Template

### Add Setup Step

If your scripts need dotnet, node, etc.:

```yaml
- name: Setup environment
  run: |
    choco install dotnet-sdk -y
    # or use setup action from marketplace
```

### Add Artifact Collection

```yaml
- name: Upload logs
  if: always()
  uses: actions/upload-artifact@v3
  with:
    name: powershell-logs
    path: ${{ github.workspace }}\logs\
```

### Collect Test Results

```yaml
- name: Publish test results
  if: always()
  uses: EnricoMi/publish-unit-test-result-action@v2
  with:
    files: ${{ github.workspace }}\test-results.xml
```

## Next Steps

- Explore [`.github/pwsh-config.ps1`](../../pwsh-config.ps1) for available functions
- Review [`.github/scripts/example.ps1`](../../scripts/example.ps1) for a working example
- See [agents/a9-deployment-manager.md](../../agents/a9-deployment-manager.md#security-configuration) for security configuration details
- Check GitHub Actions documentation for [Windows runners](https://docs.github.com/en/actions/using-github-hosted-runners/about-github-hosted-runners#supported-runners-and-hardware-resources)

## Support

For issues with:

- **Execution policy errors** → Ensure `Set-ExecutionPolicy` step runs first
- **Script not found** → Verify paths are relative to repository root
- **Permission errors** → Check workflow job `permissions:` section
- **General PowerShell help** → See [PowerShell documentation](https://learn.microsoft.com/en-us/powershell/)
