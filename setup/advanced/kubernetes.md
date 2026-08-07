# Kubernetes

## Common errors

### `adding IPv6 rule: ...: file exists`

This is caused by two factors:

1. Kubernetes shares IP rules across the entire pod even if multiple Gluetun containers are running in the same pod
1. Abrupt Gluetun exits which can be caused by a node shutdown, power event or just Gluetun hanging at shutdown (I'm working on fixing this)

To resolve this, change the update strategy from `RollingUpdate` to `Recreate` strategy AND add post start command to ensure IP rules are deleted, for example for Wireguard:

```yml
apiVersion: apps/v1
kind: Deployment
spec:
  strategy:
    type: Recreate
    spec:
      containers:
        - name: vpn
          image: qmcgaw/gluetun
          lifecycle:
            postStart:
              exec:
                command: ["/bin/sh", "-c", "(ip rule del table 51820; ip -6 rule del table 51820) || true"]
          # ...
```

**Credits to [@kvangent](https://github.com/kvangent)**

See the [original issue #2521 comment which resolved this](https://github.com/qdm12/gluetun/issues/2521#issuecomment-2453592258)

## Networking for reverse proxies running on the local network when using Gluetun's DNS

If you want Gluetun to be able to access a service running behind a reverse proxy on your local network, you can use the `hostAliases` directive and configure some Gluetun options to do so.

- Provide a [hostAliases](https://kubernetes.io/docs/tasks/network/customize-hosts-file-for-pods/#adding-additional-entries-with-hostaliases) directive that maps the provided domain(s) to an IP address for the entire pod.
- Define the appropriate [`FIREWALL_OUTBOUND_SUBNETS`](../options/firewall.md) environmental variable to unblock the appropriate subnet(s) in Gluetun.
- Define the appropriate [`DNS_REBINDING_PROTECTION_EXEMPT_HOSTNAMES`](../options/dns.md) to leave the desired domains unblocked.

Wildcard domains are not supported in `/etc/hosts`, so a `hostAlias` must be configured for each individual domain.

Note DNS tools such as `nslookup` won't resolve your names defined in `/etc/hosts`, bu the OS and tools using the OS DNS system will, such as `curl` for example.

An example deployment:

```yml
apiVersion: apps/v1
kind: Deployment
  # ...
spec:
  # ...
    spec:
      hostAliases:
        - ip: "192.168.13.37"
          hostnames:
            - "example.org"
            - "subdomain1.example.org"
        - ip: "192.168.13.38"
          hostnames:
            - "subdomain2.example.org"
      containers:
        - name: gluetun
          image: ghcr.io/qdm12/gluetun
          securityContext:
            capabilities:
              add: [ "NET_ADMIN" ]
          env:
            - name: FIREWALL_OUTBOUND_SUBNETS
              value: "192.168.13.37/32,192.168.13.38/32"
            - name: DNS_REBINDING_PROTECTION_EXEMPT_HOSTNAMES
              value: "example.org,subdomain1.example.org,subdomain2.example.org"
  # ...
```
