# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "nvme" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "sg" "nvidia-uvm" ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9903111c-60ce-4984-8f9b-578bfd2902dc";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9329-2F4D";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-06f87a243bb6.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-184b77edbf8f.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-25bc167cd3bc.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-9d36d2985247.useDHCP = lib.mkDefault true;
  # networking.interfaces.br-c78f2e77b0df.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0f0np0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0f1np1.useDHCP = lib.mkDefault true;
  # networking.interfaces.vethcd0b90a.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
