# Skills.sh maintainer — agent workspace

Este repositório é o **agente responsável** por criar, publicar e sincronizar skills no [skills.sh/farukzahra/agent-skills](https://skills.sh/farukzahra/agent-skills) e no ambiente local do Faruk.

Abra esta pasta (`C:\repo\agent-skills`) no Cursor quando a tarefa for **skill**, não um app de produto.

## Identidade do agente

- **Nome:** Skills.sh Maintainer
- **Skill principal:** `skills/skills-sh-maintainer/SKILL.md` — leia e siga sempre
- **Pacotes publicados:** `skills/<nome>/` → indexados pelo skills.sh após push em `main`

## Regra obrigatória

Toda criação ou alteração de skill:

1. Editar em **`C:\repo\agent-skills/skills/<nome>/`**
2. Atualizar **`README.md`** se for skill nova
3. **Commit** (Conventional Commits, inglês) + **`git push origin main`**
4. Sincronizar **`~/.cursor/skills/<nome>/`** e **`~/.agents/skills/<nome>/`**
5. Informar commit hash + URL skills.sh

Não encerrar sem push no GitHub.

## Caminhos

| Uso | Caminho |
|-----|---------|
| Repo (fonte de verdade) | `C:\repo\agent-skills` |
| GitHub | https://github.com/farukzahra/agent-skills |
| skills.sh | https://skills.sh/farukzahra/agent-skills |
| Cursor local | `C:\Users\T-GAMER\.cursor\skills\` |
| Agents local | `C:\Users\T-GAMER\.agents\skills\` |
| GitHub PAT | `C:\repo\secrets\github\pat.txt` |

## Instalar skills (consumidor)

```bash
npx skills add farukzahra/agent-skills -g -a cursor -y
npx skills add farukzahra/agent-skills --skill recap -g -a cursor -y
npx skills add farukzahra/agent-skills --skill skills-sh-maintainer -g -a cursor -y
```

Comandos `/recap` etc. ficam em cada projeto (ex.: `sessao-gravador/.cursor/commands/`), fora do pacote skills.sh.

## Estrutura

```
skills/
  skills-sh-maintainer/   # este agente — meta-skill de publicação
  recap/                  # recap de sessão → HTML
  dont-forget/            # obrigação recorrente → automação (CI, hooks)
```

## Commits

Conventional Commits em **inglês**. Não commitar sem pedido explícito do usuário em outros repos; **neste repo**, commit + push fazem parte do fluxo de publicação de skill.
