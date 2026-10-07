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