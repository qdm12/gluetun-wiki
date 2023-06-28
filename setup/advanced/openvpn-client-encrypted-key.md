# OpenVPN client encrypted key

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.setup.openvpn-encrypted-key)

🛑 These instructions are only for specific VPN providers, such as VPN secure. You should not read this if it not mentioned.

Your encrypted key is of the form:

```pem
-----BEGIN ENCRYPTED PRIVATE KEY-----
...
...
-----END ENCRYPTED PRIVATE KEY-----
```

It may be given to you as a separate file or inlined in your Openvpn configuration file by your VPN service provider.
💁 For VPN secure, it's usually in the file `yourusername.key`.

⚠️ Because VPN secure uses DES to encrypt the key file, it is not supported by the latest OpenVPN 2.5 and above clients. To workaround this, the key is decrypted and re-encrypted using a higher encryption standard by Gluetun, before being plugged in to the OpenVPN client.

First, you need to take your encrypted key (from its start line `-----BEGIN ENCRYPTED PRIVATE KEY-----` to `-----END ENCRYPTED PRIVATE KEY-----`) and place it in a file on your host `/yourpath/gluetun/openvpn_encrypted_key` (without file extension). Note `openvpn_encrypted_key` must be this exact name.

Then bind mount this gluetun directory in the container by running it with `-v /yourpath/gluetun:/gluetun`.

To decrypt this encrypted key, you would have to set the key passphrase, which you can set as an environment variable `OPENVPN_KEY_PASSPHRASE` or as a file/secret file.
