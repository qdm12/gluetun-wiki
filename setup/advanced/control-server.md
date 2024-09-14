# Control server

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.httpcontrolserver)

The HTTP control server allows to obtain and modify the state of the container without restarting it.

⚠️ Make sure you trust whatever is accessing the control server, as it allows to access the settings,
including credentials, and modify the settings of Gluetun 'on-the-fly'.

## Setup

A built-in HTTP server listens on port `8000` to modify the state of the container.

To access it, simply publish this port for the container, for example: `-p 8000:8000/tcp`.

We assume every request described in the following is run on `http://<your-docker-host-ip>:8000` as base.

## Authentication

There is no global authentication built-in for the server in Gluetun. Instead:

1. Pick your favorite HTTP reverse proxy (Caddy, Caddy, Nginx, etc.)
1. Pick the authentication of your choice (Basic Auth, OAuth, etc.) using your reverse proxy.
    - You can usually pick an authentication per route, or globally.
    - You might want to have TLS (HTTPS) enabled, to not leak credentials in the network.

Per route token authentication may be added in the future, for local containers needing access to it.

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
