let
 pkgs = import <nixpkgs> {};
in
pkgs.stdenv.mkDerivation {
  name = "myProject1-1.0.0";
  src = ./src;
  buildInputs = [ pkgs.hello pkgs.jq ];
}
