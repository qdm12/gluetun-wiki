# Control server

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.httpcontrolserver)

The HTTP control server allows to obtain and modify the state of the container without restarting it.

⚠️ If you use a release before v3.39.1, make sure you trust whatever is accessing the control server,
as it allows to access the settings, including credentials, and modify the settings of Gluetun 'on-the-fly'.

## Setup

A built-in HTTP server listens on port `8000` to modify the state of the container.

To access it, simply publish this port for the container, for example: `-p 8000:8000/tcp`.

We assume every request described in the following is run on `http://<your-docker-host-ip>:8000` as base.

## Authentication

⚠️ all routes will become private by default after the v3.40.0 release ⚠️

### Configuration

1. Create a file `/yourpath/config.toml` on your host, for example with the content:

    ```toml
    [[roles]]
    name = "qbittorrent"
    # Define a list of routes with the syntax "Http-Method /path"
    routes = ["GET /v1/openvpn/portforwarded"]
    # Define an authentication method with its parameters
    auth = "basic"
    username = "myusername"
    password = "mypassword"
    ```

    You can define multiple roles by adding more `[[roles]]`, and authentication methods are described in the section below.

1. Bind mount the file you created to `/gluetun/auth/config.toml`. This container path can be changed with `HTTP_CONTROL_SERVER_AUTH_CONFIG_FILEPATH` if needed.
1. Restart the container for the configuration file to take effect.

#### Authentication methods

- `none`: no authentication is required, and can be set with only

    ```toml
    auth = "none"
    ```

- `basic`: http basic authentication with a username and password, and can be set with

    ```toml
    auth = "basic"
    username = "myusername"
    password = "mypassword"
    ```

- `apikey`: the client sends the API key in the `X-API-Key` HTTP header, and can be set with

    ```toml
    auth = "apikey"
    apikey = "myapikey"
    ```

    You can generate an API key by running `docker run --rm qmcgaw/gluetun genkey` which will ouptut a 22 character [base 58](https://en.wikipedia.org/wiki/Binary-to-text_encoding#Encoding_standards) value which is suitable as an `apikey`.

### Default behavior

- Authentication configuration file specified: any server route not defined in the configuration will not be accessible.
- No authentication configuration file specified:
  - **new**, **existing+undocumented** and **existing+documented+sensitive** routes must be defined in the authentication configuration to be accessible.
  - **existing, documented and non-sensitive** routes (i.e. `GET /v1/openvpn/portforwarded`) are publicly accessibly **UNTIL after the v3.40.0 release ⚠️**

### Security over the Internet

If you expose the server over the Internet, make sure you use TLS to exchange data with the server ⚠️
You can do so for example by using an http reverse proxy such as Caddy.
If you don't, anyone between your client device and Gluetun can see the data exchanged, including credentials.

## OpenVPN and Wireguard

The HTTP control server allows to modify the state of OpenVPN and Wireguard.
The path are in the root `/v1/openvpn/` due to historical reasons, and will be migrated in the future.

- HTTP GET to `/v1/openvpn/status` to obtain the current status of Openvpn, such as `{"status":"running"}`
- HTTP PUT to `/v1/openvpn/status` with a body `{"status":"running"}` to start Openvpn (and stop Wireguard)
- HTTP PUT to `/v1/openvpn/status` with a body `{"status":"stopped"}` to stop Openvpn if it's running
- HTTP GET to `/v1/openvpn/portforwarded` to obtain the port forwarded such as `{"port":5914}`
- HTTP GET to `/v1/openvpn/settings` to obtain the settings used by Openvpn (not Wireguard) in a JSON format

## DNS

The HTTP control server allows to modify the state of Unbound, which is the subprocess responsible for DNS over TLS.

- HTTP GET to `/v1/dns/status` to obtain the current status of Unbound, such as `{"status":"running"}`
- HTTP PUT to `/v1/dns/status` with a body `{"status":"running"}` to start Unbound
- HTTP PUT to `/v1/dns/status` with a body `{"status":"stopped"}` to stop Unbound

## Updater

The updater can be triggered to update all the VPN server information while the container is running.

- HTTP GET to `/v1/updater/status` to obtain the current status of the updater, such as `{"status":"completed"}`
- HTTP PUT to `/v1/updater/status` with a body `{"status":"running"}` to start the updater job
- HTTP PUT to `/v1/updater/status` with a body `{"status":"stopped"}` to stop the updater job

## Public IP

You can obtain your current VPN public IP address by sending an HTTP GET request to `/v1/publicip/ip`.
The response will look like:

```json
{"public_ip":"58.98.64.104"}
```
