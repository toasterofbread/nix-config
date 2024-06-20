{ config, lib, pkgs, inputs, user, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos-prime";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";
  services.xserver.xkb.layout = "us";
#  services.gnome-keyring.enable = true

  hardware.pulseaudio.enable = true;

  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.postgresql.enable = true;
  networking.firewall.enable = false;
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  programs.fish.enable = true;
  programs.hyprland.enable = true;
  programs.steam.enable = true;
  security.polkit.enable = true;
  programs.nix-index = {
    enableBashIntegration = false;
    enableZshIntegration = false;
  };

#  programs.nix-ld.enable = true;
#  programs.nix-ld.libraries = with pkgs; [
#    # Add any missing dynamic libraries for unpackaged programs
#    # here, NOT in environment.systemPackages
#  ];

  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" ];
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

    (pkgs.buildFHSUserEnv {
      name = "fhs";
    })
  ];

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  
  virtualisation.arion = {
    backend = "docker";
    projects = {
      "hakatime".rootless = true;
      "hakatime".settings = {
        services = {
          "server".service = {
            image = "mujx/hakatime:v1.7.3";
            environment = { 
              HAKA_DB_HOST = "haka_db";
              HAKA_DB_PORT = 5432;
              HAKA_DB_NAME = "test";
              HAKA_DB_PASS = "test";
              HAKA_DB_USER = "test";

              HAKA_BADGE_URL = "http://localhost:8080";
              HAKA_PORT = 8080;
              HAKA_ENABLE_REGISTRATION = "true";
              HAKA_SESSION_EXPIRY = "24";
            };
            ports = [
              "8080:8080"
            ];
          };
          "haka_db".service = {
            image = "postgres:12-alpine";
            container_name = "haka_db";
            environment = {
              POSTGRES_DB = "test";
              POSTGRES_PASSWORD = "test";
              POSTGRES_USER = "test";
            };
            volumes = [
              "deploy_db_data:/var/lib/postgresql/data"
            ];
          };
        };

        docker-compose.volumes = {
          "deploy_db_data" = {};
        };
      };
    };
  };

  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05";
}
