#
# PonyTown Mod (SAF picker): JS -> native bridge that lets the page open the
# system file picker (SAF, ACTION_GET_CONTENT) and load the chosen .js file
# into the game WebView.
#
# Why: on Android 11+ raw copies into /Android/data/... are not reachable by
# the owner's tools, so the file-based custom.js drop-in cannot be tested.
# The picker hands us a content:// Uri that we can read with the app's own
# permission grant -- no storage permission needed.
#
# Security property (unchanged): a picked script is executed ONLY when the
# current page passes JsInjector.isPonyTownUrl(webView.getUrl()) -- i.e. host
# is exactly "pony.town" or a "*.pony.town" subdomain.  The picker can be
# opened from any page, but nothing runs outside pony.town.
#
# Design notes for the reviewer:
# - Plain class (no Activity subclass), instantiated once per WebView and
#   registered with WebView.addJavascriptInterface(obj, "PtModBridge").
# - It also implements Runnable so pickScript() (which JS calls on the
#   WebView JavaBridge thread) can hop to the UI thread via
#   Activity.runOnUiThread(this) before touching the picker.
# - Everything is wrapped in try/catch Throwable and never throws out.
# - Register discipline: every method keeps one register per type/role so no
#   merge point can see a register change between int and reference.  The
#   scratch int runs in its own register, object registers are never reused
#   for primitives.
# - No permissions added, no Toast, no logging.
#
.class public final Ltown/pony/game/mod/PtModBridge;
.super Ljava/lang/Object;

# interfaces

.implements Ljava/lang/Runnable;

# static fields

# Activity.requestCode for the picker (must fit in 16 bits).
.field private static final REQUEST_PICK:I = 0xc0de

# IdentityHashMap<WebView,Boolean> -- "this WebView already has the bridge".
.field private static sBridgeMap:Ljava/util/IdentityHashMap;

# Best-known Activity (from WebView.getContext()) and WebView, used by the
# picker launch and by the result handler.
.field private static sActivity:Landroid/app/Activity;

.field private static sWebView:Landroid/webkit/WebView;

# direct methods

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

# ---------------------------------------------------------------------------
# public static void ensureBridge(WebView)
# Idempotent per WebView: registers this class (named "PtModBridge") as a
# JavaScript interface the first time the WebView is seen, and remembers the
# WebView + its Activity for the picker.  Called from JsInjector.onPageFinished
# on the UI thread, so the lazy map init below needs no locking.
# ---------------------------------------------------------------------------
.method public static ensureBridge(Landroid/webkit/WebView;)V
    .locals 6

    :try_start_0
    if-eqz p0, :goto_ret

    sget-object v0, Ltown/pony/game/mod/PtModBridge;->sBridgeMap:Ljava/util/IdentityHashMap;

    if-nez v0, :goto_map_ready

    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    sput-object v0, Ltown/pony/game/mod/PtModBridge;->sBridgeMap:Ljava/util/IdentityHashMap;

    :goto_map_ready
    invoke-virtual {v0, p0}, Ljava/util/IdentityHashMap;->containsKey(Ljava/lang/Object;)Z

    move-result v5

    if-nez v5, :goto_ret

    # remember the newest WebView and, if the context is an Activity, that too
    sput-object p0, Ltown/pony/game/mod/PtModBridge;->sWebView:Landroid/webkit/WebView;

    invoke-virtual {p0}, Landroid/webkit/WebView;->getContext()Landroid/content/Context;

    move-result-object v1

    # unwrap ContextWrapper chain until the hosting Activity is found
    :goto_unwrap
    instance-of v5, v1, Landroid/app/Activity;

    if-nez v5, :goto_is_act

    instance-of v5, v1, Landroid/content/ContextWrapper;

    if-eqz v5, :goto_ctx_done

    check-cast v1, Landroid/content/ContextWrapper;

    invoke-virtual {v1}, Landroid/content/ContextWrapper;->getBaseContext()Landroid/content/Context;

    move-result-object v1

    goto :goto_unwrap

    :goto_is_act
    check-cast v1, Landroid/app/Activity;

    sput-object v1, Ltown/pony/game/mod/PtModBridge;->sActivity:Landroid/app/Activity;

    :goto_ctx_done
    new-instance v2, Ltown/pony/game/mod/PtModBridge;

    invoke-direct {v2}, Ltown/pony/game/mod/PtModBridge;-><init>()V

    const-string v3, "PtModBridge"

    invoke-virtual {p0, v2, v3}, Landroid/webkit/WebView;->addJavascriptInterface(Ljava/lang/Object;Ljava/lang/String;)V

    const/4 v5, 0x1

    invoke-static {v5}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v4

    invoke-virtual {v0, p0, v4}, Ljava/util/IdentityHashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# public void pickScript()
