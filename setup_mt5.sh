#!/bin/bash

# Chemins
MT5_INSTALLER="/root/mt5setup.exe"
MT5_PATH="$HOME/.wine/drive_c/Program Files/MetaTrader 5"
PRESETS_DIR="$MT5_PATH/MQL5/Profiles/Presets"
EXPERTS_DIR="$MT5_PATH/MQL5/Experts"

echo "--- LANCEMENT DE L'INSTALLATION AUTOMATIQUE ---"

# 1. Lancer l'installateur en arrière-plan
wine "$MT5_INSTALLER" /auto &

echo "En attente de la création des dossiers par Wine..."

# 2. BOUCLE DE VERIFICATION (Le script attend que MT5 crée le dossier racine)
MAX_ATTEMPTS=30
COUNT=0
while [ ! -d "$MT5_PATH" ] && [ $COUNT -lt $MAX_ATTEMPTS ]; do
    sleep 2
    COUNT=$((COUNT + 1))
    echo "Attente... ($COUNT/$MAX_ATTEMPTS)"
done

if [ -d "$MT5_PATH" ]; then
    echo "✔ Dossier MetaTrader 5 détecté !"
    
    # Force la création des sous-dossiers au cas où
    mkdir -p "$PRESETS_DIR"
    mkdir -p "$EXPERTS_DIR"

    # 3. Copie des fichiers avec vérification
    echo "Déploiement des fichiers..."
    cp /root/RoyalPrince_Scalper.ex5 "$EXPERTS_DIR/"
    cp /root/*.set "$PRESETS_DIR/"
    
    echo "------------------------------------------"
    echo "✔ BOT : RoyalPrince_Scalper -> Installé"
    echo "✔ CONFIGS : ULTIME OR & BTC KAMIKAZ -> Dans Presets"
    echo "------------------------------------------"
else
    echo "✘ Erreur : MT5 n'a pas été installé à temps. Réessaie."
    exit 1
fi

# 4. Tuer le processus de l'installateur s'il tourne encore
pkill -f mt5setup.exe
echo "Installation terminée. Tu peux lancer MT5."
