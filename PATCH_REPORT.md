# Pony Town Mod — PATCH_REPORT

**APK:** `town.pony.game v1.3-2387_antisplit.apk` (2.2 MB)
**Package:** `town.pony.game` · label "Pony Town" · versionName `1.3-2387` / versionCode `2387`
**SDK levels:** minSdk 23 (Android 6.0) · targetSdk 35 (Android 15) · compileSdk 36
**Status:** **BUILD SUCCESS** — rebuilt APK at `decoded/dist/ponytown-patched.apk` (~2.28 MB)
**Unsigned by design** — sign with MT Manager yourself. RTB: the original APK was already signed with the Android debug key; re-signing with MT Manager replaces it.

---

## Modified Files

| File (under `decoded/`) | Change |
|---|---|
| `AndroidManifest.xml` | +3 `<uses-permission>` + 1 `<service>` declaration (below). All existing components byte-identical. |
| `smali/town/pony/game/MainActivity.smali` | Guarded once-per-process foreground-service start block in `onCreate` |
| `smali/town/pony/game/service/PonyTownService.smali` | **NEW** — keep-alive foreground service |
| `smali/town/pony/game/mod/JsInjector.smali` | **NEW** — custom JavaScript injector |
| `smali/y5/m.smali` | +2 hook calls: `JsInjector.onPageFinished(...)` (page-finished) and `JsInjector.onPageStarted(...)` (earliest-safe) |

No auth, payment, billing, login, or network-protocol code was touched. No WakeLock, no new dependencies, no analytics, no data sent anywhere.

---

## Foreground Service

- **Class:** `town.pony.game.service.PonyTownService` — extends `android.app.Service`
- **Path:** `decoded/smali/town/pony/game/service/PonyTownService.smali`
- **Startup:** `MainActivity.onCreate` builds the intent (`Intent.setClassName(context, "town.pony.game.service.PonyTownService")`) and calls `startForegroundService()` on API 26+ / `startService()` below, wrapped in `try/catch(Throwable)` so a blocked start can never crash the game. A static once-per-process flag prevents duplicate starts when onCreate re-runs (rotation/PiP).
- **Notification channel:** id `pony_town_running`, name "Pony Town Running", importance LOW, created on API 26+ inside `startAsForeground()`.
- **Notification:** title exactly **"Pony Town Running"**, text exactly **"Keeping Pony Town active"**, `setOngoing(true)` (non-cancelable), fixed id 1, small icon `@mipmap/ic_launcher` (existing resource, id `0x7f0d0000`), tap → MainActivity via `PendingIntent.getActivity` (`FLAG_ACTIVITY_NEW_TASK` + `FLAG_IMMUTABLE`).
- **Foreground:** `startForeground()` is called from the same `startAsForeground()` path in both `onCreate` and `onStartCommand`, so the 5-second window is always met. Returns `START_STICKY`. **No WakeLock anywhere.**
- **Manifest additions:** `android.permission.POST_NOTIFICATIONS` (notification visible on Android 13+), `android.permission.FOREGROUND_SERVICE` (Android 12+), `android.permission.FOREGROUND_SERVICE_DATA_SYNC` (Android 14+ requirement for the declared type), and:
  ```xml
  <service android:name="town.pony.game.service.PonyTownService"
           android:exported="false"
           android:foregroundServiceType="dataSync"/>
  ```

---

## JavaScript Injector

