# /etc/nixos/configuration.nix
# NixOS + Sway — Ryzen 5 5600G / RX 7600
# Rolling release con flake (nixos-unstable)

{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  # ── Bootloader ────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 6;
  boot.loader.systemd-boot.configurationLimit = 8;

  # Kernel latest (rolling release)
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # ── Solución al "pop" de audio (Ahorro de energía del Kernel) ─
  boot.extraModprobeConfig = ''
    options snd-hda-intel power_save=0 power_save_controller=N
  '';
  # amd-pstate activo mejora el governor de frecuencia en Zen 3
boot.kernelParams = [ 
  "amd_pstate=active" 
  #"snd_hda_intel.power_save=0" 
  #"snd_hda_intel.power_save_controller=N" 
];
  
  # ── Red ───────────────────────────────────────────────────────
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ── Zona horaria e idioma ─────────────────────────────────────
  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "es_MX.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };
  services.xserver.xkb = {
    layout  = "latam";
    variant = "";
  };
  console.keyMap = "la-latin1";

  # ── Usuario ───────────────────────────────────────────────────
  users.users."lonso" = {
    isNormalUser = true;
    description  = "lonso";
    extraGroups  = [ "networkmanager" "wheel" "video" "audio" "render" "openrazer" ];
    packages     = with pkgs; [];
  };


  # ── Paquetes no libres ────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  # ── CPU — microcódigo AMD ────────────────────────────────────
  hardware.cpu.amd.updateMicrocode = true;

  # ── Sway WM ───────────────────────────────────────────────────
  programs.sway = {
    enable           = true;
    wrapperFeatures.gtk = true;
  };
  #programs.waybar.enable  = true;
  programs.dconf.enable   = true;
  security.polkit.enable  = true;
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  # Agrega aquí las librerías dinámicas básicas que pueda llegar a necesitar el agente
  stdenv.cc.cc.lib
  zlib
];
  # Módulo oficial de NixOS para habilitar la extensión automáticamente
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "sakura";
  };

# Configuración global de dconf para la extensión de Nautilus
  # Habilitar dconf (Obligatorio)
  # Configuración correcta para forzar a la extensión a usar Sakura




  # ── XDG Portals ───────────────────────────────────────────────
  xdg.portal = {
    enable       = true;
    wlr.enable   = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # ── Gestor de sesión — greetd + tuigreet ─────────────────────
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user    = "greeter";
      };
    };
  };

  # ── AMD GPU — drivers 64 + 32 bit ────────────────────────────
  hardware.graphics = {
    enable       = true;
    enable32Bit  = true;
    extraPackages = with pkgs; [
      rocmPackages.clr
    ];
  };
  hardware.amdgpu.initrd.enable    = true;
  hardware.amdgpu.overdrive.enable = true;
  hardware.openrazer.enable = true;
  hardware.openrazer.devicesOffOnScreensaver = false;

  # ── LACT — control de GPU ─────────────────────────────────────
  services.lact.enable = true;

  # ── GVfs + udisks2 — montaje automático USB/MTP ──────────────
  services.gvfs.enable    = true;
  services.udisks2.enable = true;

  # ── PipeWire ──────────────────────────────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable              = true;
    alsa.enable         = true;
    alsa.support32Bit   = true;
    pulse.enable        = true;
    jack.enable         = true;
  };
  # ── Evitar que WirePlumber suspenda los dispositivos ──────────
  services.pipewire.wireplumber.extraConfig."51-disable-suspension" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          { "node.name" = "~alsa_input.*"; }
          { "node.name" = "~alsa_output.*"; }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        };
      }
    ];
  };
  # ── RyzenAdj — temperatura máxima 75 °C ──────────────────────
  systemd.services.ryzenadj = {
    description = "Aplicar límites de RyzenAdj al inicio";
    wantedBy    = [ "multi-user.target" ];
    serviceConfig = {
      Type              = "oneshot";
      RemainAfterExit   = true;
      ExecStart         = "${pkgs.ryzenadj}/bin/ryzenadj --tctl-temp=75";
    };
  };

  # ── ZRAM ──────────────────────────────────────────────────────
  zramSwap = {
    enable    = true;
    algorithm = "zstd";
    memoryPercent = 25;
    priority  = 100;
  };

  # ── TRIM semanal para SSD ─────────────────────────────────────
  services.fstrim.enable = true;
  services.flatpak.enable = true;
  # Activa los módulos de pixbuf necesarios para renderizar SVG
programs.gdk-pixbuf.modulePackages = [ pkgs.librsvg ];

  # ── Journald ──────────────────────────────────────────────────
  services.journald.extraConfig = ''
    SystemMaxUse=500M
  '';

  # ── Variables de sesión GPU (RX 7600 / RDNA3) ────────────────
  environment.sessionVariables = {
    WINEESYNC              = "1";
    WINEFSYNC              = "1";
    RADV_PERFTEST          = "gpl";
    mesa_glthread          = "true";
    MESA_SHADER_CACHE_MAX_SIZE = "1G";
    NIXOS_OZONE_WL         = "1";
  };
  environment.variables = {
  XCURSOR_THEME = "breeze_cursors";
  XCURSOR_SIZE = "24";
 };


  # ── Sudo sin contraseña para perfil-cpu ──────────────────────
  security.sudo.extraRules = [
    {
      users = [ "lonso" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/perfil-cpu";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  # ── Steam, Gamemode, Gamescope ────────────────────────────────
  programs.steam.enable    = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # ── Nix store — optimización y recolección de basura ─────────
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 7d";
  };
   nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  # ── Fuentes ───────────────────────────────────────────────────
fonts.packages = with pkgs; [
  inter               # Corregido: sin el "pkgs."
  font-awesome_6      # Corregido: especifica la versión
  nerd-fonts.mononoki
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
];


  environment.systemPackages = with pkgs; [
  openrazer-daemon
  shotcut
  polychromatic
  # Terminales
  sakura micro fastfetch htop config.boot.kernelPackages.cpupower
  # Temas de íconos esenciales (faltaban)
  adwaita-icon-theme wireplumber 
  hicolor-icon-theme gsettings-desktop-schemas
  gnome-themes-extra kdePackages.breeze
  nautilus-python       # <-- CAMBIADO: Antes era gnome.nautilus-python
  # Wayland / Sway
  rofi wlogout swaybg wlsunset swayosd nwg-look waybar
  grim slurp wl-clipboard wf-recorder cliphist pkgs.lxqt.lxqt-policykit

  # Audio
  pavucontrol brightnessctl playerctl

  # Multimedia
  mpv yt-dlp ffmpeg
  gst_all_1.gstreamer
  gst_all_1.gst-plugins-bad
  gst_all_1.gst-plugins-ugly
  gst_all_1.gst-libav

  # Apps de escritorio
  nautilus baobab loupe qbittorrent kooha chromium
  vesktop gnome-text-editor file-roller obsidian

  # Ofimática
  libreoffice

  # Red
  networkmanagerapplet

  # GPU / sistema
  vulkan-tools radeontop amdgpu_top ryzenadj

  # Archivos / compresión
  exfatprogs ntfs3g p7zip unrar

  # Juegos / Wine
  wineWow64Packages.staging
  protonup-qt
  wget unzip tree
  # Utilidades
  git curl

  # Tu script personalizado (mantiene la estructura anterior)
  (writeShellApplication {
    name = "perfil-cpu";
    runtimeInputs = [ bash coreutils gawk ];
    text = builtins.readFile ./scripts/perfil-cpu.sh;

  })
];
system.stateVersion = "26.05";
}
