let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
  mkSettings = import ./mkSettings.nix;
in
  lib.runTests {
    testEmpty = {
      expr = mkSettings [];
      expected = {};
    };

    testOneBinding = {
      expr = mkSettings [
        {
          name = "Terminal";
          command = "alacritty";
          binding = "<Control><Alt>t";
        }
      ];
      expected = {
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Control><Alt>t";
          command = "alacritty";
          name = "Terminal";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings" = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };
    };

    testTwoBindings = {
      expr = mkSettings [
        {
          name = "Terminal";
          command = "alacritty";
          binding = "<Control><Alt>t";
        }
        {
          name = "Display settings";
          command = "gnome-control-center display";
          binding = "<Super>d";
        }
      ];
      expected = {
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Control><Alt>t";
          command = "alacritty";
          name = "Terminal";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "<Super>d";
          command = "gnome-control-center display";
          name = "Display settings";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings" = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
    };
  }
