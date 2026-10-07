# Pony Town Client — Android Patch

> Unofficial, experimental Android client patch for Pony Town focused on JavaScript mod injection, persistent background behavior, and desktop-style input controls.

**Target package:** `town.pony.game`  
**Client build:** `1.3-2387` · versionCode `2387`  
**Build system:** Apktool `2.10.0` + JDK `17`  
**APK output:** unsigned

## Overview

This repository contains a patched/decompiled Pony Town Android client.

The original APK is used as the base. Changes are kept as a small native/mod layer around the existing application instead of rewriting the client from scratch.

The project currently focuses on four areas:

| Area | Purpose |
| --- | --- |
| JavaScript injection | Load and manage user scripts on `pony.town` pages |
| Background keep-alive | Keep the WebView process active through a foreground service |
| Virtual input | Provide mouse and keyboard-style controls on Android |
| Reproducible rebuilds | Rebuild the patched APK automatically with GitHub Actions |

This is a personal modding/research project and is **not an official Pony Town client**.

## Features

### Script manager

The injected mod UI includes a built-in **Scripts** panel.

- Load `.js` files through the Android file picker
- Create and edit scripts
- Run scripts manually
- Enable/disable scripts
- Remove scripts
- Choose execution timing: `start`, `ready`, or `load`
- Persist scripts in the Pony Town origin's `localStorage`
- Keep compatibility with the legacy `custom.js` drop-in file

The native bridge is token-gated and the injector only accepts Pony Town hosts:

`pony.town`  
`*.pony.town`

Lookalike hosts such as `pony.town.evil-example.com` are rejected.

### Virtual mouse

The **Mouse** panel provides two control modes.

**Touch mode**

- Finger movement controls the pointer
- Press/release produces left-click
- Holding while moving supports drag

**Trackpad mode**

- Relative pointer movement
- Tap for left-click
- Tap-and-hold for drag
- Two-finger tap for right-click
- Two-finger scrolling
- On-screen left/right/scroll controls

The patched native path uses Android mouse-style `MotionEvent` delivery:

`ACTION_HOVER_MOVE` → pointer hover  
`ACTION_MOVE` → movement/drag  
`ACTION_BUTTON_PRESS` → mouse button press  
`ACTION_BUTTON_RELEASE` → mouse button release  
`ACTION_SCROLL` → wheel/trackpad scrolling

Mouse-style events are dispatched through `dispatchGenericMotionEvent()` with `SOURCE_MOUSE`, rather than emulating button presses with ordinary touch down/up events.

### On-screen keyboard

The **Keys** panel provides configurable on-screen controls for:

- A–Z
- 0–9
- Arrow keys
- Space
- Shift
- Ctrl
- Alt
- Tab
- Esc
- Enter
- Backspace

Built-in presets:

- WASD
- WASD + Space/Shift
- Arrow keys

Keys can be added, removed, resized, repositioned, and toggled.

### Background keep-alive

The patched client starts a foreground service to reduce the chance of the WebView being stopped while the app is backgrounded.

The service:

- uses Android's foreground-service API
- uses a low-importance persistent notification
- returns `START_STICKY`
- does not use a WakeLock
- is declared with the `dataSync` foreground-service type

The patched WebView stop path also avoids calling `WebView.pauseTimers()`, which would freeze game JavaScript timers while the Android process is otherwise kept alive.

## How it works

The main components are:

```text
Pony Town WebView
       │
       ├── page lifecycle hooks
       │       └── JsInjector
       │               └── assets/ptmod/ui.js
       │
       └── window.PtModBridge
                    │
                    ├── scripts
                    ├── mouse
                    └── keyboard
                         │
                         └── PtInput
                              ├── MotionEvent
                              └── KeyEvent
                                      │
                                      ▼
                               Android WebView
```

### JavaScript side

`decoded/assets/ptmod/ui.js` provides the visible mod interface and calls the native bridge.

### Injector

`JsInjector.smali` loads the script layer during the WebView page lifecycle and prevents duplicate per-page injection.

### Native bridge

`PtModBridge.smali` exposes a small JavaScript-facing API and verifies the per-process bridge token before accepting calls.

### Native input

`PtInput.smali` constructs Android `MotionEvent`/`KeyEvent` objects and posts them onto the WebView UI thread.

## Repository layout

```text
.
├── decoded/
│   ├── assets/
│   │   └── ptmod/
│   │       └── ui.js
│   ├── smali/
│   │   ├── town/pony/game/mod/
│   │   │   ├── JsInjector.smali
│   │   │   ├── PtInput.smali
│   │   │   └── PtModBridge.smali
│   │   ├── town/pony/game/service/
│   │   │   └── PonyTownService.smali
│   │   └── town/pony/game/ui/webview/
│   │       └── PonyTownWebViewImpl.smali
│   ├── smali/y5/
│   │   └── m.smali
│   ├── AndroidManifest.xml
│   └── apktool.yml
├── .github/
│   └── workflows/
│       └── rebuild-patched-apk.yml
├── ANALYSIS.md
├── PATCH_REPORT.md
├── plan.md
├── README.md
└── town.pony.game v1.3-2387_antisplit.apk
```

