# AGENTS.md — agent-skills (skills.sh)

Repo publicado em [skills.sh/farukzahra/agent-skills](https://skills.sh/farukzahra/agent-skills).

## Regra obrigatória: commit + push ao alterar skill publicada

Sempre que o usuário pedir para **mudar uma skill deste repo** (ou você editar `skills/<nome>/`):

1. Editar em **`C:\repo\agent-skills`** (fonte de verdade para skills.sh) — não só em `~/.cursor/skills/`.
2. Sincronizar cópia local se necessário: `~/.cursor/skills/<nome>/` e `~/.agents/skills/<nome>/`.
3. **Commit** em `main` (Conventional Commits, inglês).
4. **`git push origin main`** — skills.sh indexa a partir do GitHub.
5. Informar ao usuário o hash/URL do commit.

Não considerar a alteração de skill concluída sem push em `farukzahra/agent-skills`.

## Estrutura

```
skills/
  recap/
    SKILL.md
    reference/   # snippets opcionais (CSS, JS)
```

## Instalação (consumidores)

```bash
npx skills add farukzahra/agent-skills --skill recap -g -a cursor -y
```

Comando `/recap` no projeto fica em `.cursor/commands/recap.md` de cada repo (não vai no pacote skills.sh).
