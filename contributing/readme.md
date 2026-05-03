# Contributing

![Visitors count](https://visitor-badge.laobi.icu/badge?page_id=gluetun.contributing.contribute)

There are multiple ways to contribute:

- 🆕 [**VPN credentials**](#vpn-credentials)
- **Help others**
  - [Github issues](https://github.com/qdm12/gluetun/issues)
  - [Github discussions](https://github.com/qdm12/gluetun/discussions)
- [**Donate**](#donate)
  - [Github sponsors](#github-sponsors)
  - [Paypal](#paypal)
- [**Code**](#code)

And of course, [**Thank you**](#thank-you)

## VPN credentials

If you have a subscription to a VPN provider, you can contribute by sharing your credentials with me at [quentin.mcgaw@gmail.com](mailto:quentin.mcgaw@gmail.com),
or [quentin.mcgaw@protonmail.com](mailto:quentin.mcgaw@protonmail.com) but notify me via the gmail address 😏

This allows me to:

- manually debug problems and test new features in Gluetun for the VPN provider
- automate testing of the VPN provider in the CI (continuous integration) pipeline, more on that below.

I am currently looking for credentials, for both Wireguard and OpenVPN ideally, for the following VPN providers:

- ~airvpn~
- cyberghost
- expressvpn
- fastestvpn
- giganews
- hidemyass
- ipvanish
- ivpn
- ~mullvad~
- nordvpn
- perfect privacy
- privado
- ~private internet access~
- privatevpn
- ~protonvpn~
- purevpn
- slickvpn
- surfshark
- torguard
- vpnsecure
- vpn unlimited
- vyprvpn
- windscribe

For OpenVPN, I only need the username and password;

For Wireguard, I need the private key, the pre-shared key (if any) and the interface address.

The credentials are handled securely:

- Locally: your credentials would be stored in an encrypted file using [https://github.com/qdm12/gluetun/tree/master/devrun] which decrypts only in memory the credentials to stuff them in an in-memory container configuration (using Moby/Docker Go libraries). I'm already using this now.
- In CI: your credentials would be stored as secrets in the Github repository, and [injected to the CI program](https://github.com/qdm12/gluetun/blob/7a74d4f462d2e64c7f0a8253f9d9a496a6056d79/ci/internal/secrets.go#L19-L32) I coded (without AI!) through standard input, so it's not even stored in the CI environment or logged. This job only runs on commits running in the original repository ([if block](https://github.com/qdm12/gluetun/blob/7a74d4f462d2e64c7f0a8253f9d9a496a6056d79/.github/workflows/ci.yml#L74-L80)) as well.

And let me know if you want me to mention you in the "Thank you" section of the Gluetun readme, and, if so, what name/username you want me to share.

## Donate

### Github sponsors

You can sponsor me on [github.com/sponsors/qdm12](https://github.com/sponsors/qdm12)

[![Github sponsor](github-sponsor.avif)](https://github.com/sponsors/qdm12)

### Paypal

You can do a one time donation to [paypal.me/qmcgaw](https://www.paypal.me/qmcgaw)

[![Paypal](paypal.avif)](https://www.paypal.me/qmcgaw)

## Code

You can contribute to the code written in Go.
Notably, you can (since `v3.30.0`) easily add new VPN providers.
Please go to the [development](development.md) page on how to get started.

## Thank you

### Code contributors

Thanks for all the code contributions, whether small or not so small!

- [@JeordyR](https://github.com/JeordyR) for testing the Mullvad version and opening a [PR with a few fixes](https://github.com/qdm12/gluetun/pull/84/files) 👍
- [@rorph](https://github.com/rorph) for a [PR to pick a random region for PIA](https://github.com/qdm12/gluetun/pull/70) and a [PR to make the container work with kubernetes](https://github.com/qdm12/gluetun/pull/69)
- [@JesterEE](https://github.com/JesterEE) for a [PR to fix silly line endings in block lists back then](https://github.com/qdm12/gluetun/pull/55) 📎
- @elmerfdz for a [PR to add timezone information to have correct log timestamps](https://github.com/qdm12/gluetun/pull/51) 🕙
- [@Juggels](https://github.com/Juggels) for a [PR to write the PIA forwarded port to a file](https://github.com/qdm12/gluetun/pull/43)
- [@gdlx](https://github.com/gdlx) for a [PR to fix and improve PIA port forwarding script](https://github.com/qdm12/gluetun/pull/32)
- [@janaz](https://github.com/janaz) for keeping an eye on [updating things in the Dockerfile](https://github.com/qdm12/gluetun/pull/8)

### Financial contributors

Thanks for all the financial contributions, whether small or not so small!

- [@Frepke](https://github.com/Frepke)
- [@Raph521](https://github.com/Raph521)
- J. Hendriks
- G. Mendez
- M. Otmar Weber
- Alkalabs
- J. Silvagi
- J. Perez
- A. Cooper
- [@beechfuzz](https://github.com/beechfuzz)
- I. Gaon
- Fabricio20
- Isaac C.
- Willian CH.
- P. Adam 🥇
- L. Begum
- S. Castellucci
- [@voyager529](https://github.com/voyager529)
- [@harrytheeskimo](https://github.com/harrytheeskimo)
- [@lostbow17](https://github.com/lostbow17)
- [@evandev](https://github.com/evandev)
- [@codetheweb](https://github.com/codetheweb)
- [@lavaguy1](https://github.com/lavaguy1)
- [@estate000](https://github.com/estate000)
- @ansred
- [@den747](https://github.com/den747)
- Chistoph K.
- [@enphor](https://github.com/enphor)
- [@KevinRohn](https://github.com/KevinRohn)
- [@HippocampusGirl](https://github.com/HippocampusGirl)
- [@msorelle](https://github.com/msorelle)
- Bernhard R.
- Conor A.
- Arash E. 🥇
- Joseph F.
- Gabin G.
- M. Kusold
- D. McNamara
- S. Cox

Please [email me](mailto:quentin.mcgaw@gmail.com) if there is any mistake 😉
