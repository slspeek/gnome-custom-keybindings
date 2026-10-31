{
  description = "Utility function for GNOME custom shortcuts";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nix-unit.url = "github:nix-community/nix-unit";
    nix-unit.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [inputs.nix-unit.modules.flake.default];
      systems = ["x86_64-linux" "aarch64-linux"];

      # Exporteer je library function
      flake = {
        lib = {
          mkSettings = import ./lib/mkSettings.nix {lib = inputs.nixpkgs.lib;};
        };
      };

      # Voeg de test toe aan de checks per systeem
      perSystem = {pkgs, ...}: {
        nix-unit.inputs = {
          # NOTE: a `nixpkgs-lib` follows rule is currently required
          inherit (inputs) nixpkgs flake-parts nix-unit;
        };
        # Tests specified here may refer to system-specific attributes that are
        # available in the `perSystem` context
        nix-unit.tests = import ./tests/test-mkSettings.nix {mkSettings = inputs.self.lib.mkSettings;};
      };
    };
}
