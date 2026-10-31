{
  description = "Utility function for GNOME custom shortcuts";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nix-unit.url = "github:nix-community/nix-unit";
    nix-unit.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.nix-unit.modules.flake.default
        ./modules/unit-tests.nix
        ./lib/mkSettings.nix
        ./modules/treefmt.nix
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
}
