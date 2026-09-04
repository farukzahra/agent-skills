# Agent Skills

Personal agent skills for Cursor and other coding agents. Skills follow the [Agent Skills](https://agentskills.io/) format.

[![skills.sh](https://skills.sh/b/farukzahra/agent-skills)](https://skills.sh/farukzahra/agent-skills)

## Skills

### recap

Summarize all user requests from the current AI chat session and produce a concise rich HTML recap (requested vs delivered). Invoke with `/recap` or ask for a session handoff.

**Use when:**

- End of a long agent session
- User wants "what was asked vs what was delivered"
- Handoff document before closing a chat

## Install

```bash
# All skills in this repo
npx skills add farukzahra/agent-skills -g -a cursor -y

# Only recap
npx skills add farukzahra/agent-skills --skill recap -g -a cursor -y
```

## Cursor slash command (optional)

The skill works when the agent discovers it from the description. For an explicit `/recap` command in Cursor, add `.cursor/commands/recap.md` in your project (not part of the skills.sh package).

## License

MIT
