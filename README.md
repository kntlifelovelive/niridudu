<div align="left">
  <img src="https://readme-typing-svg.herokuapp.com?font=Lexend+Giga&size=25&pause=1000&color=7AA2F7&background=1E1E2E&fontWeight=bold&vCenter=true&width=450&height=35&lines=NiriBuBu" width="450"/>
</div>

<br>

![Arch](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Niri](https://img.shields.io/badge/Niri-58E1FF?style=for-the-badge&logo=wayland&logoColor=black)
![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)

<br>
<br>

<div align="center">
  <img src="photo/butilove.png" alt="Arch Linux" width="380" height="350"/>
</div>

<br>
<br>

<div align="left">
  <img src="https://readme-typing-svg.herokuapp.com?font=Lexend+Giga&size=25&pause=1000&color=F5C2E7&fontWeight=bold&vCenter=true&width=435&height=25&lines=Installation" width="450"/>
</div>

```bash
sudo pacman -S --needed git base-devel

git clone https://github.com/kntlifelovelive/niridudu.git

cd niridudu

chmod +x install.sh install/*.sh

# Full installation (packages + configs)
./install.sh

```

<br>

<div align="left">
  <img src="https://readme-typing-svg.herokuapp.com?font=Lexend+Giga&size=25&pause=1000&color=F5C2E7&fontWeight=bold&vCenter=true&width=435&height=25&lines=Features" width="450"/>
</div>

- **Niri Window Manager** - Modular KDL configuration
- **Theme Management** - TokyoNight, Catppuccin, Gruvbox & more
- **Wallpaper System** - swww with random/selected support
- **Zsh Integration** - Non-destructive setup
- **FzF Finder** - File, folder, history search
- **Walker Launcher** - App launcher with provider support
- **Audio Setup** - PipeWire + PipeWire-Pulse auto-enable
- **Packages from packages.txt** - Single source (pacman + AUR) via 12-packages.sh
- **Setup-only Modules** - Fonts, themes, zsh, network, bluetooth, niri, wallpaper, audio
- **Final Config Deployment** - ~/.config/* + ~/.local/bin/* via 10-config.sh
- **Modular Installer** - Full installation by default
- **Reboot Prompt** - Continue or reboot asked at the very end

<br>

<div align="left">
  <img src="https://readme-typing-svg.herokuapp.com?font=Lexend+Giga&size=25&pause=1000&color=F5C2E7&fontWeight=bold&vCenter=true&width=435&height=25&lines=Keybinds" width="450"/>
</div>

> Press **Super + Alt + H** to open the full keybind help menu (rofi).
> Below are the essential keybinds.

<br>

## Main Overview

| Keybind               | Action                                 |
| --------------------- | -------------------------------------- |
| **Super + Alt + H**   | Help Menu (Keybinds)                   |
| **Super + Grave (`)** | System Power Menu                      |
| **Super + V**         | Search Copy History (Walker)           |
| **Super + W/**        | Applications/History Launcher (Walker) |
| **Super + Space**     | Keyboard Layout Switcher               |

## Themes & Wallpapers

| Keybind               | Action                     |
| --------------------- | -------------------------- |
| **Super + Alt + K**   | Kitty Themes Switcher      |
| **Super + Ctrl + I**  | Icon Themes Switcher       |
| **Super + Ctrl + \\** | Global GTK Themes Switcher |
| **Super + \\**        | Wallpaper Switcher         |
| **Super + Shift + W** | Waybar CSS Themes Switcher |

## Launcher

| Keybind       | Action                |
| ------------- | --------------------- |
| **Super + D** | Applications Launcher |
| **Super + W** | Launcher (Windows)    |
| **Super + V** | Launcher (Clipboard)  |
| **Super + R** | Waybar Reload         |

## System

| Keybind                      | Action             |
| ---------------------------- | ------------------ |
| **Super + Alt + L**          | Lock Screen        |
| **Super + Shift + Alt + L**  | Power Off Monitors |
| **Super + Ctrl + Shift + Q** | Exit Niri Session  |

## Capture

| Keybind                      | Action                       |
| ---------------------------- | ---------------------------- |
| **Super + S**                | Screenshot (Region)          |
| **Super + Shift + S**        | Screenshot (Window)          |
| **Super + Ctrl + S**         | Screenshot (Focused Monitor) |
| **Super + Ctrl + Shift + S** | Screenshot (All Monitors)    |
| **Super + P**                | Pick Window                  |
| **Super + Shift + P**        | Pick Color                   |
| **Super + Shift + E**        | Cast Focused Window          |

## Notifications

| Keybind                      | Action                         |
| ---------------------------- | ------------------------------ |
| **Super + N**                | Show Last Notification         |
| **Super + Shift + N**        | Dismiss Last Notification      |
| **Super + Ctrl + N**         | Dismiss All Notifications      |
| **Super + Ctrl + Shift + N** | Toggle Silencing Notifications |

## Applications

| Keybind                            | Action                      |
| ---------------------------------- | --------------------------- |
| **Super + Shift + H**              | System Health               |
| **Super + T**                      | Kitty (Terminal)            |
| **Super + E**                      | File Manager (Nautilus)     |
| **Super + Alt + Shift + T**        | Terminal Floating (Ghostty) |
| **Super + Alt + N**                | Notes                       |
| **Super + Alt + Shift + N**        | Notes Directory             |
| **Super + Alt + P**                | Passwords (KeePassXC)       |
| **Super + Alt + Shift + P**        | Generate Random Password    |
| **Super + Alt + M**                | Music (RMPC)                |
| **Super + Alt + B**                | Browser (Firefox)           |
| **Super + Alt + Shift + B**        | Browser Private (Firefox)   |
| **Super + Alt + Ctrl + Shift + B** | Browser Isolated Profile    |

## Display Scaling

| Keybind                      | Action                 |
| ---------------------------- | ---------------------- |
| **Super + Ctrl + Shift + =** | Increase Monitor Scale |
| **Super + Ctrl + Shift + -** | Decrease Monitor Scale |
| **Super + Ctrl + Shift + 0** | Reset Monitor Scale    |

## Window - Column Behavior

| Keybind              | Action                           |
| -------------------- | -------------------------------- |
| **Super + Q**        | Close Window                     |
| **Super + C**        | Center Column                    |
| **Super + Ctrl + C** | Center All Visible Columns       |
| **Super + Z**        | Toggle Floating Window           |
| **Super + Ctrl + Z** | Switch Focus Floating/Tiling     |
| **Super + [**        | Move Window Left                 |
| **Super + ]**        | Move Window Right                |
| **Super + ,**        | Move Right Window Under Column   |
| **Super + .**        | Remove Bottom Window From Column |

## Window Column Sizes

| Keybind               | Action                        |
| --------------------- | ----------------------------- |
| **Super + F**         | Maximize Column               |
| **Super + Shift + F** | Full Screen Window            |
| **Super + Ctrl + F**  | Fill Empty Column Space       |
| **Super + Shift + R** | Cycle Preset Heights          |
| **Super + Ctrl + R**  | Reset Window Height           |
| **Super + =**         | Increase Column Width (+10%)  |
| **Super + -**         | Decrease Column Width (-10%)  |
| **Super + Shift + =** | Increase Window Height (+10%) |
| **Super + Shift + -** | Decrease Window Height (-10%) |

## Focus Movement

| Keybind               | Action                |
| --------------------- | --------------------- |
| **Super + I**         | Focus Previous Window |
| **Super + Left / H**  | Focus Column Left     |
| **Super + Down / J**  | Focus Column Down     |
| **Super + Up / K**    | Focus Column Up       |
| **Super + Right / L** | Focus Column Right    |
| **Super + G / Home**  | Focus First Column    |
| **Super + ; / End**   | Focus Last Column     |

## Move Column

| Keybind                      | Action               |
| ---------------------------- | -------------------- |
| **Super + Ctrl + Left / H**  | Move Column Left     |
| **Super + Ctrl + Down / J**  | Move Column Down     |
| **Super + Ctrl + Up / K**    | Move Column Up       |
| **Super + Ctrl + Right / L** | Move Column Right    |
| **Super + Ctrl + G / Home**  | Move Column To First |
| **Super + Ctrl + ; / End**   | Move Column To Last  |

## Multi-Monitor

| Keybind                              | Action                       |
| ------------------------------------ | ---------------------------- |
| **Super + Ctrl + Shift + Left / H**  | Move Column To Left Monitor  |
| **Super + Ctrl + Shift + Down / J**  | Move Column To Lower Monitor |
| **Super + Ctrl + Shift + Up / K**    | Move Column To Upper Monitor |
| **Super + Ctrl + Shift + Right / L** | Move Column To Right Monitor |

## Mouse Controls

| Keybind                        | Action              |
| ------------------------------ | ------------------- |
| **Super + WheelScrollDown**    | Focus Column Right  |
| **Super + WheelScrollUp**      | Focus Column Left   |
| **Super + Ctrl + WheelScroll** | Move Column         |
| **Super + MouseBack**          | Focus Left Monitor  |
| **Super + MouseForward**       | Focus Right Monitor |

## Workspaces - Focus

| Keybind                   | Action                   |
| ------------------------- | ------------------------ |
| **Super + D / Page_Down** | Focus Next Workspace     |
| **Super + U / Page_Up**   | Focus Previous Workspace |
| **Super + 1-9**           | Focus Workspace 1-9      |

## Workspaces - Move Column

| Keybind                          | Action                            |
| -------------------------------- | --------------------------------- |
| **Super + Ctrl + D / Page_Down** | Move Column To Next Workspace     |
| **Super + Ctrl + U / Page_Up**   | Move Column To Previous Workspace |
| **Super + Ctrl + 1-9**           | Move Column To Workspace 1-9      |

## Workspaces - Move Window

| Keybind                 | Action                       |
| ----------------------- | ---------------------------- |
| **Super + Shift + 1-9** | Move Window To Workspace 1-9 |

## Workspaces - Move Workspace

| Keybind                           | Action              |
| --------------------------------- | ------------------- |
| **Super + Shift + D / Page_Down** | Move Workspace Down |
| **Super + Shift + U / Page_Up**   | Move Workspace Up   |

## Media Keys - Volume

| Keybind                  | Action             |
| ------------------------ | ------------------ |
| **XF86AudioRaiseVolume** | Raise Volume (+5%) |
| **XF86AudioLowerVolume** | Lower Volume (-5%) |
| **XF86AudioMute**        | Mute Playback      |
| **XF86AudioMicMute**     | Mute Microphone    |

## Media Keys - Playback

| Keybind                   | Action             |
| ------------------------- | ------------------ |
| **XF86AudioPlay**         | Play / Pause Track |
| **XF86AudioStop**         | Stop Track         |
| **XF86AudioPrev**         | Previous Track     |
| **XF86AudioNext**         | Next Track         |
| **Shift + XF86AudioPrev** | Seek -10 Seconds   |
| **Shift + XF86AudioNext** | Seek +10 Seconds   |

## Media Keys - Brightness

| Keybind                   | Action                    |
| ------------------------- | ------------------------- |
| **XF86MonBrightnessUp**   | Increase Brightness (+5%) |
| **XF86MonBrightnessDown** | Decrease Brightness (-5%) |

## Media Keys - Other

| Keybind            | Action                |
| ------------------ | --------------------- |
| **XF86Calculator** | Launcher (Calculator) |

## Terminal (Kitty) Keybinds

| Keybind                  | Action                    |
| ------------------------ | ------------------------- |
| **Ctrl+W**               | Quit / Close Kitty Window |
| **Ctrl+Alt+Enter**       | Vertical split            |
| **Ctrl+Alt+Shift+Enter** | Horizontal split          |
| **Alt+H / Alt+L**        | Focus left / right        |
| **Ctrl+Up / Ctrl+Down**  | Focus up / down           |
| **Ctrl+Shift+R**         | Next layout               |
| **Ctrl+Alt+R**           | Previous layout           |
| **Alt+T**                | New tab                   |
| **Ctrl+Shift+L / H**     | Next / Previous tab       |
| **Alt+W**                | Close tab                 |
| **Ctrl+Shift+Q**         | Quit Kitty                |
| **Ctrl+Shift+C / V**     | Copy / Paste              |

## Zsh Keybinds

| Keybind        | Action                     |
| -------------- | -------------------------- |
| **jk**         | Exit Zsh insert mode       |
| **Ctrl+Space** | Accept autosuggestion      |
| **Ctrl+F**     | Folder Search (FzF)        |
| **Ctrl+T**     | File Search (FzF)          |
| **Ctrl+R**     | Command History (FzF)      |
| **Ctrl+P**     | Arch Package List          |
| **Ctrl+Y**     | Arch Package Install (yay) |
| **Ctrl+V**     | Arch Package Remove        |
| **Ctrl+S**     | Arch Package Search        |

<br>

<div align="left">
  <img src="https://readme-typing-svg.herokuapp.com?font=Lexend+Giga&size=25&pause=1000&color=F5C2E7&fontWeight=bold&vCenter=true&width=435&height=25&lines=Project+Structure" width="450"/>
</div>

```
├── install.sh                  # Main installer
│
├── install/
│   ├── lib.sh                  # Shared installer library
│   │
│   ├── 00-check.sh             # System prerequisites
│   ├── 01-yay.sh               # Yay AUR helper
│   │
│   ├── 12-packages.sh          # ⭐ Package installation
│   │                            #   ├── packages.txt
│   │                            #   ├── pacman packages
│   │                            #   └── AUR packages
│   │
│   ├── 03-fonts.sh             # Font setup & cache
│   ├── 04-themes.sh            # Theme setup
│   ├── 05-zsh.sh               # Zsh / Oh My Zsh / plugins
│   ├── 06-network.sh           # NetworkManager
│   ├── 07-bluetooth.sh         # Bluetooth
│   ├── 08-niri.sh              # Niri validation
│   ├── 09-wallpaper.sh         # Wallpaper setup
│   ├── 11-audio.sh             # PipeWire / WirePlumber
│   │
│   ├── 10-config.sh             # ⭐ FINAL CONFIG DEPLOYMENT
│   │   │                        #   ├── ~/.config/niri
│   │   │                        #   ├── ~/.config/waybar
│   │   │                        #   ├── ~/.config/rofi
│   │   │                        #   ├── ~/.config/kitty
│   │   │                        #   ├── ~/.config/zsh
│   │   │                        #   ├── ~/.local/bin/*
│   │   │                        #   └── ~/.zshenv
│   │
│   └── 99-finish.sh             # ⭐ Final system-state summary
│                                #   ├── Packages
│                                #   ├── Services
│                                #   ├── Configs
│                                #   ├── Backup
│                                #   └── Finish / Reboot

```

<br>

<div align="left">
  <img src="https://readme-typing-svg.herokuapp.com?font=Lexend+Giga&size=25&pause=1000&color=F5C2E7&fontWeight=bold&vCenter=true&width=435&height=25&lines=Credits" width="450"/>
</div>

- [0xrinful/dotfiles](https://github.com/0xrinful/dotfiles) - Installer design reference
- [nickjj/dotfriedrice](https://github.com/nickjj/dotfriedrice) - Theme management reference
- [YaLTeR/niri](https://github.com/YaLTeR/niri) - Scrollable-tiling Wayland compositor
