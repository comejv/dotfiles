{ pkgs, ... }:
let
  planify-fixed = pkgs.symlinkJoin {
    name = "planify-fixed";

    # The paths from the original package that we want to use
    paths = [ pkgs.planify ];

    # Post-build script to create a clean, FHS-compliant structure
    postBuild = ''
      # Create the standard directories in the new package's output path
      mkdir -p $out/bin
      mkdir -p $out/share/applications

      # Link the binary with a clean name, 'planify'
      ln -s $out/bin/io.github.alainm23.planify $out/bin/planify
      ln -s $out/bin/io.github.alainm23.planify.quick-add $out/bin/planify-quick-add

      # Copy the .desktop file and fix the Exec line to use the new binary name
      sed 's|Exec=io.github.alainm23.planify|Exec=planify|' \
        $out/share/applications/io.github.alainm23.planify.desktop \
        > $out/share/applications/planify.desktop

      # Remove the old, now-redundant .desktop file link
      rm $out/share/applications/io.github.alainm23.planify.desktop
    '';
  };
  equibop-openasar = pkgs.callPackage ./equibop/equibop.nix { };

in
{
  home.packages = with pkgs; [
    # Utilities
    nixgl.auto.nixGLDefault
    fzf
    fd

    # Nix
    nixfmt-rfc-style
    nix-your-shell

    planify-fixed

    (discord.override { withOpenASAR = true; withVencord = true; })
  ];
}
