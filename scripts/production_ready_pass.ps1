$ErrorActionPreference = 'Stop'

$root = "c:\github-repos\compliance-knowledge"
$knowledge = Join-Path $root "knowledge"

if (-not (Test-Path (Join-Path $root "scripts"))) {
    New-Item -ItemType Directory -Path (Join-Path $root "scripts") | Out-Null
}

# 1) Replace malformed root-level tax article with a proper IE article.
$ieTaxChecklistPath = Join-Path $knowledge "IE/tax_filing_checklist.md"
$ieTaxChecklist = @'
---
title: "Tax Filing Checklist for Small Companies"
country: "IE"
category: "Tax"
tags: ["tax", "filing", "revenue", "corporation"]
last_updated: "2026-04-03"
id: "article.ie.tax.filing.checklist"
---

Staying tax-compliant in Ireland means filing the right returns on time and keeping clear records.

Key checklist for SMEs:

- Register for the correct taxes with Revenue (Corporation Tax or Income Tax, VAT where applicable, and PAYE if employing staff).
- File corporation tax returns (CT1) and pay tax by Revenue deadlines.
- Submit VAT returns (typically VAT3) on your filing cycle and reconcile VAT accounts.
- Run payroll through Revenue's real-time reporting system and file payroll submissions each pay period.
- Keep supporting records (invoices, receipts, payroll files, bank records) for at least 6 years.
- Review preliminary tax requirements before year end.
- Track filing dates in a compliance calendar to avoid surcharges and interest.
- Keep tax agent authorizations and ROS access details current.
- Document how you determine deductible expenses and capital allowances.
- Prepare for Revenue interventions by maintaining organized audit-ready files.

Practical tip: assign one owner for the tax calendar and perform a monthly check to confirm all filings and payments were completed.
'@
Set-Content -Path $ieTaxChecklistPath -Value $ieTaxChecklist -Encoding UTF8

$rootTaxPath = Join-Path $knowledge "tax_compliance.md"
if (Test-Path $rootTaxPath) {
    Remove-Item $rootTaxPath -Force
}

# 2) Upgrade Germany GDPR article from placeholder text.
$deGdprPath = Join-Path $knowledge "DE/gdpr_basics.md"
$deGdpr = @'
---
title: "GDPR Basics for SMEs in Germany"
country: "DE"
category: "GDPR"
tags: ["gdpr", "records", "dpo", "privacy"]
last_updated: "2026-04-03"
id: "article.de.gdpr.basics"
---

The GDPR applies to businesses in Germany that collect or use personal data.

Core actions for SMEs:

- Map what personal data you collect, where it is stored, and who can access it.
- Keep a Record of Processing Activities (ROPA) for your main data processes.
- Use a lawful basis for each processing activity (for example contract, legal obligation, or consent).
- Provide clear privacy notices to customers, employees, and website users.
- Put data processing agreements in place with service providers handling data for you.
- Enable data subject rights handling (access, correction, deletion, objection) within GDPR timelines.
- Apply technical and organizational security measures appropriate to your risks.
- Keep a personal data breach log and notify the competent authority when required.
- Check whether you need to appoint a Data Protection Officer (DPO).
- Train staff regularly on secure data handling and phishing awareness.

In Germany, supervisory authorities are organized at federal state level. Identify your lead authority and keep its guidance in your compliance toolkit.
'@
Set-Content -Path $deGdprPath -Value $deGdpr -Encoding UTF8

# 3) Rebuild country index pages from actual article files.
$countryDirs = Get-ChildItem $knowledge -Directory | Where-Object { $_.Name -match '^[A-Z]{2}$' } | Sort-Object Name

foreach ($dir in $countryDirs) {
    $cc = $dir.Name
    $indexPath = Join-Path $dir.FullName "index.md"
    $articleFiles = Get-ChildItem $dir.FullName -File -Filter "*.md" | Where-Object { $_.Name -ne "index.md" } | Sort-Object Name

    $lines = @()
    $lines += "# $cc Compliance Articles"
    $lines += ""
    $lines += "Country-specific compliance explainers for $cc."
    $lines += ""

    if ($articleFiles.Count -eq 0) {
        $lines += "No country-specific articles are published yet."
        $lines += ""
    } else {
        $lines += "## Articles"
        $lines += ""
        foreach ($f in $articleFiles) {
            $raw = Get-Content $f.FullName -Raw
            $title = $f.BaseName
            $m = [regex]::Match($raw, '(?m)^title:\s*"([^"]+)"')
            if ($m.Success) {
                $title = $m.Groups[1].Value
            }
            $lines += "- [$title]($($f.Name))"
        }
        $lines += ""
    }

    $lines += "_Last rebuilt: 2026-04-03_"
    $lines += ""

    Set-Content -Path $indexPath -Value ($lines -join "`r`n") -Encoding UTF8
}

# 4) Rebuild global knowledge index with coverage table.
$globalIndexPath = Join-Path $knowledge "index.md"
$g = @()
$g += "# Compliance Knowledge Portal"
$g += ""
$g += "Country-indexed compliance explainers for EU jurisdictions."
$g += ""
$g += "## Coverage Snapshot"
$g += ""
$g += "| Country | Articles |"
$g += "|---|---:|"

foreach ($dir in $countryDirs) {
    $count = (Get-ChildItem $dir.FullName -File -Filter "*.md" | Where-Object { $_.Name -ne "index.md" }).Count
    $g += "| [$($dir.Name)]($($dir.Name)/index.md) | $count |"
}

$g += ""
$g += "_Last rebuilt: 2026-04-03_"
$g += ""
Set-Content -Path $globalIndexPath -Value ($g -join "`r`n") -Encoding UTF8

# 5) Clean README with concise contributor guidance.
$readmePath = Join-Path $root "README.md"
$readme = @'
# compliance-knowledge

Short, plain-language compliance explainers by country.
Rendered in-app and on Read the Docs.

## Writing Guidelines

- Keep articles clear and practical.
- Target short explainers (about 300 words).
- Use neutral, non-advisory language.
- Add frontmatter with title, country, category, tags, last_updated, and id.

## Structure

- Country articles: /knowledge/{CC}/{slug}.md
- Country index: /knowledge/{CC}/index.md
- Global index: /knowledge/index.md

## Frontmatter Template

```yaml
---
title: "GDPR Basics for SMEs"
country: "IE"
category: "GDPR"
tags: ["gdpr", "records"]
last_updated: "2026-04-03"
id: "article.ie.gdpr.basics"
---
```
'@
Set-Content -Path $readmePath -Value $readme -Encoding UTF8

Write-Output "Production readiness pass complete."