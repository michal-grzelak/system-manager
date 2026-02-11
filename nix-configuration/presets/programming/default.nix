{
  pkgs,
  common,
  ...
}: let
in {
  imports = [
    ../../apps/dev-libs
    ../../apps/git
    ../../apps/mise
    ../../apps/uv
    ../../apps/neovim
    ../../apps/gh
    ../../apps/mongo-tools
    ../../apps/opencode
    ../../apps/claudecode
  ];
}
