{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    pinentry_mac
    #asitop
  ];
}
