listOfCustomKeybinds: let
  lib = import <nixpkgs/lib>;
  path = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings";
  mkPath = id: "${path}/custom${toString id}";
in
  if listOfCustomKeybinds == []
  then {}
  else
    lib.listToAttrs (
      (lib.imap0
        (index: customBinding: {
          name = mkPath index;
          value = customBinding;
        })
        listOfCustomKeybinds)
      ++ [
        {
          name = path;
          value =
            lib.genList
            (index: "/${mkPath index}/")
            (lib.length listOfCustomKeybinds);
        }
      ]
    )
