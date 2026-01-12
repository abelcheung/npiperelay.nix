{
  lib, stdenv,
  go, buildGoModule,
  npiperelay,
  ...
}: buildGoModule {
  pname = "npiperelay";
  version = "fork.albertony";

  src = npiperelay;
  vendorHash = null;

  # Remember who we build this for
  # can't specify as attr beacuse it'll get overriden
  preBuild = ''
    export GOOS=windows
  '';

  ldflags = let
    inject = var: val: [
      "-X" "main.${var}=${toString val}"
    ];
  in [
    "-s" # Omit the symbol table and debug information
    "-w" # Omit the DWARF symbol table
  ]
  ++ inject "version" "1.9.2-albertony"
  ++ inject "commit" npiperelay.shortRev
  ++ inject "date" (builtins.substring 0 8 npiperelay.lastModifiedDate)
  ++ inject "builtBy" "nix-build"
  ;

  # fixupPhase in Nix will mess up the binary it seems :(
  dontFixup = true;

  postInstall = ''
    mv $out/bin/windows_amd64/* $out/bin
    rmdir $out/bin/windows_amd64
  '';

  meta = {
    description = "Allows access to Windows named pipes from WSL";
    homepage = "https://github.com/albertony/npiperelay";
    license = lib.licenses.mit;
    maintainers = [];
  };
}
