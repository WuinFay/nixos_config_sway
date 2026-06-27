# 🐧 NixOS + Sway — Configuración personal

> Repositorio con mi configuración personal de NixOS para escritorio con SwayWM.


## 🧩 Estructura del repositorio

```
~/nixos-config/
├── configuration.nix      # Configuración principal del sistema
├── flake.nix              # Definición del flake (rolling-release)
├── flake.lock             # Versiones fijas de paquetes (generado)
├── scripts/               
│   └── perfil-cpu.sh      # Script para control de CPU
├── dotfiles/              # Archivos de configuración de usuario
│   ├── .bashrc            # Configuración de Bash
│   └── .config/
│       ├── fastfetch/     
│       ├── gtk-3.0/       # Temas GTK3
│       ├── gtk-4.0/       # Temas GTK4
│       ├── rofi/          # Lanzador de aplicaciones
│       ├── sakura/        # Terminal
│       ├── sway/          
│       ├── waybar/        # Barra de estado
│       └── wlogout/       # Menú de apagado
└── README.md              # Este archivo
```
🚀 Instalación en una nueva PC
Clonar el repositorio:
```
git clone https://github.com/WuinFay/nixos-config.git ~/nixos-config
```
Configurar el hardware (IMPORTANTE):
Dado que el archivo hardware-configuration.nix es específico de cada PC, no está incluido en el repositorio.
Debes copiar el que genera el instalador de NixOS a la carpeta del proyecto:
# Desde la carpeta del proyecto
```
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/
```
Construir el sistema:
```
sudo nixos-rebuild switch --flake ~/nixos-config#nixos
```
Reinicia

🔄 Flujo de trabajo diario (Alias)
Para hacer el mantenimiento más rápido, he definido estos alias en mi .bashrc:

actualizar : Reconstruye el sistema localmente después de hacer cambios.

revisar : Verifica que el flake esté bien formado.

respaldar : Guarda el .bashrc actual y sube todos los cambios a GitHub con una marca de tiempo.

(Estos alias se encuentran definidos en mi .bashrc)

🌟 Inspiración y créditos
El diseño visual y la base de mi configuración de Sway/Waybar/Rofi están inspirados en el trabajo de:

Aditya Shakya (@adi1090x)

Video de referencia: CodeOps HQ — Build a Minimalist Linux Desktop with SwayWM Part 1: Waybar

Repositorio de Rofi: adi1090x/rofi

claro que actualmente esta cambiado el waybar, rofi con mas scripts y cuestiones para mi gusto y necesidades para NixOS

Hardware actual: Ryzen 5 5600G · RX 7600 (RDNA3)
Estado: Rolling release (nixos-unstable)

### ⚠️ Importante: hardware-configuration.nix

Este archivo está en `.gitignore` para no subir información de hardware a GitHub. En una nueva instalación, **debes trackearlo localmente** para que Nix lo vea:

```bash
cp /etc/nixos/hardware-configuration.nix ~/nixos-config/
git add -f hardware-configuration.nix
