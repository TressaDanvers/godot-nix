final: prev: {
  mkGodot = prev.callPackage ./mkGodot.nix { };
  mkNixosPatch = prev.callPackage ./mkNixosPatch.nix { };
  export_templates = prev.callPackage ./export_templates.nix { };
}
