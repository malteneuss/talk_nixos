let
 pkgs = import <nixpkgs> {};
in
pkgs.stdenv.mkDerivation {
  name = "myProject2-1.0.0";
  src = ./src;
  buildInputs = [ pkgs.maven pkgs.nodejs ];
}
