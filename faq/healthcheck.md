# Healthcheck

## Unhealthy

You might see from time to time

```log
[healthcheck] unhealthy: cannot dial: dial tcp4 104.16.133.229:443: i/o timeout
```

This is meant to happen eventually and it's fine (sometimes just `cloudflare.com:443` doesn't answer)

If it keeps happening [for 6 seconds](#internal-healthcheck), the VPN is [auto-healed](#internal-auto-healing).
In this case, this usually means by order of likeliness:

1. The VPN server IP address you are trying to connect to is no longer valid 🔌 [Update your server information](../setup/servers.md#update-the-vpn-servers-list)
1. The VPN server crashed 💥, try changing your VPN servers filtering options such as `SERVER_REGIONS`
1. Your host firewall is blocking outbound connections
1. Your Internet connection is not working 🤯, ensure it works
1. Are you using Docker Desktop >= `v4.5.1`?? Then **downgrade** back to `v4.5.1`. See [@Miexil](https://github.com/Miexil)'s [comment](https://github.com/qdm12/gluetun/issues/1164#issuecomment-1319705224).
1. Something else ➡️ <https://github.com/qdm12/gluetun/issues/new/choose>

## Internal healthcheck

The internal healthcheck runs from the start of the program, and cannot be disabled.
It TCP dials the address specified by `HEALTH_TARGET_ADDRESS`, which defaults to `cloudflare.com:443`.
The TCP dialing is a small operation which barely exchanges any data, and has a timeout of 3 seconds.

This internal healthcheck runs on different periods:

- if the previous check failed, it runs again after 1 second.
- if the previous check succeeded, it runs again after 5 seconds.

This healthcheck keeps a state of the health status which is accessible through an HTTP health server listening on the address specified by `HEALTH_SERVER_ADDRESS`, which defaults to `127.0.0.1:9999`.

## Internal auto-healing

There is an auto-healing feature to restart the VPN client without restarting the container.

This was designed and implemented because:

1. Containers connected to Gluetun lose connection once Gluetun is restarted
2. OpenVPN tend to lose connection from time to time, for no precise reason

This auto-healing uses the internal healthcheck together with a timer to monitor when to trigger a restart.

- At program start, it waits 6 seconds, which can be altered with `HEALTH_VPN_DURATION_INITIAL`
- After a successful [internal healthcheck](#internal-healthcheck), it would wait 6 seconds of failed healthchecks before restarting the VPN client
- After a restart of the VPN client, the timeout is increased from 6 seconds to 6+5 seconds, to increase the time allowed for the VPN to setup and reduce log spamming. Each next failure will increase the timeout by 5 seconds. This time increment  can be altered with `HEALTH_VPN_DURATION_ADDITION`

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

The healthcheck starts after 10 seconds, runs every 5 seconds, times out after 5 seconds, and fails after 1 failure.
This is as such to show the container as unhealthy as soon as possible.

You can change these values as well as the healthcheck command. For example:

- [Docker run healthcheck flags](https://docs.docker.com/engine/reference/run/#healthcheck)
- [Docker-compose healthcheck](https://docs.docker.com/compose/compose-file/compose-file-v3/#healthcheck)
