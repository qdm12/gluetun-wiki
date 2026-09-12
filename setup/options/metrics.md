# Metrics options

See the [metrics setup page](../advanced/metrics.md) for more information.

## Environment variables

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `METRICS_TYPE` | `noop` | `noop`, `prometheus` | `noop` does not expose any metrics, `prometheus` exposes metrics on HTTP port `9090` |
| `METRICS_PROMETHEUS_LISTENING_ADDRESS` | `:9090` | Any valid listening address | Address for the Prometheus metrics HTTP server endpoint to listen on |
