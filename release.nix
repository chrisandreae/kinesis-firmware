{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  mkFirmware = callPackage ./nix/firmware.nix {
    avrgcc = pkgsCross.avr.buildPackages.gcc;
    avrbinutils = pkgsCross.avr.buildPackages.binutils;
    avrlibc = pkgsCross.avr.libcCross;
  };
in

rec {
  qtclient = libsForQt5.callPackage ./nix/qtclient.nix {
    inherit compiler;
  };

  compiler = haskellPackages.callPackage ./nix/compiler.nix {};

  kinesis = mkFirmware {
    name = "kinesis";
    hardwareVariant = "KINESIS";
    hardwareLibrary = "vusb";
  };

  kinesis110 = kinesis.override {
    name = "kinesis110";
    hardwareVariant = "KINESIS110";
  };

  ergodox-nostorage = mkFirmware {
    name = "ergodox-nostorage";
    hardwareVariant = "ERGODOX";
    hardwareLibrary = "lufa";
    hasStorage = false;
  };

  ergodox-storage = ergodox-nostorage.override {
    name = "ergodox-storage";
    hasStorage = true;
  };
}
