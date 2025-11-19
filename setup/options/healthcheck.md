# Healthcheck options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Description |
| --- | --- | --- |
| `HEALTH_TARGET_ADDRESSES` | `cloudflare.com:443,github.com:443` | Addresses to TCP+TLS dial on connection establishment and then every 5 minutes. Extra addresses are used as fallbacks. |
| `HEALTH_ICMP_TARGET_IPS` | `1.1.1.1,8.8.8.8` | Addresses to ICMP ping every minute after connection. Extra addresses are used as fallbacks. |
| `HEALTH_SERVER_ADDRESS` | `127.0.0.1:9999` | Internal health check server listening address |
| `HEALTH_RESTART_VPN` | `on` | Auto healing feature. I highly suggest keeping this on. You can keep it off to debug why your connection goes unstable. |
