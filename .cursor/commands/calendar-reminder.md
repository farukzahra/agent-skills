# /calendar-reminder

User invoked **`/calendar-reminder`** or asked to add a Google Calendar event, reminder, or appointment.

Read and follow the **`google-calendar-mcp`** skill (`~/.cursor/skills/google-calendar-mcp/SKILL.md` or `.agents/skills/google-calendar-mcp/SKILL.md`).

## Parse from user message

- **Title** — short `summary` (PT or EN as user prefers).
- **When** — date, time, all-day, timezone; if user says "day after X", compute the date.
- **Why** — put context + optional **Cursor prompt** in `description` for follow-up on that day.
- **Reminders** — default popup at event time (`minutes: 0`); add `1440` for 24h before if useful.

## Execute

1. `GetDynamicTools` → `plugin-google-calendar-google-calendar` / `create_event`.
2. `CallDynamicTool` → `create_event` on primary calendar.
3. `get_event` to verify.
4. Reply with title, date, link (`htmlLink`), and what reminders were set.

## Examples

- "aviso dia 29 pra ver se o plano parou" → all-day Sep 29, description with check prompt.
- "reunião amanhã 15h 1h" → timed event, `America/Sao_Paulo`, optional Meet.
- "lembrete 1 semana antes da renovação" → compute date from expiry, `overrideReminders`.

Do not include secrets. Do not ask user to create the event manually if MCP is ready.
