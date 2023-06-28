# Routing common errors

There can be various issues regarding the firewall, routing and rules manipulation depending on your host environment.

## `cannot list rules: operation not supported`

Your Kernel might be missing `CONFIG_IP_MULTIPLE_TABLES=y`.

Reported by [mfizz1](https://github.com/mfizz1) [here](https://github.com/qdm12/gluetun/issues/1013#issuecomment-1153895571).
