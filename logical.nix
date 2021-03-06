let
  nginxCfg = {
	   enable = true;
	   config = ''
             events {
              worker_connections  1024;
             }
	     http {
               server {
	           listen 0.0.0.0:80;
		   server_name reversie;

                   location / {
                     proxy_pass http://127.0.0.1:3000/;
                     proxy_set_header        Host            $host;
                     proxy_set_header        X-Real-IP       $remote_addr;
                     proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                   }
                }
             }
	   '';
          };
in {
  network.description = "Miso network";

  webserver =
    { config, pkgs, nodes, ... }:
      {
        imports = [ ./demo.nix ];
	services = {
	  demo = { enable = true; };
	  nginx = nginxCfg;
        };
      };

  hydra =
    { config, pkgs, nodes, ... }:
      {
        nix.buildMachines = [{
           hostName = "localhost";
           systems = [ "x86_64-linux" ];
        }];

      services = {
	  hydra = {
	    enable = true;
	    notificationSender = "djohnson.m@gmail.com";
	    listenHost = "localhost";
	    hydraURL = "http://hydra.dmj.io";
          };
          postfix = {
            enable = true;
	    setSendmail = true;
          };
	  postgresql = {
 	    enable = true;
	    package = pkgs.postgresql;
	  };
	  nginx = nginxCfg;
      };
   };
}
