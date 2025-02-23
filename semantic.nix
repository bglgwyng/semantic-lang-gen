{

  generate-semantic-lang-generator = { name, Name }:
    let
      src = pkgs.stdenv.mkDerivation {
        name = "semantic-lang-generator";
        dontUnpack = true;
        buildPhase = ''
          cp ${./templates/semantic-lang-generator/generate-semantic.hs} generate-semantic.hs
          substituteInPlace generate-semantic.hs --replace Foo ${Name} --replace foo ${name}
          cp ${./templates/semantic-lang-generator/semantic-lang-generator.cabal} semantic-lang-generator.cabal
          substituteInPlace semantic-lang-generator.cabal --replace Foo ${Name} --replace foo ${name}
        '';
        installPhase = ''
          mkdir $out
          cp -r . $out/ 
        '';
      };
    in
    haskellPackages.callCabal2nix "semantic-${name}-generator" "${src}" {
      inherit semantic-mini;
      "tree-sitter-${name}" = pkgs.callPackage ./nix/generate-tree-sitter-lang.nix {
        inherit pkgs haskellPackages name Name;
      };
    };
  semantic-lang = { name, Name }:
    let
      node-types-json = "${pkgs.callPackage ./nix/generate-parser.nix { name = "yourlanguage"; grammar-js = ./example/grammar.js; }}/src/node-types.json";
    in
    pkgs.stdenv.mkDerivation {
      name = "semantic-lang";
      buildInputs = [
        (pkgs.haskell.lib.justStaticExecutables
          (generate-semantic-lang-generator { inherit name Name; }))
      ];
      dontUnpack = true;
      buildPhase = ''
        generate-semantic ${node-types-json} > $out
      '';
      installPhase = ''
        cp out.txt $out
      '';
    };
  # example-haskell-package = pkgs.callPackage ./nix/generate-tree-sitter-lang.nix {
  #   inherit pkgs haskellPackages;
  #   name = "yourlanguage";
  #   Name = "Yourlanguage";
  #   parser = example-parser;
  # };
  semantic-lang-generator = generate-semantic-lang-generator { name = "yourlanguage"; Name = "Yourlanguage"; };

  semantic-mini = (haskellPackages.callCabal2nix "semantic-mini" ./semantic-mini { });
}

