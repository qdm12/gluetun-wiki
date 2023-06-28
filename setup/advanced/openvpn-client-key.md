# OpenVPN client key

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.client-key)

🛑 These instructions are only for specific VPN providers, such as Cyberghost and VPN Unlimited. You should not read this if it not mentioned.

Your client key is usually of the form:

```pem
-----BEGIN PRIVATE KEY-----
...
...
-----END PRIVATE KEY-----
```

It may be given to you as a separate file or inlined in your Openvpn configuration file by your VPN service provider.

First, you need to take your key (from its start line `-----BEGIN PRIVATE KEY-----` to `-----END PRIVATE KEY-----`) and place it in a file on your host `/yourpath/gluetun/client.key`. Note `client.key` must be this exact name.

Then bind mount this gluetun directory in the container by running it with `-v /yourpath/gluetun:/gluetun`.

Alternatively, you can also place the base64 part in the environment variable `OPENVPN_KEY`, as a single line (so remove the new line characters).
