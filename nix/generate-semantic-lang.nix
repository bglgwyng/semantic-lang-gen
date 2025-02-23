{ pkgs, haskellPackages, tree-sitter-lang }:
let
  lang = tree-sitter-lang.lang;
  Lang = tree-sitter-lang.Lang;
  generator-src = pkgs.stdenv.mkDerivation {
    name = "semantic-lang-generator";
    dontUnpack = true;
    buildPhase = ''
      cp ${../templates/semantic-lang-generator/generate-semantic.hs} generate-semantic.hs
      substituteInPlace generate-semantic.hs --replace Foo ${Lang} --replace foo ${lang}
      cp ${../templates/semantic-lang-generator/semantic-lang-generator.cabal} semantic-lang-generator.cabal
      substituteInPlace semantic-lang-generator.cabal --replace Foo ${Lang} --replace foo ${lang}
    '';
    installPhase = ''
      mkdir $out
      cp -r . $out/ 
    '';
  };
  generator = haskellPackages.callCabal2nix "semantic-${lang}-generator" "${generator-src}" {
    inherit (haskellPackages) semantic-mini;
  };

  node-types-json = "${tree-sitter-lang.parser}/src/node-types.json";
  src =
    pkgs.stdenv.mkDerivation {
      name = "semantic-lang";
      buildInputs = [
        (pkgs.haskell.lib.justStaticExecutables generator)
      ];
      dontUnpack = true;
      buildPhase = ''
        mkdir $out
        cd $out

        mkdir -p src/Language/${Lang}

        generate-semantic ${node-types-json} > src/Language/${Lang}/AST.hs
        cp ${../templates/semantic-lang/semantic-lang.cabal} semantic-${lang}.cabal
        substituteInPlace semantic-${lang}.cabal --replace Foo ${Lang} --replace foo ${lang}
      '';
    };
in
haskellPackages.callCabal2nix "semantic-${lang}" "${src}" {
  inherit (haskellPackages) semantic-mini;
}

# generator

# haskellPackages.callCabal2nix "semantic-${lang}-generator" "${src}" {
# inherit (haskellPackages) semantic-mini;
# inherit tree-sitter-lang;
# }

# semantic-lang = { name, Name }:
# let
# node-types-json = "${pkgs.callPackage ./nix/generate-parser.nix { name = "yourlanguage"; grammar-js = ./example/grammar.js; }}/src/node-types.json";
# in
# pkgs.stdenv.mkDerivation {
# name = "semantic-lang";
# buildInputs = [
# (pkgs.haskell.lib.justStaticExecutables
# (generate-semantic-lang-generator { inherit name Name; }))
# ];
# dontUnpack = true;
# buildPhase = ''
#       generate-semantic ${node-types-json} > $out
#     '';
# installPhase = ''
#       cp out.txt $out
#     '';
# };
