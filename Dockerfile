FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV WINEDEBUG=-all

# 1. Installation des dépendances
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb x11vnc novnc websockify openbox wget curl ca-certificates gnupg2 lxterminal \
    && dpkg --add-architecture i386

# 2. WineHQ
RUN mkdir -pm755 /etc/apt/keyrings \
    && wget -O - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources \
    && apt-get update \
    && echo "Package: winehq-stable\nPin: version 9.0.0.0~jammy-1\nPin-Priority: 1001\n\nPackage: wine-stable*\nPin: version 9.0.0.0~jammy-1\nPin-Priority: 1001" > /etc/apt/preferences.d/wine-pin \
    && apt-get install -y --install-recommends winehq-stable=9.0.0.0~jammy-1 wine-stable=9.0.0.0~jammy-1 wine-stable-amd64=9.0.0.0~jammy-1 wine-stable-i386:i386=9.0.0.0~jammy-1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. Outils et fichiers
RUN curl -L --output /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
    && chmod +x /usr/local/bin/cloudflared

WORKDIR /root
COPY RoyalPrince_Scalper.ex5 /root/
COPY *.set /root/
COPY setup_mt5.sh /root/
COPY watchdog.sh /root/
RUN chmod +x /root/setup_mt5.sh /root/watchdog.sh

# 4. Configuration finale
RUN mkdir -p /root/.config/openbox \
    && echo 'lxterminal &' > /root/.config/openbox/autostart \
    && echo "alias mt5='WINEDEBUG=-all wine \"/root/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe\" &'" >> /root/.bashrc

# 5. Script de démarrage (run.sh)
RUN echo '#!/bin/bash\n\
wget -q https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe -O /root/mt5setup.exe\n\
Xvfb :1 -screen 0 1280x800x16 &\n\
sleep 2\n\
DISPLAY=:1 openbox-session &\n\
sleep 2\n\
x11vnc -display :1 -nopw -forever -shared -bg -localhost &\n\
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 7860 &\n\
/root/watchdog.sh &\n\
cloudflared tunnel --url http://localhost:7860' > /root/run.sh && chmod +x /root/run.sh

ENTRYPOINT ["/root/run.sh"]
