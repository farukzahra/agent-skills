---
name: recap
description: >-
  Summarize all user requests from the current AI chat session and produce a
  concise rich HTML recap (requested vs delivered). Use when the user invokes
  /recap or asks for a session summary, delivery recap, or handoff document.
disable-model-invocation: false
---

# /recap — Session delivery recap

Produce a **single self-contained HTML file** that recaps the conversation: what the user asked for (brief paraphrase) and what was actually delivered.

## When to use

- User invokes **`/recap`**
- User asks for session summary, recap, handoff, or "what was asked vs delivered"
- End of a long multi-topic agent session before closing

## Workflow

1. **Read the full conversation** (all user messages, chronological). Group related turns into topics; do not list every micro-message.
2. **For each topic**, write at most two short blocks:
   - **Requested** — user intent in plain language (1–2 sentences). Use the project's UI language (Portuguese for TerapIA unless the project is English-only).
   - **Delivered** — concrete outcomes: files, routes, scripts, rules, tests; include paths when helpful.
3. **Skip** failed or abandoned attempts unless the user should know about them.
4. **Generate HTML** using the template below (inline CSS only, no external dependencies).
5. **Ensure local dev server** when the project rules require it (e.g. `AGENTS.md`, user rules):
   - Read repo docs for start commands (TerapIA: `npm run db:up` + `npm run dev` → default `http://localhost:3000`).
   - If down, start it before finishing the recap.
   - Validate HTTP 200 on health or main route; record the **effective URL** (port may differ).
   - Include test login hints only if documented in the repo (never secrets from `.env`).
6. **Save** to `docs/session-recaps/YYYY-MM-DD-<slug>.html` when the project has a `docs/` folder; otherwise `session-recap.html` at workspace root or a path the user specifies.
7. **Reply** with the file path, local URL, and a short markdown table summary (optional).

## HTML template

Keep copy short; max ~8–12 topic cards per session. Label text inside the HTML follows project locale.

```html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Recap — {Project} — {Date}</title>
  <style>
    :root {
      --bg: #f6f3ee;
      --card: #fff;
      --ink: #1a1f24;
      --muted: #5c6670;
      --accent: #2d6a6b;
      --border: #e4ddd3;
      --done: #e8f5e9;
      --done-border: #a5d6a7;
      --pending: #fff8e1;
      --pending-border: #ffe082;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      font-family: "Segoe UI", system-ui, sans-serif;
      background: var(--bg);
      color: var(--ink);
      line-height: 1.55;
    }
    .wrap { max-width: 52rem; margin: 0 auto; padding: 2rem 1.25rem 3rem; }
    header {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 1.5rem 1.75rem;
      margin-bottom: 1.5rem;
    }
    header h1 { margin: 0 0 0.35rem; font-size: 1.5rem; color: var(--accent); }
    header p { margin: 0; color: var(--muted); font-size: 0.95rem; }
    .stats {
      display: flex;
      flex-wrap: wrap;
      gap: 0.5rem;
      margin-top: 1rem;
      font-size: 0.85rem;
    }
    .stats span { background: var(--bg); padding: 0.35rem 0.75rem; border-radius: 999px; }
    .local-env {
      background: #e3f2fd;
      border: 1px solid #90caf9;
      border-radius: 10px;
      padding: 1rem 1.25rem;
      margin-bottom: 1.25rem;
    }
    .local-env h2 { margin: 0 0 0.5rem; font-size: 0.95rem; color: #1565c0; }
    .local-env a { color: #1565c0; font-weight: 600; }
    .local-env ul { margin: 0.5rem 0 0; padding-left: 1.2rem; font-size: 0.9rem; }
    .local-env li { margin-bottom: 0.25rem; }
    .topic {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: 10px;
      padding: 1.1rem 1.25rem;
      margin-bottom: 0.75rem;
    }
    .topic h2 { margin: 0 0 0.65rem; font-size: 1rem; font-weight: 600; }
    .label {
      font-size: 0.7rem;
      font-weight: 700;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      color: var(--accent);
      margin-bottom: 0.25rem;
    }
    .requested { color: var(--muted); margin-bottom: 0.75rem; font-size: 0.92rem; }
    .delivered {
      background: var(--done);
      border: 1px solid var(--done-border);
      border-radius: 8px;
      padding: 0.65rem 0.85rem;
      font-size: 0.92rem;
    }
    .delivered ul { margin: 0.35rem 0 0; padding-left: 1.2rem; }
    .delivered li { margin-bottom: 0.25rem; }
    .pending {
      background: var(--pending);
      border: 1px solid var(--pending-border);
      border-radius: 10px;
      padding: 1rem 1.25rem;
      margin-top: 1.25rem;
      font-size: 0.9rem;
    }
    .pending h2 { margin: 0 0 0.5rem; font-size: 0.95rem; }
    .pending ul { margin: 0; padding-left: 1.2rem; }
    footer {
      margin-top: 1.5rem;
      font-size: 0.8rem;
      color: var(--muted);
      text-align: center;
    }
  </style>
</head>
<body>
  <div class="wrap">
    <header>
      <h1>{Recap title}</h1>
      <p>{Project name} · {Date}</p>
      <div class="stats">
        <span>{N} topics</span>
      </div>
    </header>
    <!-- Include when project has local dev server rules -->
    <section class="local-env">
      <h2>Testar localmente</h2>
      <p>App: <a href="{Base URL}">{Base URL}</a> · health OK</p>
      <ul>
        <li><a href="{Route}">{Label}</a></li>
        <li>Login de teste (se no AGENTS.md): {user} / {password}</li>
      </ul>
    </section>
    <article class="topic">
      <h2>{Topic title}</h2>
      <div class="label">{Requested label}</div>
      <p class="requested">{What user wanted}</p>
      <div class="label">{Delivered label}</div>
      <div class="delivered">
        <ul>
          <li>{Deliverable}</li>
        </ul>
      </div>
    </article>
    <footer>Generated by /recap</footer>
  </div>
</body>
</html>
```

For TerapIA and other PT-BR projects, use labels **Pedido** / **Entregue** / **Pendências** and title **Recap da sessão**.

## Quality bar

- **Concise**: each topic fits one card; no code dumps in HTML.
- **Accurate**: only claim delivery for work that was implemented or explicitly output.
- **No secrets**: never include tokens, passwords, or `.env` values.

## Optional follow-up

If the recap reveals unfinished work, add a **Pending** section at the bottom (plain list).
