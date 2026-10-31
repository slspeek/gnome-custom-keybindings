{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    nix-unit.inputs = {
      # NOTE: a `nixpkgs-lib` follows rule is currently required
      inherit (inputs) nixpkgs flake-parts nix-unit;
    };
    # Tests specified here may refer to system-specific attributes that are
    # available in the `perSystem` context
    nix-unit.tests = import ../tests/test-mkSettings.nix {mkSettings = inputs.self.lib.mkSettings;};
  };
}
