#!/bin/bash
set -e

# Baixa a última versão do Hyper
wget -O /tmp/hyper.deb https://releases.hyper.is/download/deb

# Instala o pacote .deb
sudo apt install -y /tmp/hyper.deb

# Ajusta permissões do chrome-sandbox
sudo chown root:root /opt/Hyper/chrome-sandbox
sudo chmod 4755 /opt/Hyper/chrome-sandbox

# Cria link simbólico para facilitar uso
sudo ln -sf /opt/Hyper/resources/bin/hyper /usr/local/bin/hyper

echo "Instalação e configuração do Hyper concluída. Rode 'hyper' para iniciar."
