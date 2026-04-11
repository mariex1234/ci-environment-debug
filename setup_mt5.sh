#!/bin/bash

MT5_PATH="$HOME/.wine/drive_c/Program Files/MetaTrader 5"
EXPERTS_DIR="$MT5_PATH/MQL5/Experts"
PRESETS_DIR="$MT5_PATH/MQL5/Profiles/Presets"

echo "--- INSTALLATION MT5 & RANGEMENT ---"

# 1. Lancer l'installateur
wine /root/mt5setup.exe /auto &

# 2. Attendre que MT5 crée les dossiers
echo "Recherche du dossier Experts..."
MAX_ATTEMPTS=30
COUNT=0
while [ ! -d "$EXPERTS_DIR" ] && [ $COUNT -lt $MAX_ATTEMPTS ]; do
    sleep 2
    COUNT=$((COUNT + 1))
done

if [ -d "$EXPERTS_DIR" ]; then
    echo "✔ Dossier trouvé. Nettoyage et installation..."
    
    # Force la création du dossier Presets
    mkdir -p "$PRESETS_DIR"

    # 3. On range chaque fichier à sa place
    # On met UNIQUEMENT le bot dans Experts (pour qu'il soit visible)
    cp /root/RoyalPrince_Scalper.ex5 "$EXPERTS_DIR/"
    
    # On met les configs UNIQUEMENT dans Presets
    cp /root/*.set "$PRESETS_DIR/"
    
    echo "✔ Bot installé dans EXPERTS"
    echo "✔ Configs installées dans PRESETS"
else
    echo "✘ Erreur : Dossier Experts non trouvé."
fi

pkill -f mt5setup.exe
