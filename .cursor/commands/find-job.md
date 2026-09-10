# /find-job

User invoked **`/find-job`** or asked to search LinkedIn for remote/international jobs from their resume.

Read and follow the **`find-job`** skill (`~/.cursor/skills/find-job/SKILL.md` or `.agents/skills/find-job/SKILL.md`).

1. If no resume was provided, **ask where the CV is** (paste, path, or "default").
2. If still unspecified, use default from **`../faruk`** (see skill `reference/default-resume-paths.md`).
3. Search **Worldwide + Remote + Easy Apply** — not US-residency jobs (see `reference/candidate-geo-defaults.md`).
4. Open LinkedIn Jobs in the Cursor browser; **user logs in manually** (or use `../secrets/linkedin/farukz.txt` if stored).
5. **Before each apply:** verify true remote from **Brazil/LATAM** — skip Dubai/US/EU-only and unclear “Remote” (see `reference/remote-geo-check.md`).
6. Score matches, flag suspicious companies; US work authorization default **No**.
7. **Automatically submit Easy Apply** only for geo-eligible jobs (max **20** per run, then stop).
8. Screening answers from CV — never `undefined` (`reference/screening-answers.md`).
9. Save HTML report under `docs/job-search/` including geo class + apply log.

Do not store LinkedIn credentials or session cookies in the repo.
