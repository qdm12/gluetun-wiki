# SOCKS5 options

## Environment variables

The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `SOCKS5_ENABLED` | `off` | `on`, `off` | Enable the internal SOCKS5 proxy |
| `SOCKS5_LISTENING_ADDRESS` | `:1080` | Listening address | Internal listening address for SOCKS5 |
| `SOCKS5_USER` | | | Username to use to connect to the SOCKS5 proxy, must be set with `SOCKS5_PASSWORD` |
| `SOCKS5_PASSWORD` | | | Password to use to connect to the SOCKS5 proxy, must be set with `SOCKS5_USER` |
