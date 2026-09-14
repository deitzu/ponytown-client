#
# PonyTown Mod (Stage 3): custom JavaScript injector for the game WebView.
#
# - Hostname gate: inject ONLY when the page host is exactly "pony.town"
#   or a subdomain matching "*.pony.town" (real host parsing via
#   android.net.Uri.getHost(); never url.contains()).
# - Script source: <external files>/scripts/custom.js first
#   (= /Android/data/town.pony.game/files/scripts/custom.js via
#   Context.getExternalFilesDir("scripts") -- no storage permission needed),
#   falls back to <internal files>/scripts/custom.js. The scripts
#   directories are created if missing to make drop-in easy.
# - Doc-start path (onPageStarted): injects the §7 try/catch wrapper inside a
#   one-shot DOM-ready guard with a bounded in-JS retry so the first attempt
#   being "too early" recovers automatically, with no double execution from
#   this path (per-page flag).
# - Page-finished path (onPageFinished): injects the plain §7 wrapper.
# - Never throws: every entry point is fully defensive; a missing/empty file
#   or a non-pony.town URL is a silent no-op.
#
# DIAG instrumentation (branch diag/instrument): onPageStarted/onPageFinished
# log one line per stage ("... webview=null", "... url=<url> gate=<0|1>",
# "... file=<0|1> size=<n>", "... injected") via appendLog() -> logcat tag
# "PTMod" AND /Android/data/town.pony.game/files/ptmod-diag.log, and show a
# Toast "PTMod: custom.js loaded (<size>B)" on successful injection. Script
# contents are NEVER logged (size only). Behavior is otherwise identical to
# the plain Stage 3 injector.
#
# No permissions added. No WakeLock. Does not touch PonyTownInterface,
# auth, billing, or the game's own JS.
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
# Earliest-safe injection: evaluates the custom script wrapped in the §7
# try/catch IIFE inside a one-shot DOM-ready guard. If the document does
# not exist yet, the wrapper retries in-JS (max 20 x 100 ms) and then gives
# up silently -- the onPageFinished path is the guaranteed fallback.
# DIAG: logs each decision point (see header) and a Toast on success.
# ---------------------------------------------------------------------------
.method public static onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 6

    if-nez p0, :goto_gate

    const-string v0, "onPageStarted webview=null"

    invoke-static {p0, v0}, Ltown/pony/game/mod/JsInjector;->appendLog(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :goto_gate
    invoke-static {p1}, Ltown/pony/game/mod/JsInjector;->isPonyTownUrl(Ljava/lang/String;)Z

    move-result v0

    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "onPageStarted url="

    invoke-virtual {v2, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, " gate="

    invoke-virtual {v1, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v0}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {p0, v1}, Ltown/pony/game/mod/JsInjector;->appendLog(Landroid/content/Context;Ljava/lang/String;)V

    if-eqz v0, :goto_ret

    invoke-virtual {p0}, Landroid/webkit/WebView;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Ltown/pony/game/mod/JsInjector;->readCustomScript(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ltown/pony/game/mod/JsInjector;->isEmpty(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :goto_size_zero

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v0

    goto :goto_size_done

    :goto_size_zero
    const/4 v0, 0x0

    :goto_size_done
    const-string v4, "onPageStarted file="

    if-nez v3, :goto_file_zero

    const-string v5, "1"

    goto :goto_file_str

    :goto_file_zero
    const-string v5, "0"

    :goto_file_str
    invoke-virtual {v4, v5}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, " size="

    invoke-virtual {v4, v5}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {p0, v4}, Ltown/pony/game/mod/JsInjector;->appendLog(Landroid/content/Context;Ljava/lang/String;)V

    if-nez v3, :goto_ret

    const-string v4, "(function(){ var _n=0; function _r(){ if (window.__ptModInjected) return; if (document && document.documentElement) { window.__ptModInjected=1; (function(){ try { "

    invoke-virtual {v4, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, " } catch(e) { console.error(\"Custom Script Error:\", e); } })(); } else if (++_n < 20) { setTimeout(_r, 100); } } _r(); })();"

    invoke-virtual {v4, v5}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {p0, v4}, Ltown/pony/game/mod/JsInjector;->evaluate(Landroid/webkit/WebView;Ljava/lang/String;)V

    const-string v4, "onPageStarted injected"

    invoke-static {p0, v4}, Ltown/pony/game/mod/JsInjector;->appendLog(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {v1, v0}, Ltown/pony/game/mod/JsInjector;->showInjectedToast(Landroid/content/Context;I)V

    :goto_ret
    return-void
.end method

# ---------------------------------------------------------------------------
# public static void onPageFinished(WebView, String url)
# Page-finished injection: plain §7 wrapper (document is guaranteed to exist).
# DIAG: logs each decision point (see header) and a Toast on success.
# ---------------------------------------------------------------------------
.method public static onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 6

    if-nez p0, :goto_gate

    const-string v0, "onPageFinished webview=null"

    invoke-static {p0, v0}, Ltown/pony/game/mod/JsInjector;->appendLog(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :goto_gate
    invoke-static {p1}, Ltown/pony/game/mod/JsInjector;->isPonyTownUrl(Ljava/lang/String;)Z

    move-result v0

    invoke-static {p1}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "onPageFinished url="

    invoke-virtual {v2, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, " gate="

    invoke-virtual {v1, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v0}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-static {p0, v1}, Ltown/pony/game/mod/JsInjector;->appendLog(Landroid/content/Context;Ljava/lang/String;)V

    if-eqz v0, :goto_ret

    invoke-virtual {p0}, Landroid/webkit/WebView;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-static {v1}, Ltown/pony/game/mod/JsInjector;->readCustomScript(Landroid/content/Context;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ltown/pony/game/mod/JsInjector;->isEmpty(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :goto_size_zero

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v0

    goto :goto_size_done

    :goto_size_zero
    const/4 v0, 0x0

    :goto_size_done
    const-string v4, "onPageFinished file="

    if-nez v3, :goto_file_zero

    const-string v5, "1"

    goto :goto_file_str

    :goto_file_zero
    const-string v5, "0"

    :goto_file_str
    invoke-virtual {v4, v5}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, " size="

    invoke-virtual {v4, v5}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v4, v5}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {p0, v4}, Ltown/pony/game/mod/JsInjector;->appendLog(Landroid/content/Context;Ljava/lang/String;)V

    if-nez v3, :goto_ret

    const-string v4, "(function(){ try { "

    invoke-virtual {v4, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, " } catch(e) { console.error(\"Custom Script Error:\", e); } })();"

    invoke-virtual {v4, v5}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {p0, v4}, Ltown/pony/game/mod/JsInjector;->evaluate(Landroid/webkit/WebView;Ljava/lang/String;)V

    const-string v4, "onPageFinished injected"

    invoke-static {p0, v4}, Ltown/pony/game/mod/JsInjector;->appendLog(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {v1, v0}, Ltown/pony/game/mod/JsInjector;->showInjectedToast(Landroid/content/Context;I)V

    :goto_ret
    return-void
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

    if-nez v0, :cond_true

    const/4 v0, 0x0

    return v0

    :cond_true
    const/4 v0, 0x1

    return v0
.end method

# ---------------------------------------------------------------------------
# private static void appendLog(Context, String msg)
# DIAG helper: appends one line "MM-DD HH:MM:SS <msg>" to logcat (tag
# "PTMod") and to Context.getExternalFilesDir("")/ptmod-diag.log
# (= /Android/data/town.pony.game/files/ptmod-diag.log). Fully defensive:
# the whole body is wrapped in try/catch Throwable so it can never throw
# into the game. A null Context still logs to logcat (file part skipped).
# ---------------------------------------------------------------------------
.method private static appendLog(Landroid/content/Context;Ljava/lang/String;)V
    .locals 4

    :try_start_0
    new-instance v0, Ljava/text/SimpleDateFormat;

    const-string v1, "MM-dd HH:mm:ss"

    invoke-direct {v0, v1}, Ljava/text/SimpleDateFormat;-><init>(Ljava/lang/String;)V

    new-instance v1, Ljava/util/Date;

    invoke-direct {v1}, Ljava/util/Date;-><init>()V

    invoke-virtual {v0, v1}, Ljava/text/SimpleDateFormat;->format(Ljava/util/Date;)Ljava/lang/String;

    move-result-object v0

    const-string v1, " "

    invoke-virtual {v0, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "PTMod"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz p0, :goto_file_done

    const-string v1, ""

    invoke-virtual {p0, v1}, Landroid/content/Context;->getExternalFilesDir(Ljava/lang/String;)Ljava/io/File;

    move-result-object v1

    if-eqz v1, :goto_file_done

    const-string v2, "ptmod-diag.log"

    new-instance v3, Ljava/io/File;

    invoke-direct {v3, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    const/4 v1, 0x1

    new-instance v2, Ljava/io/FileOutputStream;

    invoke-direct {v2, v3, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;Z)V

    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/io/FileOutputStream;->write([B)V

    const/16 v1, 0xa

    invoke-virtual {v2, v1}, Ljava/io/FileOutputStream;->write(I)V

    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V

    :goto_file_done
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0

    return-void
.end method

# ---------------------------------------------------------------------------
# private static void showInjectedToast(Context, int size)
# DIAG helper: shows "PTMod: custom.js loaded (<size>B)" after a successful
# injection. Fully defensive: try/catch Throwable, never crashes the game.
# ---------------------------------------------------------------------------
.method private static showInjectedToast(Landroid/content/Context;I)V
    .locals 2

    if-eqz p0, :goto_ret

    :try_start_0
    const-string v0, "PTMod: custom.js loaded ("

    invoke-static {p1}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "B)"

    invoke-virtual {v0, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
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