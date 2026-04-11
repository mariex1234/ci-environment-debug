#!/bin/bash

# Chemins avec guillemets pour gérer les espaces
MT5_PATH="/root/.wine/drive_c/Program Files/MetaTrader 5"
EXPERTS_DIR="$MT5_PATH/MQL5/Experts"

echo "--- INSTALLATION AUTOMATIQUE MT5 ---"

# 1. Lancer l'installateur en arrière-plan
wine /root/mt5setup.exe /auto &

echo "Attente de la création des dossiers (30s)..."

# 2. Boucle de vérification robuste
MAX_ATTEMPTS=15
COUNT=0
while [ ! -d "$EXPERTS_DIR" ] && [ $COUNT -lt $MAX_ATTEMPTS ]; do
    sleep 2
    COUNT=$((COUNT + 1))
    echo "Recherche du dossier Experts... ($COUNT/$MAX_ATTEMPTS)"
done

# 3. Création forcée et Copie
echo "Déploiement des fichiers dans le dossier Experts..."
mkdir -p "$EXPERTS_DIR"

# On copie le bot ET tous les .set au même endroit
cp "/root/RoyalPrince_Scalper.ex5" "$EXPERTS_DIR/"
cp /root/*.set "$EXPERTS_DIR/"

# 4. Nettoyage
pkill -f mt5setup.exe

echo "------------------------------------------------"
echo "✔ TERMINE : Tout est dans le dossier Experts !"
echo "Tu peux maintenant taper : mt5"
echo "------------------------------------------------"
