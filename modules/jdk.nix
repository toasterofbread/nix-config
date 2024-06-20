{ pkgs, ... }:

let
  JDKS = with pkgs; [ jdk21 jdk22 ];
in
{
  home.sessionPath = [ "$HOME/.jdks" ];
  home.file = (builtins.listToAttrs (builtins.map (jdk: {
    name = ".jdks/${jdk.version}";
    value = { source = jdk; };
  }) JDKS));
}
