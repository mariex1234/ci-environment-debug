#!/bin/bash

# Chemins standards
MT5_PATH="/root/.wine/drive_c/Program Files/MetaTrader 5"
EXPERTS_DIR="$MT5_PATH/MQL5/Experts"

echo "--- INSTALLATION MT5 & DEPLOIEMENT BOT ---"

# 1. Lancement de l'installateur
wine /root/mt5setup.exe /auto &

echo "Attente de l'installation (30s)..."

# 2. Boucle de vérification du dossier Experts
MAX_ATTEMPTS=15
COUNT=0
while [ ! -d "$EXPERTS_DIR" ] && [ $COUNT -lt $MAX_ATTEMPTS ]; do
    sleep 2
    COUNT=$((COUNT + 1))
    echo "Attente du dossier Experts... ($COUNT/$MAX_ATTEMPTS)"
done

# 3. Copie du Bot et des Sets
if [ -d "$EXPERTS_DIR" ]; then
    echo "Installation détectée. Copie des fichiers..."
    cp "/root/RoyalPrince_Scalper.ex5" "$EXPERTS_DIR/"
    cp /root/*.set "$EXPERTS_DIR/" 2>/dev/null
    echo "✔ Bot et configurations déployés avec succès."
else
    echo "⚠️ Dossier introuvable, création manuelle pour le prochain lancement."
    mkdir -p "$EXPERTS_DIR"
    cp "/root/RoyalPrince_Scalper.ex5" "$EXPERTS_DIR/"
fi

# 4. Nettoyage
pkill -f mt5setup.exe

echo "------------------------------------------------"
echo "TERMINE : Tapes 'mt5' pour lancer la plateforme."
echo "------------------------------------------------"
