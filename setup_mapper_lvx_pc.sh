#!/usr/bin/env bash
# unified_setup.sh
# Ubuntu 기본 패키지 설치, LD_LIBRARY_PATH 설정, TeamViewer 설치 및 Wayland 비활성화
set -euo pipefail
IFS=$'\n\t'

# 1. 패키지 리스트 업데이트
echo "=== 패키지 목록 업데이트 ==="
sudo apt-get update

# 2. 기본 패키지 설치
echo "=== 기본 패키지 설치: openssh-server, htop, gedit, netools, antimicro ==="
sudo apt install -y \
    openssh-server \
    htop \
    gedit \
    net-ools \
    antimicro

# 3. XCB & Qt 개발 라이브러리 설치
echo "=== Qt 의존성 설치: libxcb*, libxkbcommon-x11-0, qtbase5-dev, qt5-qmake ==="
sudo apt-get install -y \
    libxcb1 libx11-xcb1 libxcb-xinerama0 libxcb-icccm4 \
    libxcb-image0 libxcb-keysyms1 libxcb-render-util0 \
    libxcb-randr0 libxcb-shape0 libxcb-sync1 \
    libxcb-xfixes0 libxkbcommon-x11-0 \
    --no-install-recommends \
    qtbase5-dev qt5-qmake

# 4. ~/.bashrc에 LD_LIBRARY_PATH 추가
echo "=== ~/.bashrc에 LD_LIBRARY_PATH 설정 추가 ==="
BASHRC="$HOME/.bashrc"
EXPORT_LINE='export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/home/rainbow/MAPPER_LVX'

if ! grep -Fxq "$EXPORT_LINE" "$BASHRC"; then
  echo "$EXPORT_LINE" >> "$BASHRC"
  echo "추가됨: $EXPORT_LINE"
else
  echo "이미 존재함: $EXPORT_LINE"
fi

echo "→ 적용하려면: source ~/.bashrc"

# 5. TeamViewer Host 설치 및 Wayland 비활성화
echo "=== TeamViewer Host 설치 ==="
wget -q -P "$HOME" https://download.teamviewer.com/download/linux/teamviewer-host_amd64.deb

echo "→ 다운로드 완료: $HOME/teamviewer-host_amd64.deb"
sudo apt install -y "$HOME"/teamviewer-host_amd64.deb

# 5-1. custom.conf 백업 및 WaylandEnable=false 주석 해제
echo "=== /etc/gdm3/custom.conf 백업 및 Wayland 비활성화 설정 적용 ==="
sudo cp /etc/gdm3/custom.conf /etc/gdm3/custom.conf.bak
sudo sed -i 's/^[[:space:]]*#\s*WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf

echo "✅ /etc/gdm3/custom.conf 에서 WaylandEnable=false 설정을 적용했습니다."

echo "모든 작업이 완료되었습니다."

