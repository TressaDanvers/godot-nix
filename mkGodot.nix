{ lib, stdenv, godot_4, copyDesktopItems, export_templates }:
{ name, exec, version, src, preset, desktopItems ? [ ], exportMode ? "release", exportTemplates ? export_templates }:
stdenv.mkDerivation rec {
  inherit name version src desktopItems;

  buildInputs = [
    copyDesktopItems
    godot_4
  ];

  postPatch = ''
    patchShebangs scripts
  '';

  buildPhase = ''
    runHook preBuild

    export HOME=$TMPDIR

    sed -i -e \
      '/custom_template/!b' -e '/\/nix\/store/b' -e 's/"[^"]*"/""/g' -e 't' \
      export_presets.cfg

    mkdir -p /build/.local/share/godot/export_templates/
    ln -s ${exportTemplates} /build/.local/share/godot/export_templates/4.7.stable

    mkdir -p $out/share/${name}
    godot4 --headless --export-${exportMode} "${preset}" \
      $out/share/${name}/${exec}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    platform=$(awk -F'=' '$1 == "name" && $2 == "\"${preset}\"" {
      getline; if ($1 == "platform") {
        gsub(/"/, "", $2);
        print $2;
        exit;
      }
    }' export_presets.cfg)

    mkdir -p $out/bin

    if [ "$platform" == "Linux/X11" ]; then
      patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 \
        $out/share/${name}/${exec}
    fi

    ln -s $out/share/${name}/${exec} $out/bin
    chmod +x $out/bin/${exec}

    runHook postInstall
  '';
}
