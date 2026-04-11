#!/bin/bash

echo "--- INSTALLATION AUTOMATIQUE MT5 ---"

# 1. Lancer l'installateur
wine /root/mt5setup.exe /auto &

echo "Attente de l'installation (30s)..."
sleep 30

# 2. RECHERCHE DYNAMIQUE DU CHEMIN
# On cherche où l'installateur a réellement mis le fichier
REAL_EXE=$(find /root/.wine -name "terminal64.exe" | head -n 1)

if [ -z "$REAL_EXE" ]; then
    echo "❌ Erreur : terminal64.exe introuvable après installation."
    exit 1
fi

# On déduit le dossier Experts à partir du chemin trouvé
MT5_ROOT=$(dirname "$REAL_EXE")
EXPERTS_DIR="$MT5_ROOT/MQL5/Experts"

echo "Installation trouvée dans : $MT5_ROOT"

# 3. Déploiement des fichiers
mkdir -p "$EXPERTS_DIR"
cp "/root/RoyalPrince_Scalper.ex5" "$EXPERTS_DIR/"
cp /root/*.set "$EXPERTS_DIR/" 2>/dev/null

# 4. MISE À JOUR DE L'ALIAS MT5 AUTOMATIQUE
# On réécrit l'alias avec le BON chemin trouvé pour que la commande 'mt5' marche
echo "alias mt5='WINEDEBUG=-all wine \"$REAL_EXE\" /portable &'" >> /root/.bashrc
source /root/.bashrc

# 5. Nettoyage
pkill -f mt5setup.exe

echo "------------------------------------------------"
echo "✔ TERMINE : Tout est configuré !"
echo "Le chemin a été corrigé. Tape : source ~/.bashrc"
echo "Puis lance : mt5"
echo "------------------------------------------------"
