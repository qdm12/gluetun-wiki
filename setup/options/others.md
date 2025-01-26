# Other options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `TZ` | | i.e. `Europe/London` | Specify a timezone to use to have correct log times |
| `PUID` | `1000` | | User ID to run as non root and for ownership of files written |
| `PGID` | `1000` | | Group ID to run as non root and for ownership of files written |
| `PUBLICIP_ENABLED` | `true` | `true`, `false` | Check for public IP address information on VPN connection |
| `PUBLICIP_API` | `ipinfo` | `ipinfo`, `ip2location`, `cloudflare` or custom URL | Public IP echo service API to use or an echoip URL in the form `echoip#https://xyz` |
| `PUBLICIP_API_TOKEN` | | | Optional API token for the public IP echo service to increase rate limiting |
| `PUBLICIP_FILE` | `/tmp/gluetun/ip` | Any filepath | Filepath to store the public IP address assigned. This will be removed in the `v4` program, instead you might want to use the [control server](../advanced/control-server.md) |
| `VERSION_INFORMATION` | `on` | `on`, `off` | Logs a message indicating if a newer version is available once the VPN is connected |
