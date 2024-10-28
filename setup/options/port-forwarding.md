# VPN server port forwarding options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `VPN_PORT_FORWARDING` | `off` | `off` or `on` | Enable custom port forwarding code for supported providers |
| `VPN_PORT_FORWARDING_PROVIDER` | Current provider in use | `private internet access` | Choose the custom port forwarding code to use. This is useful when using the custom provider with Wireguard. For PIA, make sure you set `SERVER_NAMES=<server-name>`. |
| `VPN_PORT_FORWARDING_STATUS_FILE` | `/tmp/gluetun/forwarded_port` | Valid filepath | File path to use for writing the forwarded port obtained. |
| `VPN_PORT_FORWARDING_LISTENING_PORT` | | Valid port number | Port redirection for the VPN server side port forwarded. |
