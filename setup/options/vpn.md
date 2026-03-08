# VPN options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `VPN_SERVICE_PROVIDER` | `private internet access` | Valid VPN provider | Specify a supported VPN provider to use |
| `VPN_TYPE` | `openvpn` | `openvpn` or `wireguard` | VPN protocol to use. Not all providers support Wireguard. |
| `VPN_INTERFACE` | `tun0` | Any interface name | Specify a custom network interface name to use |
| `VPN_UP_COMMAND` | | Shell command | Command to run when the VPN connection goes up. You can use the following template variables if needed: `{{VPN_INTERFACE}}` |
| `VPN_DOWN_COMMAND` | | Shell command | Command to run when the VPN connection goes down. You can use the following template variables if needed: `{{VPN_INTERFACE}}` |

⚠️ For `_COMMAND` options:

- shell specific syntax such as `&&` is not understood in the command, and one should use `/bin/sh -c "my shell syntax"` to do so if they want.
- one can bind mount a shell script in Gluetun and execute it with for example `VPN_UP_COMMAND=/bin/sh -c /gluetun/myscript.sh` - 💁  feel free to propose a pull request to add commonly used shell scripts.
- the output of the command is written to the VPN logger within Gluetun
