---
description: Crea/actualiza el GitHub Project (Iniciativas, Épicas, Historias) desde roadmap/backlog.json
agent: build
---

Ejecuta la configuración del GitHub Project del portfolio.

Pasos:
1. Verifica que `gh auth status` incluya los scopes `repo` y `project`.
   Si falta `project`, indica al usuario que ejecute:
   `gh auth refresh -h github.com -s project`.
2. Ejecuta:
   ```bash
   ./scripts/setup-project.sh "$(gh auth token)"
   ```
3. Muestra la URL del Project que aparezca al final y recuerda crear las vistas
   recomendadas (Board "Mi día", Roadmap, Table "Estructura", Board "Triage").

No modifiques `roadmap/backlog.json` salvo que se te pida.
