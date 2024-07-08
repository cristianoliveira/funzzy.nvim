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
        }
      ) systems;
    in
      # Reduce the list of packages of packages into a single attribute set
      recursiveMergeAttrs(systemPackages);
}
