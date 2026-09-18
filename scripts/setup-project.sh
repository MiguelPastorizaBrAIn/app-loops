#!/usr/bin/env bash
# =============================================================================
# setup-project.sh
# Crea y configura un GitHub Project (v2) para el portfolio App Loops:
#   - Labels
#   - Milestones (roadmap con fechas)
#   - Issue types: Iniciativa -> Epica -> Historia de Usuario (sub-issues)
#   - Project con campos personalizados (Tipo, Estado, Prioridad, Horizonte,
#     Esfuerzo, Iniciativa, Inicio, Fecha objetivo)
#   - Anade todos los items al Project y rellena sus campos
#
# Uso:
#   ./scripts/setup-project.sh <TOKEN>
#   TOKEN con scopes: repo, project (classic PAT)
#
# Es idempotente: si un label/milestone/issue/proyecto ya existe, lo reutiliza.
# =============================================================================
set -uo pipefail

TOKEN="${1:-${PROJECT_TOKEN:-${GITHUB_TOKEN:-}}}"
OWNER="${OWNER:-MiguelPastorizaBrAIn}"
REPO="${REPO:-app-loops}"
BACKLOG="${BACKLOG:-roadmap/backlog.json}"
API="https://api.github.com"
GRAPHQL="$API/graphql"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
info(){ echo -e "${BLUE}$*${NC}" >&2; }
ok(){ echo -e "${GREEN}  ✓ $*${NC}" >&2; }
warn(){ echo -e "${YELLOW}  ! $*${NC}" >&2; }
err(){ echo -e "${RED}  ✗ $*${NC}" >&2; }

if [ -z "$TOKEN" ]; then
  err "Falta el token. Uso: $0 <TOKEN>  (scopes: repo, project)"
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  err "jq no esta instalado. Instalalo y vuelve a intentarlo."
  exit 1
fi
if [ ! -f "$BACKLOG" ]; then
  err "No encuentro $BACKLOG"
  exit 1
fi

# ---------------------------------------------------------------- helpers ---
rest() {
  local method="$1" path="$2" data="${3:-}"
  if [ -n "$data" ]; then
    curl -s -X "$method" "$API$path" \
      -H "Authorization: bearer $TOKEN" \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      -d "$data"
  else
    curl -s -X "$method" "$API$path" \
      -H "Authorization: bearer $TOKEN" \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28"
  fi
}

gql() {
  local query="$1" vars="${2:-}"
  [ -z "$vars" ] && vars='{}'
  jq -n --arg q "$query" --argjson v "$vars" '{query:$q, variables:$v}' |
    curl -s -X POST "$GRAPHQL" \
      -H "Authorization: bearer $TOKEN" \
      -H "Content-Type: application/json" \
      --data @-
}

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

info "==> Comprobando autenticacion"
VIEWER=$(rest GET /user)
if ! echo "$VIEWER" | jq -e '.login' >/dev/null 2>&1; then
  err "Token invalido o sin permisos:"
  echo "$VIEWER" | jq -r '.message // .'
  exit 1
fi
ok "Autenticado como $(echo "$VIEWER" | jq -r .login)"

USER_NODE_ID="$(echo "$VIEWER" | jq -r .node_id)"
REPO_JSON=$(rest GET "/repos/$OWNER/$REPO")
REPO_NODE_ID="$(echo "$REPO_JSON" | jq -r .node_id)"
if [ "$REPO_NODE_ID" = "null" ] || [ -z "$REPO_NODE_ID" ]; then
  err "No puedo acceder a $OWNER/$REPO. Revisa el scope 'repo'."
  exit 1
fi
ok "Repo node id: $REPO_NODE_ID"

