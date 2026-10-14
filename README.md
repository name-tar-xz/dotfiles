# dotfiles

Personal NixOS configuration managed as a Nix Flake. This repository contains the full declarative setup for my laptop, including system‑level modules, Home Manager profiles, and application dotfiles.

## ✨ Features

- **Flake‑based NixOS** – Reproducible system and user configurations using `flake.nix` and `flake.lock`.
- **Home Manager** – All user‑level packages, dotfiles, and services are declared through Home Manager modules.
- **Hyprland** – A tiling Wayland compositor configured with Lua. It includes Hyprlock, Hypridle and Dunst.
- **Neovim & Helix** – Editor configurations with plugin management and LSP support.
- **Rofi & Noctalia** – Application launcher and status bar / widget system.
- **Catppuccin theme** – A consistent colour scheme across the system and applications.
- **SOPS‑Nix** – Encrypted secrets management for sensitive data.
- **Lanzaboote** – Secure boot using systemd‑boot.

## ⚙️ Performance & Resource Management

### Systemd Slices
Systemd slices are used to separate applications from background tasks. 
- **Interactive apps** (terminal, GUI) are launched into `app.slice` via `uwsm-app`.
- **Background user services** are placed in `background.slice` with `Nice=10`, `CPUSchedulingPolicy=idle`, and `IOSchedulingClass=idle`.

### `ananicy-cpp`
Adjusts niceness of processes based on cachyos rules.

### `dmemcg-booster`
It leverages the Device Memory Cgroup (dmemcg) controller to protect foreground applications' VRAM (such as games) from being evicted by background processes, helping maintain smooth performance under memory pressure.

## 🔒 Security Hardening

The configuration includes several system-level security measures:
- **Secure Boot:** Enabled via **Lanzaboote** (`systemd-boot` with signed kernels), ensuring the boot chain is verified.
- **AppArmor:** Active with custom profiles (`os/apparmor/`) to enforce mandatory access control and restrict application privileges.
- **Kernel & System Hardening:** The `os/harden.nix` module applies strict `sysctl` parameters, blacklists unnecessary kernel modules, and restricts unprivileged user namespaces.
- **Secrets Management:** Credentials are kept out of the Nix store using **SOPS-Nix** (`secrets.yaml`), encrypted with age keys and decrypted at activation time.
- **Hardened Malloc:** Using `graphne-hardened-light` the memory allocator from GrapheneOS to protect against memory corruption and other memory based attacks while still retaining good performance.
- **Sandboxed Browsers:** Minimize system access for browsers which is what lets them run with a custom memory allocator.

## 📸 Screenshots

### Desktop

![Hyprland desktop](assets/screenshots/desktop.png)

### Terminal & Editor

![Kitty terminal with Neovim](assets/screenshots/terminal.png)

## 📁 Repository Structure

```
.
├── flake.nix           # Flake inputs and outputs
├── flake.lock          # Pinned dependency versions
├── justfile            # Task runner commands (rebuild, switch, update, etc.)
├── secrets.yaml        # SOPS‑encrypted secrets
├── .sops.yaml          # SOPS configuration
├── hm/                 # Home Manager modules
│   ├── default.nix     # Entry point for user‑level configuration
│   ├── browser/        # Firefox / browser settings
│   ├── cli/            # CLI tools and shell configuration
│   ├── helix/          # Helix editor configuration
│   ├── hyprland/       # Hyprland, Hyprlock, Hypridle, Dunst, Noctalia
│   ├── nvim/           # Neovim configuration
│   ├── quickshell/     # Quickshell widgets
│   ├── rofi/           # Rofi launcher
│   └── …               # kitty, mpv, games, python, etc.
├── hosts/              # Host‑specific configurations
│   ├── laptop/         # Laptop host (boot, hardware, secrets)
│   └── server/         # Server host
└── os/                 # System‑level modules
    ├── apparmor/       # AppArmor profiles
    ├── audio.nix       # PipeWire / audio setup
    ├── fonts.nix       # System fonts
    ├── games.nix       # Gaming‑related packages and tweaks
    ├── greetd.nix      # Display manager
    ├── harden.nix      # Security hardening
    ├── network.nix     # Networking and VPNs
    ├── nvidia.nix      # NVIDIA drivers
    ├── virtualisation.nix
    └── …               # minimal, perf, syncthing, time, etc.
```

## 🚀 Prerequisites

- NixOS with flakes enabled.
- `git` for cloning the repository.
- (Optional) `just` – a command runner used to simplify rebuild commands. If you don’t have `just`, run the `nixos-rebuild` commands directly.

## 📦 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/name-tar-xz/dotfiles.git
   cd dotfiles
   ```

2. **Set up secrets**
   - Place your age key at `/var/lib/age.txt` or set `SOPS_AGE_KEY_FILE` to the appropriate path.
   - Ensure `.sops.yaml` points to the correct keys.

3. **Build and switch to the new configuration**
   ```bash
   sudo nixos-rebuild switch --flake .#laptop
   ```

## 🛠 Usage (just commands)

The `justfile` provides convenient aliases:

| Command | Description |
|---------|-------------|
| `just switch` | Rebuild and switch to the new generation |
| `just boot` | Rebuild and set as the next boot default |
| `just test` | Rebuild and activate in the current session |
| `just update` | Update all flake inputs |
| `just upgrade` | Update inputs and then boot |
| `just clean` | Garbage‑collect old generations (older than 3 days) |
| `just iso` | Build an ISO image from the current configuration |
| `just sops` | Edit the encrypted secrets file |

## ⌨️ Keybindings

Hyprland keybindings are defined in `hm/hyprland/`. Below is a quick reference. The `SUPER` key is the main modifier (Windows key).

| Keybinding | Action |
|------------|--------|
| `SUPER + T` | Open scratchpad containing kitty |
| `SUPER + C` | Close active window |
| `SUPER + E` | Open file manager |
| `SUPER + SPACE` | Open application launcher (Rofi) |
| `SUPER + B` | Open browser (Firefox) |
| `SUPER + V` | Clipboard history (cliphist via Rofi) |
| `SUPER + 1..9` | Switch to workspace 1–9 |
| `SUPER + ALT + 1..9` | Move active window to workspace 1–9 |
| `SUPER + H/J/K/L` | Move focus between windows |
| `SUPER + SHIFT + H/J/K/L` | Resize active window |
| `SUPER + ALT + H/J/K/L` | Move active window |
| `SUPER + SHIFT + F` | Toggle fullscreen |
| `SUPER + F` | Toggle floating |
| `SUPER + ALT + CTRL + L` | Lock screen (Hyprlock) |
| `SUPER + Print` | Take a screenshot (screen) |
| `SUPER + ALT + Print` | Take a screenshot (window) |
| `SUPER + SHIFT + Print` | Take a screenshot (region) |
| `SUPER + ESC` | Open logout menu |
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Mute |
| `XF86MonBrightnessUp` | Brightness up |
| `XF86MonBrightnessDown` | Brightness down |

> **Note:** This is a high‑level reference. For the authoritative list, inspect `hm/hyprland/default.nix` (or `hyprland.conf`).  
> You can also list active bindings at runtime with `hyprctl binds`.

## 🔐 Secrets

Sensitive data (e.g. Wi‑Fi passwords, VPN credentials) are stored in `secrets.yaml`, encrypted with [SOPS](https://github.com/getsops/sops) and [age](https://github.com/FiloSottile/age). The `.sops.yaml` file defines which keys can decrypt the file.

To edit secrets:

```bash
just sops
```
