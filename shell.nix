{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    buildInputs = [
      (pkgs.lua5_2.withPackages (ps: with ps; [
                                 busted 
                                 luafilesystem
                                 luacheck 
      ]))
    ];

    shell = pkgs.zsh;
  }
