# Add a provider

## Gather information

You should gather information about the provider you want to add and add it in the corresponding Github issue.

In particular, you should have:

1. How to obtain server information from the provider: API url, zip url, HTML page, etc.?
2. Does it support OpenVPN? If yes:
    1. Does it support UDP? If yes, attach a configuration file for UDP (remove credentials)
    2. Does it support TCP? If yes, attach a configuration file for TCP (remove credentials)
    3. What are the user specific parts: username, password, private key, encryted private key, certificate?
3. Does it support Wireguard? If yes:
    1. The interface `PrivateKey` and `Address`, as well as an eventual `PreSharedKey`, are different for each server: the user should use the `custom` provider, do not implement anything for Wireguard
    1. The interface `PrivateKey` and `Address`, as well as an eventual `PreSharedKey`, are the same for all servers:
        1. All the servers public keys are the same public key: precise the public key
        2. All the servers public keys can be obtained (API url, zip url, etc.), precise the way to get them
        3. Servers public keys cannot be obtained or are user specific: the user should use the `custom` provider, do not implement anything for Wireguard

You need to know the following:

## Registration

1. Define a constant with your provider name in `internal/constants/providers/providers.go`:

    ```go
    const (
      // Custom is the VPN provider name for custom
      // VPN configurations.
      Custom                = "custom"
      // ...
      YourProvider          = "yourprovider"
      // ...
    )
    ```

    The string constant should be all lowercase without spacings or underscores.
    Please make sure it is inserted in alphabetical order.
1. Add the constant previously defined to the `All()` function in `internal/constants/providers/providers.go`:

    ```go
    // All returns all the providers except the custom provider.
    func All() []string {
     return []string{
        // ...
        YourProvider,
        // ...
      }
    }
    ```

    Please make sure it is inserted in alphabetical order.
1. Copy the provider example directory `internal/provider/example` to `internal/provider/<provider-name>`.
1. Rename the `package example` to `package yourprovider` from all the Go files in this newly copied directory.
1. Update the `Provider`'s `Name() string` method to return `providers.YourProvider` instead of `providers.Example`.
1. Update the import path in `internal/provider/yourprovider/provider.go` from `github.com/qdm12/gluetun/internal/provider/example/updater` to `github.com/qdm12/gluetun/internal/provider/yourprovider/updater`.
1. Register the provider code you added in the `NewProviders` function located in `internal/provider/providers.go`:

    ```go
    providerNameToProvider := map[string]Provider{
      // ...
      providers.YourProvider:   yourprovider.New(storage, randSource, client, unzipper, updaterWarner, parallelResolver),
      // ...
    }
    ```

    Please insert this entry in the map in alphabetical order.

## Updater code

⚠️ This is the hardest part ⚠️

First, add `"yourprovider": {"version": 1},` to the list of providers in `internal/storage/servers.json`.

You need to adapt the example code in the `internal/provider/yourprovider/updater` Go package such that it can fetch and update VPN servers.

There are several `// TODO` comments in the code to highlight what needs to be done, and with examples.

You should start by reading the `FetchServers` method defined in the `servers.go` file, it contains important information in the form of comments.

The base example code fetches servers information from a (fake) web HTTP API endpoint, and then parallel resolves hostnames to IP addresses.
You have to modify this to fetch servers information for your specific provider.

Once you are done, update the servers data in `internal/storage/servers.json` with:

```sh
go run ./cmd/gluetun/main.go update -maintainer -providers yourprovider
```

💁 Make sure to check the result in `internal/storage/servers.json`. This might point you to some issues in your servers data update code written in `internal/provider/yourprovider/updater`.

## Provider code

This concerns Go files in the package `internal/provider/yourprovider`.

You should check out each of the `// TODO` comments in the code to see what needs to be done,
and remove them as you go. Notably, you should:

- Modify in `connection.go` the default ports for each protocol combination:

    ```go
    defaults := utils.NewConnectionDefaults(443, 1194, 51820)
    ```

    where the first one is for OpenVPN TCP, the second for OpenVPN UDP and the last for Wireguard (UDP).

- Modify the fields of the provider settings in `openvpnconf.go`:

    ```go
    providerSettings := utils.OpenVPNProviderSettings{
      // ...
    }
    ```

    to match the 'common' settings from their Openvpn configuration files.
    Note several server-specific OpenVPN options come from the server information in `internal/storage/servers.json`.
    Some are also automatically set for example if `VPN_INTERFACE=tun`.

## Settings validation

Gluetun is designed to have strict settings validation in order to fail early if an incorrect setting is provided by the user.

You should thus aim at having settings as restrictive as possible for the new provider.
For example, if the provider does not support OpenVPN TCP, the settings validation should catch that as an error.

Settings are defined in the `internal/configuration/settings` package, where each Go file contains a settings structure with a `Validate() (err error)` method.

In our OpenVPN-TCP unsupported example mentioned above, you should then modify the `Validate` method from `internal/configuration/settings/openvpnselection.go` and add the new provider to the list of unsupported providers in:

```go
// Validate TCP
if *o.TCP && helpers.IsOneOf(vpnProvider,
  providers.Ipvanish,
  providers.Perfectprivacy,
  providers.Privado,
  providers.VPNUnlimited,
  providers.Vyprvpn,
) {
  return fmt.Errorf("%w: for VPN service provider %s",
    ErrOpenVPNTCPNotSupported, vpnProvider)
}
```

