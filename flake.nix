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
          devShells."${system}".default = pkgs.mkShell {
            packages = with pkgs; [
              lua
              lua54Packages.busted
              lua54Packages.luacheck
            ];
          };

          check = pkgs.stdenv.mkDerivation {
            name = "buld plugins for ${system}";
            src = ./.;
            doCheck = true;

            checkInputs = with pkgs; [
              lua
              lua54Packages.luarocks
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
              ./nvim-test.sh
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
