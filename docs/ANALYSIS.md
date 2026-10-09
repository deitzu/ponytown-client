> Historical Stage 1 analysis of the original APK (before any patch). Paths are relative to a full Apktool decode of the original APK.

# PonyTown APK — Stage 1 Analysis (decode + map; no patches applied)

Date: 2026-09-11 · Author: android-patch-engineer · Branch: `patch/analysis`
APK: `town.pony.game v1.3-2387_antisplit.apk` (2.2 MB)
Decoded folder: `decoded/` (this repo, untracked — see §10). All smali paths below are relative to `decoded/`.

## 1. Tooling installed & decode result

| Tool | Version / source | Result |
|---|---|---|
| OpenJDK 17 | `apt-get install -y openjdk-17-jdk-headless` (Ubuntu 24.04) | OK, `17.0.20`, at `/usr/lib/jvm/java-17-openjdk-amd64` |
| apktool | `apktool_2.10.0.jar` from iBotPeaches GitHub releases, wrapper `/usr/local/bin/apktool` | **Decode SUCCESS** (exit 0) |
| unzip / openssl | system | OK (used for manifest/signing inspection) |

- Decode command: `apktool d -f -o decoded "town.pony.game v1.3-2387_antisplit.apk"` — no `--use-aapt2` needed for decode.
- **Unmodified rebuild sanity test: SUCCESS** — `apktool b decoded` re-built a 2.2 MB APK using apktool's bundled aapt v1 (no Android SDK / aapt2 required). Stage 2 can build in this environment.
- Both `smali/` (dex) and `res/` (resources) decoded cleanly; `AndroidManifest.xml` decoded to readable XML (manifest package was **not** renamed; `renameManifestPackage: null`).

## 2. Identity & SDK levels

| Item | Value | Source |
|---|---|---|
| packageName | `town.pony.game` | AndroidManifest.xml |
| App label | `Pony Town` | `res/values/strings.xml` (`@string/app_name`) |
| versionName | `1.3-2387` | `apktool.yml` |
| versionCode | `2387` | `apktool.yml` |
| minSdkVersion | **23** (Android 6.0) | `apktool.yml` |
| targetSdkVersion | **35** (Android 15) | `apktool.yml` |
| compileSdkVersion | 36 (Android 16), codename "16" | manifest `android:compileSdkVersion` |
| Runtime | Pure Java/Kotlin, **single `classes.dex`** (1.88 MB), **no native libs** (`extractNativeLibs=false`, empty `lib/`) | apk listing |
| Signing | **Android Debug key** (`CN=Android Debug, O=Android`) — v1 (`CERT.RSA`+`CERT.SF`) plus APK Signing Block v2/v3 present | openssl over `META-INF/CERT.RSA`, `file` on APK |

## 3. Component inventory (full manifest)

**Activities**
- `town.pony.game.MainActivity` — **the only app activity**; `exported=true`, `launchMode=singleTask`, LAUNCHER; also VIEW deep-link filters:
  - `ponytown://` scheme (autoVerify)
  - `https://pony.town` + `https://*.pony.town` with `pathPrefix=/app` (autoVerify)
  - `supportsPictureInPicture=true`, `screenOrientation=fullUser`, `windowSoftInputMode=adjustResize`
- `com.android.billingclient.api.ProxyBillingActivity`, `ProxyBillingActivityV2` (Play Billing 8.0.0 library)
- `com.google.android.gms.auth.api.signin.SignInHubActivity`, `com.google.android.gms.common.api.GoogleApiActivity` (GMS libs)

**Services** (existing — none are app-owned)
- `com.google.android.gms.auth.api.signin.RevocationBoundService` (exported, permission-gated)
- `com.google.android.datatransport.runtime.backends.TransportBackendDiscovery`
- `com.google.android.datatransport.runtime.scheduling.jobscheduling.JobInfoSchedulerService`

