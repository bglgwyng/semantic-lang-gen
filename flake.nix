{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    tree-sitter.url = "github:bglgwyng/tree-sitter?ref=nix-abi-11";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule

      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, withSystem, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.
        # overlay = [ ];

        # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
        packages.tree-sitter = inputs'.tree-sitter.packages.default;
        packages.semantic-mini = (pkgs.haskellPackages.callCabal2nix "semantic-mini" ./semantic-mini { });

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [
            # tree-sitter
            pkgs.nodejs_22
          ];
        };
      };
      flake = {

        overlay = final: prev: {
          tree-sitter = inputs.tree-sitter.packages.${prev.stdenv.hostPlatform.system}.default;
          haskellPackages = prev.haskellPackages.override (_: {
            overrides = self: super: {
              semantic-mini = self.callCabal2nix "semantic-mini" ./semantic-mini { };
            };
          });

        };
        # 
        generate-parser = import ./nix/generate-parser.nix;
        generate-tree-sitter-lang = import ./nix/generate-tree-sitter-lang.nix;
        generate-semantic-lang = import ./nix/generate-semantic-lang.nix;

        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}
