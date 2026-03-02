# Example PowerShell Automation Script
# ====================================
# This is a template demonstrating how to use pwsh-config.ps1
# 
# Usage:
#   Local: . .\.github\pwsh-config.ps1; & ".\.github\scripts\example.ps1"
#   CI/CD: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; . .\.github\pwsh-config.ps1; & ".\.github\scripts\example.ps1"

param(
    [string]$Action = "info",
    [string]$Target = ""
)

# Verify pwsh-config is loaded
if (-not (Get-Command Set-GitHubAutomationPolicy -ErrorAction SilentlyContinue)) {
    Write-Host "⚠ Loading pwsh-config.ps1..." -ForegroundColor Yellow
    . "$PSScriptRoot\..\pwsh-config.ps1"
}

Write-Host "PowerShell Automation Example" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""

switch ($Action) {
    "info" {
        Write-Host "✓ Execution Policy Configuration:" -ForegroundColor Green
        Write-Host "  Current Policy: $(Get-ExecutionPolicy -Scope CurrentUser)" -ForegroundColor Gray
        Write-Host ""
        
        Write-Host "✓ Trusted Script Paths:" -ForegroundColor Green
        Get-TrustedScriptPaths | ForEach-Object {
            Write-Host "  - $_" -ForegroundColor Gray
        }
        Write-Host ""
        
        Write-Host "✓ Available Functions:" -ForegroundColor Green
        Write-Host "  - Set-GitHubAutomationPolicy [-Policy <policy>]" -ForegroundColor Gray
        Write-Host "  - Get-TrustedScriptPaths" -ForegroundColor Gray
        Write-Host "  - Test-ScriptSignature -ScriptPath <path>" -ForegroundColor Gray
        Write-Host "  - Invoke-TrustedScript -ScriptPath <path> [-Arguments @(...)]" -ForegroundColor Gray
        Write-Host ""
    }
    
    "test" {
        Write-Host "✓ Running permission test..." -ForegroundColor Green
        
        # Test: Can we read files?
        $testFile = ".\.github\pwsh-config.ps1"
        if (Test-Path $testFile) {
            Write-Host "  ✓ File read: $testFile" -ForegroundColor Green
        }
        else {
            Write-Host "  ✗ File not found: $testFile" -ForegroundColor Red
        }
        
        # Test: Can we write files?
        $testWrite = New-TemporaryFile
        $testWrite | Remove-Item -Force
        Write-Host "  ✓ Temporary file created/removed" -ForegroundColor Green
        
        Write-Host ""
        Write-Host "✓ All permission tests passed!" -ForegroundColor Green
        Write-Host ""
    }
    
    "help" {
        Write-Host "Usage: example.ps1 -Action <action> [-Target <target>]" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Actions:" -ForegroundColor Green
        Write-Host "  info   - Show configuration info (DEFAULT)" -ForegroundColor Gray
        Write-Host "  test   - Run permission tests" -ForegroundColor Gray
        Write-Host "  help   - Show this help message" -ForegroundColor Gray
        Write-Host ""
    }
    
    default {
        Write-Host "✗ Unknown action: $Action" -ForegroundColor Red
        Write-Host "Use -Action help for usage info" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "✓ Script completed successfully" -ForegroundColor Green
