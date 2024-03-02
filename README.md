NixOS ISO image that automatically connects to Tailscale with auth key

## Requirements

- [Nix](https://nixos.org)
  - Flakes & Nix command need to be enabled
  - It's recommended to use [nix-installer](https://github.com/DeterminateSystems/nix-installer) instead of the official installer
    - This installer automatically enables flakes and nix command
- [Tailscale](https://tailscale.com) account

## Build ISO

1. Create [auth key](https://tailscale.com/kb/1085/auth-keys) on Tailscale

2. Run

```bash
# impure option is required to read the environment variables
$ TAILSCLAE_AUTH_KEY=<your auth key> nix build --impure
$ ls ./result/iso
nixos.iso
```

## References

- [Tailscale on NixOS: A new Minecraft server in ten minutes](https://tailscale.com/blog/nixos-minecraft)
- [nix-community/nixos-generators](https://github.com/nix-community/nixos-generators)
