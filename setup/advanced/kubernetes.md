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
