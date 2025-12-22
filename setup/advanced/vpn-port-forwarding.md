# VPN server port forwarding

💁 Each VPN service provider supporting port forwarding have their own section on their own page on how to set it up.

🔴 This is **NOT** about [Docker port mapping](../port-mapping.md)

## Native integrations

VPN server side port forwarding is implemented natively into Gluetun for the following providers:

- **Private Internet Access**, [more information](../providers/private-internet-access.md)
- **ProtonVPN**, [more information](../providers/protonvpn.md)
- **Perfect Privacy**, [more information](../providers/perfect-privacy.md)
- **PrivateVPN**, [more information](../providers/privatevpn.md)

You can enable it with `VPN_PORT_FORWARDING=on`.
The forwarded port can be accessed:

- through the [control server](control-server.md#openvpn-and-wireguard)
- through the file written at `/tmp/gluetun/forwarded_port` (will be deprecated in v4.0.0 release)
- by running a user specified command upon port forwarding starting (see below)

## Custom port forwarding up/down command

A command can be set with:

- `VPN_PORT_FORWARDING_UP_COMMAND` to run when port forwarding has finished setting up
- `VPN_PORT_FORWARDING_DOWN_COMMAND` to run when port forwarding has finished tearing down

For example `VPN_PORT_FORWARDING_UP_COMMAND=/bin/sh -c "echo My forwarded ports are {{PORTS}}, the first forwarded port is {{PORT}} and the VPN network interface is {{VPN_INTERFACE}}"`.

Notes:

- This example command above lists all possible template variables:
  - `{{PORTS}}` is replaced by a comma separated list of the ports that have been forwarded, for example `1234,5678`
  - `{{PORT}}` is replaced by the first port that has been forwarded, for example `1234`
  - `{{VPN_INTERFACE}}` is replaced by the VPN network interface name, by default it's always `tun0`
- shell specific syntax such as `&&` is not understood in the command, and one should use `/bin/sh -c "my shell syntax"` to do so if they want.
- one can bind mount a shell script in Gluetun and execute it with for example `VPN_PORT_FORWARDING_UP_COMMAND=/bin/sh -c /gluetun/myscript.sh` - 💁  feel free to propose a pull request to add commonly used shell scripts for port forwarding!
- the output of the command is written to the port forwarding logger within Gluetun

### qBittorrent example

`VPN_PORT_FORWARDING_UP_COMMAND=/bin/sh -c 'wget -O- --retry-connrefused --post-data "json={\"listen_port\":{{PORT}},\"current_network_interface\":\"{{VPN_INTERFACE}}\",\"random_port\":false,\"upnp\":false}" http://127.0.0.1:8080/api/v2/app/setPreferences 2>&1'`
`VPN_PORT_FORWARDING_DOWN_COMMAND=/bin/sh -c 'wget -O- --retry-connrefused --post-data "json={\"listen_port\":0,\"current_network_interface\":\"lo\"}" http://127.0.0.1:8080/api/v2/app/setPreferences 2>&1'`

For this to work, the qBittorrent web UI server must be enabled and listening on port `8080` and the Web UI "Bypass authentication for clients on localhost" must be ticked (json key `bypass_local_auth`) so Gluetun can reach qBittorrent without authentication.
Due to a bug in qBittorrent, for port forwarding to be reestablished after a disconnect, the port needs to be re-set. This can be achieved automatically using the DOWN_COMMAND above.

Thanks to [@Marsu31](https://github.com/Marsu31)

## Allow a forwarded port through the firewall

For non-native integrations where you have a designated forwarded port from your VPN provider, you can allow it by adding it to the environment variable `FIREWALL_VPN_INPUT_PORTS`.

## Port redirection using iptables

Gluetun supports setting up a redirection of incoming traffic from the VPN opened port to a custom localhost port of your choosing, by using the `VPN_PORT_FORWARDING_LISTENING_PORT` environment variable. Do not use this with torrent clients, or any other software that publicly announces its port, as that software would not be aware of the publicly visible port and would be announcing the private port instead.

For example, if you have a web server (nginx, caddy, apache) listening on port 80, you can set `VPN_PORT_FORWARDING_LISTENING_PORT=80` to expose it to the outside world on all available VPN server's public ports.

## Test it

Assuming:

- your gluetun container name is `gluetun`
- your VPN public IP address is `99.99.99.99`
- your VPN port forwarded is `4567`

You can test it with:

```sh
docker exec -it gluetun /bin/sh
# Change amd64 to your CPU architecture
wget -qO port-checker https://github.com/qdm12/port-checker/releases/download/v0.4.0/port-checker_0.4.0_linux_amd64
chmod +x port-checker
./port-checker --listening-address=":4567"
```

Then in your browser, access [http://99.99.99.99:4567](http://99.99.99.99:4567).

It should show you your browser IP address and user agent.
You should also see the request logged in the port-checker output.

Finally, back to the terminal, press `CTRL+C` to stop port-checker and enter `exit` to quit the interactive shell in `gluetun`.