The tracked `decoded/` tree is the source used for rebuilding the patched APK.

## Build

### Requirements

- JDK 17
- Apktool 2.10.0

### Local rebuild

From the repository root:

```bash
curl -fsSL -o apktool.jar \
  https://github.com/iBotPeaches/Apktool/releases/download/v2.10.0/apktool_2.10.0.jar

java -jar apktool.jar b decoded \
  -o build/ponytown-patched-unsigned.apk
```

The output is intentionally **unsigned**.

The build does not require a full Android SDK; Apktool handles the APK rebuild using its bundled tooling.

### GitHub Actions

The repository includes:

```text
.github/workflows/rebuild-patched-apk.yml
```

The workflow can be started manually and also runs for relevant pull-request/development changes.

Build steps:

1. Check out the repository
2. Install JDK 17
3. Download Apktool 2.10.0
4. Validate the decoded project
5. Rebuild the unsigned APK
6. Test the APK archive with `unzip -t`
7. Generate a SHA-256 checksum
8. Upload the APK and checksum as workflow artifacts

The workflow does **not** sign the APK.

## Getting the APK

The intended workflow is:

```text
GitHub Actions
      │
      ▼
patched unsigned APK
      │
      ▼
sign with your own Android tooling
      │
      ▼
install on test device
```

After a successful workflow run, download:

```text
ponytown-patched-unsigned.apk
SHA256SUMS.txt
```

Artifact retention is controlled by the workflow file.

## Signing and installation

The generated APK is unsigned by design.

A typical installation flow is:

1. Download the unsigned APK artifact.
2. Sign it with your own key using Android tooling or MT Manager.
3. Install the signed APK on the test device.
4. Grant any required Android permissions/settings.

The package remains:

```text
town.pony.game
```

Because this modifies an existing Android application, installation behavior can depend on the signing key and the existing version installed on the device.

## Custom JavaScript

The legacy script path is still supported:

```text
/Android/data/town.pony.game/files/scripts/custom.js
```

The injector also supports an internal app-files fallback.

The preferred interface is the built-in **Scripts** manager, but the legacy file is useful for quick testing and backwards compatibility.

Scripts are only injected into accepted Pony Town hosts.

## Testing

A successful Apktool rebuild is **not** the same as a successful runtime test.

Testing is split into three levels.

### 1. Build validation

- Apktool rebuild succeeds
- Output APK is non-empty
- APK archive passes integrity checks
- Patched classes/resources are present

### 2. Mod-layer validation

- `ui.js` loads
- Bridge calls are token-gated
- Scripts are not double-injected
- Script settings persist
- Mouse/keyboard UI state behaves correctly

### 3. Device validation

- App launches normally
- Foreground service starts
- Scripts load and execute
- Mouse hover works
- Left/right click works
- Drag works
- Scroll reaches the WebView
- Keyboard input reaches the game
- Backgrounding does not immediately freeze the session

The native input path is still considered **experimental until verified on a physical device**.

## Known limitations

- Physical-device runtime testing is required for final verification.
- Multi-key modifier behavior is limited; modifier buttons do not fully emulate browser `shiftKey`/`ctrlKey` state on every synthetic event.
- Pages that consume only raw touch input may ignore virtual mouse events.
- The mod UI is rendered inside the page and can be hidden by fullscreen game elements.
- Android background execution and power-management policies can still affect long-lived connections.
- Foreground-service behavior varies between Android versions and vendor ROMs.
- The rebuilt APK is unsigned.

## Technical documents

Use the other Markdown files for deeper details:

| File | Purpose |
| --- | --- |
| [PATCH_REPORT.md](PATCH_REPORT.md) | Patch history, modified files, verification results, and known unverified areas |
| [ANALYSIS.md](ANALYSIS.md) | Reverse-engineering and implementation analysis |
| [plan.md](plan.md) | Original patch design and implementation plan |

## Scope and safety

This repository does not intentionally modify Pony Town authentication, payment, billing, or account credentials.

The mod layer is intended for client-side experimentation and input/mod development. It does not replace the game's servers or server-side logic.

Do not place secrets, API keys, signing keys, or other private credentials in this repository or in GitHub Actions logs/artifacts.

## Disclaimer

This is an unofficial modification of the Pony Town Android client for personal experimentation, interoperability research, and mod development.

Pony Town, its name, trademarks, original client, and related assets remain the property of their respective owners. Use, redistribution, and modification of the original software should comply with the applicable terms, licenses, and laws.
