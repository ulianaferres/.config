{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    mission-center
    ethtool
    obs-studio
    pinentry-all
    gamescope
    makemkv
    whatsapp-for-linux
    popsicle
    powertop
    nerd-fonts.droid-sans-mono
    s-tui
    resilio-sync
    proton-pass
  ];

  programs = {
    plasma = {
      enable = true;

      workspace = {
        clickItemTo = "select";
        lookAndFeel = "org.kde.breezedark.desktop";
      };
    };
  };
}
