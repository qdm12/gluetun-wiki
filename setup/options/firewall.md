# Firewall options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `FIREWALL_VPN_INPUT_PORTS` | | i.e. `1000,8080` | Comma separated list of ports to allow from the VPN server side |
| `FIREWALL_INPUT_PORTS` | | i.e. `1000,8000` | Comma separated list of ports to allow through the default interface. This seems needed for Kubernetes sidecars. |
| `FIREWALL_DEBUG` | `off` | `on` or `off` | Prints every firewall related command. You should use it for **debugging purposes** only. |
| `FIREWALL_OUTBOUND_SUBNETS` | | i.e. `192.168.1.0/24,192.168.10.121,10.0.0.5/28` | Comma separated subnets that Gluetun and the containers sharing its network stack are allowed to access. This involves firewall and routing modifications. |

## Custom iptables rules

If you need to specify additional iptables rules to be run after the built-in iptables rules, you can use the file at `/iptables/post-rules.txt` with one iptables command per line and these will automatically be run on container start.
For example the `/iptables/post-rules.txt` file could contain:

```sh
iptables -A INPUT -i eth0 -s 0.0.0.0/0 -d 192.168.2.0/24 -p udp --sport 1197 -j ACCEPT
iptables -A INPUT -i eth0 -s 0.0.0.0/0 -d 192.168.2.0/24 -p tcp --sport 1197 -j ACCEPT
```
