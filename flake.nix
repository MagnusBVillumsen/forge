{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        packages.forge = pkgs.rustPlatform.buildRustPackage {
          pname = "forge";
          version = "0.1.0-dev";
          src = pkgs.lib.cleanSource ./.;

          cargoLock.lockFile = ./Cargo.lock;

          nativeBuildInputs = with pkgs; [
            pkg-config
            installShellFiles
          ];
          buildInputs = with pkgs; [ openssl ];

          postInstall = ''
            export HOME=$(mktemp -d)
            installShellCompletion --cmd forge \
              --bash <($out/bin/forge completion bash) \
              --fish <($out/bin/forge completion fish) \
              --zsh <($out/bin/forge completion zsh) \
              --nushell <($out/bin/forge completion nushell)
          '';

          meta = with pkgs.lib; {
            description = "CLI tool for Forgejo, with gh-style output for scripts and agents";
            homepage = "https://github.com/MagnusBVillumsen/forge";
            license = with licenses; [
              asl20 # or
              mit
            ];
          };

          env = {
            BUILD_TYPE = "flake";
          };
        };

        packages.default = packages.forge;

        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.default ];

          nativeBuildInputs = with pkgs; [
            cargo
            rustc
            rustfmt
            clippy
          ];

          # Required for rust-analyzer to work
          RUST_SRC_PATH = "${pkgs.rustPlatform.rustcSrc}/library";
        };
      }
    );
}
