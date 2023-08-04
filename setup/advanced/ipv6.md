# IPv6

⚠️ IPv6 is an experimental Docker feature, no thorough test was done to ensure there is no IP/DNS leak with Gluetun configured with IPv6. Feel free to create an issue or pull request if you have some testing done and can confirm.

## Setup

1. On your Docker host, edit and create if needed `/etc/docker/daemon.json` with the following JSON key-value pairs:

    ```json
    {
      "ipv6": true,
      "fixed-cidr-v6": "2001:db8:1::/64",
      "experimental": true,
      "ip6tables": true
    }
    ```

    ⚠️ Ensure to change the [documented address `2001:db8:1::/64`](https://en.wikipedia.org/wiki/Reserved_IP_addresses#IPv6) with a valid IPv6 network. The default IPv4 pools are from the private address range, the IPv6 equivalent would be ULA networks.

    [Reference: Docker documentation on IPv6](https://docs.docker.com/config/daemon/ipv6/#use-ipv6-for-the-default-bridge-network)
1. Restart the Docker daemon to reload its JSON configuration. Most Linux distributions use `sudo systemctl restart docker` to do this.
1. Edit your Gluetun `docker-compose.yml` and add the `sysctls` section and modify `WIREGUARD_ADDRESSES` to have both an IPv4 and an IPv6 address:

    ```yaml
    services:
      gluetun:
        # ...
        environment:
          WIREGUARD_ADDRESSES=xxx.xxx.xxx.xxx/32,fd7d:.............../128
        sysctls:
          - net.ipv6.conf.all.disable_ipv6=0
    ```

    Note if you only set an IPv6 Wireguard address, all IPv4 traffic won't go through which is undesirable.

1. Test your setup:
    1. Launch your docker-compose stack
    1. Run:

        ```sh
        sudo docker run --rm --network=container:gluetun alpine:3.18 sh -c "apk add curl && curl -6 --silent https://ipv6.ipleak.net/json/"
        ```

        And this should show the IPv6 address of the VPN server.