- **Class:** `town.pony.game.mod.JsInjector` — path `decoded/smali/town/pony/game/mod/JsInjector.smali`. Separate from the game's own code; the game's JavaScript is never modified.
- **Hostname gate (`isPonyTownUrl`):** real host parsing via `android.net.Uri.getHost()` + lowercase; script runs **only** on exactly `pony.town` or a host ending in `.pony.town`. Lookalikes such as `pony.town.evil-example.com` are rejected (plan.md §8). *Note: an inverted condition in this gate was found during Stage-3 review and fixed (`if-nez`→`if-eqz`) — the shipped APK contains the corrected gate, verified in the built dex.*
- **Mode 1 — document-start (fallback):** true document-start via androidx.webkit is unavailable in this APK (R8 stripped the API). Fallback implemented: hook in `y5/m.onPageStarted` → `JsInjector.onPageStarted(webView, url)` injects the wrapped script inside a one-shot DOM-ready guard with a bounded in-JS retry (max 20 × 100 ms) and a per-page flag so it never double-runs.
- **Mode 2 — page-finished:** hook in `y5/m.onPageFinished` → `JsInjector.onPageFinished(webView, url)` injects the plain wrapper. This is the guaranteed path.
- **Script source (`custom.js`):** read as text, never hardcoded. Priority:
  1. External app storage: `/Android/data/town.pony.game/files/scripts/custom.js` (via `Context.getExternalFilesDir("scripts")` — no storage permission needed)
  2. Fallback: internal `getFilesDir()/scripts/custom.js`
  
  The `scripts/` directories are auto-created so drop-in is easy. Missing/empty file → silent no-op.
- **Wrapper (plan.md §7):** the file contents are injected inside an IIFE with error isolation:
  ```js
  (function() {
    try {
      // custom user script
    } catch (error) {
      console.error("Custom Script Error:", error);
    }
  })();
  ```
- **Safety:** every entry point is fully defensive (try/catch Throwable), file reads capped at 1 MiB, and a non-pony.town URL is a silent no-op. No permissions added beyond Stage 2's.

---

## Build Status

- **SUCCESS** — `apktool b decoded` (apktool 2.10.0, JDK 17, bundled aapt; no Android SDK required). Exit code 0.
- Output: `decoded/dist/ponytown-patched.apk` (2,275,925 bytes).
- Round-trip re-decode of the built APK verified: `PonyTownService` present, `JsInjector` present with corrected gate, both WebView hooks in the right callbacks, manifest differs from the original by exactly the 4 Stage-2 lines.

