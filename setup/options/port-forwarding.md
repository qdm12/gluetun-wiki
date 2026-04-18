# VPN server port forwarding options

Read [the guide](../advanced/vpn-port-forwarding.md) for details.

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `VPN_PORT_FORWARDING` | `off` | `off` or `on` | Enable custom port forwarding code for supported providers |
| `VPN_PORT_FORWARDING_PROVIDER` | Current provider in use | `private internet access`, `perfect privacy`, `privatevpn`, `protonvpn` | Choose the custom port forwarding code to use. This is useful when using the custom provider with Wireguard. For PIA, make sure you set `SERVER_NAMES=<server-name>`. |
| `VPN_PORT_FORWARDING_PORTS_COUNT` | `1` | Depends on VPN provider | Number of TCP+UDP ports to forward. Can be up to `4` for ProtonVPN. |
| `VPN_PORT_FORWARDING_STATUS_FILE` | `/tmp/gluetun/forwarded_port` | Valid filepath | File path to use for writing the forwarded port obtained. |
| `VPN_PORT_FORWARDING_LISTENING_PORTS` | | Comma separated list of port numbers | Port redirections to redirect incoming traffic to. Do not use with torrent clients. Specify 0 or `N` ports for `VPN_PORT_FORWARDING_PORTS_COUNT=N` |
| `VPN_PORT_FORWARDING_UP_COMMAND` | | Shell command | Command to run when port forwarding has finished setting up. |
| `VPN_PORT_FORWARDING_DOWN_COMMAND` | | Shell command | Command to run when port forwarding has finished tearing down. |
