# VPN server port forwarding options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `VPN_PORT_FORWARDING` | `off` | `off` or `on` | Enable custom port forwarding code for supported providers |
| `VPN_PORT_FORWARDING_STATUS_FILE` | `/tmp/gluetun/forwarded_port` | Valid filepath | File path to use for writing the forwarded port obtained. |