### What could NOT be verified (honest limits)
- **No on-device runtime test was possible** (no emulator/device in this environment). First real test: sign with MT Manager, install, launch.
- Android 13+: the notification only shows after the user allows notifications for the app (the permission is declared but not runtime-requested; it appears in the app's settings).
- Android 15: a `dataSync` foreground service has a ~6h-per-24h system budget before it can be stopped (`onTimeout`). Acceptable for a personal keep-alive mod; using `specialUse` would avoid it but requires a Play-facing property string and isn't appropriate here.
- Swiping the game away from Recents stops the service by default (`stopWithTask` default) — expected behavior, matching the "starts when the app opens" design.

---

## How to Sign & Install (MT Manager)

1. Copy `decoded/dist/ponytown-patched.apk` (or take the whole `decoded/` folder as project) into MT Manager.
2. Rebuild/sign with your own key (the APK is unsigned by design).
3. Install on a device running Android 8+ (API 26+). Android 13+ devices: allow notifications for Pony Town after first launch.
4. Optional custom JS: create `/Android/data/town.pony.game/files/scripts/custom.js` (external) or the internal equivalent, and it will be injected on `pony.town` pages.

---

## Update 2026-10-07 — injector fix + background disconnect fix

Found by reading the smali (not yet verified on a device). Rebuilt with apktool 2.10.0: build OK, round-trip decode OK.

### Injector never loaded — causes and fixes
1. `JsInjector.isEmpty` / `PtModBridge.isEmptyText` were inverted (non-empty text returned `true`). Result: an external `custom.js` was treated as empty and skipped, and a missing script hit `String.concat(null)`. **Fixed** (`if-nez` → `if-eqz`), callers flipped accordingly.
2. `PtModBridge.ensureBridge` had an inverted `instance-of Activity` check, so `sActivity` was never set and `pickScript()` did nothing. **Fixed**, and it now unwraps `ContextWrapper` chains to find the Activity.
3. `addJavascriptInterface` only becomes visible to JS on the *next* page load, but the bridge was registered in `onPageFinished`. **Fixed**: the bridge is now also registered right after the game's own `"Android"` interface in the `PonyTownWebViewImpl` constructor (new tracked file `ui/webview/PonyTownWebViewImpl.smali`). `PtModBridge` stays gated: scripts only run on `pony.town` / `*.pony.town`.
4. Workaround: a script picked with **LOAD SCRIPT** is now saved to internal `files/scripts/custom.js` and auto-loads on every launch (picking an empty file clears it). The small LOAD SCRIPT button is always shown (55% opacity). An external `custom.js` still takes priority over the saved one.

### Kicked from server after long background — cause and fix
`PonyTownWebViewImpl.e()` (the lifecycle `onStop`) calls `WebView.pauseTimers()`. That freezes the game's JS timers while the foreground service keeps the process alive, so heartbeats stop and the server drops the connection. **Fixed**: the `pauseTimers()` call is removed. Volume is still muted on stop. Not changed: Doze / Wi-Fi power-save can still drop sockets on some devices; if kicks continue, a user-enabled WifiLock is the next option.

Modified in this update: `JsInjector.smali`, `PtModBridge.smali`, `PonyTownWebViewImpl.smali` (new).
---

## Update 2026-10-07 (2) — Mod UI: script manager, virtual mouse, on-screen keys

Built with apktool 2.10.0 (OK) and `ui.js` smoke-tested in desktop Chromium against a fake bridge. **Not run on a device** — native input delivery (hover/click/keys into the WebView) is verified only by compiling, so test it first.

### How it is wired
- A draggable **PT** launcher button (replaces the old red LOAD SCRIPT button) opens a panel with tabs **Scripts / Mouse / Keys / About**.
- `assets/ptmod/ui.js` (new) is injected by `JsInjector` at `onPageStarted`, `onPageCommitVisible` and `onPageFinished` — pony.town only, idempotent. It is wrapped with a per-process random token; `PtModBridge` ignores any call without that token.
- `PtModBridge` (rewritten) exposes `pickScript / exec / mouseMove / mouseBtn / key`. `PtInput` (new) posts real `MotionEvent`s (`TOOL_TYPE_MOUSE`, `SOURCE_MOUSE`) and `KeyEvent`s onto the WebView UI thread, so hover, `:hover` and `isTrusted` events work like a physical mouse/keyboard.
- All hooks in `y5/m` and `PonyTownWebViewImpl` are wrapped in `try/catch Throwable`.

### Scripts tab
Load `.js` from the file picker, New (paste), View/Edit, Run, Remove, enable/disable checkbox, and a run timing per script (`start` / `ready` / `load`). Scripts live in the pony.town origin's localStorage and run automatically on every page load. Disabling or removing stops it fully after a page reload. Legacy `files/scripts/custom.js` still works.

### Mouse tab
- On/off, **type: Touch** (cursor follows finger; press = click, drag = drag) or **Trackpad** (swipe moves, tap = left click, tap-and-hold = drag, two-finger tap = right click, on-screen L/R buttons).
- Sensitivity, cursor visibility and size.
- "Report hover/fine pointer" makes `matchMedia('(hover:hover)')` / `(pointer:fine)` (and `any-*`) return true while the mouse is on, and fires `change` listeners.
- Built-in hover test area. Page scripts can read `window.ptmod.mouse` and listen for the `ptmod:mouse` event.
- While the mouse is on, the page's own touch events are blocked (touch becomes mouse), except over the mod UI.

### Keys tab
On-screen key buttons (A–Z, 0–9, arrows, Space, Shift, Ctrl, Alt, Tab, Esc, Enter, Backspace). Presets: WASD, WASD + Space/Shift, Arrows. Add/remove keys, change key and size, drag to arrange (Edit layout), opacity. Sent as real Android key events (native) or synthetic page events.

### Limits
- Multi-touch holding several keys works through pointer events; actual feel on your device is untested.
- Modifier buttons don't set `shiftKey`/`ctrlKey` on other keys.
- Games that read raw touch only (not mouse) ignore the virtual mouse.
- The panel/cursor render inside the page; if the game opens a fullscreen element they may be hidden.

Files: `PtInput.smali` (new), `PtModBridge.smali`, `JsInjector.smali`, `y5/m.smali`, `PonyTownWebViewImpl.smali`, `assets/ptmod/ui.js` (new).


## Update 2026-10-07 (3) — native mouse click + scroll branch

Branch: fix/native-mouse-click-scroll

- Mouse button events now use ACTION_BUTTON_PRESS/ACTION_BUTTON_RELEASE through dispatchGenericMotionEvent instead of ACTION_DOWN/ACTION_UP through dispatchTouchEvent.
- Left/right button identity is carried through MotionEvent.setActionButton(); drag movement remains generic SOURCE_MOUSE with the held button state.
- Added native ACTION_SCROLL using AXIS_HSCROLL and AXIS_VSCROLL.
- Trackpad mode now supports two-finger scrolling and on-screen up/down scroll buttons.
- Added .github/workflows/rebuild-patched-apk.yml to rebuild the tracked decoded APK with Apktool 2.10.0 and upload the unsigned APK artifact.
- Runtime behavior is not device-verified here.

## Update 2026-10-08 — trackpad: move while L/R is held

- **Bug:** with the on-screen L/R button held, the cursor could not move. `ui.js` counted the finger resting on the L/R button as a second finger, so every swipe was treated as a two-finger scroll gesture; `tp.id` also stayed set after the game finger lifted, so the next touch was lost.
- **Fix (`decoded/assets/ptmod/ui.js`):** only fingers that are not on the mod UI count toward the two-finger gesture (`gameTouches`); tracking resets when the last game finger lifts; taps and tap-then-hold are ignored while an L/R button is held (they used to release it); L/R release also handles `lostpointercapture`.
- **Drag test:** Mouse tab now has a drag-test box (ball follows the cursor while held, plus an HTML5 draggable chip and drop zone) and counters for down / move(held) / up / dragstart / drop, so drag and drop can be verified on a device.
- Not verified on a device yet.

## Update 2026-10-08 (2) — drag did not move the page/UI

- **Cause:** while a button was held, `PtInput` sent `ACTION_MOVE` through `dispatchGenericMotionEvent`. Android routes generic pointer events to `WebView.onGenericMotionEvent`, which Chromium only uses for button press/release and scroll; mouse moves are only accepted via the hover path (`ACTION_HOVER_MOVE`). So the page never received `mousemove` while a button was down (cursor moved visually, nothing dragged).
- **Fix:** move-while-held now sends `ACTION_HOVER_MOVE` carrying the pressed-button state (method 0, default).
- **Mouse tab → "Drag method":** `Hover-move + button` (default), `Move, generic` (old behaviour), `Move, touch path`, `Hover + touch`. Encoded in the high bits of `buttons` for `mouseBtn` phase 2 (no new bridge API).
- **Tap-then-hold window** widened from 280 ms to 350 ms.
- Not verified on a device yet.

## Update 2026-10-08 (3) — in-game UI ignores drag while custom-script UI reacts

Finding from device testing: after the hover-move fix a draggable bubble created by a custom script drags correctly, but in-game UI does not. So native mouse events reach the page; the game's own UI likely listens to different events (touch/pointer) or filters pointer type. Two tools added to find/work around it without guessing:

- **Debug tab → Event spy:** logs the events the page receives (type, real target element, `isTrusted`, pointer type, buttons; moves only while a button is down). Turn on, close the panel, drag something in the game, reopen the tab.
- **Mouse tab → "Also emit touch events on press/drag (compat)":** off by default. When on, mouse press/drag/release at the cursor also dispatches script-made `touchstart/touchmove/touchend` on the element under the cursor, for UI that only handles touch. The mod's own touch handler ignores non-trusted events, so there is no feedback loop. Side effect: a click may be seen twice (touch tap + mouse click) by some UI.
- Not verified on a device yet.
