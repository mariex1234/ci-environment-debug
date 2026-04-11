FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
# Cette ligne supprime définitivement les erreurs de clipboard dans le terminal
ENV WINEDEBUG=-all

# 1. Préparation système et Architecture 32 bits
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb x11vnc novnc websockify openbox wget curl ca-certificates gnupg2 lxterminal \
    && dpkg --add-architecture i386

# 2. Installation de WineHQ Stable 9.0
RUN mkdir -pm755 /etc/apt/keyrings \
    && wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
    && apt-get update

# 3. Application du Pinning pour Wine 9.0
RUN echo "Package: winehq-stable\nPin: version 9.0.0.0~jammy-1\nPin-Priority: 1001\n\nPackage: wine-stable*\nPin: version 9.0.0.0~jammy-1\nPin-Priority: 1001" > /etc/apt/preferences.d/wine-pin

# 4. Installation Wine 9.0
RUN apt-get install -y --install-recommends \
    winehq-stable=9.0.0.0~jammy-1 \
    wine-stable=9.0.0.0~jammy-1 \
    wine-stable-amd64=9.0.0.0~jammy-1 \
    wine-stable-i386:i386=9.0.0.0~jammy-1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 5. Cloudflared
RUN curl -L --output /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
    && chmod +x /usr/local/bin/cloudflared

WORKDIR /root

# 6. Injection de tes fichiers (doivent être dans le même dossier que le Dockerfile)
COPY RoyalPrince_Scalper.ex5 /root/
COPY *.set /root/
COPY setup_mt5.sh /root/
RUN chmod +x /root/setup_mt5.sh

#7 Version sécurisée pour le Dockerfile (sans conflit de guillemets)
RUN echo "alias config='/root/setup_mt5.sh'" >> /root/.bashrc && \
    echo 'alias mt5="WINEDEBUG=-all wine \"/root/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe\" /config:\"C:\\Program Files\\MetaTrader 5\\config.ini\" /portable &"' >> /root/.bashrc
# 8. Script run.sh
RUN echo '#!/bin/bash\n\
rm -f /tmp/.X1-lock\n\
wget -q https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe -O /root/mt5setup.exe\n\
Xvfb :1 -screen 0 1280x800x16 &\n\
sleep 2\n\
DISPLAY=:1 openbox-session &\n\
sleep 2\n\
x11vnc -display :1 -nopw -forever -shared -bg -localhost &\n\
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 7860 &\n\
echo "--- SYSTEME PRET | LANCE ./setup_mt5.sh ---"\n\
cloudflared tunnel --url http://localhost:7860' > /root/run.sh && chmod +x /root/run.sh

ENTRYPOINT ["/root/run.sh"]
