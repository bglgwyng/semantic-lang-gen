# code;
foo = { name, Name }: pkgs.stdenv.mkDerivation {
name = "foo";
buildInputs = [
(haskellPackages.ghcWithPackages
(ps: with ps; [
cabal-install
tree-sitter
neat-interpolation
flake.packages."semantic-mini:lib:semantic-mini"
(generate-tree-sitter-lang { inherit name Name; })
]))
];
dontUnpack = true;
buildPhase = ''
            # echo "packages: ." > cabal.project
            cp ${./templates/generate-types.hs.tpl} generate-types.hs
            substituteInPlace generate-types.hs --replace Foo ${Name} --replace foo ${name}
            cabal run ${./templates/generate-types.hs.tpl}
          '';
installPhase = ''
            cp out.txt $out
          '';
};
