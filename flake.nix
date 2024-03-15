{
  description = "MKDocs flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs@{ self, flake-parts, systems, ... }: flake-parts.lib.mkFlake { inherit inputs; } {
    systems = import systems;

    perSystem = { config, self', inputs', pkgs, system, lib, ... }: {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.mkdocs
          pkgs.python311Packages.mkdocs-material
        ];
      };

      packages.default = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
        name = "mkdocs-html";

        src = lib.cleanSource self;

        nativeBuildInputs = [
          pkgs.mkdocs
          pkgs.python311Packages.mkdocs-material
        ];

        buildPhase = ''
          mkdocs build --strict -d $out
        '';

        dontConfigure = true;
        doCheck = false;
        dontInstall = true;
      });

      checks = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            markdownlint.enable = true;
            nixpkgs-fmt.enable = true;
            statix.enable = true;
          };
        };
      };
    };
  };
}
