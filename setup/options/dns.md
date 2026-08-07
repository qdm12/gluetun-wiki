# DNS options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `DNS_UPSTREAM_RESOLVER_TYPE` | `dot` | `dot`, `doh` or `plain` | How to connect to the upstream DNS servers. `dot` means DNS over TLS, `doh` means DNS over HTTPS, `plain` means plain UDP DNS. |
| `DNS_UPSTREAM_RESOLVERS` | `cloudflare` | `cira family`, `cira private`, `cira protected`, `cleanbrowsing adult`, `cleanbrowsing family`, `cleanbrowsing security`, `cloudflare`, `cloudflare family`, `cloudflare security`, `google`, `libredns`, `opendns`, `quad9`, `quad9 secured`, `quad9 unsecured`, `quadrant` | Comma delimited list of DNS over TLS providers |
| `DNS_CACHING` | `on` | `on`, `off` | DNS caching |
| `DNS_UPSTREAM_IPV6` | `off` | `on`, `off` | DNS IPv6 resolution |
| `DNS_BLOCK_IPS` | | Any valid IP address | Comma separated list of IP addresses to not resolve public domains to. |
| `DNS_BLOCK_IP_PREFIXES` | | | Comma separated list of CIDRs to not resolve public domains to. |
| `DNS_REBINDING_PROTECTION_EXEMPT_HOSTNAMES` | | Comma separated list of public domain names | Public domain names to exclude from DNS rebinding protection. Parent domains such as `*.example.com` are allowed; the wildcard must appear only at the start. |
| `DNS_UPDATE_PERIOD` | `24h` | i.e. `0`, `30s`, `5m`, `24h` | Period to update block lists and restart the DNS server. Set to `0` to deactivate updates |
| `BLOCK_MALICIOUS` | `on` | `on`, `off` | Block malicious hostnames and IPs |
| `BLOCK_SURVEILLANCE` | `off` | `on`, `off` | Block surveillance hostnames and IPs |
| `BLOCK_ADS` | `off` | `on`, `off` | Block ads hostnames and IPs |
| `DNS_UNBLOCK_HOSTNAMES` | | i.e. `domain1.com,x.domain2.co.uk` | Comma separated list of domain names to leave unblocked from the filtering |
| `DNS_UPSTREAM_PLAIN_ADDRESSES` | | Comma separated list of `ip:port` addresses | (Warning: prefer NOT using this)If set, the internal DNS server will forward queries to the addresses specified over plaintext. Ideally do NOT use the VPN provider DNS, see why below. If you set this to a private IP address on your Docker bridge network or your LAN, your DNS queries will leak out of the VPN tunnel! |

## Warning on `DNS_UPSTREAM_PLAIN_ADDRESSES`

I highly recommend NOT using this option, reason being users use it 99% of the time to either:

1. Use their local DNS server, meaning all DNS traffic will NOT go through the VPN tunnel and leak out of it. This can be mitigated if using an encrypted DNS protocol to an upstream DNS resolver, but it's not ideal. There is also little reason to do so.
1. Blindly trust your VPN provider by either:
    1. using the VPN provider DNS server IP address: the VPN provider can read all your DNS data, and produce their own responses, more details below.
    1. using a public DNS resolver, for example `1.1.1.1:53` - which the VPN infrastructure can read and **modify** (this actually happened to me - not for malicious purposes - but still)

> VPN provider DNS is bad idea

A lot, if not all, of VPN providers offer a DNS server IP address they manage. And privacy-wise, it's quite a potential disaster.

You hand over all your DNS data to your VPN provider. That VPN provider has at the very least your public IP address, which can be associated with you, and can have on top of this:

- your email address
- your payment information
- your name
- access to your unencrypted traffic like most torrenting

That means the vpn provider can build a pretty decent profile and either sell it or hand it to authorities, without you knowing.

A wild guess (prove me right/wrong!) as well is that because the communication to the vpn provider dns server is unencrypted over udp, it might be possible for another user on the vpn server to sniff that dns traffic.

The solution: don't set `DNS_UPSTREAM_PLAIN_ADDRESSES` to your vpn provider dns address and stick to using the built-in dns forwarding server exchanging dns queries with public resolvers over tls or https. By default it only uses cloudflare which is enough for a much better privacy.

Cloudflare's DNS will receive dns queries from multiple users all coming from the same vpn server ip address, so it cannot build a profile of you only and doesn't even have any other information on you.

Want to go extra privacy? Set `DNS_UPSTREAM_RESOLVERS` to multiple ones, for example `cloudflare,google`. It means every query will be sent to one of the upstream resolvers at random, making your dns traffic fractured and so even harder to build a dns profile.

💁 If you liked that section, please share it with anyone suggesting to use the VPN provider dns server, as there is a lot of users suggesting that unfortunately!
