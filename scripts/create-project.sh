#!/bin/bash

# Script para crear GitHub Project para App Loops
# Uso: ./scripts/create-project.sh [GITHUB_TOKEN]

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Verificar token
if [ -z "$1" ]; then
    echo -e "${RED}Error: Necesitas proporcionar tu GitHub Token${NC}"
    echo ""
    echo "Uso: $0 [GITHUB_TOKEN]"
    echo ""
    echo "Para obtener un token:"
    echo "1. Ve a https://github.com/settings/tokens"
    echo "2. Haz clic en 'Generate new token (classic)'"
    echo "3. Selecciona los scopes: project, repo"
    echo "4. Copia el token"
    exit 1
fi

TOKEN=$1
OWNER_ID="U_kgDOE6vSXg"
GRAPHQL_URL="https://api.github.com/graphql"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Creando GitHub Project para App Loops${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 1. Crear el Proyecto
echo -e "${YELLOW}1. Creando proyecto...${NC}"

CREATE_PROJECT_QUERY='
mutation {
  createProjectV2(
    input: {
      ownerId: "'$OWNER_ID'",
      title: "App Loops Development",
      shortDescription: "Sistema de gestión de tareas y proyectos basado en Loops",
      readme: "# App Loops Development\n\nProyecto para el desarrollo del sistema de gestión de tareas y proyectos basado en Loops.\n\n## Objetivos\n- Configurar estructura del repositorio\n- Definir tipos de Loops\n- Crear plantillas reutilizables\n- Implementar automatización\n- Completar documentación"
    }
  ) {
    projectV2 {
      id
      number
      title
      url
    }
  }
}'

RESPONSE=$(curl -s -X POST "$GRAPHQL_URL" \
    -H "Authorization: bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"query\": $(echo "$CREATE_PROJECT_QUERY" | jq -Rs .)}")

PROJECT_ID=$(echo "$RESPONSE" | jq -r '.data.createProjectV2.projectV2.id')
PROJECT_NUMBER=$(echo "$RESPONSE" | jq -r '.data.createProjectV2.projectV2.number')
PROJECT_URL=$(echo "$RESPONSE" | jq -r '.data.createProjectV2.projectV2.url')

if [ "$PROJECT_ID" = "null" ] || [ -z "$PROJECT_ID" ]; then
    echo -e "${RED}Error al crear el proyecto:${NC}"
    echo "$RESPONSE" | jq .
    exit 1
fi

echo -e "${GREEN}✓ Proyecto creado: $PROJECT_URL${NC}"
echo ""

# 2. Obtener IDs de los issues
echo -e "${YELLOW}2. Obteniendo issues...${NC}"

GET_ISSUES_QUERY='
{
  repository(owner: "MiguelPastorizaBrAIn", name: "app-loops") {
    issues(first: 10, states: OPEN) {
      nodes {
        id
        number
        title
      }
    }
  }
}'

ISSUES_RESPONSE=$(curl -s -X POST "$GRAPHQL_URL" \
    -H "Authorization: bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"query\": $(echo "$GET_ISSUES_QUERY" | jq -Rs .)}")

echo "$ISSUES_RESPONSE" | jq -r '.data.repository.issues.nodes[] | "  Issue #\(.number): \(.title)"'
echo ""

# 3. Agregar issues al proyecto
echo -e "${YELLOW}3. Agregando issues al proyecto...${NC}"

for ISSUE_NUM in 1 2 3 4 5; do
    ISSUE_ID=$(echo "$ISSUES_RESPONSE" | jq -r ".data.repository.issues.nodes[] | select(.number == $ISSUE_NUM) | .id")
    
    if [ -n "$ISSUE_ID" ] && [ "$ISSUE_ID" != "null" ]; then
        ADD_ITEM_QUERY='
        mutation {
          addProjectV2ItemById(
            input: {
              projectId: "'$PROJECT_ID'",
              contentId: "'$ISSUE_ID'"
            }
          ) {
            item {
              id
            }
          }
        }'
        
        ADD_RESPONSE=$(curl -s -X POST "$GRAPHQL_URL" \
            -H "Authorization: bearer $TOKEN" \
            -H "Content-Type: application/json" \
            -d "{\"query\": $(echo "$ADD_ITEM_QUERY" | jq -Rs .)}")
        
        ITEM_ID=$(echo "$ADD_RESPONSE" | jq -r '.data.addProjectV2ItemById.item.id')
        
        if [ "$ITEM_ID" != "null" ] && [ -n "$ITEM_ID" ]; then
            echo -e "${GREEN}  ✓ Issue #$ISSUE_NUM agregado al proyecto${NC}"
        else
            echo -e "${RED}  ✗ Error al agregar issue #$ISSUE_NUM${NC}"
        fi
    fi
done

echo ""

# 4. Resumen
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  ¡Proyecto creado exitosamente!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "URL del proyecto: ${GREEN}$PROJECT_URL${NC}"
echo -e "Número de proyecto: ${GREEN}$PROJECT_NUMBER${NC}"
echo ""
echo -e "${YELLOW}Próximos pasos:${NC}"
echo "1. Ve al proyecto en GitHub"
echo "2. Haz clic en '+ Add view' para crear un Board view"
echo "3. Agrega columnas: Backlog, To Do, In Progress, Review, Done"
echo "4. Mueve los issues a las columnas correspondientes"
echo ""
echo -e "${BLUE}¡Listo! Tu proyecto está listo para usar.${NC}"