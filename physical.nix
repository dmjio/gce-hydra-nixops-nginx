let
  creds = { project = "hydra-143619";
	    serviceAccount = "756352456028-compute@developer.gserviceaccount.com";
	    accessKey = "/Users/dmj/.ssh/gce.pem";
	  };
  hydra = { resources,  ... } : {
     deployment.targetEnv = "gce";
     deployment.gce = creds // {
         network = resources.gceNetworks."hydra-net";
         region = "us-central1-a";
         instanceType = "g1-small";
         tags = [ "public-http" ];
     };

     networking.firewall.allowedTCPPorts = [ 80 22 ];
  };

in {

     resources.gceStaticIps = creds // {
        ipAddress = "130.211.188.234";
        name = "outside";
    };
    resources.gceNetworks."hydra-net" = creds // {
       addressRange = "192.168.4.0/24";
       firewall = {
         allow-http = {
           targetTags = [ "public-http" ];
           allowed.tcp = [ 80 22 ];
       };
       allow-ping.allowed.icmp = null;
     };
   };

  hydra = hydra;
  webserver = hydra;

}
