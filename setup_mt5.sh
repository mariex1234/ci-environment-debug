#!/bin/bash

# Configuration des chemins
MT5_ROOT="/root/.wine/drive_c/Program Files/MetaTrader 5"
EXPERTS_DIR="$MT5_ROOT/MQL5/Experts"
CONFIG_NAME="config.ini"

echo "--- CONFIGURATION AUTOMATIQUE EXNESS & MT5 ---"

# 1. Création du fichier de config directement dans le dossier MT5
# On utilise 'config.ini' (plus standard pour MT5)
echo "[Common]
Login=81616089
Password=01191981IRENE@a
Server=Exness-MT5Trial10
ProxyEnable=0
CertConfirm=1" > "$MT5_ROOT/$CONFIG_NAME"

# 2. Force l'enregistrement du serveur (pour éviter la fenêtre "Select Company")
mkdir -p "$MT5_ROOT/bases"
echo "Exness-MT5Trial10" > "$MT5_ROOT/bases/servers.dat"

# 3. Lancement de l'installateur en mode auto
wine /root/mt5setup.exe /auto &

echo "Attente de l'installation et des dossiers (30s)..."

# 4. Boucle de vérification du dossier Experts
MAX_ATTEMPTS=15
COUNT=0
while [ ! -d "$EXPERTS_DIR" ] && [ $COUNT -lt $MAX_ATTEMPTS ]; do
    sleep 2
    COUNT=$((COUNT + 1))
    echo "Recherche du dossier Experts... ($COUNT/$MAX_ATTEMPTS)"
done

# 5. Déploiement du Bot et des fichiers .set
echo "Déploiement des fichiers MQL5..."
mkdir -p "$EXPERTS_DIR"
cp "/root/RoyalPrince_Scalper.ex5" "$EXPERTS_DIR/"
cp /root/*.set "$EXPERTS_DIR/"

# 6. Nettoyage de l'installateur
pkill -f mt5setup.exe

echo "------------------------------------------------"
echo "✔ CONFIGURATION TERMINEE"
echo "Identifiants injectés : 81616089 (Trial10)"
echo "------------------------------------------------"
