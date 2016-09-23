{ config, pkgs, lib, ... }:
  let
   cfg = config.services.demo;
  in with lib; {
    options = {
      services.demo  = {
         enable = mkOption {
            default = false;
            type = with types; bool;
	    description = ''Start web server when nixos starts'';
	  };
	};
     };
      config = mkIf cfg.enable {
        systemd.services.demo = {
	  description = "demo service";
          wantedBy = [ "multi-user.target" ];
	   serviceConfig = {
             ExecStart = "${pkgs.demo}/bin/main +RTS -N -RTS;";
          };
	};
      };
    }

