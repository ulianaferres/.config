{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.nano;
in
{
  options = {
    programs.nano = {
      enable = lib.mkEnableOption "nano, a small user-friendly console text editor" // {
        default = true;
      };

      package = lib.mkPackageOption pkgs "nano" { };

      nanorcPackage = lib.mkPackageOption pkgs "nanorc" {};

      nanorc = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          The user nano configuration.
          See {manpage}`nanorc(5)`.
        '';
        example = ''
          set nowrap
          set tabstospaces
          set tabsize 2
        '';
      };

      syntaxHighlight = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable syntax highlight for various languages.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file.".nanorc".text =
      (lib.optionalString cfg.syntaxHighlight ''
        # load syntax highlighting files
        include "${cfg.nanorcPackage}/share/*.nanorc"
        include "${cfg.package}/share/nano/*.nanorc"
        include "${cfg.package}/share/nano/extra/*.nanorc"
      '')
      + cfg.nanorc;
  };
}
