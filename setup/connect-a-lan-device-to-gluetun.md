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

The HTTP proxy server will also work as a an [RFC 2817-compliant](https://www.rfc-editor.org/rfc/rfc2817#section-5.2) CONNECT proxy, meaning you can tunnel protocol to arbitrary destination ports through it, not just HTTP.

- A good example of this is using it in conjunction with netcat (`nc`) and the OpenSSH command line client's [ProxyCommand](https://man.openbsd.org/ssh_config#ProxyCommand) option:
  - `ssh -o 'ProxyCommand nc -X connect -x 192.168.1.10:8888 %h %p' ssh-server.example.org`
  - PuTTY can also [use CONNECT proxies](https://the.earth.li/~sgtatham/putty/0.80/htmldoc/Chapter4.html#config-proxy).
  
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