**Receivers**
- `androidx.profileinstaller.ProfileInstallReceiver` (exported, DUMP permission)
- `com.google.android.datatransport.runtime.scheduling.jobscheduling.AlarmManagerSchedulerBroadcastReceiver`

**Providers**
- `androidx.startup.InitializationProvider` (authority `town.pony.game.androidx-startup`; initializers: EmojiCompat, ProcessLifecycle, ProfileInstaller)

**Other**: `<queries>` (https VIEW, Play Billing bind, maps), `uses-feature glEsVersion 0x20000` (hardware accelerated game), `uses-library org.apache.http.legacy` + `androidx.window.extensions/sidecar` (required=false). **No `<activity-alias>` anywhere.**

Permissions granted: `INTERNET`, `WRITE_EXTERNAL_STORAGE`, `WRITE_CLIPBOARD`, `ACCESS_NETWORK_STATE`, `com.android.vending.BILLING`, plus self-defined signature permission `town.pony.game.DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`. `usesCleartextTraffic=true`.

## 4. Entry points & first screen

- **There is NO custom Application class** — manifest `<application>` has no `android:name`; `android:appComponentFactory="androidx.core.app.CoreComponentFactory"`.
- **Only launcher = `MainActivity`** (`town.pony.game.MainActivity`, `smali/town/pony/game/MainActivity.smali`, `onCreate(Landroid/os/Bundle;)V` at line 71; class extends `Lg/i;` → `Lb1/y;` → androidx AppCompat activity chain, Java).
- First screen: `MainActivity.setContentView(FrameLayout)` (line 288) whose only child is the **PonyTownWebViewImpl** WebView. Normal launch flow:

```
MainActivity.onCreate
 └─ new Ly5/f (WebView controller/DTO, smali/y5/f.smali)
 └─ new PonyTownWebViewImpl(activity, controller, FrameLayout)   (line 223-227)
     └─ WebView config + clients + JS bridge (see §6)
 └─ setContentView (line 288)
 └─ loadUrl( n4/k.s(getIntent().getData()) )                     (lines 293→321→337)
     where n4/k.s(Uri) = "URI resolver": null → "https://pony.town/" (default),
     "ponytown" scheme → server selector, https → host-validated game URL
```

- Deep links while running are handled in `MainActivity.onNewIntent(Intent)` (line 464): only `ponytown://` or `https://…(<host>.endsWith("pony.town"))` are accepted, then `n4/k.s()` → `loadUrl()`.

## 5. WebView implementation map (who owns what)

| Concern | Class | Smali path (relative to `decoded/`) |
|---|---|---|
| **WebView subclass (owns the view)** | `town.pony.game.ui.webview.PonyTownWebViewImpl` | `smali/town/pony/game/ui/webview/PonyTownWebViewImpl.smali` |
| Base WebView class | `y5.a` (super of impl: `Landroid/webkit/WebView;` + LifecycleOwner) | `smali/y5/a.smali` |
| **WebViewClient** (page lifecycle) | `y5.m` (subclass of `android.webkit.WebViewClient`) | `smali/y5/m.smali` |
| **WebChromeClient** (progress, file chooser) | `y5.o` (subclass of `android.webkit.WebChromeClient`) | `smali/y5/o.smali` |
| WebView controller / URL policy | `y5.f` (holds `w` = currentMainServer Uri, default `https://pony.town/`) | `smali/y5/f.smali` |
| JS→native bridge (name `"Android"`) | `town.pony.game.ui.webview.PonyTownInterface` | `smali/town/pony/game/ui/webview/PonyTownInterface.smali` |
| URI resolver (builds game URL) | `n4.k.s(Landroid/net/Uri;)Landroid/net/Uri;` (line 3118) | `smali/n4/k.smali` |
| Download listener | `y5.k` | `smali/y5/k.smali` |
| File-chooser ValueCallback continuations | `y5.p`, `y5.q`, `y5.h` (continuations/lambdas on impl) | `smali/y5/{p,q,h}.smali` |
| Error-dialog "Retry/Quit" listener | `y5.b` (calls `impl.loadUrl(currentMainServer)`) | `smali/y5/b.smali` |

