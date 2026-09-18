# App Loops · Automatizaciones con IA

Sistema de gestión (portfolio) para construir automatizaciones con IA, pensado
para **una sola persona**: organiza iniciativas, épicas e historias de usuario,
prioridades, roadmap y fechas con sentido.

## El GitHub Project

**Portfolio: Iniciativa → Épica → Historia de Usuario**

| Nivel | Qué es | Duración | Herramienta |
|-------|--------|----------|-------------|
| **Iniciativa** | Objetivo estratégico | Un trimestre | Issue + `Tipo = Iniciativa` |
| **Épica** | Bloque entregable | 2–4 semanas | Sub-issue de la Iniciativa |
| **Historia** | Valor concreto | Días | Sub-issue de la Épica |

- **Roadmap y fechas:** [`roadmap/README.md`](roadmap/README.md)
- **Campos, vistas y rutina:** [`docs/PROJECT-STRUCTURE.md`](docs/PROJECT-STRUCTURE.md)
- **Fuente de verdad del backlog:** [`roadmap/backlog.json`](roadmap/backlog.json)

## Puesta en marcha (una vez)

El Project se crea automáticamente con un workflow:

1. Crea un **PAT** en https://github.com/settings/tokens con scopes `repo` y `project`.
2. Guárdalo como secreto del repo con el nombre **`PROJECT_TOKEN`**
   (Settings → Secrets and variables → Actions → New repository secret).
3. Ve a **Actions → Setup GitHub Project → Run workflow**.

Esto crea/actualiza:
- Labels (`type:*`, `priority:*`, `horizon:*`, `area:*`)
- Milestones del roadmap (M0–M4 con fechas)
- Iniciativas, épicas e historias (con sub-issues)
- El Project con campos: Tipo, Estado, Prioridad, Horizonte, Esfuerzo,
  Iniciativa, Inicio y Fecha objetivo.

> También en local: `./scripts/setup-project.sh <TOKEN>` (requiere `jq`).
> Es idempotente: puedes re-ejecutarlo sin duplicar nada.

## Vistas recomendadas del Project

1. **Board "Mi día"** — agrupada por `Estado`, filtro `horizon:"Ahora"`.
2. **Roadmap** — fechas `Inicio` → `Fecha objetivo`, agrupada por `Iniciativa`.
3. **Table "Estructura"** — agrupada por `Tipo`, ordenada por `Prioridad`.
4. **Board "Triage"** — agrupada por `Prioridad`, filtro `-tipo:"Historia de Usuario"`.

## Reglas para no ahogarte (1 persona)

- Máximo **1 Iniciativa en "Ahora"**.
- Máximo **3 historias `En progreso`** a la vez.
- **P0** bloquea todo; mantén como mucho 2.
- Revisa y reajusta fechas cada viernes.

## Crear trabajo nuevo

Usa las plantillas de issue: **Iniciativa**, **Épica**, **Historia de Usuario**
o **Tarea técnica**. O edita `roadmap/backlog.json` y re-ejecuta el workflow.

## Estructura del repositorio

```
app-loops/
├── roadmap/            # backlog.json + roadmap y fechas
├── docs/               # guía del Project y flujo de Loops
├── .github/
│   ├── ISSUE_TEMPLATE/ # plantillas Iniciativa/Épica/Historia/Tarea
│   └── workflows/      # Setup GitHub Project
├── scripts/            # setup-project.sh y utilidades
├── tasks/ projects/ loops/ templates/ config/ reports/
```

## Flujo de estados

`Backlog → Listo → En progreso → En revisión → Bloqueado → Hecho`

## Licencia

MIT — ver [`LICENSE`](LICENSE).
