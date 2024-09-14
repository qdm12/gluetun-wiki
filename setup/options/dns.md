# DNS options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `DOT` | `on` | `on`, `off` | Activate DNS over TLS with Unbound |
| `DOT_PROVIDERS` | `cloudflare` | `cloudflare`, `google`, `quad9`, `quadrant`, `cleanbrowsing` | Comma delimited list of DNS over TLS providers |
| `DOT_CACHING` | `on` | `on`, `off` | Unbound caching |
| `DOT_IPV6` | `off` | `on`, `off` | DNS IPv6 resolution |
| `DOT_PRIVATE_ADDRESS` | All private CIDRs ranges | | Comma separated list of CIDRs or single IP addresses Unbound won't resolve to. Note that the default setting prevents DNS rebinding |
| `DNS_UPDATE_PERIOD` | `24h` | i.e. `0`, `30s`, `5m`, `24h` | Period to update block lists and cryptographic files and restart Unbound. Set to `0` to deactivate updates |
| `BLOCK_MALICIOUS` | `on` | `on`, `off` | Block malicious hostnames and IPs with Unbound |
| `BLOCK_SURVEILLANCE` | `off` | `on`, `off` | Block surveillance hostnames and IPs with Unbound |
| `BLOCK_ADS` | `off` | `on`, `off` | Block ads hostnames and IPs with Unbound |
| `UNBLOCK` | |i.e. `domain1.com,x.domain2.co.uk` | Comma separated list of domain names to leave unblocked with Unbound |
| `DNS_ADDRESS` | `127.0.0.1` | Any IP address | IP address to use as DNS resolver. It defaults to localhost to use the DNS over TLS Unbound server. |
| `DNS_KEEP_NAMESERVER` | `off` | `on` or `off` | Keep `/etc/resolv.conf` untouched. ⚠️ this will likely **leak DNS traffic outside the VPN** through your default container DNS. This imples `DOT=off` and ignores `DNS_ADDRESS` |
