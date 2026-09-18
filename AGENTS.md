# AGENTS.md — App Loops

Guía para agentes que trabajen en este repositorio.

## Qué es
Portfolio de automatizaciones con IA gestionado con GitHub Projects v2.
Jerarquía: **Iniciativa → Épica → Historia de Usuario** (sub-issues).

## Fuente de verdad
- `roadmap/backlog.json` — define iniciativas, épicas e historias, milestones,
  labels y campos del Project.
- Tras editar `backlog.json`, **materializa los cambios**:
  ```bash
  ./scripts/setup-project.sh "$(gh auth token)"
  ```
  o lanza el workflow **Setup GitHub Project** (`workflow_dispatch`).
- El script es **idempotente**: reutiliza labels/milestones/issues/proyecto y
  actualiza lo que cambie. No duplica.

## Requisitos
- `gh` autenticado con scopes **`repo`**, **`project`**, **`workflow`**.
  Comprobar: `gh auth status`. Añadir scope project:
  `gh auth refresh -h github.com -s project`.
- `jq` instalado.

## Convenciones
- IDs: `INIT-x`, `EPIC-x.y`, `US-x.y.z`, `TASK-...`.
- Labels: `type:*`, `priority:P0..P3`, `horizon:now|next|later`, `area:*`.
- Estados del Project: Backlog → Listo → En progreso → En revisión → Bloqueado → Hecho.
- Fechas: `YYYY-MM-DD`. Campos `Inicio` y `Fecha objetivo`.
- Historia de usuario: **Como / Quiero / Para** + criterios de aceptación.

## Reglas de trabajo (1 persona)
- Máx. **1 Iniciativa en "Ahora"**.
- Máx. **3 historias `En progreso`** a la vez.
- **P0** bloquea todo; máx. 2.

## Vistas del Project (crear una vez)
1. Board "Mi día" agrupada por `Estado`, filtro `horizon:"Ahora"`.
2. Roadmap con `Inicio` → `Fecha objetivo`, agrupada por `Iniciativa`.
3. Table "Estructura" agrupada por `Tipo`.
4. Board "Triage" agrupada por `Prioridad`.

## Documentación
- `roadmap/README.md` — roadmap y fechas.
- `docs/PROJECT-STRUCTURE.md` — campos, vistas, rutina.
- `README.md` — visión general y puesta en marcha.
