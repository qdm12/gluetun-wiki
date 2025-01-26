# VPN servers

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.servers.updating)

## List of VPN servers

To list the VPN servers available for a particular VPN provider using your current Gluetun version, use:

```sh
docker run --rm -v /yourpath:/gluetun qmcgaw/gluetun format-servers -yourprovider
```

where:

- `/yourpath` is the path to your bind mounted directory
- `yourprovider` is your VPN provider in lowercase without quotes, for example `protonvpn` or `private-internet-access`.

This will list the servers in Markdown format, for example:

```markdown
| Country | City | Hostname | TCP | UDP |
| --- | --- | --- | --- | --- |
| Albania |  | `albania-ca-version-2.expressnetw.com` | ❌ | ✅ |
...
| Vietnam |  | `vietnam-ca-version-2.expressnetw.com` | ❌ | ✅ |
```

This is useful to know what are the currently available server filter options which can be used.

For certain providers such as NordVPN, the list of servers is very long and you can use the `--output=/gluetun/servers-list.md` flag to write to a file.

## Update the VPN servers list

The VPN servers list used by Gluetun is the merged list from:

- [the built-in Gluetun servers list](https://raw.githubusercontent.com/qdm12/gluetun/master/internal/storage/servers.json)
- your locally bind mounted `/gluetun/servers.json` file, which reflects the built-in servers list by default

The built-in servers list can become outdated.
You can update **your** servers list `/gluetun/servers.json`, using the built-in update mechanisms.

### Update periodically

By default this is disabled.

You can set the environment variable `UPDATER_PERIOD` to `24h` for example. Every 24 hours, after the tunnel is ready, the container will update the servers information for the currently in-use VPN service provider. This has this advantage the update is done through the VPN and using DNS over TLS.

This periodic update can be extended to update data for other providers by setting them as a comma separated value in the environment variable `UPDATER_VPN_SERVICE_PROVIDERS`.

[🚨 Report a servers update bug](https://github.com/qdm12/gluetun/issues/new?labels=%3Abug%3A+bug&template=bug.yml&title=Bug%3A+)

### Update using the command line

💁 This technique is useful in case all the built-in servers data is now outdated, and you can no longer connect to any VPN server. Otherwise you should prefer using the [periodic update](#update-periodically).

⚠️ This will show your ISP/Government/Sniffing actors that you access some VPN service providers and, depending on the VPN provider you use, try to resolve their server hostnames.
That might not be the best solution depending on your location. Plus some of the requests might be blocked, hence not allowing certain server information to be updated.

The command is of the form:

```sh
docker run --rm -v /yourpath:/gluetun qmcgaw/gluetun update -enduser -providers yourprovider
```

where:

- `/yourpath` is the path to your bind mounted directory
- `yourprovider` is your VPN provider, for example `protonvpn`.

You can also run this with `docker-compose` using:

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    # ...
    volumes:
      /yourpath:/gluetun
    command: update -enduser -providers mullvad
```

[🚨 Report a servers update bug](https://github.com/qdm12/gluetun/issues/new?labels=%3Abug%3A+bug&template=bug.yml&title=Bug%3A+)
