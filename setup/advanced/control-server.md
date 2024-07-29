# Control server

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.httpcontrolserver)

The HTTP control server allows to obtain and modify the state of the container without restarting it.

## Setup

A built-in HTTP server listens on port `8000` to modify the state of the container.

To access it, simply publish this port for the container, for example: `-p 8000:8000/tcp`.

We assume every request described in the following is run on `http://<your-docker-host-ip>:8000` as base.

## OpenVPN and Wireguard

The HTTP control server allows to modify the state of OpenVPN and Wireguard.
The path are in the root `/v1/openvpn/` due to historical reasons, and will be migrated in the future.

- HTTP GET to `/v1/openvpn/status` to obtain the current status of Openvpn/Wireguard, such as `{"status":"running"}`
- HTTP PUT to `/v1/openvpn/status` with a body `{"status":"running"}` to start Openvpn/Wireguard
- HTTP PUT to `/v1/openvpn/status` with a body `{"status":"stopped"}` to stop Openvpn/Wireguard
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
