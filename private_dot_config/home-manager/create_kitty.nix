{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    package = pkgs.writeShellScriptBin "kitty" ''
      #!${pkgs.bash}/bin/bash
      # Execute the real kitty binary, but wrapped in nixGL.
      # We use the full path to the real kitty package to be explicit.
      # "$@" ensures all arguments are passed through to the real kitty.
      exec ${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${pkgs.kitty}/bin/kitty "$@"
    '';

    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };
    shellIntegration.enableFishIntegration = true;
    settings = {
      copy_on_select = true;
      placement_strategy = "top-left";
      hide_window_decorations = true;
      shell = "fish";

      # Remote Control (needed for live theme switching)
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";

      # Window
      draw_minimal_borders = "yes";
      background_opacity = "1.0";
      window_padding_width = "0";
      resize_in_steps = "no";
    };
    extraConfig = "include current-theme.conf";
    keybindings = {
      "ctrl+shift+left" = "neighboring_window left";
      "ctrl+shift+right" = "neighboring_window right";
      "ctrl+shift+up" = "neighboring_window up";
      "ctrl+shift+down" = "neighboring_window down";
      "ctrl+shift+h" = "launch --stdin-source=@screen_scrollback nvim";
    };
  };

  # Automatic Theme Switching
  # Kitty will automatically use these files depending on the OS color scheme
  xdg.configFile."kitty/light-theme.auto.conf".source =
    "${pkgs.kitty-themes}/share/kitty-themes/themes/GitHub_Light.conf";
  xdg.configFile."kitty/no-preference-theme.auto.conf".source =
    "${pkgs.kitty-themes}/share/kitty-themes/themes/GitHub_Light.conf";
  xdg.configFile."kitty/dark-theme.auto.conf".source =
    "${pkgs.kitty-themes}/share/kitty-themes/themes/GitHub_Dark.conf";

  home.packages = [ pkgs.kitty.terminfo ];
}
