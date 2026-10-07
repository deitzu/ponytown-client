# Pony Town Client — Patched Android Build

A modified, research-oriented build of the Pony Town Android client with an injected local mod layer, lifecycle/keep-alive changes, script management, virtual mouse/keyboard input, and an automated APK rebuild workflow.

> **Status:** Experimental / device testing required  
> **Target package:** `town.pony.game`  
> **Current client build:** `1.3-2387` (versionCode `2387`)

## What this project is

This repository contains a patched/decompiled Pony Town Android client. The original application's WebView and native Android code are kept as the base; modifications are layered around them rather than replacing the client with a new implementation.

The main goals are:

- keep the WebView active when the app is backgrounded
- inject user-provided JavaScript without editing the game's web application
- provide an in-app script manager
- expose mouse and keyboard-like controls on Android
- support native-style mouse hover, click, drag, and scroll events
- rebuild the patched APK reproducibly with GitHub Actions

This is primarily a personal modding/research project. It is **not** an official Pony Town client.

## Features

### JavaScript mod layer

The mod layer is injected through `JsInjector` and is restricted to Pony Town hosts.

The current implementation provides:

- external/internal `custom.js` loading
- a persistent script picker
- script creation, editing, running, enabling/disabling, and removal
- configurable execution timing: `start`, `ready`, or `load`
- per-page injection guards to avoid duplicate execution
- a token-gated `PtModBridge` between page JavaScript and Android code
- defensive error handling around injection and bridge calls

Scripts can use the bridge-backed mouse/keyboard APIs exposed by the mod UI.

### Virtual mouse

The **Mouse** tab provides two control modes:

**Touch**
- move the pointer with a finger
- press/release for left-click
- drag while holding

**Trackpad**
- relative pointer movement
- tap for left-click
- tap-and-hold for drag
- two-finger tap for right-click
- two-finger scrolling
- on-screen left/right/scroll buttons

The native input path uses Android `MotionEvent` delivery through `dispatchGenericMotionEvent()` for mouse-style events.

The implementation distinguishes:

- hover: `ACTION_HOVER_MOVE`
- movement/drag: `ACTION_MOVE` with mouse source/button state
- button press: `ACTION_BUTTON_PRESS`
- button release: `ACTION_BUTTON_RELEASE`
- scrolling: `ACTION_SCROLL` with horizontal/vertical scroll axes

The UI can also report a fine/hover-capable pointer to page code through the relevant media-query checks.

### On-screen keyboard

The **Keys** tab provides configurable on-screen keys, including:

- A–Z
- 0–9
- Arrow keys
- Space, Shift, Ctrl, Alt, Tab
- Esc, Enter, Backspace

Built-in presets include:

- WASD
- WASD + Space/Shift
- Arrow keys

Key buttons can be added, removed, resized, repositioned, and toggled.

### Foreground service

The patched client starts a foreground service to keep the app process active while backgrounded.

The service:

- uses Android's foreground-service API
- exposes a persistent low-importance notification
- returns `START_STICKY`
- does **not** use a WakeLock
- is declared with the `dataSync` foreground-service type

The game WebView no longer calls `pauseTimers()` during the patched stop path, because freezing JavaScript timers can break long-lived game sessions while the process is otherwise kept alive.

## Repository layout

```text
.
├── decoded/
│   ├── assets/
│   │   └── ptmod/
│   │       └── ui.js
│   ├── smali/
│   │   └── town/pony/game/mod/
│   │       ├── JsInjector.smali
│   │       ├── PtInput.smali
│   │       └── PtModBridge.smali
│   ├── smali/y5/
│   │   └── m.smali
│   ├── smali/town/pony/game/ui/webview/
│   │   └── PonyTownWebViewImpl.smali
│   ├── AndroidManifest.xml
│   └── apktool.yml
├── .github/
│   └── workflows/
│       └── rebuild-patched-apk.yml
├── PATCH_REPORT.md
└── README.md
```

