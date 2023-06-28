# Multiple Gluetun

You can easily run multiple Gluetun containers on the same host machine without any conflict.

On the other hand, there are few tricks to lower resource usage.

## Common DNS server

You can run a shared DNS server for all your Gluetun instances.
You can have a DNS server such as [`qmcgaw/dns:v2.0.0-beta`](https://github.com/qdm12/dns/tree/v2.0.0-beta) and run it in the same Docker network as your other Gluetun containers.
You can have it non-VPN'ed or VPN'ed through one of the Gluetun containers.