# ---------------------------------------------------------------- labels ---
info "==> Labels"
rest GET "/repos/$OWNER/$REPO/labels?per_page=100" > "$TMP/labels.json"
jq -r '.[].name' "$TMP/labels.json" > "$TMP/label_names.txt" 2>/dev/null || true
while IFS= read -r row; do
  name=$(echo "$row" | jq -r .name)
  color=$(echo "$row" | jq -r .color)
  desc=$(echo "$row" | jq -r '.description // ""')
  if grep -qxF "$name" "$TMP/label_names.txt" 2>/dev/null; then
    rest PATCH "/repos/$OWNER/$REPO/labels/$name" \
      "$(jq -n --arg n "$name" --arg c "$color" --arg d "$desc" '{new_name:$n,color:$c,description:$d}')" >/dev/null
    ok "label actualizado: $name"
  else
    rest POST "/repos/$OWNER/$REPO/labels" \
      "$(jq -n --arg n "$name" --arg c "$color" --arg d "$desc" '{name:$n,color:$c,description:$d}')" >/dev/null
    ok "label creado: $name"
  fi
done < <(jq -c '.labels[]' "$BACKLOG")

# ------------------------------------------------------------ milestones ---
info "==> Milestones (roadmap)"
rest GET "/repos/$OWNER/$REPO/milestones?state=all&per_page=100" > "$TMP/ms.json"
declare -A MS_NUM
while IFS= read -r row; do
  k=$(echo "$row" | jq -r .key); t=$(echo "$row" | jq -r .title)
  due=$(echo "$row" | jq -r .due); desc=$(echo "$row" | jq -r '.description // ""')
  if jq -e --arg t "$t" '.[]|select(.title==$t)' "$TMP/ms.json" >/dev/null 2>&1; then
    num=$(jq -r --arg t "$t" '.[]|select(.title==$t)|.number' "$TMP/ms.json")
    ok "milestone existe: $t (#$num)"
  else
    body=$(jq -n --arg t "$t" --arg d "$desc" --arg due "${due}T23:59:59Z" '{title:$t,description:$d,due_on:$due}')
    resp=$(rest POST "/repos/$OWNER/$REPO/milestones" "$body")
    num=$(echo "$resp" | jq -r .number)
    ok "milestone creado: $t (#$num)"
  fi
  MS_NUM["$k"]="$num"
done < <(jq -c '.milestones[]' "$BACKLOG")

# --------------------------------------------------------------- project ---
info "==> GitHub Project"
PROJ_QUERY='query($login:String!){ user(login:$login){ projectsV2(first:100){ nodes { id number title url } } } }'
PROJ_RESP=$(gql "$PROJ_QUERY" "$(jq -n --arg login "$OWNER" '{login:$login}')")
PROJ_TITLE=$(jq -r '.meta.projectTitle' "$BACKLOG")
PROJ_DESC=$(jq -r '.meta.projectDescription' "$BACKLOG")
PROJ_ID=$(echo "$PROJ_RESP" | jq -r --arg t "$PROJ_TITLE" '.data.user.projectsV2.nodes[]?|select(.title==$t)|.id')
PROJ_URL=$(echo "$PROJ_RESP" | jq -r --arg t "$PROJ_TITLE" '.data.user.projectsV2.nodes[]?|select(.title==$t)|.url')
PROJ_NUM=$(echo "$PROJ_RESP" | jq -r --arg t "$PROJ_TITLE" '.data.user.projectsV2.nodes[]?|select(.title==$t)|.number')

if [ -n "$PROJ_ID" ] && [ "$PROJ_ID" != "null" ]; then
  ok "proyecto existe: $PROJ_URL"
