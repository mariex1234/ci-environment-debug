#!/bin/bash

MT5_PATH="$HOME/.wine/drive_c/Program Files/MetaTrader 5"
EXPERTS_DIR="$MT5_PATH/MQL5/Experts"

echo "--- INSTALLATION MT5 EN COURS ---"

# 1. Lancer l'installateur
wine /root/mt5setup.exe /auto &

# 2. Attendre que le dossier Experts soit créé
echo "Attente de la création des dossiers MT5..."
MAX_ATTEMPTS=30
COUNT=0
while [ ! -d "$EXPERTS_DIR" ] && [ $COUNT -lt $MAX_ATTEMPTS ]; do
    sleep 2
    COUNT=$((COUNT + 1))
done

if [ -d "$EXPERTS_DIR" ]; then
    echo "✔ Dossier Experts détecté."
    
    # 3. Copie de tout au même endroit (Bot + Configs)
    cp /root/RoyalPrince_Scalper.ex5 "$EXPERTS_DIR/"
    cp /root/*.set "$EXPERTS_DIR/"
    
    echo "--- CONFIGURATION TERMINEE ---"
    echo "Le bot et les fichiers .set sont dans MQL5/Experts"
else
    echo "✘ Erreur : Dossiers non détectés après 60s."
fi

pkill -f mt5setup.exe
