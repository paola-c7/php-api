#!/bin/bash
 
# --- Controlla che venga passata una cartella come argomento ---
if [ -z "$1" ]; then
    echo "Devi specificare una cartella!"
    echo "Uso: ./avvia.sh nomecartella"
    echo "Esempi:"
    echo "    ./avvia.sh esercizi"
    echo "    ./avvia.sh php-api-json"
    exit 1
fi
 
CARTELLA="$1"
 
# Controlla che la cartella esista
if [ ! -d "$CARTELLA" ]; then
    echo "Cartella '$CARTELLA' non trovata!"
    exit 1
fi
 
echo "Cartella trovata: $CARTELLA"
 
# --- Libera la porta 8000 ---
PORTA=8000
PID=$(lsof -t -i:$PORTA 2>/dev/null)
 
if [ -n "$PID" ]; then
    echo "Porta $PORTA occupata dal processo $PID, lo fermo..."
    kill -9 $PID
    sleep 2
 
    if lsof -t -i:$PORTA > /dev/null 2>&1; then
        echo "Impossibile liberare la porta $PORTA. Prova manualmente: kill -9 $PID"
        exit 1
    else
        echo "Porta $PORTA liberata!"
    fi
else
    echo "Porta $PORTA libera!"
fi
 
# --- Avvia il server PHP dalla cartella ---
echo "Avvio server PHP sulla porta $PORTA..."
php -S 0.0.0.0:$PORTA -t "$CARTELLA" &
SERVER_PID=$!
sleep 1
 
# --- Recupera URL Codespaces ---
if [ -n "$CODESPACE_NAME" ]; then
    URL="https://${CODESPACE_NAME}-${PORTA}.githubpreview.dev"
else
    URL="http://localhost:${PORTA}"
fi
 
echo ""
echo "Server avviato su: $CARTELLA (PID: $SERVER_PID)"
echo "Apri nel browser:"
echo "$URL"
echo ""
echo "File disponibili nella cartella '$CARTELLA':"
ls "$CARTELLA"/*.php 2>/dev/null | xargs -I{} basename {} | sed 's/^/    - /'
echo ""
echo "Per fermare il server: kill $SERVER_PID"
