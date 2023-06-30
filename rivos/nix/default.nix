# SPDX-FileCopyrightText: Copyright (c) 2023 by Rivos Inc.
# SPDX-FileCopyrightText: Copyright (c) 2003-2023 Eelco Dolstra and the Nixpkgs/NixOS contributors
# SPDX-License-Identifier: MIT
{ stdenv, lib, fetchFromGitHub, fetchpatch, protobuf, protobufc, asciidoc, iptables
, xmlto, docbook_xsl, libpaper, libnl, libcap, libnet, pkg-config, iproute2
, which, python3, makeWrapper, docbook_xml_dtd_45, perl, nftables, libbsd
, buildPackages
, src
, version
}:

stdenv.mkDerivation rec {
  pname = "criu";
  inherit src version;

  enableParallelBuilding = true;
  depsBuildBuild = [ protobufc buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    pkg-config
    asciidoc
    xmlto
    libpaper
    docbook_xsl
    which
    makeWrapper
    docbook_xml_dtd_45
    python3
    python3.pkgs.wrapPython
    perl
  ];
  buildInputs = [
    protobuf
    libnl
    libcap
    libnet
    nftables
    libbsd
  ];
  propagatedBuildInputs = [
    protobufc
  ] ++ (with python3.pkgs; [
    python
    python3.pkgs.protobuf
  ]);

  postPatch = ''
    substituteInPlace ./Documentation/Makefile \
      --replace "2>/dev/null" "" \
      --replace "-m custom.xsl" "-m custom.xsl --skip-validation -x ${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
    substituteInPlace ./Makefile --replace "head-name := \$(shell git tag -l v\$(CRIU_VERSION))" "head-name = ${version}.0"
    ln -sf ${protobuf}/include/google/protobuf/descriptor.proto ./images/google/protobuf/descriptor.proto
  '';

  makeFlags = let
    # criu's Makefile infrastructure expects to be passed a target architecture
    # which neither matches the config-tuple's first part, nor the
    # targetPlatform.linuxArch attribute. Thus we take the latter and map it
    # onto the expected string:
    linuxArchMapping = {
      "x86_64" = "x86";
      "arm" = "arm";
      "arm64" = "aarch64";
      "powerpc" = "ppc64";
      "s390" = "s390";
      "mips" = "mips";
      "riscv" = "riscv64";
    };
  in [
    "PREFIX=$(out)"
    "ASCIIDOC=${buildPackages.asciidoc}/bin/asciidoc"
    "XMLTO=${buildPackages.xmlto}/bin/xmlto"
    "DEBUG=1"
  ] ++ (lib.optionals (stdenv.buildPlatform != stdenv.targetPlatform) [
    "ARCH=${linuxArchMapping."${stdenv.targetPlatform.linuxArch}"}"
    "CROSS_COMPILE=${stdenv.targetPlatform.config}-"
  ]);

  installTargets = [
    "install-criu"
    "compel"
    "install-man"
  ];

  postInstall = ''
  '';

  outputs = [ "out" "dev" "man" ];

  preBuild = ''
    # No idea why but configure scripts break otherwise.
    export SHELL=""
  '';

  hardeningDisable = [ "stackprotector" "fortify" ];
  # dropping fortify here as well as package uses it by default:
  # command-line>:0:0: error: "_FORTIFY_SOURCE" redefined [-Werror]

  postFixup = ''
    wrapProgram $out/bin/criu \
      --set-default CR_IPTABLES ${iptables}/bin/iptables \
      --set-default CR_IP_TOOL ${iproute2}/bin/ip
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Userspace checkpoint/restore for Linux";
    homepage    = "https://criu.org";
    license     = licenses.gpl2;
    platforms   = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" "riscv64-linux" ];
    maintainers = [ maintainers.thoughtpolice ];
  };
}
