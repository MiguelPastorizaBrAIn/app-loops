# Roadmap · App Loops (Automatizaciones con IA)

> Fuente de verdad: [`backlog.json`](backlog.json). El script `scripts/setup-project.sh`
> materializa este backlog en issues + un GitHub Project.

## Cómo se organiza (3 niveles)

| Nivel | Qué es | Duración | Herramienta |
|-------|--------|----------|-------------|
| **Iniciativa** | Objetivo estratégico | Un trimestre | Issue + campo `Tipo = Iniciativa` |
| **Épica** | Bloque entregable | 2–4 semanas | Sub-issue de la Iniciativa |
| **Historia de Usuario** | Valor concreto y verificable | Días | Sub-issue de la Épica |

Las historias usan el formato **Como / Quiero / Para** con **criterios de aceptación**.

## Horizonte temporal

| Horizonte | Significado | Regla práctica |
|-----------|-------------|----------------|
| **Ahora** | Foco actual (1–2 semanas) | Máx. 1 iniciativa activa |
| **Siguiente** | Preparado, aún no empezado | Se planifica al cerrar "Ahora" |
| **Después** | Visión, sin compromiso | Se revisa cada mes |

## Hitos (Milestones) y fechas

| Hito | Ventana | Objetivo |
|------|---------|----------|
| **M0 · Fundación** | 18 sep → 15 oct 2026 | Repo, CI/CD, entornos |
| **M1 · Motor IA MVP** | 16 oct → 30 nov 2026 | Orquestador + capa de modelos |
| **M2 · Integraciones** | 1 dic → 31 dic 2026 | Conectores y SDK |
| **M3 · Observabilidad y Calidad** | 1 ene → 31 ene 2027 | Trazas, seguridad, testing |
| **M4 · Producto Beta** | 1 feb → 31 mar 2027 | UX, onboarding, docs |

## Iniciativas

| # | Iniciativa | Horizonte | Prioridad | Ventana | Hito |
|---|-----------|-----------|-----------|---------|------|
| 1 | Fundación de la Plataforma | Ahora | P1 | 18 sep → 15 oct | M0 |
| 2 | Motor de Automatizaciones con IA | Siguiente | P0 | 16 oct → 30 nov | M1 |
| 3 | Biblioteca de Integraciones | Siguiente | P1 | 1 dic → 31 dic | M2 |
| 4 | Observabilidad, Calidad y Seguridad | Después | P1 | 1 ene → 31 ene | M3 |
| 5 | Producto y Adopción | Después | P2 | 1 feb → 31 mar | M4 |

## Cómo trabajas el día a día (solo tú)

1. **Lunes**: mira la vista **Roadmap** y la vista **Board** filtrada por `horizon:"Ahora"`.
2. **Al empezar algo**: mueve la historia a `En progreso` y pon `Inicio` = hoy.
3. **Al terminar**: muévela a `En revisión` y verifica los criterios de aceptación.
4. **Al cerrar**: pásala a `Hecho`. Si era la última de la épica, cierra la épica.
5. **Viernes**: revisa `P0/P1` abiertas y reajusta fechas objetivo.
6. **Fin de mes**: replanifica "Siguiente" → "Ahora".

## Reglas de priorización (para no ahogarte)

- **P0 - Crítica**: bloquea todo lo demás. Máx. 2 en paralelo.
- **P1 - Alta**: valor directo. Es tu columna vertebral.
- **P2 - Media**: mejoras que suman, pero esperan.
- **P3 - Baja**: ideas aparcadas.

> Regla de oro para una persona: **máximo 1 Iniciativa en "Ahora" y 3 historias `En progreso` a la vez.**

## Estados

`Backlog → Listo → En progreso → En revisión → Bloqueado → Hecho`

## Añadir o cambiar trabajo

1. Edita `roadmap/backlog.json`.
2. Vuelve a ejecutar el workflow **Setup GitHub Project**.
   Es idempotente: no duplica lo que ya existe y actualiza labels.
