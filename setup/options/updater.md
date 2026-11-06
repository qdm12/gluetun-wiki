# Servers updater options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `UPDATER_PREFER_DIRECT_DOWNLOAD` | `no` | `yes` or `no` | Whether to prefer direct download of servers data from [gluetun-servers](https://github.com/qdm12/gluetun-servers/tree/main/pkg/servers), instead of using the Gluetun code to fetch, parse and process servers data. This is notably faster and more reliable, but defaults to `no` to avoid breaking compatibility. |
| `UPDATER_PERIOD` | `0` | Valid duration string such as `480h` | Period to update the VPN servers data in memory and to /gluetun/servers/. Set to `0` to disable. This does a burst of DNS over HTTPs requests, which may be blocked if you set `BLOCK_MALICIOUS=on` for example. |
| `UPDATER_MIN_RATIO` | `0.8` | Ratio between `0` (excluded) and `1` | Ratio of servers to be found for the update to succeed, compared to the servers already built in the program |
| `UPDATER_VPN_SERVICE_PROVIDERS` | the current VPN provider used | Any valid VPN provider name | List of providers to update servers data for, when the updater triggers periodically. If left empty, it defaults to the current VPN provider used at start. |
| `UPDATER_PROTONVPN_EMAIL` | | Your Proton email | If you need paid servers data, you must use a paid account. Otherwise I recommend creating a free throwaway account for this. |
| `UPDATER_PROTONVPN_PASSWORD` | | Your Proton password | If you need paid servers data, you must use a paid account. Otherwise I recommend creating a free throwaway account for this. |
