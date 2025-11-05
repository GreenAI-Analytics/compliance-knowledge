# Path to the IE folder
$ieFolder = "knowledge/IE"
$indexFile = Join-Path $ieFolder "index.md"

# Get all .md files except index.md
$files = Get-ChildItem -Path $ieFolder -Filter *.md | Where-Object { $_.Name -ne "index.md" }

# Start building the index content
$content = @()
$content += "# 🇮🇪 Ireland Compliance Articles"
$content += ""
$content += "Below is a list of all compliance articles for Ireland:"
$content += ""

foreach ($file in $files) {
    $slug = $file.BaseName
    $titleLine = Select-String -Path $file.FullName -Pattern '^title:\s*"(.*)"' | Select-Object -First 1
    $title = if ($titleLine) { $titleLine.Matches[0].Groups[1].Value } else { $slug }
    $content += "- [$title]($slug.md)"
}

# Write to index.md
$content | Set-Content -Path $indexFile -Encoding UTF8

Write-Host "✅ index.md updated with $($files.Count) articles."