{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  gitMinimal,
}:

buildGoModule (finalAttrs: {
  pname = "depot";
  version = "2.101.35";

  src = fetchFromGitHub {
    owner = "depot";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dhtVSZJjZN5wFIOVTIqTc0CCNYhPkHTQZhEEUAbP5AE=";
  };

  vendorHash = "sha256-YLcDI6xUCOytPYC4atoKkUvcA0Qw7YistNTTBcPhzn8=";

  subPackages = [ "cmd/depot" ];

  # so `depot version` works correctly
  ldflags = [
    "-s"
    "-w"
    "-X github.com/depot/cli/internal/build.Version=${finalAttrs.version}"
    "-X github.com/depot/cli/internal/build.SentryEnvironment=release"
  ];

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    gitMinimal
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd depot \
      --bash <($out/bin/depot completion bash) \
      --fish <($out/bin/depot completion fish) \
      --zsh <($out/bin/depot completion zsh)
  '';

  meta = {
    description = "Build your Docker images in the cloud";
    homepage = "https://github.com/depot/cli";
    mainProgram = "depot";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [
      RobertCraigie
    ];
  };
})
