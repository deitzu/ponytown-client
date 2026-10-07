#
# PonyTown Mod: injector for the game WebView.
#
# What gets injected (pony.town / *.pony.town ONLY -- real host parsing via
# android.net.Uri.getHost(); never url.contains()):
#   1. The built-in mod UI (assets/ptmod/ui.js): script manager, virtual
#      mouse, on-screen keys.  It is wrapped as
#        (function(__PT_TOKEN){ <ui.js> })("<per-process token>");
#      so only this script knows the token needed to call PtModBridge.
#      The script is idempotent (window.__ptmodLoaded), so injecting it from
#      onPageStarted / onPageCommitVisible / onPageFinished is safe.
#   2. Legacy custom.js (kept): <external files>/scripts/custom.js first, then
#      <internal files>/scripts/custom.js, run once per document inside a
#      try/catch IIFE.
# Never throws: every entry point is fully defensive.
#
# No permissions added. No WakeLock. Does not touch PonyTownInterface, auth,
# billing, or the game's own JS.
#
.class public final Ltown/pony/game/mod/JsInjector;
.super Ljava/lang/Object;

# direct methods

.method private constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

# ---------------------------------------------------------------------------
# public static boolean isPonyTownUrl(String url)
# Real hostname gate: "pony.town" exactly, or ends with ".pony.town".
# "pony.town.evil-example.com" -> false (plan.md §8).
# ---------------------------------------------------------------------------
.method public static isPonyTownUrl(Ljava/lang/String;)Z
    .locals 3

    if-eqz p0, :cond_ret_false

    :try_start_0
    invoke-static {p0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    invoke-virtual {v0}, Landroid/net/Uri;->getHost()Ljava/lang/String;

    move-result-object v1
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    if-eqz v1, :cond_ret_false

    invoke-virtual {v1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v1

    const-string v2, "pony.town"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_ret_true

    const-string v2, ".pony.town"

    invoke-virtual {v1, v2}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_ret_false

    :cond_ret_true
    const/4 v0, 0x1

    return v0

    :cond_ret_false
    const/4 v0, 0x0

    return v0

    :catch_0
    move-exception v0

    const/4 v0, 0x0

    return v0
.end method

# ---------------------------------------------------------------------------
# public static void onPageStarted(WebView, String url)
# Also called from onPageCommitVisible (earliest point the new document exists).
# ---------------------------------------------------------------------------
.method public static onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 1

    :try_start_0
    if-eqz p0, :goto_ret

    invoke-static {p1}, Ltown/pony/game/mod/JsInjector;->isPonyTownUrl(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :goto_ret

    invoke-static {p0}, Ltown/pony/game/mod/JsInjector;->inject(Landroid/webkit/WebView;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# public static void onPageFinished(WebView, String url)
# Guaranteed path.  Also makes sure the PtModBridge JS interface exists.
# ---------------------------------------------------------------------------
.method public static onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 1

    :try_start_0
    invoke-static {p0}, Ltown/pony/game/mod/PtModBridge;->ensureBridge(Landroid/webkit/WebView;)V

    if-eqz p0, :goto_ret

    invoke-static {p1}, Ltown/pony/game/mod/JsInjector;->isPonyTownUrl(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :goto_ret

    invoke-static {p0}, Ltown/pony/game/mod/JsInjector;->inject(Landroid/webkit/WebView;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# private static void inject(WebView)   (URL gate already passed)
# ---------------------------------------------------------------------------
.method private static inject(Landroid/webkit/WebView;)V
    .locals 0

    invoke-static {p0}, Ltown/pony/game/mod/JsInjector;->injectUi(Landroid/webkit/WebView;)V

    invoke-static {p0}, Ltown/pony/game/mod/JsInjector;->injectLegacy(Landroid/webkit/WebView;)V

    return-void
.end method

# ---------------------------------------------------------------------------
# private static void injectUi(WebView)
# Reads assets/ptmod/ui.js and evaluates it wrapped with the bridge token.
# ---------------------------------------------------------------------------
.method private static injectUi(Landroid/webkit/WebView;)V
    .locals 4

    :try_start_0
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, "ptmod/ui.js"

    invoke-static {v0, v1}, Ltown/pony/game/mod/JsInjector;->readAsset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ltown/pony/game/mod/JsInjector;->isEmpty(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :goto_ret

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "(function(__PT_TOKEN){"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\n})("

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Ltown/pony/game/mod/PtModBridge;->token()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ");"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {p0, v2}, Ltown/pony/game/mod/JsInjector;->evaluate(Landroid/webkit/WebView;Ljava/lang/String;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# private static void injectLegacy(WebView)
# custom.js (external, then internal) -- once per document.
# ---------------------------------------------------------------------------
.method private static injectLegacy(Landroid/webkit/WebView;)V
    .locals 3

    :try_start_0
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0}, Ltown/pony/game/mod/JsInjector;->readCustomScript(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ltown/pony/game/mod/JsInjector;->isEmpty(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :goto_ret

    const-string v0, "(function(){ if (window.__ptModInjected) return; window.__ptModInjected=1; try { "

    invoke-virtual {v0, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, " } catch(e) { console.error(\"Custom Script Error:\", e); } })();"

    invoke-virtual {v0, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {p0, v0}, Ltown/pony/game/mod/JsInjector;->evaluate(Landroid/webkit/WebView;Ljava/lang/String;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# private static String readAsset(Context, String name)
# Reads an APK asset fully as UTF-8 text; null when missing/unreadable.
# ---------------------------------------------------------------------------
.method private static readAsset(Landroid/content/Context;Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v0

    invoke-virtual {v0, p1}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v1

    new-instance v2, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v2}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v3, 0x2000

    new-array v3, v3, [B

    :goto_loop
    invoke-virtual {v1, v3}, Ljava/io/InputStream;->read([B)I

    move-result v4

    if-ltz v4, :goto_done

    const/4 v5, 0x0

    invoke-virtual {v2, v3, v5, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_loop

    :goto_done
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    const-string v3, "UTF-8"

    invoke-virtual {v2, v3}, Ljava/io/ByteArrayOutputStream;->toString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception v0

    const/4 v0, 0x0

    return-object v0
.end method

# ---------------------------------------------------------------------------
# private static void evaluate(WebView, String js)
# Defensive wrapper around evaluateJavascript: the game must never crash
# because of script injection (e.g. pre-commit navigation).
# ---------------------------------------------------------------------------
.method private static evaluate(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 1

    :try_start_0
    const/4 v0, 0x0

    invoke-virtual {p0, p1, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# private static boolean isEmpty(String)
# ---------------------------------------------------------------------------
.method private static isEmpty(Ljava/lang/String;)Z
    .locals 1

    if-eqz p0, :cond_true

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    if-eqz v0, :cond_true

    const/4 v0, 0x0

    return v0

    :cond_true
    const/4 v0, 0x1

    return v0
.end method

# ---------------------------------------------------------------------------
# private static String readCustomScript(Context)
# Priority 1: getExternalFilesDir("scripts")/custom.js (app-specific
# external dir, /Android/data/town.pony.game/files/scripts/custom.js --
# no storage permission required on API 19+).
# Priority 2: getFilesDir()/scripts/custom.js (internal, always present).
# Both scripts directories are created if missing. Empty or missing file
# is treated as "no script" (returns null).
# ---------------------------------------------------------------------------
.method private static readCustomScript(Landroid/content/Context;)Ljava/lang/String;
    .locals 3

    if-eqz p0, :goto_ret_null

    :try_start_0
    const-string v0, "scripts"

    invoke-virtual {p0, v0}, Landroid/content/Context;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    if-eqz v1, :goto_internal

    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    const-string v2, "custom.js"

    new-instance v0, Ljava/io/File;

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v0}, Ltown/pony/game/mod/JsInjector;->readFile(Ljava/io/File;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Ltown/pony/game/mod/JsInjector;->isEmpty(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :goto_internal

    return-object v0

    :goto_internal
    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v0

    const-string v1, "scripts"

    new-instance v2, Ljava/io/File;

    invoke-direct {v2, v0, v1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->mkdirs()Z

    const-string v0, "custom.js"

    new-instance v1, Ljava/io/File;

    invoke-direct {v1, v2, v0}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-static {v1}, Ltown/pony/game/mod/JsInjector;->readFile(Ljava/io/File;)Ljava/lang/String;

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :goto_ret_null
    const/4 v0, 0x0

    return-object v0

    :catch_0
    move-exception v0

    const/4 v0, 0x0

    return-object v0
.end method

# ---------------------------------------------------------------------------
# private static String readFile(File)
# Reads the whole file as UTF-8 text (capped at 1 MiB for safety).
# Returns null when the file is missing/empty/unreadable.
# ---------------------------------------------------------------------------
.method private static readFile(Ljava/io/File;)Ljava/lang/String;
    .locals 6

    :try_start_0
    if-eqz p0, :goto_ret_null

    invoke-virtual {p0}, Ljava/io/File;->isFile()Z

    move-result v0

    if-eqz v0, :goto_ret_null

    invoke-virtual {p0}, Ljava/io/File;->length()J

    move-result-wide v1

    const-wide/16 v3, 0x0

    cmp-long v5, v1, v3

    if-lez v5, :goto_ret_null

    const-wide v3, 0x100000L

    cmp-long v5, v1, v3

    if-lez v5, :goto_ok

    move-wide v1, v3

    :goto_ok
    long-to-int v5, v1

    new-array v4, v5, [B

    new-instance v0, Ljava/io/FileInputStream;

    invoke-direct {v0, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    const/4 v5, 0x0

    :goto_loop
    array-length v1, v4

    if-ge v5, v1, :goto_done

    array-length v1, v4

    sub-int v1, v1, v5

    invoke-virtual {v0, v4, v5, v1}, Ljava/io/InputStream;->read([BII)I

    move-result v1

    if-ltz v1, :goto_done

    add-int/2addr v5, v1

    goto :goto_loop

    :goto_done
    const/4 v1, 0x0

    const-string v2, "UTF-8"

    new-instance v3, Ljava/lang/String;

    invoke-direct {v3, v4, v1, v5, v2}, Ljava/lang/String;-><init>([BIILjava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/InputStream;->close()V

    return-object v3
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret_null
    const/4 v0, 0x0

    return-object v0

    :catch_0
    move-exception v0

    const/4 v0, 0x0

    return-object v0
.end method