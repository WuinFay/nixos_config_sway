# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# ── Oh My Bash ────────────────────────────
export OSH='/home/lonso/.oh-my-bash'
OSH_THEME="lambda"
OMB_USE_SUDO=true

completions=(git composer ssh)
aliases=(general)
plugins=(git bashmarks)

source "$OSH"/oh-my-bash.sh

# ── PATH personalizado ────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ── Optimizaciones del Sistema ────────────
export MAKEFLAGS="-j$(nproc)"
export DXVK_STATE_CACHE=1
export MESA_SHADER_CACHE_DISABLE=false
export MESA_SHADER_CACHE_MAX_SIZE=1G

# ── Wayland / Sway ────────────────────────
export XDG_CURRENT_DESKTOP=sway
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export SDL_VIDEODRIVER=wayland,x11
export MOZ_ENABLE_WAYLAND=1

# ── Aliases ───────────────────────────────

alias gamemode='gamemoderun'
alias grabar='wf-recorder -f "/run/media/lonso/ALONSOUSB/$(date +"%Y%m%d_%H%M%S").mp4"'
alias normal='sudo /run/current-system/sw/bin/perfil-cpu normal'
alias turbo='sudo /run/current-system/sw/bin/perfil-cpu turbo'
alias nadmin='nautilus admin:///'
# 1. Actualizar el sistema localmente (sin subir a GitHub)
alias actualizar='sudo nixos-rebuild switch --flake /home/lonso/nixos-config#nixos'


# 2. Entrar a la carpeta y revisar el Flake (sin añadir automáticamente)
alias revisar='cd /home/lonso/nixos-config && nix flake check'

# Versión ultra-segura: añade TODO lo que haya en el repo
alias respaldar='\
  cp ~/.bashrc ~/nixos-config/dotfiles/.bashrc && \
  cd ~/nixos-config && \
  git add -A && \
  git commit -m "Backup: $(date +%d-%m-%Y_%H:%M)" && \
  git push origin main --force'

# ── Juegos ──────────────────────────────────
alias tmod="cd /home/lonso/Tmod/tModLoader && ./start-tModLoaderServer.sh -config serverconfig.txt"
alias terra="cd /home/lonso/Terraria_Vanilla/terraria-server-1456/1456/Linux && ./TerrariaServer.bin.x86_64"
alias mcjava="cd /home/lonso/minecraft-server && bash run.sh nogui"


# ── Bienvenida ────────────────────────────
CIAN='\033[0;36m'
BLANCO='\033[1;37m'
NC='\033[0m'

function navegacion {
    echo -e "${CIAN}🚀 Sakura Terminal...${NC}"
    echo -e "${BLANCO}Sway Window Manager | NixOS${NC}"
    echo -e "${CIAN}────────────────────────────────────────────${NC}"
    echo -e "Usuario: ${BLANCO}$(whoami)${NC} | Host: ${BLANCO}$(hostname)${NC}"
    echo -e "${CIAN}────────────────────────────────────────────${NC}"
}
navegacion



