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