## Markdown servers table formatting

This is needed to easily generate a Markdown table of all the servers information for the provider, which in turn is used in the Github Wiki.

Register the new provider in `internal/models/markdown.go`:

```go
func getMarkdownHeaders(vpnProvider string) (headers []string) {
  switch vpnProvider {
  // ...
  case providers.YourProvider:
    return []string{countryHeader, cityHeader, ispHeader, hostnameHeader, vpnHeader, tcpHeader, udpHeader}
  // ...
  }
}
```

Depending on what fields each provider server has (i.e. country, region, etc.), you should adapt the list of headers above.

In case you add a field to the `Server` model, you should then add a constant header in `internal/models/markdown.go`:

```go
const (
 cityHeader        = "City"
 // ...
 newHeader         = "new header"
 // ...
 vpnHeader         = "VPN"
)
```

And then add it to the `switch` in the method `ToMarkdown(headers ...string) (markdown string)`:

```go
  switch header {
  case cityHeader:
    fields[i] = s.City
    // ...
  case newHeader:
    fields[i] = s.NewField
    // ...
  }
```

## Github documentation

- Add the provider name to the list of VPN service provider in `.github/ISSUE_TEMPLATE/bug.yml`:

    ```yml
    - type: dropdown
      id: vpn-service-provider
      attributes:
        label: VPN service provider
        options:
          - Custom
          - Cyberghost
          # ...
          - YourProvider
          # ...
    ```

    Please make sure it's inserted in the right alphabetical place in the list.
- Add the provider name to the list of VPN service provider in `.github/labels.yml`:

    ```yml
    # VPN providers
    - name: ":cloud: Cyberghost"
      color: "cfe8d4"
      description: ""
    # ...
    - name: ":cloud: YourProvider"
      color: "cfe8d4"
      description: ""
    # ...
    ```

    Please make sure it's inserted in the right alphabetical place in the list.

- Add the provider name to service providers enumeration in the `README.md`:

    ```md
    - Supports: **Cyberghost**, ..., **NewProviderName**, ..., **Windscribe** servers
    ```

## Final steps

Don't forget to open a pull request so your changes get merged in the base repository 😉 See the [Development page Final steps section](development.md#final-steps).

## Optional

These optional additions are code changes that may or may not be needed.

### Add a user provided setting

You may need a new user-provided setting that is not already built in Gluetun.

The settings are processed in the following order:

1. Each setting value is read from the following sources order: secret files, plain files and environment variables. The first source containing a non empty setting value is used and other sources are skipped. This is done in the `internal/configuration/settings` directory, using the [qdm12/gosettings library](https://github.com/qdm12/gosettings). The files source is in `internal/configuration/srouces/files` and the secrets source is in `internal/configuration/sources/secrets`. The environment variables source is built-in qdm12/gosettings already.
1. Set the default values for any still unset setting values, using `setDefaults` methods in the `internal/configuration/settings` package.
1. Validate the settings. This is done with `validate` methods defined in the `internal/configuration/settings` package.

To add a setting, you need to do several code changes:

1. Add a field to one of the settings structures in the `internal/configuration/settings` package.
1. Add necessary code for the new field in the settings struct methods: `read`, `copy`, `overrideWith`, `setDefaults`, `toLinesNode` and `validate`
1. You may have to modify one or more sources in `internal/configuration/sources/` to return some settings values, if needed. Gluetun reads most settings from environment variables only, so feel free to limit the reading to environment variables.

⚠️ If you add an environment variable, add it as its default value in the `Dockerfile` in the `ENV` section:

```Dockerfile
ENV VPN_SERVICE_PROVIDER=pia \
    # ...
    NEW_VARIABLE_NAME= \
    # ...
```

### Add a field to the server model

The server model `Server` defined in `internal/models/server.go` is shared for all providers. You can add a field to it if needed for the new provider. If you do so, you would have to modify code in different places:

- add an if condition in the `filterServer` function defined in `internal/provider/utils/filtering.go` to filter servers with that new field
- add a test case in the `Test_FilterServers` function in `internal/provider/utils/filtering_test.go` to test cover that new code path you added
- add an if condition to the `noServerFoundError` function in `internal/storage/formatting.go` to add a part to `messageParts` if the field is set
- add code in `internal/models/markdown.go`, see the [Markdown servers table formatting](#markdown-servers-table-formatting) section

### Add an OpenVPN option

If you need an extra OpenVPN option in the generated OpenVPN configuration file, you can define it in the `OpenVPNConfig` function in `internal/provider/utils/openvpn.go`.

For example to add the `tun-mtu` option, you can add:

```go
if provider.TunMTU > 0 {
  lines.add("tun-mtu", fmt.Sprint(provider.TunMTU))
}
```

## Final words

If you reached the end of this document, first of all, congratulations!! 🎉 🎖️ 🏅 🥇

- If anything is missing, please [create a Wiki issue](https://github.com/qdm12/gluetun/issues/new/choose).
- If you have any question, please [create a discussion](https://github.com/qdm12/gluetun/discussions/new).
