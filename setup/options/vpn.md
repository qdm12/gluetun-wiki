# VPN options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `VPN_SERVICE_PROVIDER` | `private internet access` | Valid VPN provider | Specify a supported VPN provider to use |
| `VPN_TYPE` | `openvpn` | `openvpn` or `wireguard` | VPN protocol to use. Not all providers support Wireguard. |
| `VPN_INTERFACE` | `tun0` | Any interface name | Specify a custom network interface name to use |