else
  warn "el token necesita scope 'project' para crear el project"
  CREATE_MUT='mutation($input:CreateProjectV2Input!){ createProjectV2(input:$input){ projectV2{ id number url } } }'
  README_MD="# ${PROJ_TITLE}\n\n${PROJ_DESC}\n\n## Estructura\n- Iniciativas (trimestre)\n- Epicas (2-4 semanas)\n- Historias de Usuario (dias)\n\n## Flujo\nBacklog -> Listo -> En progreso -> En revision -> Hecho"
  VARS=$(jq -n --arg owner "$USER_NODE_ID" --arg repo "$REPO_NODE_ID" --arg title "$PROJ_TITLE" \
    '{input:{ownerId:$owner,repositoryId:$repo,title:$title}}')
  CR=$(gql "$CREATE_MUT" "$VARS")
  PROJ_ID=$(echo "$CR" | jq -r '.data.createProjectV2.projectV2.id')
  PROJ_URL=$(echo "$CR" | jq -r '.data.createProjectV2.projectV2.url')
  PROJ_NUM=$(echo "$CR" | jq -r '.data.createProjectV2.projectV2.number')
  if [ -z "$PROJ_ID" ] || [ "$PROJ_ID" = "null" ]; then
    err "No se pudo crear el project:"
    echo "$CR" | jq .
    exit 1
  fi
  ok "proyecto creado: $PROJ_URL"
  UPD_MUT='mutation($input:UpdateProjectV2Input!){ updateProjectV2(input:$input){ projectV2{ id url } } }'
  gql "$UPD_MUT" "$(jq -n --arg p "$PROJ_ID" --arg d "$PROJ_DESC" --arg r "$README_MD" '{input:{projectId:$p,shortDescription:$d,readme:$r}}')" >/dev/null 2>&1 || warn "no se pudo fijar descripcion/readme"
fi

# ---------------------------------------------------------------- fields ---
info "==> Campos del Project"
FIELDS_QUERY='query($id:ID!){ node(id:$id){ ... on ProjectV2 { fields(first:100){ nodes { ... on ProjectV2FieldCommon { id name dataType } ... on ProjectV2SingleSelectField { id name options { id name } } } } } } }'
FIELDS_RESP=$(gql "$FIELDS_QUERY" "$(jq -n --arg id "$PROJ_ID" '{id:$id}')")
echo "$FIELDS_RESP" | jq '[.data.node.fields.nodes[] | {name, id, options: (.options // [])}]' > "$TMP/fields.json"

create_field() {
  local name="$1" dtype="$2" opts="$3"
  local exists
  exists=$(jq -r --arg n "$name" '.[]|select(.name==$n)|.id' "$TMP/fields.json")
  if [ -n "$exists" ] && [ "$exists" != "null" ]; then
    ok "campo existe: $name"; return 0
  fi
  local mut='mutation($input:CreateProjectV2FieldInput!){ createProjectV2Field(input:$input){ projectV2Field{ ... on ProjectV2FieldCommon { id name } } } }'
  local vars
  if [ "$dtype" = "SINGLE_SELECT" ]; then
    vars=$(jq -n --arg pid "$PROJ_ID" --arg n "$name" --arg dt "$dtype" --argjson opts "$opts" \
      '{input:{projectId:$pid,dataType:$dt,name:$n,singleSelectOptions:$opts}}')
  else
    vars=$(jq -n --arg pid "$PROJ_ID" --arg n "$name" --arg dt "$dtype" \
      '{input:{projectId:$pid,dataType:$dt,name:$n}}')
  fi
  local r; r=$(gql "$mut" "$vars")
  if echo "$r" | jq -e '.data.createProjectV2Field.projectV2Field.id' >/dev/null 2>&1; then
    ok "campo creado: $name"
  else
    warn "no se pudo crear campo $name: $(echo "$r" | jq -r '.errors[0].message // .message // "?"')"
  fi
}

for key in tipo estado prioridad horizonte esfuerzo; do
  name=$(jq -r --arg k "$key" '.fields[$k].name' "$BACKLOG")
  opts=$(jq -c --arg k "$key" '[.fields[$k].options[] | {name:.name,color:.color,description:""}]' "$BACKLOG")
  create_field "$name" "SINGLE_SELECT" "$opts"
done
create_field "$(jq -r '.fields.iniciativa.name' "$BACKLOG")" "TEXT" "[]"
create_field "$(jq -r '.fields.inicio.name' "$BACKLOG")" "DATE" "[]"
create_field "$(jq -r '.fields.objetivo.name' "$BACKLOG")" "DATE" "[]"

FIELDS_RESP=$(gql "$FIELDS_QUERY" "$(jq -n --arg id "$PROJ_ID" '{id:$id}')")
echo "$FIELDS_RESP" | jq '[.data.node.fields.nodes[] | {name, id, options: (.options // [])}]' > "$TMP/fields.json"

