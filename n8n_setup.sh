#!/bin/bash

# Configura tu dominio aquí
N8N_DOMAIN="TU_DOMINIO.com"
N8N_PROJECT_DIR="$HOME/n8n-docker"

# Crea carpeta principal y de datos si no existen
if [ ! -d "$N8N_PROJECT_DIR" ]; then
  echo "Creando proyecto en $N8N_PROJECT_DIR..."
  sudo mkdir -p "$N8N_PROJECT_DIR/data"
else
  echo "El proyecto ya existe en $N8N_PROJECT_DIR"
fi

cd "$N8N_PROJECT_DIR"

# Crea docker-compose.yml solo si no existe
if [ ! -f "docker-compose.yml" ]; then
  echo "Creando archivo docker-compose.yml..."
  sudo tee docker-compose.yml > /dev/null <<EOF
services:
  n8n:
    image: n8nio/n8n
    restart: unless-stopped
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=${N8N_DOMAIN}
      - WEBHOOK_URL=https://${N8N_DOMAIN}/
      - WEBHOOK_TUNNEL_URL=https://${N8N_DOMAIN}/
    volumes:
      - ./data:/root/.n8n
EOF
  echo "Archivo docker-compose.yml creado."
else
  echo "El archivo docker-compose.yml ya existe. Modifícalo manualmente si deseas cambiar configuraciones."
fi

echo
echo "Ejecutando doker compose..."
cd ~/n8n-docker && sudo docker compose up -d

echo
echo "Para cambiar el dominio, edita docker-compose.yml y reinicia con:"
echo "sudo docker compose down && sudo docker compose up -d"
