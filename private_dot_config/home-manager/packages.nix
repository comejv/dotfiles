{ pkgs, ... }:
let
  nvidiaLibDir = "/lib/x86_64-linux-gnu";

  nvidiaMlSoFile = "libnvidia-ml.so.1";

  # Define the overridden btop package
  btopGpu = pkgs.btop.overrideAttrs (oldAttrs: {
    # Add patchelf to build inputs
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.patchelf ];

    # Ensure GPU support is compiled in
    # Check if Nixpkgs already does this; often it does.
    # If not, uncomment and adjust the makeFlags or buildPhase.
    # makeFlags = (oldAttrs.makeFlags or []) ++ [ "GPU_SUPPORT=true" ];
    # Or modify buildPhase if needed:
    # buildPhase = oldAttrs.buildPhase + ''
    #   make GPU_SUPPORT=true
    # '';
    doCheck = false;
    doInstallCheck = false;

    # Add a postFixup phase to run patchelf
    # We run this *after* the default fixup phase
    postFixup =
      (oldAttrs.postFixup or "")
      + ''
        echo "Patching btop binary with host NVML library..."
        patchelf \
          --add-needed "${nvidiaLibDir}/${nvidiaMlSoFile}" \
          $out/bin/btop
        # Optional: Verify the change (prints NEEDED libraries)
        # patchelf --print-needed $out/bin/btop
      '';

    # DO NOT disable hardening unless absolutely necessary!
    # hardeningDisable = [ "all" ]; # <-- Avoid this if possible!

    meta = oldAttrs.meta // {
      description = oldAttrs.meta.description + " (patched for host NVML)";
      note = "Impure build: relies on host library at ${nvidiaLibDir}/${nvidiaMlSoFile}";
    };
  });
  planify-fixed = pkgs.symlinkJoin {
    name = "planify-fixed";

    # The paths from the original package that we want to use
    paths = [ pkgs.planify ];

    # Post-build script to create a clean, FHS-compliant structure
    postBuild = ''
      # Create the standard directories in the new package's output path
      mkdir -p $out/bin
      mkdir -p $out/share/applications

      # Link the binary with a clean name, e.g., 'planify'
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
in
{
  home.packages = with pkgs; [
    # Utilities
    xsel
    xclip
    btopGpu
    fd
    fzf
    ripgrep
    (import (fetchTarball "https://github.com/nix-community/nixGL/archive/main.tar.gz") { })
    .auto.nixGLDefault

    # SE
    gcc
    gnumake

    # Nix
    nixfmt-rfc-style
    nix-your-shell

    discordo

    zotero

    planify-fixed
  ];
}
