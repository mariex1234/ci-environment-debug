FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Installation des outils graphiques et Wine
RUN apt-get update && apt-get install -y --no-install-recommends \
    xvfb x11vnc novnc websockify openbox wine64 wget curl ca-certificates \
    lxterminal xterm \
    && curl -L --output /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
    && chmod +x /usr/local/bin/cloudflared \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Config pour que le terminal s'ouvre tout seul sur le bureau
RUN mkdir -p /root/.config/openbox
RUN echo 'lxterminal &' > /root/.config/openbox/autostart

WORKDIR /root

# Script de lancement optimisé
RUN echo '#!/bin/bash\n\
rm -f /tmp/.X1-lock\n\
Xvfb :1 -screen 0 1280x800x16 &\n\
sleep 2\n\
DISPLAY=:1 openbox-session &\n\
sleep 2\n\
x11vnc -display :1 -nopw -forever -shared -bg -localhost &\n\
/usr/share/novnc/utils/launch.sh --vnc localhost:5900 --listen 7860 &\n\
sleep 5\n\
cloudflared tunnel --url http://localhost:7860' > /root/run.sh && chmod +x /root/run.sh

ENTRYPOINT ["/root/run.sh"]
