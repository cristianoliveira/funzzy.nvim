{
  description = "Funzzy.nvim development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      recursiveMergeAttrs = listOfAttrsets: lib.fold (attrset: acc: lib.recursiveUpdate attrset acc) {} listOfAttrsets;

      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      systemPackages = map (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          devShells."${system}".default = import ./shell.nix {
            inherit pkgs;
          };

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

              echo "Running tests: for ${system}"
              $PWD/nvim-test.sh
            '';

            buildPhase = ''
              echo "Building plugins for ${system}"
              
            '';
          };
        }
      ) systems;
    in
      # Reduce the list of packages of packages into a single attribute set
      recursiveMergeAttrs(systemPackages);
}
