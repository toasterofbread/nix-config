
{ config, lib, pkgs, inputs, user, system, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./cachix.nix
      inputs.home-manager.nixosModules.default
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ (import /etc/nixos/overlays/firefox.nix) ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "amdgpu" "kvm-amd" ];

  networking.hostName = "nixos-prime";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";
  services.xserver.xkb.layout = "us";
#  services.gnome-keyring.enable = true;

  hardware.pulseaudio.enable = true;

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.postgresql.enable = true;
  networking.firewall.enable = false;
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

   programs.fish.enable = true;
   programs.hyprland = {
     enable = true;
#     package = inputs.hyprland.packages.${system}.hyprland-legacy-renderer;
   };
   programs.steam.enable = true;
   security.polkit.enable = true;
   programs.nix-index = {
     enableBashIntegration = false;
     enableZshIntegration = false;
   };
   programs.adb.enable = true;

   services.ollama = {
     enable = true;
     acceleration = "rocm";
     environmentVariables = {
       HCC_AMDGPU_TARGET = "gfx1030"; # used to be necessary, but doesn't seem to anymore
     };
     rocmOverrideGfx = "10.3.0";
   };

   services.xserver = {
     enable = false;
     autorun = false; # Doesn't work?
     displayManager.gdm = {
       enable = true;
       wayland = true;
     };
     desktopManager.gnome.enable = true;
   };

   xdg.portal.enable = true;

   services.flatpak = {
     enable = true;
     uninstallUnmanaged = true;

     remotes = [
       { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; }
       { name = "toastbits"; location = "https://flatpak.toastbits.dev/index.flatpakrepo"; }
       { name = "moe"; location = "https://gol.launcher.moe/gol.launcher.moe.flatpakrepo"; }
     ];
     packages = [
       { appId = "dev.toastbits.spmp"; origin = "toastbits";  }
       { appId = "dev.toastbits.spmp-server"; origin = "toastbits";  }
       { appId = "moe.launcher.the-honkers-railway-launcher"; origin = "moe"; }
       { appId = "org.flatpak.Builder"; origin = "flathub"; }
     ];
   };

 #  programs.nix-ld.enable = true;
 #  programs.nix-ld.libraries = with pkgs; [
 #    # Add any missing dynamic libraries for unpackaged programs
 #    # here, NOT in environment.systemPackages
 #  ];

   users.users.${user} = {
     isNormalUser = true;
     initialPassword = "password";
     extraGroups = [ "wheel" "plugdev" "adbusers" "libvirtd" "vboxusers" "seat" "video" ];
     shell = pkgs.fish;
   };

   home-manager = {
     useGlobalPkgs = true;
     useUserPackages = true;
     extraSpecialArgs = { inherit inputs user; };
     users.${user} = {
       imports = [
         ./home.nix
         inputs.catppuccin.homeManagerModules.catppuccin
       ];
     };
   };

   environment.systemPackages = with pkgs; [
     nano
     wget
     git
     tree
     file
     fzf
     killall
     gdb
     gcc
     gnumake
     nix-index
     latest.firefox-nightly-bin

     (pkgs.buildFHSUserEnv {
       name = "fhs";
     })

     # TEMP
 #    gnome.gnome-shell
 #    gnome.gnome-session
   ];

 #  services.xserver.displayManager.sessionPackages = [ pkgs.gnome.gnome-session.sessions ];
   
  virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd = {
     enable = true;
     qemu = {
       package = pkgs.qemu_kvm;
       runAsRoot = true;
       swtpm.enable = true;
       ovmf = {
         enable = true;
         packages = [(pkgs.OVMF.override {
           secureBoot = true;
           tpmSupport = true;
         }).fd];
       };
     };
   };

   virtualisation.docker = {
     enable = true;
     rootless = {
       enable = true;
       setSocketVariable = true;
     };
   };

#   virtualisation.arion = {
#     backend = "docker";
#     projects = {
#       "hakatime".rootless = true;
#       "hakatime".settings = {
#         services = {
#           "server".service = {
#             image = "mujx/hakatime:v1.7.3";
#             environment = {
#               HAKA_DB_HOST = "haka_db";
#               HAKA_DB_PORT = 5432;
#               HAKA_DB_NAME = "test";
#               HAKA_DB_PASS = "test";
#               HAKA_DB_USER = "test";
#
#               HAKA_BADGE_URL = "http://localhost:8080";
#               HAKA_PORT = 8080;
#               HAKA_ENABLE_REGISTRATION = "true";
#               HAKA_SESSION_EXPIRY = "24";
#             };
#             ports = [
#               "8080:8080"
#             ];
#           };
#           "haka_db".service = {
#             image = "postgres:12-alpine";
#             container_name = "haka_db";
#             environment = {
#               POSTGRES_DB = "test";
#               POSTGRES_PASSWORD = "test";
#               POSTGRES_USER = "test";
#             };
#             volumes = [
#               "deploy_db_data:/var/lib/postgresql/data"
#             ];
#           };
#         };

#         docker-compose.volumes = {
#           "deploy_db_data" = {};
#         };
#       };
#     };
#   };

  # adb
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee4", MODE="0666", GROUP="plugdev"  >
  '';

  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05";
}