field_id(){ jq -r --arg n "$1" '.[]|select(.name==$n)|.id' "$TMP/fields.json"; }
opt_id(){ jq -r --arg n "$1" --arg o "$2" '.[]|select(.name==$n)|.options[]|select(.name==$o)|.id' "$TMP/fields.json"; }

F_TIPO=$(field_id "Tipo"); F_ESTADO=$(field_id "Estado"); F_PRIO=$(field_id "Prioridad")
F_HOR=$(field_id "Horizonte"); F_ESF=$(field_id "Esfuerzo")
F_INI=$(field_id "Iniciativa"); F_INICIO=$(field_id "Inicio"); F_OBJ=$(field_id "Fecha objetivo")

set_sel(){ gql 'mutation($input:UpdateProjectV2ItemFieldValueInput!){ updateProjectV2ItemFieldValue(input:$input){ projectV2Item{ id } } }' \
  "$(jq -n --arg p "$PROJ_ID" --arg i "$2" --arg f "$1" --arg o "$3" '{input:{projectId:$p,itemId:$i,fieldId:$f,value:{singleSelectOptionId:$o}}}')" >/dev/null; }
set_txt(){ gql 'mutation($input:UpdateProjectV2ItemFieldValueInput!){ updateProjectV2ItemFieldValue(input:$input){ projectV2Item{ id } } }' \
  "$(jq -n --arg p "$PROJ_ID" --arg i "$2" --arg f "$1" --arg t "$3" '{input:{projectId:$p,itemId:$i,fieldId:$f,value:{text:$t}}}')" >/dev/null; }
set_date(){ gql 'mutation($input:UpdateProjectV2ItemFieldValueInput!){ updateProjectV2ItemFieldValue(input:$input){ projectV2Item{ id } } }' \
  "$(jq -n --arg p "$PROJ_ID" --arg i "$2" --arg f "$1" --arg d "$3" '{input:{projectId:$p,itemId:$i,fieldId:$f,value:{date:$d}}}')" >/dev/null; }

# ---------------------------------------------------------------- issues ---
info "==> Issues y jerarquia"
rest GET "/repos/$OWNER/$REPO/issues?state=all&per_page=100" > "$TMP/issues.json"

ensure_issue() { # title body labels(JSON array) milestone_number -> "number|id|node_id"
  local title="$1" body="$2" labels="$3" ms="$4"
  local num id node
  num=$(jq -r --arg t "$title" '.[]|select(.title==$t)|.number' "$TMP/issues.json" | head -1)
  if [ -n "$num" ] && [ "$num" != "null" ]; then
    id=$(jq -r --arg t "$title" '.[]|select(.title==$t)|.id' "$TMP/issues.json" | head -1)
    node=$(jq -r --arg t "$title" '.[]|select(.title==$t)|.node_id' "$TMP/issues.json" | head -1)
    ok "issue existe: $title (#$num)"
  else
    local payload
    payload=$(jq -n --arg t "$title" --arg b "$body" --argjson l "$labels" --argjson m "$ms" \
      '{title:$t, body:$b, labels:$l, milestone:$m}')
    local r; r=$(rest POST "/repos/$OWNER/$REPO/issues" "$payload")
    num=$(echo "$r" | jq -r .number); id=$(echo "$r" | jq -r .id); node=$(echo "$r" | jq -r .node_id)
    if [ "$num" = "null" ] || [ -z "$num" ]; then
      err "fallo creando issue: $title -> $(echo "$r" | jq -r '.message // .')"
      echo "||"; return 0
    fi
    ok "issue creado: $title (#$num)"
  fi
  # asegurar labels
  rest PUT "/repos/$OWNER/$REPO/issues/$num/labels" "$(jq -n --argjson l "$labels" '{labels:$l}')" >/dev/null 2>&1 || true
  echo "$num|$id|$node"
}

add_to_project(){ # node_id -> item_id
  local r; r=$(gql 'mutation($input:AddProjectV2ItemByIdInput!){ addProjectV2ItemById(input:$input){ item{ id } } }' \
    "$(jq -n --arg p "$PROJ_ID" --arg c "$1" '{input:{projectId:$p,contentId:$c}}')")
  echo "$r" | jq -r '.data.addProjectV2ItemById.item.id'
}

