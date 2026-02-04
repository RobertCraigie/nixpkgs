{
  lib,
  stdenv,
  fetchFromGitHub,
  jre_headless,
  makeWrapper,
  gradle,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "palantir-java-format";
  version = "2.86.0";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "palantir-java-format";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W000000000000000000000000000000000000000000=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };
  __darwinAllowLocalNetworking = true; # this is required for using mitm-cache on Darwin

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  doCheck = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 core/build/libs/palantir-java-format-*-with-dependencies.jar $out/share/palantir-java-format/palantir-java-format.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/palantir-java-format \
      --add-flags "-jar $out/share/palantir-java-format/palantir-java-format.jar"

    runHook postInstall
  '';

  meta = {
    description = " A modern, lambda-friendly, 120 character Java formatter.";
    homepage = "https://github.com/palantir/palantir-java-format";
    license = lib.licenses.asl20;
    mainProgram = "palantir-java-format";
    maintainers = [];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    inherit (jre_headless.meta) platforms;
  };
})
