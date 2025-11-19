{ pkgs, lang, grammar-js, scanner-c ? null }:
pkgs.stdenv.mkDerivation {
  inherit lang scanner-c;
  name = "tree-sitter-${lang}";
  src = grammar-js;
  nativeBuildInputs = [ pkgs.tree-sitter pkgs.nodejs_22 pkgs.jq ];
  dontUnpack = true;
  # why tmp is needed?
  buildPhase = ''
    mkdir tmp
    cd tmp
    tree-sitter generate --abi 14 $src
    
    # Validate that grammar.json name matches lang
    GRAMMAR_NAME=$(jq -r '.name' src/grammar.json)
    if [ "$GRAMMAR_NAME" != "${lang}" ]; then
      echo "Error: '$GRAMMAR_NAME' does not match expected lang '${lang}'"
      exit 1
    fi
    
    ${if scanner-c == null then "" else "ln -s ${scanner-c} src/scanner.c"}
  '';
  installPhase = ''
    mkdir -p $out
    cp -r ./* $out
  '';
  postInstall = ''
    mkdir -p $out/etc
    mv $out/env-vars $out/etc/
  '';
}
