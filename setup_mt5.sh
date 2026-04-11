#!/bin/bash

# --- FORCE L'INITIALISATION DE WINE ---
echo "Initialisation de Wine..."
winecfg /v win10 & # Lance une config rapide en arrière-plan
sleep 5
pkill winecfg

# --- LANCEMENT DE L'INSTALLATION ---
echo "Lancement de l'installateur Exness..."
# On utilise le chemin complet pour l'installateur
wine /root/mt5setup.exe /auto &

echo "Attente de l'installation (environ 60s)..."

# --- BOUCLE DE VÉRIFICATION RÉELLE ---
# Au lieu de vérifier le dossier Experts, on vérifie l'EXE
MAX_ATTEMPTS=30
COUNT=0
EXE_PATH="/root/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe"

while [ ! -f "$EXE_PATH" ] && [ $COUNT -lt $MAX_ATTEMPTS ]; do
    sleep 3
    COUNT=$((COUNT + 1))
    echo "Attente de terminal64.exe... ($COUNT/$MAX_ATTEMPTS)"
done

if [ -f "$EXE_PATH" ]; then
    echo "✔ MT5 installé avec succès !"
    # On place le config.ini ICI maintenant que le dossier existe
    echo "[Common]
Login=81616089
Password=01191981IRENE@a
Server=Exness-MT5Trial10" > "/root/.wine/drive_c/Program Files/MetaTrader 5/config.ini"
else
    echo "❌ Erreur : L'installation a échoué. Vérifie les logs Wine."
fi