## Building

The repository is designed to rebuild the tracked `decoded/` tree with Apktool.

### Local build

Requirements:

- Java 17
- Apktool 2.10.0

Build:

```bash
java -jar apktool.jar b decoded -o build/ponytown-patched-unsigned.apk
```

The output is intentionally **unsigned**.

### GitHub Actions

The workflow at:

```text
.github/workflows/rebuild-patched-apk.yml
```

can be triggered manually and is also configured to rebuild when relevant APK/decode/workflow files change.

The workflow:

1. checks out the repository
2. installs JDK 17
3. downloads Apktool 2.10.0
4. rebuilds the decoded project
5. checks that the APK archive is valid
6. generates a SHA-256 checksum
7. uploads the unsigned APK and checksum as workflow artifacts

The workflow does not sign the APK and does not require an Android SDK for the Apktool build step.

## Signing and installation

The rebuild artifact is unsigned by design.

A typical workflow is:

1. obtain `ponytown-patched-unsigned.apk`
2. sign/rebuild it with your own Android tooling or MT Manager
3. install the resulting APK on the test device
4. grant any required Android permissions/settings

For Android 13+, notification visibility may require allowing notifications for the app.

The package name remains:

```text
town.pony.game
```

## Custom JavaScript

The legacy drop-in script path is supported:

```text
/Android/data/town.pony.game/files/scripts/custom.js
```

The injector also supports an internal app-files fallback.

The file is read as text and injected through a defensive wrapper so a script exception does not directly crash the host activity.

The preferred long-term interface is the built-in **Scripts** manager rather than relying only on the legacy `custom.js` file.

## Current branch focus

The latest development branch is:

```text
fix/native-mouse-click-scroll
```

This branch adds the native mouse button/scroll path on top of the existing mod UI.

Current changes include:

- mouse buttons delivered as generic mouse button events instead of touch down/up events
- explicit left/right `actionButton` handling
- native scroll events and horizontal/vertical scroll axes
- two-finger trackpad scrolling
- on-screen scroll controls
- automated unsigned APK rebuild via GitHub Actions

See [PATCH_REPORT.md](PATCH_REPORT.md) for the full implementation history and audit notes.

## Limitations

This project is still experimental.

Known limitations include:

- native input behavior still needs real-device verification
- multi-key modifier semantics are not fully modeled
- applications that only consume raw touch input may ignore the virtual mouse
- page-level overlays may be hidden by game fullscreen elements
- Android background execution and power-management behavior can still affect long-lived connections
- the foreground-service behavior is platform-version dependent
- the APK is unsigned after rebuilding

Do not treat a successful Apktool build as proof that the patched client behaves correctly on a physical device.

## Testing philosophy

Changes should be validated at three different levels:

### Static/build validation

- Apktool rebuild succeeds
- APK archive passes integrity checks
- expected patched classes/resources are present

### Web/mod-layer validation

- `ui.js` parses and loads
- bridge calls are token-gated
- script lifecycle does not double-inject
- UI settings persist as expected

### Device/runtime validation

- app launches normally
- foreground service starts
- script loading works
- mouse hover/click/drag/scroll reaches the WebView
- keyboard events reach the game
- backgrounding does not immediately freeze the game

A build passing the first two levels does **not** imply the third level has passed.

## Project notes

The detailed technical record lives in [PATCH_REPORT.md](PATCH_REPORT.md). It records modified files, lifecycle hooks, injector behavior, native input routing, build verification, and known unverified areas.

The repository deliberately keeps the mod implementation close to the original client structure so that individual patches can be inspected, tested, and reverted without redesigning the application.

## Disclaimer

This is an unofficial modification of the Pony Town Android client for personal experimentation, interoperability research, and mod development.

Pony Town and related trademarks/assets remain the property of their respective owners. Use and redistribution of the original client or its assets should follow the applicable licenses and terms.
