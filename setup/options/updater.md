# Servers updater options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `UPDATER_PERIOD` | `0` | Valid duration string such as `24h` | Period to update the VPN servers data in memory and to /gluetun/servers.json. Set to `0` to disable. This does a burst of DNS over TLS requests, which may be blocked if you set `BLOCK_MALICIOUS=on` for example. |
| `UPDATER_MIN_RATIO` | `0.8` | Ratio between `0` (excluded) and `1` | Ratio of servers to be found for the update to succeed, compared to the servers already built in the program |
| `UPDATER_VPN_SERVICE_PROVIDERS` | the current VPN provider used | Any valid VPN provider name | List of providers to update servers data for, when the updater triggers periodically. If left empty, it defaults to the current VPN provider used at start. |
