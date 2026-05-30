{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "searchfox-cli";
  version = "0.15.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "padenot";
    repo = "searchfox-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5D28uoHJcuiaC/NbLEViJ6Z9waWmBDj3o4NRLXVAxuE=";
  };

  cargoBuildFlags = [
    "--package"
    "searchfox-cli"
  ];

  cargoHash = "sha256-/LYstGJV3YWq3qjHn8QbiELKv4kaT4FRADGzA0u944E=";

  # Integration tests require network access to searchfox.org
  cargoTestFlags = [
    "--lib"
    "--bins"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for searchfox.org";
    homepage = "https://github.com/padenot/searchfox-cli";
    changelog = "https://github.com/padenot/searchfox-cli/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ RobertCraigie ];
    mainProgram = "searchfox-cli";
  };
})
