# Healthcheck options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Description |
| --- | --- | --- |
| `HEALTH_TARGET_ADDRESS` | `cloudflare.com:443` | Address to ping on every **internal** health check |
| `HEALTH_VPN_DURATION_INITIAL` | `6s` | Initial duration to wait for the VPN to be ready before restarting it |
| `HEALTH_VPN_DURATION_ADDITION` | `5s` | Additional duration to add to the wait time for each consecutive failure of the VPN |
| `HEALTH_SUCCESS_WAIT_DURATION` | `5s` | Duration to wait after a success check to perform another check |
| `HEALTH_SERVER_ADDRESS` | `127.0.0.1:9999` | Internal health check server listening address |
