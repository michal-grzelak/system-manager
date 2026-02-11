{
  pkgs,
  common,
  ...
}: let
  inherit (common) utils;
in {
  programs.claude-code = {
    enable = true;
  };
}
