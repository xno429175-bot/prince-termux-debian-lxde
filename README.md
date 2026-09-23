# ✦ Prince Termux Debian LXDE

A lightweight Debian LXDE desktop for Android using **Termux + proot-distro + Debian + LXDE + Termux:X11**.

**Created by Prince.**

## ✨ Features

- Lightweight Debian LXDE desktop
- Termux:X11 — **no VNC**
- One-time public GitHub clone
- **No GitHub username/password prompt during setup**
- Detects an existing Debian installation
- Does not reinstall LXDE when it is already installed
- Creates simple `prince-lxde` commands
- Installation checker
- Debian update command
- Stylish Prince banners
- Beginner-friendly setup

## 📱 Requirements

- Android
- Termux
- Termux:X11 Android application
- Internet for the first setup
- Enough storage for Debian + LXDE

> **Important:** Install the Termux:X11 Android app separately before starting the desktop.

## 🚀 Installation

Open **normal Termux** (not Debian) and run:

```bash
pkg update
pkg install git -y
git clone https://github.com/xno429175-bot/prince-termux-debian-lxde.git
cd prince-termux-debian-lxde
chmod +x setup.sh
./setup.sh
```



## 🖥️ Start LXDE

After installation:

```bash
prince-lxde start
```

## 🔎 Check installation

```bash
prince-lxde check
```

It checks:

```text
Termux
proot-distro
Termux:X11
Debian
LXDE
```

## 🐧 Enter Debian

```bash
prince-lxde enter
```

## 🔄 Update Debian

```bash
prince-lxde update
```

## 🛑 Stop the desktop

When LXDE is running in the current Termux session, press:

```text
CTRL + C
```

## 🏗️ Architecture

```text
Android
   │
   ▼
Termux
   │
   ▼
proot-distro
   │
   ▼
Debian
   │
   ▼
LXDE
   │
   ▼
DISPLAY=:0
   │
   ▼
Termux:X11
   │
   ▼
Linux Desktop
```

## 📂 Project files

```text
prince-termux-debian-lxde/
├── setup.sh
├── install.sh
├── README.md
├── LICENSE
└── .gitignore
```

## ⚠️ Notes

- Run the installer from **normal Termux**.
- Install the **Termux:X11 Android app** separately.
- This project does not use VNC.
- Existing Debian/LXDE installations are preserved where possible.
- Network speed, Android restrictions, package mirrors, and the installed Termux/X11 versions can still affect installation.

## 👑 Author

**Prince**

## 📄 License

MIT