link_sub(){ # parent_number child_id
  rest POST "/repos/$OWNER/$REPO/issues/$1/sub_issues" "$(jq -n --argjson id "$2" '{sub_issue_id:$id}')" >/dev/null 2>&1 \
    && ok "sub-issue enlazada (#$1 <- $2)" || warn "no se pudo enlazar sub-issue (#$1 <- $2)"
}

priority_label(){ case "$1" in "P0"*) echo "priority:P0";; "P1"*) echo "priority:P1";; "P2"*) echo "priority:P2";; "P3"*) echo "priority:P3";; *) echo "priority:P2";; esac; }
priority_opt(){ case "$1" in "P0"*) echo "P0 - Crítica";; "P1"*) echo "P1 - Alta";; "P2"*) echo "P2 - Media";; "P3"*) echo "P3 - Baja";; *) echo "P2 - Media";; esac; }
effort_opt(){ local n="$1"; if [ "$n" -le 2 ]; then echo XS; elif [ "$n" -le 3 ]; then echo S; elif [ "$n" -le 5 ]; then echo M; elif [ "$n" -le 8 ]; then echo L; else echo XL; fi; }

for i in $(seq 0 $(( $(jq '.initiatives|length' "$BACKLOG") - 1 ))); do
  init=$(jq -c ".initiatives[$i]" "$BACKLOG")
  it=$(echo "$init" | jq -r .title)
  ikey=$(echo "$init" | jq -r .key)
  idesc=$(echo "$init" | jq -r .description)
  ims=$(echo "$init" | jq -r .milestone)
  iprio=$(echo "$init" | jq -r .priority)
  ihor=$(echo "$init" | jq -r .horizon)
  istart=$(echo "$init" | jq -r .start)
  itarget=$(echo "$init" | jq -r .target)
  ilabels=$(echo "$init" | jq -c ".labels + [\"$(priority_label "$iprio")\"]")
  imsnum="${MS_NUM[$ims]}"

  body=$(printf '## %s\n\n%s\n\n- **Horizonte:** %s\n- **Inicio:** %s\n- **Objetivo:** %s\n- **Milestone:** %s\n' \
    "$ikey" "$idesc" "$ihor" "$istart" "$itarget" "$ims")
  res=$(ensure_issue "$it" "$body" "$ilabels" "$imsnum")
  inum=$(echo "$res" | cut -d'|' -f1); iid=$(echo "$res" | cut -d'|' -f2); inode=$(echo "$res" | cut -d'|' -f3)
  [ -z "$inum" ] && continue
  item=$(add_to_project "$inode")
  [ -n "$item" ] && [ "$item" != "null" ] && {
    set_sel "$F_TIPO" "$item" "$(opt_id "Tipo" "Iniciativa")"
    set_sel "$F_ESTADO" "$item" "$(opt_id "Estado" "Backlog")"
    set_sel "$F_PRIO" "$item" "$(opt_id "Prioridad" "$(priority_opt "$iprio")")"
    set_sel "$F_HOR" "$item" "$(opt_id "Horizonte" "$ihor")"
    set_txt "$F_INI" "$item" "$it"
    set_date "$F_INICIO" "$item" "$istart"
    set_date "$F_OBJ" "$item" "$itarget"
  }

  ne=$(echo "$init" | jq '.epics|length')
  for e in $(seq 0 $(( ne - 1 ))); do
    epic=$(echo "$init" | jq -c ".epics[$e]")
    et=$(echo "$epic" | jq -r .title); ekey=$(echo "$epic" | jq -r .key)
    edesc=$(echo "$epic" | jq -r .description); eprio=$(echo "$epic" | jq -r .priority)
    elabels=$(echo "$epic" | jq -c ".labels + [\"$(priority_label "$eprio")\"]")
    ebody=$(printf '## %s\n\n%s\n\n**Iniciativa:** %s\n' "$ekey" "$edesc" "$it")
    eres=$(ensure_issue "$et" "$ebody" "$elabels" "$imsnum")
    enum=$(echo "$eres" | cut -d'|' -f1); eid=$(echo "$eres" | cut -d'|' -f2); enode=$(echo "$eres" | cut -d'|' -f3)
    [ -z "$enum" ] && continue
    link_sub "$inum" "$eid"
    eitem=$(add_to_project "$enode")
    [ -n "$eitem" ] && [ "$eitem" != "null" ] && {
      set_sel "$F_TIPO" "$eitem" "$(opt_id "Tipo" "Épica")"
      set_sel "$F_ESTADO" "$eitem" "$(opt_id "Estado" "Backlog")"
      set_sel "$F_PRIO" "$eitem" "$(opt_id "Prioridad" "$(priority_opt "$eprio")")"
      set_sel "$F_HOR" "$eitem" "$(opt_id "Horizonte" "$ihor")"
      set_txt "$F_INI" "$eitem" "$it"
      set_date "$F_INICIO" "$eitem" "$istart"
      set_date "$F_OBJ" "$eitem" "$itarget"
    }

    ns=$(echo "$epic" | jq '.stories|length')
    for s in $(seq 0 $(( ns - 1 ))); do
      st=$(echo "$epic" | jq -c ".stories[$s]")
      stt=$(echo "$st" | jq -r .title); skey=$(echo "$st" | jq -r .key)
      spa=$(echo "$st" | jq -r .as_a); spw=$(echo "$st" | jq -r .i_want); sps=$(echo "$st" | jq -r .so_that)
      sprio=$(echo "$st" | jq -r .priority); sest=$(echo "$st" | jq -r .estimate)
      slabels=$(echo "$st" | jq -c ".labels + [\"$(priority_label "$sprio")\"]")
      accept=$(echo "$st" | jq -r '.acceptance[]? | "- [ ] \(.)"')
      sbody=$(printf '## %s\n\n**Como** %s  \n**Quiero** %s  \n**Para** %s\n\n### Criterios de aceptacion\n%s\n\n---\n**Epica:** %s\n**Estimacion:** %s pts\n' \
        "$skey" "$spa" "$spw" "$sps" "$accept" "$et" "$sest")
      sres=$(ensure_issue "$stt" "$sbody" "$slabels" "$imsnum")
      snum=$(echo "$sres" | cut -d'|' -f1); sid=$(echo "$sres" | cut -d'|' -f2); snode=$(echo "$sres" | cut -d'|' -f3)
      [ -z "$snum" ] && continue
      link_sub "$enum" "$sid"
      sitem=$(add_to_project "$snode")
      [ -n "$sitem" ] && [ "$sitem" != "null" ] && {
        set_sel "$F_TIPO" "$sitem" "$(opt_id "Tipo" "Historia de Usuario")"
        set_sel "$F_ESTADO" "$sitem" "$(opt_id "Estado" "Backlog")"
        set_sel "$F_PRIO" "$sitem" "$(opt_id "Prioridad" "$(priority_opt "$sprio")")"
        set_sel "$F_HOR" "$sitem" "$(opt_id "Horizonte" "$ihor")"
        set_sel "$F_ESF" "$sitem" "$(opt_id "Esfuerzo" "$(effort_opt "$sest")")"
        set_txt "$F_INI" "$sitem" "$it"
        set_date "$F_OBJ" "$sitem" "$itarget"
      }
    done
  done
done

echo ""
info "=============================================="
ok "Project listo: $PROJ_URL"
info "=============================================="
echo ""
echo -e "${YELLOW}Recomendado (una vez):${NC}"
echo "  1. En el Project, crea una vista Board agrupada por 'Estado'."
echo "  2. Crea una vista Roadmap con fechas 'Inicio' y 'Fecha objetivo'."
echo "  3. Crea una vista Table agrupada por 'Tipo'."
echo "  4. Filtros utiles:"
echo "       horizon:\"Ahora\"        -> foco de la semana"
echo "       priority:\"P0 - Crítica\" -> lo urgente"
echo "       -tipo:\"Historia de Usuario\" -> solo estructura"
echo ""