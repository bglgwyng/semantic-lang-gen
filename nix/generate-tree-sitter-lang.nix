{ pkgs, Lang, parser, src-only ? false }:
let
  lang = parser.lang;
  src = pkgs.stdenv.mkDerivation {
    name = "tree-sitter-example";
    dontUnpack = true;
    buildPhase = ''
      mkdir vendor
      cp -r ${parser} vendor/tree-sitter-${lang}
      cp ${../templates/tree-sitter-foo/tree-sitter-foo.cabal} tree-sitter-${lang}.cabal
      substituteInPlace tree-sitter-${lang}.cabal --replace foo ${lang} --replace Foo ${Lang}
      mkdir TreeSitter
      cp ${../templates/tree-sitter-foo/TreeSitter/Foo.hs} TreeSitter/${Lang}.hs
      substituteInPlace TreeSitter/${Lang}.hs --replace foo ${lang} --replace Foo ${Lang}
    '';
    installPhase = ''
      rm env-vars
      mkdir $out
      cp -r . $out/ 
    '';
  };
in
if src-only then
  src
else
  (pkgs.haskellPackages.callCabal2nix "tree-sitter-${lang}" src { }).overrideAttrs (_: {
    inherit lang Lang parser;
  })
  
