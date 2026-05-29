#!/bin/bash
# Script de surveillance automatique
while true; do
    if ! pgrep -f "metatrader.exe" > /dev/null; then
        echo "Relance de MetaTrader..."
        DISPLAY=:1 wine /chemin/vers/votre/metatrader.exe &
    fi
    sleep 30
done
