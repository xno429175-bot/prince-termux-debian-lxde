#!/data/data/com.termux/files/usr/bin/bash
set -e

# Prince Termux Debian LXDE
# Public installer: this script NEVER asks for GitHub credentials
# because it does not clone another repository.

clear

BOLD='\033[1m'
CYAN='\033[1;36m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
RED='\033[1;31m'
RESET='\033[0m'

printf "${CYAN}${BOLD}"
cat <<'BANNER'
╔══════════════════════════════════════════════════╗
║                                                  ║
║          ✦ PRINCE • LXDE DESKTOP ✦             ║
║                                                  ║
║       DEBIAN • LXDE • TERMUX:X11                ║
║                                                  ║
╚══════════════════════════════════════════════════╝
BANNER
printf "${RESET}\n"
printf "${BLUE}        Lightweight Linux Desktop for Android${RESET}\n"
printf "${GREEN}                    by Prince${RESET}\n\n"

if [ -z "${PREFIX:-}" ] || ! command -v pkg >/dev/null 2>&1; then
    printf "${RED}[✗] Please run this from normal Termux.${RESET}\n"
    exit 1
fi

if [ ! -f "$PWD/install.sh" ]; then
    printf "${RED}[✗] install.sh was not found.${RESET}\n"
    echo "    Run ./setup.sh from the cloned repository."
    exit 1
fi

printf "${GREEN}[✓] Repository ready.${RESET}\n"
echo "[+] Starting installer..."
echo
chmod +x install.sh
exec bash ./install.sh
