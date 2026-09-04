# Agent Skills — Skills.sh Maintainer

Repositório **oficial** das skills publicadas em [skills.sh/farukzahra/agent-skills](https://skills.sh/farukzahra/agent-skills).

**Agente deste workspace:** Skills.sh Maintainer — ver `AGENTS.md` e skill `skills-sh-maintainer`.

[![skills.sh](https://skills.sh/b/farukzahra/agent-skills)](https://skills.sh/farukzahra/agent-skills)

## Skills

### skills-sh-maintainer

Meta-skill: criar, atualizar, publicar e sincronizar skills no skills.sh e no ambiente local (`~/.cursor/skills`, `~/.agents/skills`).

**Use when:** criar skill nova, alterar skill publicada, push para GitHub/skills.sh, instalar globalmente.

### recap

Summarize all user requests from the current AI chat session and produce a concise rich HTML recap (requested vs delivered). Dark mode, product tokens, **clickable topic cards** (mark as seen, `localStorage`). Invoke with `/recap` or ask for a session handoff.

**Use when:**

- End of a long agent session
- User wants "what was asked vs what was delivered"
- Handoff document before closing a chat

## Install

```bash
# All skills in this repo
npx skills add farukzahra/agent-skills -g -a cursor -y

# Maintainer (publish workflow)
npx skills add farukzahra/agent-skills --skill skills-sh-maintainer -g -a cursor -y

# Recap only
npx skills add farukzahra/agent-skills --skill recap -g -a cursor -y
```

## Local clone

```text
C:\repo\agent-skills   ← fonte de verdade; commit + push aqui
```

## Cursor slash commands

| Command | Repo | Notes |
|---------|------|-------|
| `/skills-sh` | **this repo** | `.cursor/commands/skills-sh.md` |
| `/recap` | consumer project | e.g. `sessao-gravador/.cursor/commands/recap.md` |

## License

MIT
