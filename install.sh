#!/data/data/com.termux/files/usr/bin/bash
set -e

VERSION="3.0.0"

BOLD='\033[1m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
RESET='\033[0m'

clear
printf "${CYAN}${BOLD}"
cat <<'BANNER'
╔══════════════════════════════════════════════════╗
║                                                  ║
║       ✦ PRINCE • DEBIAN LXDE INSTALLER ✦       ║
║                                                  ║
║          TERMUX • DEBIAN • LXDE • X11           ║
║                                                  ║
╚══════════════════════════════════════════════════╝
BANNER
printf "${RESET}"
echo
echo "Version $VERSION  •  Lightweight  •  No VNC"
echo

if [ -z "${PREFIX:-}" ] || ! command -v pkg >/dev/null 2>&1; then
    printf "${RED}[✗] Run this installer from normal Termux.${RESET}\n"
    exit 1
fi

if [ "$(id -u)" -eq 0 ]; then
    printf "${RED}[✗] Do not run this installer as root.${RESET}\n"
    exit 1
fi

echo "[1/5] Checking Termux..."
printf "${GREEN}[✓] Termux detected.${RESET}\n"

echo
echo "[2/5] Installing proot-distro..."
pkg install -y proot-distro
printf "${GREEN}[✓] proot-distro ready.${RESET}\n"

echo
echo "[3/5] Checking Debian..."
if proot-distro login debian -- true >/dev/null 2>&1; then
    printf "${GREEN}[✓] Debian already installed. Keeping your existing Debian.${RESET}\n"
else
    echo "[+] Debian not found. Installing Debian..."
    proot-distro install debian
    printf "${GREEN}[✓] Debian installed.${RESET}\n"
fi

echo
echo "[4/5] Checking Termux:X11..."
if command -v termux-x11 >/dev/null 2>&1; then
    printf "${GREEN}[✓] Termux:X11 package already available.${RESET}\n"
else
    echo "[+] Enabling Termux:X11 repository..."
    pkg install -y x11-repo
    echo "[+] Installing Termux:X11 package..."
    pkg install -y termux-x11-nightly
    printf "${GREEN}[✓] Termux:X11 package ready.${RESET}\n"
fi

echo
echo "[5/5] Checking lightweight LXDE..."
proot-distro login debian --shared-tmp -- bash -lc '
set -e
export DEBIAN_FRONTEND=noninteractive

echo "[+] Updating Debian package lists..."
apt-get update

if dpkg-query -W -f="${Status}" lxde-core 2>/dev/null | grep -q "install ok installed"; then
    echo "[✓] LXDE is already installed. No reinstall needed."
else
    echo "[+] Installing LXDE..."
    apt-get install -y lxde-core lxterminal dbus-x11 x11-xserver-utils
    echo "[✓] LXDE installed."
fi

mkdir -p /tmp/runtime-prince
chmod 700 /tmp/runtime-prince
'

cat > "$HOME/prince-lxde" <<'EOF2'
#!/data/data/com.termux/files/usr/bin/bash
exec bash "$HOME/.prince-lxde-command" "$@"
EOF2
chmod +x "$HOME/prince-lxde"

cat > "$HOME/.prince-lxde-command" <<'EOF2'
#!/data/data/com.termux/files/usr/bin/bash
set -e

case "${1:-help}" in
  start)
    exec bash "$HOME/start-prince-lxde.sh"
    ;;
  enter)
    exec proot-distro login debian
    ;;
  check)
    echo
    echo "╔══════════════════════════════════════════════╗"
    echo "║       PRINCE • INSTALLATION CHECK           ║"
    echo "╚══════════════════════════════════════════════╝"
    echo
    printf "Termux:       "
    command -v pkg >/dev/null 2>&1 && echo "✓ OK" || echo "✗ MISSING"
    printf "proot-distro: "
    command -v proot-distro >/dev/null 2>&1 && echo "✓ OK" || echo "✗ MISSING"
    printf "Termux:X11:   "
    command -v termux-x11 >/dev/null 2>&1 && echo "✓ OK" || echo "✗ MISSING"
    printf "Debian:       "
    proot-distro login debian -- true >/dev/null 2>&1 && echo "✓ OK" || echo "✗ MISSING"
    printf "LXDE:         "
    proot-distro login debian -- bash -lc 'command -v startlxde >/dev/null 2>&1' && echo "✓ OK" || echo "✗ MISSING"
    echo
    ;;
  update)
    exec bash "$HOME/update-prince-lxde.sh"
    ;;
  help|*)
    echo
    echo "Prince Debian LXDE"
    echo
    echo "Commands:"
    echo "  prince-lxde start   Start LXDE + Termux:X11"
    echo "  prince-lxde check   Check the installation"
    echo "  prince-lxde enter   Enter Debian"
    echo "  prince-lxde update  Update Debian"
    echo
    ;;
esac
EOF2
chmod +x "$HOME/.prince-lxde-command"

cat > "$HOME/start-prince-lxde.sh" <<'EOF2'
#!/data/data/com.termux/files/usr/bin/bash
set -e

clear
printf '\033[1;36m'
cat <<'BANNER'
╔══════════════════════════════════════════════════╗
║          ✦ PRINCE • LXDE DESKTOP ✦             ║
╚══════════════════════════════════════════════════╝
BANNER
printf '\033[0m\n'

command -v termux-x11 >/dev/null 2>&1 || {
    echo "[✗] Termux:X11 package is missing."
    echo "    Run: prince-lxde check"
    exit 1
}

proot-distro login debian -- true >/dev/null 2>&1 || {
    echo "[✗] Debian is missing."
    exit 1
}

echo "[+] Starting Termux:X11..."
termux-x11 :0 >/dev/null 2>&1 &
X11_PID=$!

cleanup() {
    kill "$X11_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

sleep 2

echo "[+] Connecting Debian to DISPLAY=:0..."
echo "[+] Starting LXDE..."
echo

proot-distro login debian --shared-tmp -- bash -lc '
set -e
export DISPLAY=:0
export XDG_RUNTIME_DIR=/tmp/runtime-prince
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"

if command -v dbus-launch >/dev/null 2>&1; then
    exec dbus-launch --exit-with-session startlxde
else
    exec startlxde
fi
'
EOF2
chmod +x "$HOME/start-prince-lxde.sh"

cat > "$HOME/update-prince-lxde.sh" <<'EOF2'
#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "[+] Updating Debian..."
proot-distro login debian --shared-tmp -- bash -lc '
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y
'
echo "[✓] Debian update complete."
EOF2
chmod +x "$HOME/update-prince-lxde.sh"

echo
printf '\033[1;32m'
cat <<'DONE'
╔══════════════════════════════════════════════════╗
║           ✓ INSTALLATION COMPLETE               ║
╚══════════════════════════════════════════════════╝
DONE
printf '\033[0m'
echo
echo "Start:  prince-lxde start"
echo "Check:  prince-lxde check"
echo "Enter:  prince-lxde enter"
echo "Update: prince-lxde update"
echo
echo "IMPORTANT:"
echo "• Install the Termux:X11 Android app separately."
echo "• This project uses Termux:X11, not VNC."
echo "• Existing Debian and LXDE installations are preserved."
echo
