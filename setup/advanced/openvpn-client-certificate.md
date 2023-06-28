# OpenVPN client certificate

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.client-certificate)

🛑 These instructions are only for specific VPN providers, such as Cyberghost or VPN secure. You should not read this if it not mentioned.

Your client certificate is usually of the form:

```pem
-----BEGIN CERTIFICATE-----
...
...
-----END CERTIFICATE-----
```

It may be given to you as a separate file or inlined in your Openvpn configuration file by your VPN service provider.

💁 For VPN secure, it's usually in the file `yourusername.crt`.

First, you need to take your certificate (from its start line `-----BEGIN CERTIFICATE-----` to `-----END CERTIFICATE-----`) and place it in a file on your host `/yourpath/gluetun/client.crt`. Note `client.crt` must be this exact name.

Then bind mount this gluetun directory in the container by running it with `-v /yourpath/gluetun:/gluetun`.

Alternatively, you can also place the base64 part in the environment variable `OPENVPN_CERT`, as a single line (so remove the new line characters).
