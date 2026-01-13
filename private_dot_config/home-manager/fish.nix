{ pkgs, ... }:

{
  home.shell.enableFishIntegration = true;
  programs.fzf.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      if command -q nix-your-shell
        nix-your-shell fish | source
      end
      # set -gx pure_enable_single_line_prompt true
      set -gx pure_enable_nixdevshell true
      set -gx pure_enable_virtualenv true
      set fish_color_command blue
      set -g fish_key_bindings fish_vi_key_bindings
    '';
    plugins = [
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
    ];
    functions = {
      multicd = "echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)";
      sshfs_x = ''
        if test (count $argv) -gt 0
            set pc $argv[1]
        else
            set pc porsche
        end
        sudo sshfs -oallow_other "$pc.p:/users/eleves-b/2024/come.vincent" /mnt/X/ -F /home/comev/.ssh/config
      '';
    };

    shellAbbrs = {
      dotdot = {
        regex = ''^\.\.+$'';
        function = ''multicd'';
      };
    };
    shellAliases = {
      id = "/usr/bin/id";
    };
  };
}
