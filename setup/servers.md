# VPN servers

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.servers.updating)

## List of VPN servers

To list the VPN servers available for a particular VPN provider using your current Gluetun version, use:

```sh
docker run --rm -v /yourpath:/gluetun qmcgaw/gluetun format-servers -yourprovider
```

where:

- `/yourpath` is the path to your bind mounted directory
- `-yourprovider` is your VPN provider in lowercase without quotes, for example `-protonvpn` or `-private-internet-access`.

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

- [the built-in Gluetun servers list](https://github.com/qdm12/gluetun-servers/tree/main/pkg/servers) ([release tag](https://github.com/qdm12/gluetun-servers/releases) matching the `github.com/qdm12/gluetun-servers` version defined in [go.mod](https://github.com/passteque/gluetun/blob/master/go.mod))
- your locally bind mounted `/gluetun/servers/` json files, which reflects the built-in servers list by default

The built-in servers list can become outdated.
You can update **your** servers list directory `/gluetun/servers`, using the built-in update mechanisms.

### Update periodically

By default this is disabled. I highly recommend setting this to NO LESS than 360h (15 days) to avoid spamming the VPN providers with requests, which might end up leading the updating mechanism to be blocked by the VPN providers.

You can set the environment variable `UPDATER_PERIOD` to `480h` for example. Every 480 hours, after the tunnel is ready, the container will update the servers information for the currently in-use VPN service provider. This has this advantage the update is done through the VPN and using DNS over HTTPS.

This periodic update can be extended to update data for other providers by setting them as a comma separated value in the environment variable `UPDATER_VPN_SERVICE_PROVIDERS`.

[🚨 Report a servers update bug](https://github.com/qdm12/gluetun/issues/new?labels=%3Abug%3A+bug&template=bug.yml&title=Bug%3A+)

### Update using the command line

💁 This technique is useful in case all the built-in servers data is now outdated, and you can no longer connect to any VPN server. Otherwise you should prefer using the [periodic update](#update-periodically).

⚠️ This will show Cloudflare and/or Google DNS over HTTPS servers that you (with your public IP address) are resolving VPN server hostnames.

The command is of the form:

```sh
docker run --rm -v /yourpath:/gluetun qmcgaw/gluetun update -providers yourprovider
```

where:

- `/yourpath` is the path to your bind mounted directory
- `yourprovider` is your VPN provider, for example `protonvpn`.

💁 For ProtonVPN, you must set `-proton-email` and `-proton-password` with some Proton credentials.
If you need paid servers data, you need paid credentials. Otherwise you can use a throwaway free account for this.

You can also run this with `docker-compose` using:

```yml
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    # ...
    volumes:
      /yourpath:/gluetun
    command: update -providers mullvad
```

[🚨 Report a servers update bug](https://github.com/qdm12/gluetun/issues/new?labels=%3Abug%3A+bug&template=bug.yml&title=Bug%3A+)

## Use a third party tool to update your servers list

If you want to use a third party tool (**at your own risk**) to update your servers list, you can set in your `/gluetun/servers/yourprovider.json` file the field `"preferred": true` at the top level, which will make Gluetun use that file no matter what data it has built-in, **except** if versions are mismatching, which is a rare change.

You can also change the file path to your json file in `/gluetun/servers/manifest.json` if you feel like it.
