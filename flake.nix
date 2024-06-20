{
  description = "flake.nix";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    arion.url = "github:toasterofbread/arion?ref=51fef9a931cd88a635cb90eeebaf5ed095b1b93c";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, arion, ... }@inputs:  
    let 
      host = "nixos-prime";
      system = "x86_64-linux";
      user = "toaster";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.${host} = nixpkgs.lib.nixosSystem { 
        specialArgs = { inherit inputs user; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          arion.nixosModules.arion
        ];
      };

      homeConfigurations.${host} = home-manager.lib.homeManagerConfiguration {
        modules = [
        ];
      };
    };
}
