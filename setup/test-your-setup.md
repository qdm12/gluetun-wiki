# Test your setup

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.testing)

Once your container is up and running, you can test your connection is correct and secured (purely optional).

## Check your IP address

Assuming your container is called `gluetun`, run:

```sh
docker run --rm --network=container:gluetun alpine:3.20 sh -c "apk add wget && wget -qO- https://ipinfo.io"
```

in order to obtain the VPN IP address and ensure the connection is working.

## Check DNS over TLS

Ideally, use a computer and connect to `gluetun` using a Shadowsocks client tunneling UDP (for DNS) to test the following:

- Check DNSSEC using [internet.nl/connection](https://www.internet.nl/connection/)
- Check DNS leaks with [https://www.dnsleaktest.com](https://www.dnsleaktest.com)
- Some other DNS leaks tests might not work because of [this](https://github.com/qdm12/dns#verify-dns-connection) (*TLDR*: Unbound DNS server is a local caching intermediary)
