# Healthcheck

Gluetun monitors the VPN connection at different times, and comes with VPN auto-healing which restarts internally the VPN if the connection is detected to not be working.

This was designed and implemented because:

1. Containers connected to Gluetun lose connection once Gluetun is restarted
2. VPN connections tend to go down from time to time, for no precise reason 🤷

The monitoring "healthcheck" in Gluetun is not the same as the [Docker healthcheck](#docker-healthcheck), although a down connection is reported to the Docker healthcheck as well.

## Do not mix cause and effect ⚠️

When your VPN connection goes down, other warnings or errors will likely show before a healthcheck error message is logged, such as:

- `...: connection refused` as well as `...: operation not permitted`: the firewall blocks it because the VPN is not working.
- `...: i/o timeout` and `...: Client.Timeout awaiting for headers`: the VPN connection no longer works so things are timing out

All of the above are **NOT** causes, but **consequences** of the VPN not working.

## Possible log messages

There are multiple log messages which indicate the VPN connection is not working, before it gets restarted internally:

- **Startup check** failure: this happens when doing a TCP+TLS dial to the health target address at startup fails within 6 seconds. It essentially means your connection doesn't work right after establishing the VPN, and is usually fatal and won't recover.

  ```log
  WARN [vpn] restarting VPN because it failed to pass the healthcheck: startup check: dialing: dial tcp4: lookup cloudflare.com: i/o timeout
  ```

- **Small periodic check** failure: every minute after connection, a small check is performed, with 3 tries of 10s, 20s and 30s timeouts. This check is an ICMP echo (aka ping) to the health target address (defined by `HEALTH_ICMP_TARGET_IPS`) if ICMP is allowed, otherwise a plaintext UDP DNS query. If all these 3 tries fail, the VPN is considered down and is thus restarted internally.

  ```log
  WARN [vpn] restarting VPN because it failed to pass the healthcheck: periodic check: dialing: dial tcp4: lookup cloudflare.com: i/o timeout
  ```

- **Full periodic check** failure: every **5 minutes** after connection, a full check is performed, with 2 retries of 20s and 30s timeouts. This check is a TCP+TLS dial to the health target address (defined by `HEALTH_TARGET_ADDRESSES`). If the 2 tries fail, the VPN is considered down and is thus restarted internally.

  ```log
  WARN [vpn] restarting VPN because it failed to pass the healthcheck: periodic full check: dialing: dial tcp4

## Possible causes

⚠️ **DO NOT OPEN AN ISSUE** ⚠️ about this kind of problem because:

- it is almost always due to the VPN server or authentication servers misbehaving - I cannot do anything about it
- someone opens a similar issue every few days, and it's getting very repetitive.
- I need to focus on more important fixes/features/maintenance I can do something about.

### Startup check failure

If you see such log messages repeating, it means the VPN keeps on not working even after reconnecting. In this case, this usually means by order of likeliness:

1. The VPN server IP address you are trying to connect to is no longer valid 🔌 [**Update your server information**](../setup/servers.md#update-the-vpn-servers-list)
1. The VPN server crashed 💥, try changing your VPN servers filtering options such as `SERVER_REGIONS`
1. Maybe the Docker image you are running runs wrong, try [a previous tag](../setup/docker-image-tags.md) or the `latest` tag
1. Your host firewall is blocking outbound connections
1. Your Internet connection is not working 🤯, ensure it works
1. Lower your MTU with `WIREGUARD_MTU` or `OPENVPN_MSSFIX` (see [`--mssfix`](https://openvpn.net/community-resources/reference-manual-for-openvpn-2-6/)) environment variables

### Periodic check failure

If your VPN connection goes down from time to time, this is usually due to:

1. VPN server issues - try changing your VPN servers filtering options such as `SERVER_REGIONS`
1. Your bandwidth is so saturated that the healthcheck fails ⏱️
1. Your Internet connection was unstable for some time 🤯

## Health server

You can access the status of the health of Gluetun through an HTTP health server listening on the address specified by `HEALTH_SERVER_ADDRESS`, which defaults to `127.0.0.1:9999`.

## Docker healthcheck

The Docker healthcheck is defined in the [Dockerfile](https://github.com/qdm12/gluetun/blob/master/Dockerfile).

As of today (2022-03-30), it is:

```Dockerfile
HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=1 CMD /gluetun-entrypoint healthcheck
```

*Note*: this does not apply for example to Kubernetes, which does not run the healthcheck defined in the image by default.

This command executes the same Gluetun program in 'healthcheck mode', which is a quick and ephemeral operation.

It queries the health HTTP server of the long running instance of Gluetun (at `http://127.0.0.1:9999/`).
The response can either be:

- Status `200 OK` if Gluetun is healthy
- Status `500 Internal server error` together with an error message string, if Gluetun is unhealthy

The ephemeral Gluetun instance will then exit with code `0` if the long running instance is healthy, and with code `1` otherwise.

This healthcheck starts after 10 seconds, runs every 5 seconds, times out after 5 seconds, and fails after 1 failure.
This is as such to show the container as unhealthy as soon as possible.

You can change these values as well as the healthcheck command. For example:

- [Docker run healthcheck flags](https://docs.docker.com/engine/containers/run/#healthchecks)
- [Docker-compose healthcheck](https://github.com/docker/compose/blob/v1/docs/Compose%20file%20reference%20(legacy)/version-3.md#healthcheck)
