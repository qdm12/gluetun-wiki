# HTTP proxy options

## Environment variables

💁 The following environment variables are all optional.

| Variable | Default | Choices | Description |
| --- | --- | --- | --- |
| `HTTPPROXY` | `off` | `on`, `off` | Enable the internal HTTP proxy |
| `HTTPPROXY_LOG` | `off` | `on` or `off` | Logs every tunnel requests |
| `HTTPPROXY_LISTENING_ADDRESS` | `:8888` | A listening address | Internal listening address for the HTTP proxy |
| `HTTPPROXY_USER` | | | Username to use to connect to the HTTP proxy |
| `HTTPPROXY_PASSWORD` | | | Password to use to connect to the HTTP proxy |
| `HTTPPROXY_STEALTH` | `off` | `on` or `off` | Stealth mode means HTTP proxy headers are not added to your requests |
