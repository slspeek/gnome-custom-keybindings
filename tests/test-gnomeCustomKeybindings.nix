{ gnomeCustomKeybindings, pkgs, ... }:
let
  inherit (pkgs) lib;
  dconfMockModule = {
    options.dconf.settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
    };
  };
  evaluated = lib.evalModules {
    modules = [
      dconfMockModule
      gnomeCustomKeybindings
      {
        gnomeCustomKeybindings.enable = true;
        gnomeCustomKeybindings.bindings = [ ];
      }
    ];
  };
in
{
  testEnabled = {
    expr = evaluated.config.gnomeCustomKeybindings.enable;
    expected = true;
  };

  testEmptySettings = {
    expr = evaluated.config.dconf.settings;
    expected = { };
  };
}
