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

([Alternative guide on Reddit](https://www.reddit.com/r/gluetun/comments/1ozqhax/howto_the_mysterious_configtoml_file_and_gluetuns/))

### Configuration

For the *lazies* not willing to setup a configuration file, you can set the environment variable `HTTP_CONTROL_SERVER_AUTH_DEFAULT_ROLE` to a JSON string defining the default role to use for all routes not covered in the auth  configuration file. For example:

- `HTTP_CONTROL_SERVER_AUTH_DEFAULT_ROLE='{"auth":"basic","username":"myusername","password":"mypassword"}'`
- `HTTP_CONTROL_SERVER_AUTH_DEFAULT_ROLE='{"auth":"apikey","apikey":"myapikey"}'`
- `HTTP_CONTROL_SERVER_AUTH_DEFAULT_ROLE='{"auth":"none"}'` to have no authentication. **Highly discouraged!**

For the less lazy users, you can do the following, on top of the above as well:

1. Create a file `/yourpath/config.toml` on your host, for example with the content:

    ```toml
    [[roles]]
    name = "qbittorrent"
    # Define a list of routes with the syntax "Http-Method /path"
    routes = ["GET /v1/portforward"]
    # Define an authentication method with its parameters
    auth = "basic"
    username = "myusername"
    password = "mypassword"

    [[roles]]
    name = "something"
    routes = ["GET /v1/publicip/ip", "PUT /v1/vpn/status"]
    auth = "none"
    ```

    See more details on authentication methods in the section below.
    Note the `name` field is only for logs and has no other functional purpose.

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

- Authentication configuration file or `HTTP_CONTROL_SERVER_AUTH_DEFAULT_ROLE` specified: any server route not defined in the configuration will not be accessible.
- No authentication configuration file and no `HTTP_CONTROL_SERVER_AUTH_DEFAULT_ROLE` specified:
  - **new**, **existing+undocumented** and **existing+documented+sensitive** routes must be defined in the authentication configuration to be accessible.
  - **existing, documented and non-sensitive** routes (i.e. `GET /v1/portforward`) are publicly accessibly **UNTIL after the v3.40.0 release ⚠️**

### Security over the Internet

If you expose the server over the Internet, make sure you use TLS to exchange data with the server ⚠️
You can do so for example by using an http reverse proxy such as Caddy.
If you don't, anyone between your client device and Gluetun can see the data exchanged, including credentials.

## OpenVPN and Wireguard

The HTTP control server allows to modify the state of OpenVPN or Wireguard.

- HTTP GET to `/v1/vpn/status` to obtain the current status of the VPN, such as `{"status":"running"}`
- HTTP PUT to `/v1/vpn/status` with a body `{"status":"running"}` or `{"status":"stopped"}` to respectively start or stop the VPN
- HTTP GET to `/v1/vpn/settings` to obtain the settings used by the VPN in a JSON format

## Port forwarding

- HTTP GET to `/v1/portforward` to obtain the port forwarded such as `{"port":5914}`

## DNS

The HTTP control server allows to modify the state of the DNS server, which is responsible for DNS over TLS/HTTPS.

- HTTP GET to `/v1/dns/status` to obtain the current status of the DNS server, such as `{"status":"running"}`
- HTTP PUT to `/v1/dns/status` with a body `{"status":"running"}` to start the DNS server
- HTTP PUT to `/v1/dns/status` with a body `{"status":"stopped"}` to stop the DNS server

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
