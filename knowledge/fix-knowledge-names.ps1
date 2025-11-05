# Path to your knowledge folder
$path = "C:\github-repos\compliance-knowledge\knowledge\ie"

Set-Location $path

Write-Host "Normalizing ComplianceTrack knowledge filenames in $path..."

# 1️⃣ Fix double .md extensions
Get-ChildItem -Path $path -Filter "*.md.md" | ForEach-Object {
    $newName = $_.Name -replace "\.md\.md$", ".md"
    Rename-Item -Path $_.FullName -NewName $newName -Force
    Write-Host "Renamed: $($_.Name) -> $newName"
}

# 2️⃣ Fix misspellings and uppercase prefixes
$renameMap = @{
    "employement_permit.md"                   = "employment_permit.md"
    "fincialreporting_accountingobligation.md" = "financialreporting_accountingobligation.md"
    "IP_compliance.md"                         = "ip_compliance.md"
    "IT_risk.md"                               = "it_risk.md"
}

foreach ($oldName in $renameMap.Keys) {
    $oldPath = Join-Path $path $oldName
    if (Test-Path $oldPath) {
        $newName = $renameMap[$oldName]
        Rename-Item -Path $oldPath -NewName $newName -Force
        Write-Host "Renamed: $oldName -> $newName"
    }
}

# 3️⃣ Normalize any uppercase letters at start (e.g., 'IP_', 'IT_', etc.)
Get-ChildItem -Path $path -Filter "*.md" | ForEach-Object {
    $lowerName = $_.Name.ToLower()
    if ($_.Name -ne $lowerName) {
        Rename-Item -Path $_.FullName -NewName $lowerName -Force
        Write-Host "Lowercased: $($_.Name) -> $lowerName"
    }
}

Write-Host "`n✅ All filenames normalized successfully."
