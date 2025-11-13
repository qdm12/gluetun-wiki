# DNS options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `DNS_SERVER` | `on` | `on`, `off` | Activate the built-in DNS server. You should keep it `on` and NOT use the VPN provided DNS servers. |
| `DNS_UPSTREAM_RESOLVER_TYPE` | `dot` | `dot`, `doh` or `plain` | How to connect to the upstream DNS servers. `dot` means DNS over TLS, `doh` means DNS over HTTPS, `plain` means plain UDP DNS. |
| `DNS_UPSTREAM_RESOLVERS` | `cloudflare` | `cira family`, `cira private`, `cira protected`, `cleanbrowsing adult`, `cleanbrowsing family`, `cleanbrowsing security`, `cloudflare`, `cloudflare family`, `cloudflare security`, `google`, `libredns`, `opendns`, `quad9`, `quad9 secured`, `quad9 unsecured`, `quadrant` | Comma delimited list of DNS over TLS providers |
| `DNS_CACHING` | `on` | `on`, `off` | DNS caching |
| `DNS_UPSTREAM_IPV6` | `off` | `on`, `off` | DNS IPv6 resolution |
| `DNS_BLOCK_IPS` | | Any valid IP address | Comma separated list of IP addresses to not resolve public domains to. |
| `DNS_BLOCK_IP_PREFIXES` | All private CIDRs ranges | | Comma separated list of CIDRs to not resolve public domains to. Note that the default setting prevents DNS rebinding |
| `DNS_UPDATE_PERIOD` | `24h` | i.e. `0`, `30s`, `5m`, `24h` | Period to update block lists and restart the DNS server. Set to `0` to deactivate updates |
| `BLOCK_MALICIOUS` | `on` | `on`, `off` | Block malicious hostnames and IPs |
| `BLOCK_SURVEILLANCE` | `off` | `on`, `off` | Block surveillance hostnames and IPs |
| `BLOCK_ADS` | `off` | `on`, `off` | Block ads hostnames and IPs |
| `DNS_UNBLOCK_HOSTNAMES` | |i.e. `domain1.com,x.domain2.co.uk` | Comma separated list of domain names to leave unblocked from the filtering |
| `DNS_ADDRESS` | `127.0.0.1` | Any IP address | IP address to use as DNS resolver. It defaults to localhost to use the built-in DNS server. |
| `DNS_KEEP_NAMESERVER` | `off` | `on` or `off` | I highly recommend using [image tag `:pr-2970`](https://github.com/qdm12/gluetun/pull/2970) instead of turning this `on`. This keeps `/etc/resolv.conf` untouched and will likely **leak DNS traffic outside the VPN** through your default container DNS. This imples `DNS_SERVER=off` and ignores `DNS_ADDRESS` |
