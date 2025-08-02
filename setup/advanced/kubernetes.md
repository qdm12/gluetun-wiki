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

## Reverse proxy running on the local network
Some configurations might require interacting with a service that is running behind a reverse proxy on the local network,
this can be accomplished without adding a public DNS record by using the `hostAliases` directive and configuring some environmental variables for the gluetun pod.

- Provide a [hostAliases](https://kubernetes.io/docs/tasks/network/customize-hosts-file-for-pods/#adding-additional-entries-with-hostaliases) directive that maps the provided domain(s) to an IP address for the entire pod.
- Define the appropriate [FIREWALL_OUTBOUND_SUBNETS](../options/firewall.md) environmental variable to unblock the appropriate subnet(s) in the firewall.
- Define the appropriate [UNBLOCK](../options/dns.md) environmental variable to leave the desired domain(s) unblocked with Unbound.

It is important to note that wildcard domains are not supported in the `/etc/hosts` file, so a `hostAlias` must be configured for each individual domain.

An example `Deployment`:

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
          image: qmcgaw/gluetun
          securityContext:
            capabilities:
              add: [ "NET_ADMIN" ]
          env:
            - name: FIREWALL_OUTBOUND_SUBNETS
              value: "192.168.13.37/32,192.168.13.38/32"
            - name: UNBLOCK
              value: "example.org,subdomain1.example.org,subdomain2.example.org"
  # ...  
```