All of the app's own WebView classes are **R8-obfuscated into `y5.*`** (source `r8-map-id-72568c…`); the class names in the table are bytecode names — the original Java names (e.g. `PonyTownWebViewClient`) are gone. **Patch work must target `y5.*` exactly as they are.**

### WebView setup (all inside `PonyTownWebViewImpl.<init>` line 267)
- `getSettings().setJavaScriptEnabled(true)` (line 1026) — **JavaScript enabled**
- `setJavaScriptCanOpenWindowsAutomatically(true)`, `setDomStorageEnabled(true)`, `setUseWideViewPort(true)`, `setTextZoom(100)`, `setMediaPlaybackRequiresUserGesture(false)`, `setBuiltInZoomControls(false)`, `setSupportZoom` implied, UA suffix ` PonyTownApp/1.3`
- `CookieManager.setAcceptThirdPartyCookies(webView, true)`
- `setWebViewClient(new y5.m(this))` (line 1149), `setWebChromeClient(new y5.o(this))` (line 1163), `setDownloadListener(y5.k)`
- `addJavascriptInterface(new PonyTownInterface(controller), "Android")` (line 1190)
- External-links handling: `y5.m.shouldOverrideUrlLoading` → `y5.f.m(Uri)` (line 1067) — the centralized URL policy (scheme switch incl. `https`, host validation `getHost().equals("pony.town") || host.endsWith("pony.town")`, updates `w` = currentMainServer, opens external browser for non-pony hosts)

