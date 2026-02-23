{
  pkgs,
  common,
  config,
  lib,
  ...
}: let
  inherit (common) utils;
in {
  config = lib.mkIf (config.definitions.shellToUse == "fish") {
    programs.fish = {
      enable = true;

      shellInit = ''
        # disable greeting
        set -U fish_greeting;
      '';
      interactiveShellInit = ''
        # user init

        # add bun to path
        fish_add_path "/home/grzekuu/.cache/.bun/bin"
      '';

      plugins = [
        # this plugin sets nix env on path in fish shell
        {
          name = "nix";
          src = pkgs.fetchFromGitHub {
            name = "nix.fish";
            owner = "kidonng";
            repo = "nix.fish";
            rev = "HEAD";
            sha256 = "sha256-GMV0GyORJ8Tt2S9wTCo2lkkLtetYv0rc19aA5KJbo48=";
          };
        }
      ];
    };

    # programs.bash = lib.mkIf (config.definitions.isLinux
    #   == true) {
    #   enable = lib.mkForce true;

    #   initExtra = ''
    #     exec fish
    #   '';
    # };
  };
}
