FROM debian:12-slim

# 1. Installation des dépendances minimales (Wine + interface)
RUN apt-get update && apt-get install -y \
    wine \
    xvfb \
    x11vnc \
    fluxbox \
    wget \
    procps \
    && apt-get clean

# 2. Variables d'environnement pour Wine
ENV WINEPREFIX=/root/.wine
ENV WINEARCH=win64
ENV DISPLAY=:1

# 3. Copie de tes fichiers (Bot, Installateur, Script)
COPY mt5setup.exe /root/mt5setup.exe
COPY RoyalPrince_Scalper.ex5 /root/RoyalPrince_Scalper.ex5
COPY setup_mt5.sh /root/setup_mt5.sh

# 4. Rendre le script exécutable
RUN chmod +x /root/setup_mt5.sh

# 5. Configuration des Alias (Version Propre)
RUN echo "alias config='/root/setup_mt5.sh'" >> /root/.bashrc && \
    echo "alias mt5='WINEDEBUG=-all wine \"/root/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe\" /portable &'" >> /root/.bashrc

# 6. Dossier de travail
WORKDIR /root

# Commande par défaut (lance l'interface graphique en arrière-plan)
CMD Xvfb :1 -screen 0 1280x1024x24 & fluxbox & x11vnc -forever -create & bash
