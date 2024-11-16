{
  description = "flake.nix";

  inputs = {
#    nixpkgs.url = "github:nixos/nixpkgs?ref=084f6a3e260a9576c955137ff44b2e6d4fac6891";
    nixpkgs.url = "github:toasterofbread/nixpkgs?ref=9819df87589a6a00dccd6e76638cf92877c1a110";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

#    hyprland = {
#      type = "git";
#      url = "https://github.com/hyprwm/Hyprland?ref=v0.43.0";
#      submodules = true;
#      inputs.nixpkgs.follows = "nixpkgs";
#    };

# https://github.com/hyprwm/Hyprland/issues/5346
# Working: 0.36.0 0.37.1 (i think?) 0.38.1
# Broken: 0.40.0 0.41.1 0.41.2 [Apr 24 4540d8c] [Apr 19 b52a49b] 0.39.1 0.39.0

    # v0.43.0
#    nixpkgs-hyprland.url = "github:nixos/nixpkgs?ref=d9d07251f12399413e6d33d5875a6f1994ef75a7";

    catppuccin.url = "github:catppuccin/nix?ref=8bdb55cc1c13f572b6e4307a3c0d64f1ae286a4f";
    arion.url = "github:toasterofbread/arion?ref=51fef9a931cd88a635cb90eeebaf5ed095b1b93c";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";

    spmp.url = "github:toasterofbread/spmp/v0.4.0";
#    spmp.url = "github:toasterofbread/spmp?ref=9de5433e09595a199a21b8ca6fa732c98a73a327";
    spms.url = "github:toasterofbread/spmp-server?ref=34470d61fd53109fde1869480b4943ed721fccfd";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, arion, nix-flatpak, spmp, spms, ... }@inputs:
    let
      host = "nixos-prime";
      system = "x86_64-linux";
      user = "toaster";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs user system; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          arion.nixosModules.arion
          nix-flatpak.nixosModules.nix-flatpak
        ];
      };

      homeConfigurations.${host} = home-manager.lib.homeManagerConfiguration {
        modules = [
        ];
      };
    };
}
