#!/bin/bash

# Chemins MT5 standards sous Wine
MT5_DIR="$HOME/.wine/drive_c/Program Files/MetaTrader 5"
MQL5_DIR="$MT5_DIR/MQL5/Experts"
DESKTOP_DIR="$HOME/Desktop"

echo "--- DEBUT DE L'INSTALLATION AUTOMATIQUE ---"

# 1. Lancement de l'installation de MT5 (Déjà téléchargé dans /root/ via ton Dockerfile)
echo "[1/4] Lancement de l'installeur MT5..."
wine /root/mt5setup.exe /auto

# Attente pour laisser le temps à Wine de créer les dossiers (10 sec)
echo "Attente de la création des dossiers..."
sleep 10

# 2. Création des dossiers cibles si MT5 ne les a pas encore créés
mkdir -p "$MQL5_DIR"
mkdir -p "$DESKTOP_DIR"

# 3. Copie du Bot et des Configs
echo "[2/4] Déploiement du Bot RoyalPrince..."
if [ -f "./RoyalPrince_Scalper.ex5" ]; then
    cp "./RoyalPrince_Scalper.ex5" "$MQL5_DIR/"
    echo "✔ Bot copié dans MQL5/Experts"
else
    echo "✘ Erreur: RoyalPrince_Scalper.ex5 introuvable dans le répertoire courant."
fi

echo "[3/4] Déploiement des configurations sur le Bureau..."
cp ./*.set "$DESKTOP_DIR/" 2>/dev/null
echo "✔ Fichiers .set copiés sur le Bureau"

# 4. Finalisation
echo "[4/4] Installation terminée !"
echo "--- TU PEUX MAINTENANT LANCER MT5 ---"

# Optionnel : lancer MT5 directement à la fin
# wine "$MT5_DIR/terminal64.exe"
