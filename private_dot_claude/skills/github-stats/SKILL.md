---
name: github-stats
description: Fetch GitHub contribution stats (commits, PRs authored/merged/open, PRs reviewed) for the current user across a GitHub org. Use when the user asks about their GitHub activity, contributions, or stats.
argument-hint: "[org] [timeframe]"
user-invocable: true
allowed-tools: Bash
---

# GitHub Stats

Fetch GitHub contribution stats for the authenticated user across a GitHub organization.

## Arguments

- `$0` — GitHub org name (required).
- `$1` — Time filter (optional). Examples: "last week", "last month", "last quarter", "2026-01-01..2026-03-01". If omitted, show all-time stats.

## Steps

1. Get the authenticated user's login with `gh api user --jq '.login'`.

2. Convert the time filter to a GitHub search date qualifier:
   - "last week" / "past week" → `>YYYY-MM-DD` (7 days ago)
   - "last month" / "past month" → `>YYYY-MM-DD` (30 days ago)
   - "last quarter" / "past quarter" → `>YYYY-MM-DD` (90 days ago)
   - "YYYY-MM-DD..YYYY-MM-DD" → use as-is
   - If no time filter, omit the date qualifier entirely.

3. Fetch the following counts using `gh api` with the search API. Run these in parallel:
   - **Total commits**: `search/commits?q=author:{user}+org:{org}+author-date:{date_filter}`
   - **Total PRs authored**: `search/issues?q=author:{user}+org:{org}+type:pr+created:{date_filter}`
   - **PRs merged**: `search/issues?q=author:{user}+org:{org}+type:pr+is:merged+merged:{date_filter}`
   - **PRs open**: `search/issues?q=author:{user}+org:{org}+type:pr+is:open+created:{date_filter}`
   - **PRs reviewed**: `search/issues?q=reviewed-by:{user}+org:{org}+type:pr+updated:{date_filter}`

   Use `-q '.total_count'` to extract counts.

4. Fetch per-repo commit breakdown. For each repo in the org (`orgs/{org}/repos?per_page=100`), query `search/commits?q=author:{user}+repo:{org}/{repo}+author-date:{date_filter}&per_page=1` and collect repos with >0 commits. Run this efficiently in a single bash loop.

5. List individual PRs created in the period using `search/issues` with `per_page=100`, showing repo, PR number, state, and title.

6. Present results in this format:

   ### {Period description}

   | Metric | Count |
   |---|---|
   | Commits | **{n}** |
   | PRs created | **{n}** |
   | PRs merged | **{n}** (merge rate if applicable) |
   | PRs open | **{n}** |
   | PRs reviewed | **{n}** |

   ### Per-repo commits

   | Repository | Commits |
   |---|---|
   | {repo} | {n} |

   ### PRs created

   - **{repo}** — {count} PRs ({brief descriptions})

   End with a brief one-line observation about the activity.
