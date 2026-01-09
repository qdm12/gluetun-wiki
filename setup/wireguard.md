# Wireguard

## Native integrations

Gluetun supports Wireguard with native integration for the following providers:

- [AirVPN](providers/airvpn.md)
- [Ivpn](providers/ivpn.md)
- [Mullvad](providers/mullvad.md)
- [NordVPN](providers/nordvpn.md)
- [ProtonVPN](providers/protonvpn.md)
- [Surfshark](providers/surfshark.md)
- [Windscribe](providers/windscribe.md)

And you should refer to their respective page to set up easily Wireguard with them.

## Custom setup

Gluetun supports custom Wireguard client configurations.

This is especially useful with providers such as [Torguard](providers/torguard.md) and [VPN Unlimited](providers/vpn-unlimited.md).

See [the custom provider](providers/custom.md) for more details on how to use this.

## Available options

Available options are listed in [options/wireguard](options/wireguard.md).

## Notes

When using Wireguard together with port forwarding (for example Proton VPN's NAT-PMP), ensure that any LAN access you configure with `FIREWALL_OUTBOUND_SUBNETS` does not overlap with the Wireguard tunnel address range (for example `10.x.x.x/`). If it does, Gluetun can end up sending the port forwarding traffic through the outbound subnet instead of the VPN tunnel, which results in failed or refused port forwarding connections. See https://github.com/qdm12/gluetun/issues/3013 for a real-world example.
