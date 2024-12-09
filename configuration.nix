{ config, pkgs, ... }:

{
  networking.hostName = "scratlab";
  networking.useDHCP = true;  # Use DHCP for IP addressing, change if static IP is required

  networking.firewall.allowedTCPPorts = [ 80 443 8080 ];  # Allow HTTP/HTTPS, and other ports your containers might use

  virtualisation.docker.enable = true;
  virtualisation.docker.enableDockerCompose = true;

  # Allow your user to access Docker without sudo
  users.users.kert = {
    isNormalUser = true;
    extraGroups = [ "docker" ];  # Add your user to the docker group to run Docker commands without sudo
  };

  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];

  services.docker.enable = true;

  # Make Docker start automatically on boot
  systemd.services.docker = {
    description = "Docker service";
    wantedBy = [ "multi-user.target" ];
  };

  # Optional: Enable Docker socket access for the user running Docker Compose
  security.pam.services.sudo = {
    enable = true;
    sudoers = [
      {
        user = "kert";  # Replace with your username
        extraConfig = "NOPASSWD: /usr/bin/docker-compose";
      }
    ];
  };

  time.timeZone = "Europe/Tallinn";

  systemd.journald.extraConfig = ''
    MaxRetentionSec=1week
    SystemMaxUse=1G
  '';
}