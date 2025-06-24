{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
      size = 16;
    };
    shellIntegration.enableFishIntegration = true;
    settings = {
      copy_on_select = true;
      placement_strategy = "top-left";
      hide_window_decorations = true;
      shell = "fish";
      include = "current-theme.conf";
    };
    keybindings = {
      "ctrl+shift+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "ctrl+shift+up" = "neighboring_window up";
      "ctrl+shift+down" = "neighboring_window down";
      "ctrl+alt+enter" = "launch --cwd=current";
    };
  };

}
