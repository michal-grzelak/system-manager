{
  pkgs,
  common,
  ...
}: let
  inherit (common) utils;
in {
  programs.opencode = {
    enable = true;

    settings = {
      provider = {
        nano-gpt = {
          models = {
            "moonshotai/kimi-k2.5" = {
              name = "Kimi K2.5";
              limit = {
                context = 256000;
                output = 65535;
              };
            };
            "moonshotai/kimi-k2.5:thinking" = {
              name = "Kimi K2.5 Thinking";
              limit = {
                context = 256000;
                output = 65535;
              };
            };
          };
        };
      };
    };
  };
}
