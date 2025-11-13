# Healthcheck options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Description |
| --- | --- | --- |
| `HEALTH_TARGET_ADDRESS` | `cloudflare.com:443` | Address to TCP+TLS dial on connection establishment and then every 5 minutes |
| `HEALTH_ICMP_TARGET_IP` | `1.1.1.1` | Address to ICMP ping every minute after connection |
| `HEALTH_SERVER_ADDRESS` | `127.0.0.1:9999` | Internal health check server listening address |
| `HEALTH_RESTART_VPN` | `on` | Auto healing feature. I highly suggest keeping this on. You can keep it off to debug why your connection goes unstable. |
