#!/bin/bash

# Chemins standards
MT5_PATH="/root/.wine/drive_c/Program Files/MetaTrader 5"
EXPERTS_DIR="$MT5_PATH/MQL5/Experts"

echo "--- INSTALLATION MT5 & DEPLOIEMENT BOT ---"

# 1. Lancement de l'installateur en mode automatique
wine /root/mt5setup.exe /auto &

echo "Attente de l'installation (environ 30s)..."

# 2. Boucle de vérification
MAX_ATTEMPTS=20
COUNT=0
while [ ! -d "$EXPERTS_DIR" ] && [ $COUNT -lt $MAX_ATTEMPTS ]; do
    sleep 2
    COUNT=$((COUNT + 1))
    echo "Recherche du dossier Experts... ($COUNT/$MAX_ATTEMPTS)"
done

# 3. Création forcée et copie du Bot
echo "Déploiement du bot..."
mkdir -p "$EXPERTS_DIR"
if [ -f "/root/RoyalPrince_Scalper.ex5" ]; then
    cp "/root/RoyalPrince_Scalper.ex5" "$EXPERTS_DIR/"
    echo "✔ Bot copié avec succès."
else
    echo "ERREUR : RoyalPrince_Scalper.ex5 introuvable."
fi

# 4. Nettoyage
pkill -f mt5setup.exe

echo "--- TERMINE : Tapes 'mt5' pour lancer ---"
