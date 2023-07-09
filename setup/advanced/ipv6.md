# IPv6

**Warning**: IPv6 is an experimental feature in docker, I haven't done a through test to make sure there is no IP/DNS leaking in "IPv6 + Gluetun" configuration.

---

## Setup

1. On docker host, edit `/etc/docker/daemon.json` (If file doesn't exist, create the file), fill the file with following texts

  ```json
  {
    "ipv6": true,
    "fixed-cidr-v6": "fd00::/80",
    "experimental": true,
    "ip6tables": true
  }
  ```

  reference: <https://docs.docker.com/config/daemon/ipv6/#use-ipv6-for-the-default-bridge-network>, IP range change to unique local address following the note at button of the documentation.

2. Restart docker service (`sudo systemctl restart docker` or it's equivalent in your distro)

3. Edit docker-compose.yml file, **add "sysctls" section** and **modify WIREGUARD_ADDRESSES to have both IPv4 and IPv6 address**, so it becomes:

  ```yaml
  services:
    gluetun:
      image: qmcgaw/gluetun
      cap_add:
        ........
      environment:
        ........
      ports:
        .......
      sysctls:
        - net.ipv6.conf.all.disable_ipv6=0
  ```

  reference: <https://github.com/dperson/openvpn-client/issues/75#issuecomment-326843622>, If you don't add sysctls section you will encounter a problem.

4. After you run your docker compose file, run `sudo docker run --rm --network=container:ipv6-gluetun-1 alpine:3.18 sh -c "apk add curl && curl -6 --silent https://api64.ipify.org/"`  
This command should show a IPv6 address that belongs your VPN service, **MAKE SURE it's not your own IPv6 address**!  
If you ping the address you see a high latency, you are probably good.  
I would recommend checking <https://ipleak.net/>, put in the IP address and search, see which country the IP belongs to.

---

## Example docker compose file

```yaml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    cap_add:
      - NET_ADMIN
    environment:
      - VPN_SERVICE_PROVIDER=airvpn
      - VPN_TYPE=wireguard
      - WIREGUARD_PRIVATE_KEY=<insert WIREGUARD_PRIVATE_KEY>
      - WIREGUARD_PRESHARED_KEY=<insert WIREGUARD_PRESHARED_KEY>
      - WIREGUARD_ADDRESSES=xxx.xxx.xxx.xxx/32,fd7d:.............../128
      - SERVER_COUNTRIES=<country>
    sysctls:
      - net.ipv6.conf.all.disable_ipv6=0
```
