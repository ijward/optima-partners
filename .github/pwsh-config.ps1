# PowerShell Configuration for A9 .github Automation
# ===================================================
# This script configures PowerShell execution policy and trusted paths for all automation
# scripts and workflows running from .github/* directories.
#
# Usage:
#   1. In GitHub Actions workflows: Source this script at workflow start
#   2. Locally in PowerShell: `. .\.github\pwsh-config.ps1` before running .ps1 scripts
#   3. In Windows Terminal profiles: Add sourcing to profile

# ==================== EXECUTION POLICY CONFIGURATION ====================

# Set execution policy for workflow scripts to bypass prompts
# This allows .ps1 scripts in .github/* to run without permission checks
function Set-GitHubAutomationPolicy {
    param(
        [ValidateSet('Bypass', 'RemoteSigned', 'AllSigned', 'Unrestricted', 'Restricted')]
        [string]$Policy = 'RemoteSigned'
    )
    
    try {
        # CurrentUser scope: applies to current user, no elevation required
        Set-ExecutionPolicy -ExecutionPolicy $Policy -Scope CurrentUser -Force
        Write-Host "✓ Execution policy set to '$Policy' for CurrentUser scope" -ForegroundColor Green
    }
    catch {
        Write-Host "⚠ Could not set execution policy (may require elevation): $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

# ==================== TRUSTED PATH CONFIGURATION ====================

# Define trusted script paths within .github/* that should never require prompts
$trustedPaths = @(
    (Resolve-Path ".\.github\scripts" -ErrorAction SilentlyContinue).Path,
    (Resolve-Path ".\.github\workflows" -ErrorAction SilentlyContinue).Path,
    (Resolve-Path ".\.github\setup" -ErrorAction SilentlyContinue).Path
)

function Get-TrustedScriptPaths {
    return $trustedPaths | Where-Object { $_ }
}

# ==================== GITHUB ACTIONS WORKFLOW SETUP ====================

# For use in GitHub Actions workflows (example in comments below):
# 
# jobs:
#   build:
#     runs-on: windows-latest  # or windows-2022, windows-2019
#     steps:
#       - uses: actions/checkout@v4
#       
#       - name: Configure PowerShell for automation
#         shell: pwsh
#         run: |
#           Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
#           . .\.github\pwsh-config.ps1
#           Set-GitHubAutomationPolicy -Policy RemoteSigned
#       
#       - name: Run automation script
#         shell: pwsh
#         run: |
#           . .\.github\pwsh-config.ps1
#           & ".\.github\scripts\my-script.ps1"

# ==================== SECURITY STANDARDS ====================

# Execution Policy Defaults:
# - RemoteSigned (RECOMMENDED): Local scripts run without prompt, downloaded scripts must be signed
#   - Balances security and convenience
#   - Suitable for local .github scripts
#
# - Bypass: All scripts run without any prompt or signature check
#   - USE ONLY in isolated environments or GitHub Actions runners
#   - NOT RECOMMENDED for developer machines
#
# - AllSigned: All scripts must be digitally signed
#   - Highest security, but requires certificate infrastructure
#   - Overkill for .github automation unless legal requirement exists
#
# - Restricted: No scripts can run (default on most Windows systems)
#   - Only interactive commands allowed
#   - Prevents all automation

# Permission Prompt Prevention:
# 1. Scripts in current directory (.github\scripts): No prompt with RemoteSigned
# 2. Downloaded scripts: Signed certificate required OR Bypass policy
# 3. GitHub Actions runners: RemoteSigned recommended (scripts are local to runner)

# ==================== HELPER FUNCTIONS ====================

function Test-ScriptSignature {
    param([string]$ScriptPath)
    
    if (-not (Test-Path $ScriptPath -PathType Leaf)) {
        write-Host "✗ Script not found: $ScriptPath" -ForegroundColor Red
        return $false
    }
    
    $signature = Get-AuthenticodeSignature -FilePath $ScriptPath
    
    switch ($signature.Status) {
        'Valid' {
            Write-Host "✓ Script is properly signed: $ScriptPath" -ForegroundColor Green
            return $true
        }
        'UnknownError' {
            Write-Host "⚠ Signature verification unknown: $ScriptPath" -ForegroundColor Yellow
            return $null
        }
        default {
            Write-Host "✗ Script is not signed or signature invalid: $ScriptPath" -ForegroundColor Red
            return $false
        }
    }
}

function Invoke-TrustedScript {
    param(
        [string]$ScriptPath,
        [string[]]$Arguments
    )
    
    $resolvedPath = Resolve-Path $ScriptPath -ErrorAction Stop
    
    # Check if in trusted paths
    $isTrusted = $false
    foreach ($trustedPath in (Get-TrustedScriptPaths)) {
        if ($resolvedPath -like "$trustedPath*") {
            $isTrusted = $true
            break
        }
    }
    
    if (-not $isTrusted) {
        Write-Host "⚠ Warning: Running script outside trusted paths. No permission check." -ForegroundColor Yellow
        Write-Host "  Trusted paths:" -ForegroundColor Yellow
        Get-TrustedScriptPaths | ForEach-Object { Write-Host "    - $_" -ForegroundColor Yellow }
    }
    
    Write-Host "→ Executing: $resolvedPath" -ForegroundColor Cyan
    
    if ($Arguments) {
        & $resolvedPath @Arguments
    }
    else {
        & $resolvedPath
    }
}

# ==================== INITIALIZATION ====================

# Main initialization: Set RemoteSigned policy on import
Set-GitHubAutomationPolicy -Policy RemoteSigned

Write-Host "PowerShell automation configuration loaded" -ForegroundColor Green
Write-Host "  - Execution Policy: RemoteSigned (CurrentUser)" -ForegroundColor Gray
Write-Host "  - Trusted paths configured" -ForegroundColor Gray
Write-Host "  - Use Invoke-TrustedScript for safe execution" -ForegroundColor Gray
