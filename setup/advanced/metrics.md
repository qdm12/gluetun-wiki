# Metrics

You can expose metrics for Gluetun, by setting `METRICS_TYPE=prometheus` and scraping the HTTP port `9090`.
See the [metrics options page](../options/metrics.md) for more information.

The following metrics are exposed:

| Metric | Type | Description |
| --- | --- | --- |
| `gluetun_tun_rx_bytes_total` | Counter | Cumulative number of bytes received over the VPN network interface. Resets to `0` if VPN interface goes down. |
| `gluetun_tun_tx_bytes_total` | Counter | Cumulative number of bytes sent over the VPN network interface. Resets to `0` if VPN interface goes down. |

There is a Grafana dashboard specification you can import at [passteque/gluetun/metrics/grafana.json](https://github.com/passteque/gluetun/blob/master/metrics/grafana.json).
This JSON specification corresponds to the latest container image, make sure to use the one matching your Gluetun version to avoid having empty panels.
