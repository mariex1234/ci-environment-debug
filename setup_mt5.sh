#!/bin/bash

# Chemins MT5
MT5_DIR="$HOME/.wine/drive_c/Program Files/MetaTrader 5"
MQL5_DIR="$MT5_DIR/MQL5/Experts"
DESKTOP_DIR="$HOME/Desktop"

echo "--- DEBUT INSTALLATION MT5 ---"

# 1. Lancer l'installateur
wine /root/mt5setup.exe /auto
echo "Installation en cours... attente de 15 secondes..."
sleep 15

# 2. Création des dossiers
mkdir -p "$MQL5_DIR"
mkdir -p "$DESKTOP_DIR"

# 3. Copie des fichiers
echo "Déploiement du bot RoyalPrince et des configs..."
cp /root/RoyalPrince_Scalper.ex5 "$MQL5_DIR/"
cp /root/*.set "$DESKTOP_DIR/"

echo "--- TOUT EST PRET ---"
echo "Tu peux lancer MT5 avec la commande : wine \"$MT5_DIR/terminal64.exe\""
