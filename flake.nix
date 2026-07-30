{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils }:
    flake-utils.lib.eachDefaultSystem (_: {
      overlays = final: prev: {
        mkGodot = prev.callPackage ./mkGodot.nix {};
        mkNixosPatch = prev.callPackage ./mkNixosPatch.nix {};
        export_templates = prev.callPackage ./export_templates.nix {};
      };
    });
}
