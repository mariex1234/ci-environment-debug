#!/bin/bash
# /root/watchdog.sh

while true; do
    # Vérifie si le processus terminal64.exe tourne
    if ! pgrep -f "terminal64.exe" > /dev/null; then
        echo "$(date) : MetaTrader 5 est arrêté, redémarrage..."
        # On relance MetaTrader
        DISPLAY=:1 wine "/root/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe" &
    fi
    # Vérifie toutes les 60 secondes pour ne pas surcharger le CPU
    sleep 60
done
