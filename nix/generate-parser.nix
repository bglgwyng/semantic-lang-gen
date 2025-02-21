{ pkgs, name, grammar-js }:
pkgs.stdenv.mkDerivation {
  inherit name;
  src = grammar-js;
  buildInputs = [ pkgs.tree-sitter pkgs.nodejs_22 ];
  dontUnpack = true;
  # why tmp is needed?
  buildPhase = ''
    mkdir tmp
    cd tmp
    ${pkgs.tree-sitter}/bin/tree-sitter generate $src
  '';
  installPhase = ''
    mkdir -p $out
    cp -r ./* $out
  '';
}
