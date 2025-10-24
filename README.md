# compliance-knowledge
> Short, plain-language explainers (≤300 words) by **country**.  
> Rendered in-app; titles/teasers can be localized via the i18n repo.

---

## ✨ Writing rules
- Keep it under **300 words**. Use **plain language** and bullets.
- No legal advice or opinions; cite public sources if helpful.
- One article per topic per country. Re-use general pieces across countries if applicable.

---

## 📚 Directory structure
/knowledge/{country-cc}/{slug}.md

### Frontmatter (required)
```yaml
---
title: "GDPR Basics for SMEs"
country: "IE"             # ISO-2
category: "GDPR"          # free text, used for grouping
tags: ["gdpr","records"]  # optional
last_updated: "2025-10-24"
id: "article.ie.gdpr.basics"  # stable ID used by i18n for localized titles/teasers
---
Body

Plain Markdown.

Optional section headings.

Prefer links to official pages.

🔤 Localization

The article body is stored in the language the editor writes (usually English).

Localized title and teaser can live in compliance-i18n/knowledge/{lang}.json:

article.ie.gdpr.basics.title

article.ie.gdpr.basics.teaser

If a key is missing, app falls back to the Markdown title.
✅ PR checklist

Frontmatter present and valid.

Keep under 300 words.

If adding a new id, add i18n keys in the i18n repo (optional).

Merge before 23:30 UTC to land in tomorrow’s 00:00 UTC build.


### 🇮🇪 `knowledge/ie/gdpr_basics.md`
```md
---
title: "GDPR Basics for SMEs"
country: "IE"
category: "GDPR"
tags: ["gdpr","records","dpo"]
last_updated: "2025-10-24"
id: "article.ie.gdpr.basics"
---

The General Data Protection Regulation (GDPR) sets rules for how you collect, use, and store personal data. As an SME, focus on:

- Keep only the data you truly need and limit access.
- Maintain a short Record of Processing Activities (ROPA).
- Honor rights requests (access, erasure, rectification) within legal deadlines.
- Use Data Processing Agreements (DPAs) with vendors.
- Report certain data breaches to the DPC within 72 hours.

**Tip:** If core activities involve large-scale processing, you may need a Data Protection Officer (DPO). See the DPC guidance for criteria.

⚙️ .github/workflows/validate.yml
name: Validate Knowledge
on:
  pull_request:
    paths: ["knowledge/**.md"]
  push:
    branches: [main]
    paths: ["knowledge/**.md"]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Check frontmatter exists
        run: |
          set -e
          for f in $(git ls-files 'knowledge/**/*.md'); do
            echo "Checking $f"
            awk 'NR==1{exit !/---/}' "$f"
          done
      - name: Word count check (<= 300 words)
        run: |
          for f in $(git ls-files 'knowledge/**/*.md'); do
            wc=$(sed -n '/^---$/,/^---$/!p' "$f" | wc -w | tr -d ' ')
            echo "$f: $wc words"
          done
