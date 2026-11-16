inputs: {
  flake.homeManagerModules = {
    gnomeCustomKeybindings =
      {
        config,
        lib,
        ...
      }:
      let
        shortcutSubmodule = lib.types.submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Display name of the shortcut.";
            };
            command = lib.mkOption {
              type = lib.types.str;
              description = "Command to execute when triggered.";
            };
            binding = lib.mkOption {
              type = lib.types.str;
              description = "Key combination (e.g. <Ctrl><Alt>T).";
            };
          };
        };
      in
      {
        options.gnomeCustomKeybindings = {
          enable = lib.mkEnableOption "GNOME custom keybindings";
          bindings = lib.mkOption {
            type = lib.types.listOf shortcutSubmodule;
            default = [ ];
            example = [
              {
                name = "Terminal";
                command = "gnome-terminal";
                binding = "<Ctrl><Alt>T";
              }
            ];
            description = "List of custom GNOME keybindings.";
          };

        };

        config = lib.mkIf config.gnomeCustomKeybindings.enable {
          dconf.settings = inputs.self.lib.mkSettings config.gnomeCustomKeybindings.bindings;
          #        environment.systemPackages = [ pkgs.dconf ];
        };

      };
    default = inputs.self.homeManagerModules.gnomeCustomKeybindings;
  };
}
