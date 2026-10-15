<p align="center">
  <img src="support/branding/logo-512.png" alt="Lalitha Local Share logo" width="160"/>
</p>

<h1 align="center">Lalitha Local Share</h1>

<p align="center">Share files and messages with nearby devices over your own Wi‑Fi — no internet, no cloud, no account.</p>

---

Lalitha Local Share is a free, open-source app for sending photos, videos, documents and text between phones and computers on the same local network. Everything is sent directly from device to device over encrypted HTTPS.

It is a rebranded edition of **[LocalSend](https://github.com/localsend/localsend)** by Tien Do Nam and contributors, released under the Apache License 2.0. See [NOTICE](NOTICE) for details.

## Features

- Send files, folders and text to any nearby device
- Works on Android, iOS, Windows, macOS and Linux
- No internet connection or sign-up needed
- End-to-end HTTPS encryption with per-device certificates
- Optional PIN to protect receiving
- "Receive via link": share files to any phone through its web browser
- Works with devices running LocalSend (same protocol, port 53317)

## Network setup

If devices cannot see each other, allow the app through the firewall:

| Traffic  | Protocol | Port  | Action |
|----------|----------|-------|--------|
| Incoming | TCP, UDP | 53317 | Allow  |
| Outgoing | TCP, UDP | Any   | Allow  |

Also make sure "AP isolation" / "client isolation" is turned off on your router (often enabled on guest networks).

## Building from source

Requirements:

1. [Flutter](https://flutter.dev) **3.41.9** — easiest with [fvm](https://fvm.app) (`fvm install` reads `.fvmrc`)
2. [Rust](https://www.rust-lang.org/tools/install) (the toolchain in `rust-toolchain.toml` is installed automatically)
3. The SDK for your target platform (Android Studio, Xcode, Visual Studio with C++ workload, or Linux GTK dev packages)

```bash
cd app
fvm flutter pub get
fvm flutter run                 # run on a connected device / desktop
```

Release builds:

```bash
fvm flutter build apk           # Android
fvm flutter build windows       # Windows
fvm flutter build linux         # Linux
fvm flutter build macos         # macOS (needs your own Apple signing team)
fvm flutter build ios           # iOS  (needs your own Apple signing team)
```

The command-line client:

```bash
cargo build --release --package localsend-cli
```

## App identifiers

| Platform        | Identifier                     |
|-----------------|--------------------------------|
| Android         | `com.lalitha.localshare`       |
| iOS / macOS     | `com.lalitha.localshare`       |
| App group       | `group.com.lalitha.localshare` |
| Linux           | `com.lalitha.localshare`       |

These are different from LocalSend's, so both apps can be installed side by side.

## Branding

The logo source is in [`support/branding/`](support/branding). App icons for every platform were generated from it.

## License

Apache License 2.0 — see [LICENSE](LICENSE) and [NOTICE](NOTICE).

Original project: LocalSend © 2022-2026 Tien Do Nam and contributors.
Modifications for Lalitha Local Share © 2026 Lalitha.
