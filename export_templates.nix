{ fetchurl, runCommandCC, unzip }: let
  templates = fetchurl {
    url = "https://github.com/godotengine/godot/releases/download/4.7-stable/Godot_v4.7-stable_export_templates.tpz";
    hash = "sha256-lxRFncBxkHwPPV8X1gj69p582iEzH8XTnEUD/6Tpnuw=";
  };
in runCommandCC "build-export-templates" {
  buildInputs = [ unzip ];
} ''
  unzip -j ${templates} -d $out

  interpreter=$(cat $NIX_CC/nix-support/dynamic-linker)
  patchelf --set-interpreter $interpreter $out/linux_*
''