### URL loading
- `PonyTownWebViewImpl.loadUrl(String)` / `loadUrl(String, Map)` override `WebView.loadUrl` (lines 2394/2429) and also handle the offline-asset page (`file:///android_asset/offline.html`, in `assets/offline.html`).
- Default page: **`https://pony.town/`** — used as initial URI (via `n4/k.s(null)`) and stored in `y5.f.w` (default from constructor line 177). Dynamic URL building only in `n4/k.s()` (ponytown:// server-selector → `<scheme>://<host>/app/…`), never hardcoded concatenation of the game URL in the WebView classes.

## 6. Startup analysis — where to start the Foreground Service

**Recommended hook: `MainActivity.onCreate(Landroid/os/Bundle;)V`** — `decoded/smali/town/pony/game/MainActivity.smali` line 71.
Reasoning:
1. **No Application class exists**, so `Application.onCreate()` would require creating a brand-new smali Application subclass **and** adding `android:name` to the manifest — more invasive, and a second Android-12+ concern: a FGS started during `Application.onCreate` before any activity is visible can hit `ForegroundServiceStartNotAllowedException` on some cold-start paths.
2. `MainActivity.onCreate` runs while the activity is (about to be) foreground — `startForegroundService()` here is the standard, lowest-risk point, and it runs exactly on "app opened" per plan.md.
3. Insertion point: after `super.onCreate(...)` near the top of the method (line 71), or right after `setContentView` (line 288) — before the first `loadUrl` (line 337) is fine either way.

**Alternate hook**: a new `Application` subclass (e.g. `town.pony.game.PonyTownApp` extending `android.app.Application`) with manifest `android:name`, calling `startForegroundService` in `onCreate()`. Works, but patch is bigger and must preserve `androidx.core.app.CoreComponentFactory` (`appComponentFactory` attribute is untouched by adding `android:name`).

Guard for Android 12+/13+ (targetSdk 35): wrap the start in try/catch for `ForegroundServiceStartNotAllowedException`/`SecurityException`, or check `ActivityManager.isBackgroundRestricted()`; the service itself must call `startForeground()` with a valid notification within 5 s (channel creation on API 26+).

## 7. Injection analysis

### Page-finished injection — AVAILABLE (primary)
- Hook: **`y5.m.onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V`** — `decoded/smali/y5/m.smali` line 260. Fires after every finished main-frame page.
- The app **already evaluates JavaScript at this exact point**: it calls `impl.h("Android.onBackgroundColor(...)")`.
- **`PonyTownWebViewImpl.h(Ljava/lang/String;)V`** (line 2336) is the app's existing evaluateJavascript primitive: wraps the script in `try { … }catch(ex){ console.error('Error in App-side JS execution:', ex);}` and calls `WebView.evaluateJavascript(script, null)` (line 2386). Exactly matches plan.md §7's error-wrapper requirement. Our injector can reuse `h()` or call `evaluateJavascript` directly with its own wrapper.

### Document-start injection — **NOT usable out of the box**
- The APK **bundles androidx.webkit 1.14.0 boundary interfaces** (`META-INF/androidx.webkit_webkit.version` = `1.14.0`; `org/chromium/support_lib_boundary/ScriptHandlerBoundaryInterface.smali`, `WebViewProviderBoundaryInterface.smali` with `addDocumentStartJavaScript`, etc.).
- **BUT the androidx.webkit API/glue classes have been stripped by R8**: there is no `androidx/webkit/` package in `smali/`, and **no class anywhere references or implements the boundary interfaces**. `WebViewCompat.addDocumentStartJavaScript` therefore does **not** exist at runtime → `NoClassDefFoundError` if called.
- Re-adding androidx.webkit by hand-writing smali is not realistic (no Gradle per plan.md §2; the full lib is ~1.5 MB of code).
- **Fallback (recommended): earliest-injection via `WebViewClient.onPageStarted(WebView, String, Bitmap)`** — `y5/m.smali` line 340 (fires when navigation begins, before page render). `evaluateJavascript` there needs the document to exist, so the robust pattern is a tiny retry probe (evaluate a self-removing `if(document.documentElement){…}` loop a few times, or inject on `DOMContentLoaded` from a script that is itself injected at onPageStarted; `setDomStorageEnabled` + JS being enabled makes this viable). Note honestly in the final patch: true "document start (before any page JS)" semantics are NOT achievable without androidx.webkit; we get "as early as the app can".
- Note: `y5.m.onPageCommitVisible(WebView, String)` (line 235, API 23+) is another early callback that could be used as an additional trigger.

### Hostname gate for the injector
- The app's own policy (`y5.f.m(Uri)`, line 1067 region) accepts `host.equals("pony.town") || host.endsWith("pony.town")`. For our injector, plan.md §8 demands a stricter parse — use `Uri.parse(url).getHost()` and require `host.equals("pony.town") || host.endsWith(".pony.town")` (dot-prefixed subdomain), **not** raw `contains`, in the new code. The injector can reuse the `url` String parameter of `onPageFinished`/`onPageStarted` directly.

### Script storage
- Read `custom.js` from app-private external files: `context.getExternalFilesDir("scripts")/custom.js` → `/Android/data/town.pony.game/files/scripts/custom.js` (no permission needed on API 19+ for own app dir; `WRITE_EXTERNAL_STORAGE` already declared for legacy paths). Fallback: internal `context.getFilesDir()/scripts/custom.js` (plan.md §6).

## 8. Unusual observations

1. **"antisplit" filename**: the APK is a merged/single APK (one `classes.dex`, no `lib/`, no `assets/index.*`) — original Pony Town ships split per-ABI; this is an antisplit-merge build. No split manifest entries remain.
2. **Signed with the Android debug key** (`CN=Android Debug`) + APK Signing Block (v2/v3) — i.e. the "original" is already debug-signed; the owner will re-sign with MT Manager (fine — plan says never sign).
3. **Heavy R8 obfuscation** with `r8-map-id-…` source names on every app class; single-letter package obfuscation (`a`..`z5`). Resource IDs are standard (no resource obfuscation).
4. **No custom Application, no app-owned Service/Receiver** — manifest is lean; adding one `<service>` + `FOREGROUND_SERVICE` permission is low-risk.
5. `usesCleartextTraffic=true` + `WRITE_EXTERNAL_STORAGE` + `WRITE_CLIPBOARD` are pre-existing (do not "add" them).
6. Play Billing 8.0.0 + GMS auth/sign-in + datatransport/firebase libs present — proves the app does IAP/Google auth flows inside the WebView bridge (`PonyTownInterface` exposes `tryRunTransaction`, `getActivePurchases`, etc.). **Do not touch these** (plan.md §10).
7. `supportsPictureInPicture=true` + `singleTask` + `fullUser` rotation: the activity can be backgrounded w/o being destroyed — relevant for FGS design (service keeps the process alive, notification is the persistent signal).
8. Kotlin (kotlinx-coroutines present, `kotlin/` dir), all app code compiled to Java-compatible smali (no interface default-method surprises except standard).
9. No `configChanges` handling of `keyboard|navigation` in MainActivity (only orientation family) — irrelevant to patch, noted for completeness.

## 9. Recommended Stage-2 hook points (exact anchors)

| Patch | Target | Smali path | Anchor |
|---|---|---|---|
| Start FGS on app open | `MainActivity.onCreate` | `town/pony/game/MainActivity.smali` | `.method public final onCreate(Landroid/os/Bundle;)V` line 71; insert after `super.onCreate`/before `loadUrl` (line 337), or right after `setContentView` (line 288) |
| New `<service>` + permission | `AndroidManifest.xml` | `decoded/AndroidManifest.xml` | add `FOREGROUND_SERVICE` (and `POST_NOTIFICATIONS` for 13+ if we want the notification visible) + `<service android:name="…" android:exported="false"/>` |
| Page-finished JS injection | `y5.m.onPageFinished` | `y5/m.smali` | line 260 (call new injector after existing `h()` call, before `invoke-super`) |
| Early JS injection (doc-start fallback) | `y5.m.onPageStarted` | `y5/m.smali` | line 340 |
| Injection primitive | `PonyTownWebViewImpl.h(String)` | `town/pony/game/ui/webview/PonyTownWebViewImpl.smali` | line 2336 (reuse; already try/catch-wraps + evaluateJavascript) |
| Hostname gate | new injector code | new class e.g. `town/pony/game/inject/CustomJsInjector.smali` | check `Uri.parse(url).getHost()` vs `pony.town` / `.pony.town` suffix |

New classes should go under `town/pony/game/` package paths (create `smali/town/pony/game/…`). Keep smali register counts correct when editing (plan.md §11).

## 10. Working-tree state

- `decoded/` (29 MB) is **untracked** (gitignored) but present in the working tree for Stage 2 — do not delete.
- This file is committed on branch `patch/analysis`; PR into `main` opened.
- Tooling lives at `/usr/local/bin/apktool` + `/opt/apktool/apktool.jar` + JDK at `/usr/lib/jvm/java-17-openjdk-amd64` (persists across sessions on this machine).

## 11. Risks / notes for the lead

- FGS on Android 12+ (targetSdk 35): must call `startForeground()` promptly; `ForegroundServiceStartNotAllowedException` possible if started while backgrounded — our chosen hook (activity onCreate) avoids the common failure; still wrap in try/catch.
- Android 13+ wants `POST_NOTIFICATIONS` runtime permission for the notification to be *visible* — without it the service still runs but the notification is hidden (FGS proper works). Decide whether to add + request it (plan.md: don't add unnecessary permissions; flag for owner decision).
- Document-start (pre-page-JS) injection is NOT achievable with the shipped androidx.webkit (glue stripped). Plan around onPageStarted + retry/DOMContentLoaded fallback, or evaluate at onPageFinished only. This is the single biggest deviation risk vs plan.md §5 Mode 1.
- The app already calls `evaluateJavascript` on page finish — hooking there is natural and low-risk; never modify `PonyTownInterface` (auth/billing bridge).
- Build toolchain is verified end-to-end (decode + rebuild ok). Rebuilt APK is unsigned by design; owner signs with MT Manager.