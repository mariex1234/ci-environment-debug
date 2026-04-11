#!/bin/bash

# Chemins
MT5_INSTALLER="/root/mt5setup.exe"
MT5_PATH="$HOME/.wine/drive_c/Program Files/MetaTrader 5"
EXPERTS_DIR="$MT5_PATH/MQL5/Experts"

echo "--- INSTALLATION MT5 & REGROUPEMENT DES FICHIERS ---"

# 1. Lancer l'installateur
wine "$MT5_INSTALLER" /auto &

# 2. Attente intelligente du dossier Experts
MAX_ATTEMPTS=30
COUNT=0
while [ ! -d "$EXPERTS_DIR" ] && [ $COUNT -lt $MAX_ATTEMPTS ]; do
    sleep 2
    COUNT=$((COUNT + 1))
    echo "Recherche du dossier Experts... ($COUNT/$MAX_ATTEMPTS)"
done

if [ -d "$EXPERTS_DIR" ]; then
    echo "✔ Dossier Experts trouvé !"

    # 3. On copie TOUT (Bot + Configs) au même endroit
    echo "Déploiement du bot et des fichiers .set dans le dossier Experts..."
    cp /root/RoyalPrince_Scalper.ex5 "$EXPERTS_DIR/"
    cp /root/*.set "$EXPERTS_DIR/"
    
    echo "------------------------------------------------"
    echo " TOUT EST DANS LE DOSSIER EXPERTS :"
    echo " - RoyalPrince_Scalper.ex5"
    echo " - ULTIME OR.set"
    echo " - BTC KAMIKAZ.set"
    echo "------------------------------------------------"
else
    echo "✘ Erreur : Impossible de trouver le dossier Experts."
    exit 1
fi

pkill -f mt5setup.exe
