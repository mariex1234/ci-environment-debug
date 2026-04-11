FROM debian:12-slim

# 1. Installation des outils (Wine, interface, wget)
RUN apt-get update && apt-get install -y \
    wine \
    xvfb \
    x11vnc \
    fluxbox \
    wget \
    procps \
    && apt-get clean

# 2. Téléchargement direct de l'installateur MT5 (pour éviter l'erreur "not found")
RUN wget -O /root/mt5setup.exe https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe

# 3. Config environnement
ENV WINEPREFIX=/root/.wine
ENV WINEARCH=win64
ENV DISPLAY=:1

# 4. Copie des fichiers restants (ton Bot et ton Script)
# Assure-toi que ces deux-là sont bien présents à la racine de ton dépôt GitHub
COPY RoyalPrince_Scalper.ex5 /root/RoyalPrince_Scalper.ex5
COPY setup_mt5.sh /root/setup_mt5.sh

# 5. Permissions
RUN chmod +x /root/setup_mt5.sh

# 6. Alias
RUN echo "alias config='/root/setup_mt5.sh'" >> /root/.bashrc && \
    echo "alias mt5='WINEDEBUG=-all wine \"/root/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe\" /portable &'" >> /root/.bashrc

WORKDIR /root

# Lancement auto du serveur graphique
CMD Xvfb :1 -screen 0 1280x1024x24 & fluxbox & x11vnc -forever -create & bash
