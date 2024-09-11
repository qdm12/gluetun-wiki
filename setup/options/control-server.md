# Control server options

## Environment variables

💁 The following environment variables are all optional.

This is to configure the [HTTP Control server](../advanced/control-server.md).

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `HTTP_CONTROL_SERVER_ADDRESS` | `:8000` | Valid listening address | Listening address for the HTTP control server |
| `HTTP_CONTROL_SERVER_LOG` | `on` | `on` or `off` | Enable logging of HTTP requests |
| `HTTP_CONTROL_SERVER_AUTH_CONFIG_FILEPATH` | | Valid path | Path to a TOML file containing authentication configuration |
