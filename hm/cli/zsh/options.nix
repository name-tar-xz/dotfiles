{ lib, config, ... }:
let
  inherit (lib)
    mkOption
    types
    mkOrder
    concatStringsSep
    ;
in
{
  options = {
    programs.zsh = {
      functions = mkOption {
        type = types.attrsOf types.lines;
        default = { };
        example = {
          pargs = "print $0: $*";
        };
        description = ''
          Functions added to .zshrc
        '';
      };

      zleFunctions = mkOption {
        type = types.attrsOf types.lines;
        default = { };
        description = ''
          Functions that are added to the Zsh environment and are added to the
          zsh command line editor via `zle -N`. The key is the name
          and the value is the body of the function to be added
        '';
        example = {
          mkcd = ''
            mkdir --parents "$1" && cd "$1"
          '';
        };
      };

      bindkey = mkOption {
        type = types.attrsOf types.str;
        default = { };
        description = ''
          Keybinds set in Zsh via bindkey. The name is the keybind and value
          is the command.
        '';
        example = {
          "^A" = "beginning-of-line";
        };
      };

      zstyle = mkOption {
        type = types.attrsOf (types.attrsOf types.anything);
        default = { };
        example = {
          auto-description = "'+%d'";
          file-sort = "name";
          use-cache = true;
          ignore-parents = [
            "parent"
            "pwd"
          ];
        };
        description = ''
          Configure zstyle options. See {manpage}`zshmodules(1)`.
          These are used to configure the completion System See {manpage}`zshcompsys(1).
        '';
      };

      shellSuffixAliases = mkOption {
        default = { };
        example = {
          ps = "gv --";
        };
        description = ''
          Suffix Aliases used when a file with a matching suffix is called
          without any other commands.
        '';
      };
    };
  };

  config =
    let
      cfg = config.programs.zsh;
    in
    lib.mkMerge [
      (lib.mkIf (cfg.zleFunctions != { }) { programs.zsh.functions = cfg.zleFunctions; })
      {
        programs.zsh.initContent = lib.mkMerge [
          (lib.mkIf (cfg.functions != { }) (
            mkOrder 550 (
              concatStringsSep "\n" (
                lib.mapAttrsToList (name: def: ''
                  function ${name} {
                    ${def}
                  }
                '') cfg.functions
              )
            )
          ))

          (lib.mkIf (cfg.shellSuffixAliases != { }) (
            mkOrder 1100 (
              lib.optionalString (cfg.shellSuffixAliases != { }) (
                concatStringsSep "\n" (
                  lib.mapAttrsToList (k: v: "alias -s -- ${lib.escapeShellArg k}=${lib.escapeShellArg v}") cfg.shellSuffixAliases
                )
              )
            )
          ))

          (lib.mkIf (cfg.zleFunctions != { }) (
            mkOrder 560 (concatStringsSep "\n" (lib.mapAttrsToList (name: _def: "zle -N ${name}") cfg.zleFunctions))
          ))

          (lib.mkIf (cfg.bindkey != { }) (
            mkOrder 580 (concatStringsSep "\n" (lib.mapAttrsToList (name: def: "bindkey '${name}' ${def}") cfg.bindkey))
          ))

          (lib.mkIf (cfg.zstyle != { }) (
            mkOrder 1120 (
              concatStringsSep "\n" (
                lib.flatten (
                  lib.mapAttrsToList (
                    pattern: set:
                    map (opts: "zstyle '${pattern}' ${opts}") (lib.mapAttrsToList (name: val: "${name} ${(toString val)}") set)
                  ) cfg.zstyle
                )
              )
            )
          ))
        ];
      }
    ];
}
