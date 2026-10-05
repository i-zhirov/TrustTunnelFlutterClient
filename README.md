# TrustTunnel Redux

> **Unofficial fork.** This project is a personal fork of the
> [TrustTunnel Flutter Client](https://github.com/TrustTunnel/TrustTunnelFlutterClient).
> It is **not affiliated with or endorsed by the upstream project**, and it is
> **not** an official release channel. Use at your own risk.

TrustTunnel Redux keeps the upstream functionality but adds one **experimental
feature that is not present upstream**:

## ✨ Experimental feature: SOCKS5 proxy mode (Android)

In addition to the standard TUN (virtual network interface) mode, Redux can run
the backend in **SOCKS5 proxy mode** — the client exposes a local SOCKS5 proxy
(127.0.0.1 or any interface) instead of a TUN device. Only one mode is active at
a time (TUN **or** SOCKS).

- Configurable **port**, **username/password** (authentication is enforced), and
  **bind address** (`127.0.0.1` by default; `0.0.0.0` to allow connections from
  the local network)
- Works with apps/tools that can use a SOCKS5 proxy
- Settings: **Settings → Connection mode**

This feature required matching experimental changes in the native client
library (see [TrustTunnelClient-redux](https://github.com/i-zhirov/TrustTunnelClient-redux)).

## Getting builds

Installable packages (APK/AAB) are published as
[GitHub Releases](https://github.com/i-zhirov/TrustTunnelFlutterClient-redux/releases).
You can also install/update with [Obtainium](https://github.com/ImranR98/Obtainium)
by adding this repository and filtering for the `app-release.apk` asset.

> Redux uses the application id `com.adguard.trusttunnel.redux`, so it can be
> installed side-by-side with the official TrustTunnel app.

## Branch layout

- `master` — mirror of the upstream repository (the original README lives in
  [`README_UPSTREAM.md`](README_UPSTREAM.md))
- `socks5-proxy-support` — fork changes (SOCKS5 proxy feature, CI, releases)

## Upstream documentation

The original upstream README is preserved at
[`README_UPSTREAM.md`](README_UPSTREAM.md) — please refer to it for the full
project description, architecture, and upstream usage instructions.
