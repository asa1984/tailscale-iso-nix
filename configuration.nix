{pkgs, ...}: let
  # get $TAILSCALE_AUTH_KEY
  TAILSCALE_AUTH_KEY = builtins.getEnv "TAILSCALE_AUTH_KEY";
in {
  # Bootloader
  # BIOS: grub
  # UEFI: grub, systemd-boot
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # These packages are installed in the live environment
  environment.systemPackages = with pkgs; [
    curl
    gitMinimal
    # ...favorite packages...
  ];

  # IMPORTANT: After installed, you must set new password with `pwsswd`
  users.users.root.initialPassword = "password";

  # Don't touch - https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  # Enable tailscale service
  services.tailscale.enable = true;

  # Oneshot service to automatically connect to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatically connect to Tailscale & Tailscale SSH";
    after = ["network-pre.target" "tailscale.service"];
    wants = ["network-pre.target" "tailscale.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    script = with pkgs;
    /*
    bash
    */
      ''
        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # otherwise authenticate with tailscale
        ${tailscale}/bin/tailscale up --ssh --auth-key=${TAILSCALE_AUTH_KEY}
      '';
  };
}
