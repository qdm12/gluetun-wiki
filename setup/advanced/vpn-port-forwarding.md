# VPN server port forwarding

💁 Each VPN service provider supporting port forwarding have their own section on their own page on how to set it up.

🔴 This is **NOT** about [Docker port mapping](../port-mapping.md)

## Native integrations

VPN server side port forwarding is implemented natively into Gluetun for the following providers:

- **Private Internet Access**, [more information](../providers/private-internet-access.md)
- **ProtonVPN**, [more information](../providers/protonvpn.md)

You can enable it with `VPN_PORT_FORWARDING=on`.
The forwarded port can be accessed:

- through the [control server](control-server.md#openvpn-and-wireguard)
- through the file written at `/tmp/gluetun/forwarded_port` (will be deprecated in v4.0.0 release)
- by running a user specified command upon port forwarding starting (see below)

## Custom port forwarding up/down command

A command can be set with:

- `VPN_PORT_FORWARDING_UP_COMMAND` to run when port forwarding has finished setting up
- `VPN_PORT_FORWARDING_DOWN_COMMAND` to run when port forwarding has finished tearing down

For example `VPN_PORT_FORWARDING_UP_COMMAND=/bin/sh -c "echo {{PORTS}}"`.

Notes:

- The special string `{{PORTS}}` is replaced by a comma separated list of the ports that have been forwarded. For example `/bin/sh -c "echo {{PORTS}}"` would become `/bin/sh -c "echo 5678,9876"`
- shell specific syntax such as `&&` is not understood in the command, and one should use `/bin/sh -c "my shell syntax"` to do so if they want.
- one can bind mount a shell script in Gluetun and execute it with for example `VPN_PORT_FORWARDING_UP_COMMAND=/bin/sh -c /gluetun/myscript.sh` - 💁  feel free to propose a pull request to add commonly used shell scripts for port forwarding!
- the output of the command is written to the port forwarding logger within Gluetun

### qBittorrent examples

#### with authentication

##### compose.yml
```yaml
services:
  pf-gluetun:
    image: qmcgaw/gluetun
    environment:
      QBIT_ADDRESS: http://localhost:8080
      QBIT_USERNAME: yourusername
      QBIT_PASSWORD: yourpassword
      VPN_PORT_FORWARDING_UP_COMMAND: /bin/sh -c 'sh /gluetun/update-port.sh "{{PORTS}}"'
      ...
    volumes:
      - ./gluetun/update-port.sh:/gluetun/update-port.sh
    ...
```

##### update-port.sh
```sh
#!/bin/sh
set -e

port="$1"

echo "Logging in to qBittorrent as $QBIT_USERNAME..."

wget --quiet --save-cookies=/tmp/cookies.txt --keep-session-cookies \
     --post-data="username=$QBIT_USERNAME&password=$QBIT_PASSWORD" \
     --header="Referer: $QBIT_ADDRESS" \
     "$QBIT_ADDRESS/api/v2/auth/login" -O /tmp/login_response.txt

login_response=$(cat /tmp/login_response.txt)

if [ "$login_response" != "Ok." ]; then
  echo "Error: Login failed. Response: $login_response"
  exit 1
fi

echo "Login successful. Session cookie saved."
echo "Updating QBittorrent port to $port..."

wget --quiet --load-cookies=/tmp/cookies.txt \
     --post-data="json={\"listen_port\": $port}" \
     "$QBIT_ADDRESS/api/v2/app/setPreferences" -O /tmp/set_preferences_response.txt

if grep -q "403 Forbidden" /tmp/set_preferences_response.txt; then
  echo "Error: Setting port failed. Unauthorized (403 Forbidden)."
  exit 1
fi

echo "qBittorrent port updated successfully."
```

#### without authentication

`VPN_PORT_FORWARDING_UP_COMMAND=/bin/sh -c 'wget -O- --retry-connrefused --post-data "json={\"listen_port\":{{PORTS}}}" http://127.0.0.1:8080/api/v2/app/setPreferences 2>&1'`

For this to work, the qBittorrent web UI server must be enabled and listening on port `8080` and the Web UI "Bypass authentication for clients on localhost" must be ticked (json key `bypass_local_auth`) so Gluetun can reach qBittorrent without authentication.

Thanks to [@Marsu31](https://github.com/Marsu31)

## Allow a forwarded port through the firewall

For non-native integrations where you have a designated forwarded port from your VPN provider, you can allow it by adding it to the environment variable `FIREWALL_VPN_INPUT_PORTS`.

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
