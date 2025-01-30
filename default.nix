{
  pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    packages = [
      pkgs.hugo
      pkgs.netlify-cli
    ];
}
