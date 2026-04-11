#!/bin/bash

# Chemins avec guillemets pour les espaces
MT5_PATH="/root/.wine/drive_c/Program Files/MetaTrader 5"
EXPERTS_DIR="$MT5_PATH/MQL5/Experts"

echo "--- CONFIGURATION AUTOMATIQUE EXNESS & MT5 ---"

# 1. Création du fichier de connexion automatique
echo "[Common]
Login=81616089
Password=01191981IRENE@a
Server=Exness-MT5Trial10
ProxyEnable=0
CertConfirm=1" > /root/exness.ini

# 2. Lancement de l'installateur
wine /root/mt5setup.exe /auto &

echo "Attente de l'installation (30s)..."

# 3. Boucle de vérification du dossier Experts
MAX_ATTEMPTS=15
COUNT=0
while [ ! -d "$EXPERTS_DIR" ] && [ $COUNT -lt $MAX_ATTEMPTS ]; do
    sleep 2
    COUNT=$((COUNT + 1))
    echo "Recherche du dossier Experts... ($COUNT/$MAX_ATTEMPTS)"
done

# 4. Déploiement du Bot et des .set
echo "Déploiement des fichiers dans le dossier Experts..."
mkdir -p "$EXPERTS_DIR"
cp "/root/RoyalPrince_Scalper.ex5" "$EXPERTS_DIR/"
cp /root/*.set "$EXPERTS_DIR/"

# 5. Nettoyage de l'installateur
pkill -f mt5setup.exe

echo "------------------------------------------------"
echo "✔ TERMINE : Tout est prêt et rangé !"
echo "Compte Exness configuré. Tapes maintenant : mt5"
echo "------------------------------------------------"
