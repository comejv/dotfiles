{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  equicord,
  electron,
  libicns,
  pipewire,
  libpulseaudio,
  autoPatchelfHook,
  pnpm_9,
  nodejs,
  nix-update-script,
  openasar, # NEW: add openasar package from nixpkgs
  withTTS ? true,
  withMiddleClickScroll ? false,
  withSystemEquicord ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "equibop";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "Equicord";
    repo = "Equibop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y5q3shwmMjXlMaLWfxjN164uM8hSbWymsHIIJxM82Nk=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    fetcherVersion = 1;
    hash = "sha256-laTyxRh54x3iopGVgoFtcgaV7R6IKux1O/+tzGEy0Fg=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    libpulseaudio
    pipewire
    (lib.getLib stdenv.cc.cc)
  ];

  patches = [
    ./disable_update_checking.patch
  ]
  ++ lib.optional withSystemEquicord (
    replaceVars ./use_system_equicord.patch {
      inherit equicord;
    }
  );

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  buildPhase = ''
    runHook preBuild
    pnpm build
    pnpm exec electron-builder \
      --dir \
      -c.asarUnpack="**/*.node" \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}
    runHook postBuild
  '';

  postBuild = ''
    pushd build
    ${libicns}/bin/icns2png -x icon.icns
    popd
  '';

  installPhase = ''
    runHook preInstall

    # Install Equibop resources
    mkdir -p $out/opt/Equibop
    cp -r dist/*unpacked/resources $out/opt/Equibop/

    # Replace Equibop's app.asar with OpenASAR while keeping a backup
    if [ -f "$out/opt/Equibop/resources/app.asar" ]; then
      mv "$out/opt/Equibop/resources/app.asar" \
         "$out/opt/Equibop/resources/app.equibop.asar"
    fi

    install -Dm0644 ${openasar} \
      "$out/opt/Equibop/resources/app.asar"

    # Icons
    for file in build/icon_*x32.png; do
      file_suffix=''${file//build\/icon_}
      install -Dm0644 "$file" \
        "$out/share/icons/hicolor/''${file_suffix//x32.png}/apps/equibop.png"
    done

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron}/bin/electron $out/bin/equibop \
      --add-flags $out/opt/Equibop/resources/app.asar \
      ${lib.optionalString withTTS "--add-flags \"--enable-speech-dispatcher\""} \
      ${lib.optionalString withMiddleClickScroll "--add-flags \"--enable-blink-features=MiddleClickAutoscroll\""} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  desktopItems = makeDesktopItem {
    name = "equibop";
    desktopName = "Equibop";
    exec = "equibop %U";
    icon = "equibop";
    startupWMClass = "Equibop";
    genericName = "Internet Messenger";
    keywords = [
      "discord"
      "equibop"
      "electron"
      "chat"
    ];
    categories = [
      "Network"
      "InstantMessaging"
      "Chat"
    ];
  };

  passthru = {
    inherit (finalAttrs) pnpmDeps;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Custom Discord App aiming to give you better performance and improve Linux support (bundled with OpenASAR)";
    homepage = "https://github.com/Equicord/Equibop";
    changelog = "https://github.com/Equicord/Equibop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.NotAShelf ];
    mainProgram = "equibop";
    platforms = lib.platforms.linux;
  };
})
