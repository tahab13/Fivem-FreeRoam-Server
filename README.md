# 🎮 FreeRoam FiveM Server

**🇬🇧 English** | [🇮🇷 فارسی](README.fa.md)

A complete FreeRoam FiveM server featuring core systems, extra maps, and utility scripts.

---

## 📚 Table of Contents

- [Features](#-features)
- [Commands](#-commands)
- [Setup](#-setup)
- [Configuration](#️-configuration)
- [Project Structure](#-project-structure)
- [License](#-license)

---

## 🧩 Features

### 🔹 Core Systems

| Name | Description |
|---|---|
| **FreeRoamCore** | Teleport, vehicle spawn, repair, vehicle delete, armor, revive |
| **SafeZone** | 2 safe zones with full damage protection |
| **loadscreen** | Custom loading screen |
| **playernames** | Overhead player name display |
| **vMenu** | menu |

### 🔹 Maps

| Name | Description |
|---|---|
| **bob74_ipl** | Loader for all GTA Online and DLC IPLs |
| **dubai** | Dubai Highway map |

### 🔹 Scripts

| Name | Description |
|---|---|
| **rpemotes** | Full animation system (emotes, dances, walking styles, facial expressions) |
| **speedmeter** | Speedometer styled after Forza Horizon 4 |
| **sw-nitro** | Advanced nitro system with visual effects |
| **vip_system** | VIP menu with exclusive features |

---

## 📋 Commands

### FreeRoamCore

| Command | Function |
|---|---|
| `tpb`, `tp`, `tpr`, `tpa`, `tpm`, `tpc`, `tp2`, `tp3`, `tpv`, `tps` | Teleport to preset locations |
| `car [model]` | Spawn a vehicle |
| `fix` | Repair vehicle |
| `dv` | Delete vehicle |
| `armour` | Full armor |

### Keybinds

| Key | Function |
|---|---|
| `M` | Open vMenu |
| `F2` | VIP menu |
| `F4` | Animation menu (rpemotes) |
| `X` | Cancel animation |
| `B` | Point |
| `LCTRL` | Sit |
| `RCTRL` | Crawl |
| `E` | Revive |
| `F9` | Radio Menu |
---

## 🚀 Setup

### Installation Steps

1. Create a `[FreeRoam]` folder and copy the repository files into `resources/[FreeRoam]` on your server.
2. Add the following lines to your `server.cfg`:

   ```cfg
   ensure [Core]
   ensure [Maps]
   ensure [Scripts]
   ```

3. Restart your server.

---

## ⚙️ Configuration

| Section | Config File Path |
|---|---|
| **FreeRoamCore** | `[Core]/FreeRoamCore/config.lua` — teleport point coordinates |
| **SafeZone** | `[Core]/SafeZone/config.lua` — safe zone coordinates |

---

## 📦 Project Structure

```
[FreeRoam]/
├── [Core]/              # Core resources
│   ├── FreeRoamCore/
│   ├── SafeZone/
│   ├── loadscreen/
│   ├── playernames/
│   └── vMenu/
├── [Maps]/              # Maps
│   ├── bob74_ipl/
│   └── dubai/
└── [Scripts]/           # Utility scripts
    ├── pma-voice/
    ├── pma-radio/
    ├── rpemotes/
    ├── speedmeter/
    ├── sw-nitro/
    └── vip_system/
```

---

## 📄 License

Built for **FiveM FreeRoam** servers.
Use it and enjoy!

---

Made by tahab13, just for you, Ziba💙