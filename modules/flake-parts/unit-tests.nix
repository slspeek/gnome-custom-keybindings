{ inputs, ... }: {
  imports = [ inputs.nix-unit.modules.flake.default ];
  perSystem = { pkgs, ... }: {
    nix-unit.inputs = {
      # NOTE: a `nixpkgs-lib` follows rule is currently required
      inherit (inputs)
        flake-parts
        import-tree
        nixpkgs
        nix-unit
        self
        treefmt-nix
        ;
    };
    # Tests specified here may refer to system-specific attributes that are
    # available in the `perSystem` context
    nix-unit.tests = {
      mkSettings = import ../../tests/test-mkSettings.nix {
        mkSettings = inputs.self.lib.mkSettings;
      };
      gnomeCustomKeybindings = import ../../tests/test-gnomeCustomKeybindings.nix {
        gnomeCustomKeybindings = inputs.self.homeManagerModules.gnomeCustomKeybindings;
        inherit pkgs;
      };
    };
  };
}
