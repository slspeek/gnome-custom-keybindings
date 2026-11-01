{ inputs, ... }:
let
  lib = inputs.nixpkgs.lib;
  mkSettings =
    listOfCustomKeybindings:
    let
      path = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings";
      mkPath = id: "${path}/custom${toString id}";
    in
    if listOfCustomKeybindings == [ ] then
      { }
    else
      lib.listToAttrs (
        (lib.imap0 (index: customKeybinding: {
          name = mkPath index;
          value = customKeybinding;
        }) listOfCustomKeybindings)
        ++ [
          {
            name = path;
            value = lib.genList (index: "/${mkPath index}/") (lib.length listOfCustomKeybindings);
          }
        ]
      );
in
{
  flake.lib.mkSettings = mkSettings;
}
