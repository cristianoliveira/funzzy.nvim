{
  description = "Funzzy.nvim development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: 
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        shell = pkgs.bash;
      in {

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            hello
          ];
        };

        packages = {
          default = pkgs.hello;
          funzzy_nvim = pkgs.stdenv.mkDerivation {
            name = "fzz vim for ${system}";
            src = ./.;
            doCheck = true;

            checkInputs = with pkgs; [
              (pkgs.lua5_2.withPackages (ps: with ps; [
                busted 
                luafilesystem
                luacheck 
                luarocks
              ]))
              neovim

            ];

            # NOTE: Configure the test environment
            configurePhase = ''
              export NVIM_BIN=${pkgs.neovim}/bin/nvim
            '';

            # NOTE: Run the tests
            checkPhase = ''

              echo "Running quick checks:"
              ${pkgs.lua54Packages.busted}/bin/busted lua
              ${pkgs.lua54Packages.luacheck}/bin/luacheck lua

              ls -la

              echo "Running tests: for ${system}"
              ${shell}/bin/bash ./nvim-test.sh
            '';

            buildPhase = ''
              echo "Building plugins for ${system}"
              
            '';
          };
        };
    });
}
