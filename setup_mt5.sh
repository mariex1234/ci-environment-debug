#!/bin/bash

# Chemins MT5
MT5_DIR="$HOME/.wine/drive_c/Program Files/MetaTrader 5"
MQL5_DIR="$MT5_DIR/MQL5/Experts"
PRESETS_DIR="$MT5_DIR/MQL5/Profiles/Presets"

echo "--- INSTALLATION MT5 & RANGEMENT DES CONFIGS ---"

# 1. Lancer l'installateur
wine /root/mt5setup.exe /auto
sleep 15

# 2. Création des dossiers (MT5 ne crée pas toujours Presets par défaut)
mkdir -p "$MQL5_DIR"
mkdir -p "$PRESETS_DIR"

# 3. Copie des fichiers
echo "Installation du bot RoyalPrince..."
cp /root/RoyalPrince_Scalper.ex5 "$MQL5_DIR/"

echo "Mise en place des configurations dans le dossier Presets..."
cp /root/*.set "$PRESETS_DIR/"

echo "--- TERMINE ---"
echo "Dans MT5 : Expert Advisors -> Propriétés -> Charger -> Tu verras tes fichiers .set ici."
