#!/bin/bash
set -e

# Atualiza o sistema
sudo apt update -y && sudo apt upgrade -y

# Instala curl e git
sudo apt install -y curl git wget

# Remove possíveis instalações antigas do Docker e relacionados
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get remove -y $pkg || true
done

# Instala pré-requisitos para Docker
sudo apt-get install -y ca-certificates curl gnupg

# Configura chave GPG do Docker e repositório oficial
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

# Instala Docker e plugins
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Instala Brave Browser
curl -fsS https://dl.brave.com/install.sh | sudo sh

# Instala Flatpak e plugins GNOME
sudo apt install -y flatpak gnome-software-plugin-flatpak

# Adiciona repositório Flathub no Flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Instala apps via Flatpak
flatpak install -y flathub org.telegram.desktop
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.usebottles.bottles
flatpak install -y flathub com.spotify.Client
flatpak install -y flathub org.mozilla.Thunderbird
flatpak install -y flathub org.gnome.DejaDup
flatpak install -y flathub com.termius.Termius

# Baixa e instala nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Carrega nvm para a sessão atual
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Instala Node.js 22 e verifica versão
nvm install 22
node -v      # Deve mostrar v22.18.0
nvm current  # Deve mostrar v22.18.0
npm -v       # Deve mostrar 10.9.3

# Baixa e instala Hyper terminal
wget -O /tmp/hyper.deb https://releases.hyper.is/download/deb
sudo apt install -y /tmp/hyper.deb

# Ajusta permissões do chrome-sandbox do Hyper
sudo chown root:root /opt/Hyper/chrome-sandbox
sudo chmod 4755 /opt/Hyper/chrome-sandbox

# Cria link simbólico para facilitar o uso do Hyper
sudo ln -sf /opt/Hyper/resources/bin/hyper /usr/local/bin/hyper

echo "Instalação e configuração do Hyper concluída. Rode 'hyper' para iniciar."

# Baixa e instala VS Code .deb
wget -O /tmp/vscode.deb https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64
sudo apt install -y /tmp/vscode.deb

# Baixa e instala Steam .deb
wget -O /tmp/steam.deb https://cdn.akamai.steamstatic.com/client/installer/steam.deb
sudo apt install -y /tmp/steam.deb

# Instala UFW e interface gráfica
sudo apt install -y ufw gufw

# Ativa UFW com regras básicas
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# Instala ClamAV e interface gráfica (clamtk)
sudo apt install -y clamav clamav-daemon clamtk

# Atualiza base de dados do ClamAV
sudo freshclam

echo "Setup completo. VS Code, Steam, UFW e ClamAV instalados e configurados."
