# Connect a LAN device to Gluetun

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.connect-to-gluetun)

There are various ways to connect a device to Gluetun.

## HTTP proxy

This is useful for some clients such as Chrome, Firefox or Kodi.

⚠️ This is fine to use as long as you connect to Gluetun within your network. Your credentials and plaintext traffic (non HTTPS) are left unencrypted from your client device to gluetun. You might want to use Shadowsocks instead which tunnels UDP as well as TCP and encrypts your entire traffic.

1. Setup an HTTP proxy client, such as [SwitchyOmega for Chrome](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif?hl=en)
1. Ensure the Gluetun container is launched with:
    - the environment variable `-e HTTPPROXY=on`
    - the port `8888` published `-p 8888:8888/tcp`
1. With your HTTP proxy client, connect to the Docker host (i.e. `192.168.1.10`) on port `8888`. You need to enter your credentials if you set them with `HTTPPROXY_USER` and `HTTPPROXY_PASSWORD`. Note that Chrome does not support authentication.
1. If you set `HTTPPROXY_LOG` to `on`, more information will be logged in the Docker logs.

## Shadowsocks proxy

1. Setup a Shadowsocks proxy client, there is a list of [ShadowSocks clients for **all platforms**](https://shadowsocks.org/doc/getting-started.html#getting-started)
    - **note** some clients do not tunnel UDP so your DNS queries will be done locally and not through Gluetun and its built in DNS over TLS
    - Clients that support such UDP tunneling are, as far as I know:
        - iOS: Potatso Lite
        - OSX: ShadowsocksX
        - Android: Shadowsocks by Max Lv
1. Ensure the Gluetun container is launched with:
    - the environment variable `-e SHADOWSOCKS=on`
    - the port `8388` published for both tcp and udp `-p 8388:8388/tcp -p 8388:8388/udp`
1. With your Shadowsocks proxy client
    - Enter the Docker host (i.e. `192.168.1.10`) as the server IP
    - Enter port TCP (and UDP, if available) `8388` as the server port
    - Use the password you have set with `SHADOWSOCKS_PASSWORD`
    - Choose the encryption method/algorithm to the method you specified in `SHADOWSOCKS_CIPHER`
1. If you set `SHADOWSOCKS_LOG` to `on`, (a lot) more information will be logged in the Docker logs

## Access your LAN through Gluetun

You first need to set your LAN CIDR in `FIREWALL_OUTBOUND_SUBNETS`.
For example with `-e FIREWALL_OUTBOUND_SUBNETS=192.168.1.0/24`.

You can then use any of the proxy servers built-in Gluetun (such as Shadowsocks) to access your LAN.


## Access VPN from your LAN through Gluetun

If you need client to access VPN connection through Gluetun and this client is not connected to Gluetun contatiner (for example laptop or PC):

1. Create custom iptables rules file as described [here](https://github.com/qdm12/gluetun-wiki/blob/719e1a0bf7cc65391123f3f85427b8cde417c059/setup/options/firewall.md?plain=1#L7)

2. In iptables rule file (post-rules.txt) add appropriate settings which will make Gluetun to pass through traffic 
```sh
iptables -A FORWARD -i eth0 -o tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i tun0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth0 -o tun0 -s 192.168.0.0/24 -d 0.0.0.0/0 -j ACCEPT
iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
```
* 192.168.0.0/24 - you network, where client is stationed

3. Add appropriate mapping for Gluetun contatiner
```sh
   -v /yourpath/iptables/post-rules.txt:/iptables/post-rules.txt
```
```yml
   - /yourpath/iptables/post-rules.txt:/iptables/post-rules.txt
```

4. Now you can have Glutun container as a gateway. This step is related to appropriate network and router setup on your end.