# Called from the page (button click) through the "PtModBridge" JS interface.
# Runs on the WebView JavaBridge thread -> hop to the UI thread, then run().
# ---------------------------------------------------------------------------
.method public pickScript()V
    .locals 1

    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_0
    sget-object v0, Ltown/pony/game/mod/PtModBridge;->sActivity:Landroid/app/Activity;

    if-eqz v0, :goto_ret

    invoke-virtual {v0, p0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# public void run()  (Runnable -- always executed on the UI thread)
# Launches the system file picker.  ACTION_GET_CONTENT + CATEGORY_OPENABLE
# needs no permission and gives us a readable content:// Uri on every
# supported Android version.  EXTRA_MIME_TYPES additionally lists the usual
# JavaScript MIME types so a .js file is selectable whichever type the
# picker/provider reports for it.
# ---------------------------------------------------------------------------
.method public run()V
    .locals 5

    :try_start_0
    sget-object v0, Ltown/pony/game/mod/PtModBridge;->sActivity:Landroid/app/Activity;

    if-eqz v0, :goto_ret

    new-instance v1, Landroid/content/Intent;

    const-string v2, "android.intent.action.GET_CONTENT"

    invoke-direct {v1, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v2, "text/*"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->setType(Ljava/lang/String;)Landroid/content/Intent;

    const-string v2, "android.intent.category.OPENABLE"

    invoke-virtual {v1, v2}, Landroid/content/Intent;->addCategory(Ljava/lang/String;)Landroid/content/Intent;

    const/4 v4, 0x4

    new-array v3, v4, [Ljava/lang/String;

    const/4 v4, 0x0

    const-string v2, "text/*"

    aput-object v2, v3, v4

    const/4 v4, 0x1

    const-string v2, "application/javascript"

    aput-object v2, v3, v4

    const/4 v4, 0x2

    const-string v2, "text/javascript"

    aput-object v2, v3, v4

    const/4 v4, 0x3

    const-string v2, "application/x-javascript"

    aput-object v2, v3, v4

    const-string v2, "android.intent.extra.MIME_TYPES"

    invoke-virtual {v1, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;[Ljava/lang/String;)Landroid/content/Intent;

    const v4, 0xc0de

    invoke-virtual {v0, v1, v4}, Landroid/app/Activity;->startActivityForResult(Landroid/content/Intent;I)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# public static void onActivityResult(int requestCode, int resultCode, Intent)
# Called from MainActivity.onActivityResult.  Reads the picked document and
# evaluates it in the stored WebView -- but only if that WebView currently
# sits on a pony.town page (see injectIntoWebView).
# ---------------------------------------------------------------------------
.method public static onActivityResult(IILandroid/content/Intent;)V
    .locals 4

    :try_start_0
    const v0, 0xc0de

    if-ne p0, v0, :goto_ret

    # Activity.RESULT_OK == -1
    const/4 v0, -0x1

    if-ne p1, v0, :goto_ret

    if-eqz p2, :goto_ret

    invoke-virtual {p2}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    move-result-object v1

    if-eqz v1, :goto_ret

    sget-object v2, Ltown/pony/game/mod/PtModBridge;->sActivity:Landroid/app/Activity;

    if-eqz v2, :goto_ret

    invoke-static {v2, v1}, Ltown/pony/game/mod/PtModBridge;->readText(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :goto_ret

    # persist so it auto-loads next launch (picking an empty file clears it)
    invoke-static {v2, v3}, Ltown/pony/game/mod/PtModBridge;->saveScript(Landroid/content/Context;Ljava/lang/String;)V

    invoke-static {v3}, Ltown/pony/game/mod/PtModBridge;->isEmptyText(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :goto_ret

    invoke-static {v3}, Ltown/pony/game/mod/PtModBridge;->injectIntoWebView(Ljava/lang/String;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# private static void saveScript(Context, String)
# Writes the picked script to <internal files>/scripts/custom.js so JsInjector
# loads it automatically on every launch (no /Android/data access needed).
# ---------------------------------------------------------------------------
.method private static saveScript(Landroid/content/Context;Ljava/lang/String;)V
    .locals 5

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getFilesDir()Ljava/io/File;

    move-result-object v0

    new-instance v1, Ljava/io/File;

    const-string v2, "scripts"

    invoke-direct {v1, v0, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/File;->mkdirs()Z

    new-instance v0, Ljava/io/File;

    const-string v2, "custom.js"

    invoke-direct {v0, v1, v2}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V

    new-instance v3, Ljava/io/FileOutputStream;

    invoke-direct {v3, v0}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    const-string v4, "UTF-8"

    invoke-virtual {p1, v4}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v3}, Ljava/io/OutputStream;->close()V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# private static void injectIntoWebView(String script)
# Hostname gate + defensive evaluate.  Same wrapper style as JsInjector.
# ---------------------------------------------------------------------------
.method private static injectIntoWebView(Ljava/lang/String;)V
    .locals 4

    :try_start_0
    sget-object v0, Ltown/pony/game/mod/PtModBridge;->sWebView:Landroid/webkit/WebView;

    if-eqz v0, :goto_ret

    invoke-virtual {v0}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ltown/pony/game/mod/JsInjector;->isPonyTownUrl(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :goto_ret

    const-string v1, "(function(){ try { "

    invoke-virtual {v1, p0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, " } catch(e) { console.error(\"Custom Script Error:\", e); } })();"

    invoke-virtual {v1, v2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Ltown/pony/game/mod/PtModBridge;->evaluate(Landroid/webkit/WebView;Ljava/lang/String;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# private static void evaluate(WebView, String js)
# Defensive wrapper around evaluateJavascript (identical shape to
# JsInjector.evaluate): the game must never crash because of injection.
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
# private static boolean isEmptyText(String)
# ---------------------------------------------------------------------------
.method private static isEmptyText(Ljava/lang/String;)Z
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
# private static String readText(Context, Uri)
# Reads the picked document through the app's own ContentResolver, capped at
# 1 MiB.  Returns null if it cannot be read.
# ---------------------------------------------------------------------------
.method private static readText(Landroid/content/Context;Landroid/net/Uri;)Ljava/lang/String;
    .locals 7

    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object v0

    invoke-virtual {v0, p1}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;

    move-result-object v1

    if-eqz v1, :goto_null

    const v3, 0x100000

    new-array v4, v3, [B

    const/4 v2, 0x0

    :goto_loop
    array-length v3, v4

    if-ge v2, v3, :goto_done

    array-length v3, v4

    sub-int v3, v3, v2

    invoke-virtual {v1, v4, v2, v3}, Ljava/io/InputStream;->read([BII)I

    move-result v3

    if-ltz v3, :goto_done

    add-int/2addr v2, v3

    goto :goto_loop

    :goto_done
    const-string v5, "UTF-8"

    const/4 v3, 0x0

    new-instance v6, Ljava/lang/String;

    invoke-direct {v6, v4, v3, v2, v5}, Ljava/lang/String;-><init>([BIILjava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    return-object v6

    :goto_null
    const/4 v6, 0x0

    return-object v6
    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception v0

    const/4 v0, 0x0

    return-object v0
.end method
