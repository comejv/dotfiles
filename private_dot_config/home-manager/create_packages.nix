{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Utilities
    nixgl.auto.nixGLDefault

    # Nix
    nixfmt-rfc-style
    nix-your-shell

    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ];

  programs.fzf.enable = true;
  programs.fd.enable = true;

  programs.chawan = {
    enable = true;
    settings = {
      external = {
        copy-cmd = "wl-copy";
        paste-cmd = "wl-paste";
      };

      buffer.user-style = ''
        * {
          background-color: #1e1e1e !important;
          color: #e0e0e0 !important;
          border-color: #444 !important;
        }
        a, a:visited {
          color: #6db3f2 !important;
        }
      '';

      page."C-k" = "() => pager.load('ddg:')";

      omnirule = {
        ddg = {
          match = "^ddg:";
          substitute-url = "(x) => \"https://lite.duckduckgo.com/lite/?kp=-1&kd=-1&q=\" + encodeURIComponent(x.split(\\\":\\\").slice(1).join(\\\":\\\"))";
        };
        wiki = {
          match = "^wiki:";
          substitute-url = "(x) => \"https://en.wikipedia.org/wiki/Special:Search?search=\" + encodeURIComponent(x.split(\\\":\\\").slice(1).join(\\\":\\\"))";
        };
        cnrtl = {
          match = "^cnrtl:";
          substitute-url = "(x) => \"https://cnrtl.fr/definition/\" + encodeURIComponent(x.split(\\\":\\\").slice(1).join(\\\":\\\"))";
        };
      };
    };
  };
}
