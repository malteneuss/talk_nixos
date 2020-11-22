let
  pkgs = import <nixpkgs> { };
in pkgs.dockerTools.buildLayeredImage {
  name = "mneuss/helloworld";
  tag = "latest";
  contents = [ pkgs.hello ];

  config = {
    Cmd = [ "hello" ];
    Env = [ "PORT=5000" ];
    WorkingDir = "/";
  };
}
