# Pony Town Client — Android Mod Patch

> Unofficial, experimental patch for the Pony Town Android client (`town.pony.game`): a JavaScript mod layer, a virtual mouse, configurable on-screen keys, background keep-alive, wake lock and Picture-in-Picture.

| | |
| --- | --- |
| **Target package** | `town.pony.game` |
| **Base client** | `1.3-2387` (versionCode `2387`) |
| **Build** | Apktool `2.10.0` + JDK `17`, via GitHub Actions |
| **Output** | unsigned APK (you sign it yourself) |

This is a personal modding/research project and is **not an official Pony Town client**. The original APK is kept as the base and changes are a small native + JavaScript layer around the existing app.

## Contents

- [Features](#features)
- [How it works](#how-it-works)
- [Repository layout](#repository-layout)
- [Build](#build)
- [Install](#install)
- [Using the mod](#using-the-mod)
- [Debugging](#debugging)
- [Known limitations](#known-limitations)
- [Documentation](#documentation)
- [Scope, safety and disclaimer](#scope-safety-and-disclaimer)

## Features

Everything is configured from the floating **PT** button, which opens the mod panel (tabs: **Scripts · Apps · Mouse · Keys · Debug · About**). The button can be dragged anywhere.

### Script manager

- Load `.js` files with the Android file picker, or create/edit scripts in the panel
- Run, enable/disable, view and remove scripts
- Execution timing per script: `start`, `ready` or `load`
- Scripts persist in the Pony Town origin's `localStorage`
- Legacy drop-in `custom.js` is still supported (see [Custom JavaScript](#custom-javascript))
- The native bridge is token-gated and the injector only runs on `pony.town` and `*.pony.town`; look-alike hosts such as `pony.town.evil-example.com` are rejected

### Virtual mouse

Real Android mouse `MotionEvent`s are injected into the WebView, so the game and its UI see genuine hover, click, drag and wheel input.

| Mode | Behaviour |
| --- | --- |
| **Touch** | The pointer follows your finger; press/release is a left click; moving while pressed drags |
| **Trackpad** | Relative movement, tap = left click, tap-and-hold = drag, two-finger tap = right click, two-finger swipe = scroll |

Options:

- Cursor visibility/size and sensitivity
- On-screen **L / R** buttons (trackpad) and **scroll buttons** ⇞ ▲ ▼ ⇟ (page/line up and down), each with its own toggle
- Scroll method: native wheel events at the cursor, or JS `scrollBy`
- Selectable drag method and optional touch-event compatibility for pages that only react to touch
- Mouse events are normalised so Angular CDK drag (in-game windows, menus, sliders) works
- The page can see `hover`/`pointer: fine` (matchMedia spoofing, optional)
- **The cursor never presses the mod's own overlay** (keys and cursor controls). Clicks pass through to the game underneath
- **Cursor-control layout is editable**: drag L/R/scroll buttons anywhere, set size (S–XL), opacity, transparent background, or reset the layout

### On-screen keys

- Keys: A–Z, 0–9, arrows, Space, Shift, Ctrl, Alt, Tab, Esc, Enter, Backspace, **F1–F12**, numpad 0–9, Del/Ins/Home/End/PgUp/PgDn/Caps and US-layout symbols (`- = [ ] \ ; ' , . / \`` and the shifted `! @ # $ % ^ & * ( ) _ + { } | : " < > ? ~`)
- Presets: WASD, WASD + Space/Shift, Arrows and **Full keyboard** (84-key tenkeyless layout placed like a physical keyboard, scaled to the screen); add, remove, resize and drag keys in **Edit layout** mode
- **Snap & align** while dragging in Edit layout: keys and cursor controls snap to neighbours' edges and centres, sit flush with a small gap next to each other, and snap to screen edges (yellow guide lines; can be turned off)
- Opacity and transparent-background options
- **Slide between keys** (global toggle plus per-key on/off): a finger that leaves a key releases it without lifting; gliding onto a neighbouring key presses it
- Sent as real Android key events (native) or page `KeyboardEvent`s (synthetic)

### Background and power

- **Foreground service** with a low-importance persistent notification (`dataSync` type, `START_STICKY`) keeps the WebView process alive
- `WebView.pauseTimers()` is not called when the app stops, so game timers keep running
- **Wake lock** (partial CPU wake lock, off by default): toggle in **About** or from the **notification action**; the state is remembered
- **Keep screen on** while the game is open (separate toggle)
- **Picture-in-Picture**: *Enter Picture-in-Picture now* button in **About**, plus optional auto-PiP when you leave the app (device/ROM dependent). The overlay hides itself in a small PiP window

### Mini browser (Apps tab)

A small native window (second WebView) floating over the game, e.g. for Discord without switching apps.

- Save **web apps** (name + URL); the browser can **only** be launched from this list
- Size: small (40%) / medium (65%) / full, docked top or bottom; toolbar with back, reload, size, dock flip and close
- Optional **Desktop** user agent per app (recommended for Discord)
- Isolated: no JS bridge or mod token, only `http(s)` URLs. Created on open and destroyed on close to save RAM
- Not supported: voice/mic; Google sign-in is blocked in WebViews (use email/password or QR)

### Debug tools

The **Debug** tab has an event spy (what the page actually receives, and whether events are trusted), a drag test area and a hover test area.

## How it works

```text
Pony Town WebView
       │
       ├── page lifecycle hooks ──► JsInjector ──► assets/ptmod/ui.js  (panel, mouse, keys)
       │
       └── window.PtModBridge  (per-process token, pony.town only)
                    │
                    ├── scripts   pickScript, exec
                    ├── input     mouseMove, mouseBtn, mouseScroll, key ──► PtInput ──► MotionEvent / KeyEvent
                    └── system    setPip, pipNow, setScreen, setWake, getWake ──► PtPip / PtWake / PonyTownService
                    └── apps      openApp, closeApp ──► PtBrowser
```

| Component | Role |
| --- | --- |
| `assets/ptmod/ui.js` | Visible mod UI and all JavaScript-side behaviour; calls the bridge |
| `JsInjector` | Injects the UI and legacy `custom.js` on accepted hosts, once per page |
| `PtModBridge` | JavaScript-facing API; every call checks the bridge token |
| `PtInput` | Builds Android `MotionEvent`/`KeyEvent` objects and posts them on the UI thread |
| `PonyTownService` | Foreground service and notification (with wake-lock action) |
| `PtWake` / `PtPip` | Wake lock state, PiP and keep-screen-on helpers |
| `PtBrowser` | Isolated floating mini-browser WebView (Apps tab) |
| `MainActivity`, `PonyTownWebViewImpl`, `y5/m` | Small hooks into the original app (service start, bridge registration, page callbacks, file-picker result, user-leave-hint listener) |

Native mouse events use `dispatchGenericMotionEvent()` with `SOURCE_MOUSE`: `ACTION_HOVER_MOVE` for hover/drag, `ACTION_BUTTON_PRESS`/`RELEASE` for buttons and `ACTION_SCROLL` for the wheel.

## Repository layout

```text
.
├── decoded/                         patch overlay (not a full Apktool project)
│   ├── AndroidManifest.xml
│   ├── assets/ptmod/ui.js
│   └── smali/
│       ├── town/pony/game/MainActivity.smali
│       ├── town/pony/game/mod/      JsInjector, PtInput, PtModBridge, PtPip, PtWake, PtBrowser
│       ├── town/pony/game/service/  PonyTownService
│       ├── town/pony/game/ui/webview/PonyTownWebViewImpl.smali
│       └── y5/m.smali
├── docs/
│   ├── PATCH_REPORT.md              patch history and per-change notes
│   ├── ANALYSIS.md                  reverse-engineering notes (Stage 1)
│   └── plan.md                      original task brief
├── .github/workflows/rebuild-patched-apk.yml
├── town.pony.game v1.3-2387_antisplit.apk    original base APK
└── README.md
```

`decoded/` only contains the files that differ from the original. CI decodes the original APK into a temporary full project, copies `decoded/` over it and rebuilds. New smali files are tracked normally (`decoded/` is no longer git-ignored); the workflow fails early if a required class file is missing from the overlay.

## Build

### GitHub Actions (recommended)

`.github/workflows/rebuild-patched-apk.yml` runs on pull requests, on pushes to `main`, `fix/**` and `feat/**` (when `decoded/`, the base APK or the workflow change) and manually.

1. Check out, install JDK 17, download Apktool 2.10.0
2. Decode the tracked original APK
3. Overlay `decoded/` and check that required files are present
4. Rebuild the unsigned APK and test the archive (`unzip -t`)
5. Upload `ponytown-patched-unsigned` (APK, `SHA256SUMS.txt`, decode/build logs; kept 14 days)

The workflow never signs the APK.

### Local build

Requires JDK 17 and Apktool 2.10.0:

```bash
curl -fsSL -o apktool.jar \
  https://github.com/iBotPeaches/Apktool/releases/download/v2.10.0/apktool_2.10.0.jar

rm -rf build && mkdir -p build
java -jar apktool.jar d -f "town.pony.game v1.3-2387_antisplit.apk" -o build/decoded
cp -a decoded/. build/decoded/
java -jar apktool.jar b build/decoded -o build/ponytown-patched-unsigned.apk
```

Syntax-check the UI script before committing: `node --check decoded/assets/ptmod/ui.js`.

## Install

1. Download the `ponytown-patched-unsigned` artifact from a successful workflow run
2. Sign it with your own key (for example with MT Manager)
3. Install the signed APK; allow notifications for the app so the foreground-service notification (and its wake-lock action) is visible
4. If installing over an existing copy fails, the signing key probably differs — uninstall first

## Using the mod

1. Open Pony Town and tap the floating **PT** button.
2. **Mouse** tab: turn the virtual mouse on and pick *Touch* or *Trackpad*.
3. **Keys** tab: turn on-screen keys on, choose a preset, then *Edit layout* to drag keys and cursor controls.
4. **Scripts** tab: load or write scripts.
5. **About** tab: PiP, wake lock, keep-screen-on, reload and reset.

### Custom JavaScript

Besides the Scripts manager, the legacy file is still read on `pony.town` pages:

```text
/Android/data/town.pony.game/files/scripts/custom.js
```

(with an internal app-files fallback). Page scripts can read `window.ptmod.mouse` and listen for the `ptmod:mouse` event.

## Debugging

- Crash log (adb or a Shizuku/adb terminal app): `logcat -d -b crash`
- Open the app, wait for the crash, then `logcat -d | grep -iE "FATAL|AndroidRuntime|VerifyError|town.pony|ptmod"`
- Use the **Debug → Event spy** tab to see which events the page receives
- A successful rebuild is not a runtime test: always check that the app starts

Things learned the hard way (see [docs/PATCH_REPORT.md](docs/PATCH_REPORT.md)):

- `androidx` `ComponentActivity` (`b/q`) declares `onUserLeaveHint` **final** — overriding it in `MainActivity` crashes at class load. Use its listener list instead (as `PtPip` does)
- Overlay files must be tracked by git, otherwise CI silently builds without them

## Known limitations

- Android background execution, vendor power management (HyperOS/MIUI etc.) and the `dataSync` foreground-service time budget on Android 15 can still end long sessions
- The wake lock increases battery use; turn it off when not needed
- Auto-PiP depends on the ROM (some need a per-app PiP permission); the manual button is the reliable path
- Pages that consume only raw touch input may ignore virtual mouse events (touch-compat option exists)
- Modifier key buttons do not set `shiftKey`/`ctrlKey` on other synthetic events
- The overlay is rendered inside the page and can be hidden by fullscreen game elements
- Key symbols assume a US keyboard layout
- The rebuilt APK is unsigned

## Documentation

| File | Purpose |
| --- | --- |
| [docs/PATCH_REPORT.md](docs/PATCH_REPORT.md) | Patch history: modified files, fixes and verification notes |
| [docs/ANALYSIS.md](docs/ANALYSIS.md) | Reverse-engineering and hook analysis of the original APK |
| [docs/plan.md](docs/plan.md) | Original task brief for the first patch stages |

## Scope, safety and disclaimer

The patch does not touch Pony Town authentication, payment, billing or account credentials, and it does not replace the game's servers or server-side logic. Do not put secrets or signing keys in this repository or in workflow logs/artifacts.

This is an unofficial modification for personal experimentation, interoperability research and mod development. Pony Town, its name, trademarks, original client and assets remain the property of their respective owners. Use, redistribution and modification of the original software should comply with the applicable terms, licenses and laws.
