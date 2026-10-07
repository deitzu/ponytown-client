#
# PonyTown Mod: JS -> native bridge, registered with
# WebView.addJavascriptInterface(obj, "PtModBridge") when the game WebView is
# created (so window.PtModBridge exists on the very first page load).
#
# JS-visible API (every call must carry the per-process token that
# JsInjector hands ONLY to the built-in UI script -- other frames/pages that
# can see window.PtModBridge cannot call anything without it):
#   pickScript(token)                       open the system file picker (SAF)
#   exec(token, code)                       evaluate JS in the game page
#   mouseMove(token, x, y)                  real hover move   (physical px)
#   mouseBtn(token, 1|2|3, x, y, buttons)   mouse down / move-held / up
#   key(token, androidKeyCode, down)        real key down / up
# Native work is done by PtInput on the UI thread. exec() and the picked-file
# callback run only while the page is pony.town (JsInjector.isPonyTownUrl).
#
# The picked file is NOT executed here any more: its name + text are handed to
# the UI script via window.__ptOnPicked(name, text); the script manager stores
# it and decides when to run it.
#
# Everything is wrapped in try/catch Throwable and never throws out.
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

# Best-known Activity (unwrapped from WebView.getContext()) and WebView.
.field private static sActivity:Landroid/app/Activity;

.field private static sWebView:Landroid/webkit/WebView;

# Per-process random token required by every JS-visible call.
.field private static sToken:Ljava/lang/String;

# direct methods

.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

# ---------------------------------------------------------------------------
# public static String token()
# Lazily creates the per-process token (UUID from SecureRandom).
# ---------------------------------------------------------------------------
.method public static token()Ljava/lang/String;
    .locals 1

    sget-object v0, Ltown/pony/game/mod/PtModBridge;->sToken:Ljava/lang/String;

    if-nez v0, :goto_have

    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v0

    sput-object v0, Ltown/pony/game/mod/PtModBridge;->sToken:Ljava/lang/String;

    :goto_have
    return-object v0
.end method

# ---------------------------------------------------------------------------
# private static boolean ok(String token)
# ---------------------------------------------------------------------------
.method private static ok(Ljava/lang/String;)Z
    .locals 1

    if-eqz p0, :goto_no

    invoke-static {}, Ltown/pony/game/mod/PtModBridge;->token()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    return v0

    :goto_no
    const/4 v0, 0x0

    return v0
.end method

# ---------------------------------------------------------------------------
# public static void ensureBridge(WebView)
# Idempotent per WebView: registers this class (named "PtModBridge") as a
# JavaScript interface the first time the WebView is seen, and remembers the
# WebView + its hosting Activity (found by unwrapping ContextWrappers).
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

    # remember the newest WebView and the Activity hosting it
    sput-object p0, Ltown/pony/game/mod/PtModBridge;->sWebView:Landroid/webkit/WebView;

    invoke-virtual {p0}, Landroid/webkit/WebView;->getContext()Landroid/content/Context;

    move-result-object v1

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
# public void pickScript(String token)      [JS-visible]
# Runs on the WebView JavaBridge thread -> hop to the UI thread, then run().
# ---------------------------------------------------------------------------
.method public pickScript(Ljava/lang/String;)V
    .locals 1

    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_0
    invoke-static {p1}, Ltown/pony/game/mod/PtModBridge;->ok(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :goto_ret

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
# public void exec(String token, String code)     [JS-visible]
# Evaluates `code` in the game page (PtInput mode 6, pony.town only).
# ---------------------------------------------------------------------------
.method public exec(Ljava/lang/String;Ljava/lang/String;)V
    .locals 8

    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_0
    invoke-static {p1}, Ltown/pony/game/mod/PtModBridge;->ok(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :goto_ret

    sget-object v0, Ltown/pony/game/mod/PtModBridge;->sWebView:Landroid/webkit/WebView;

    if-eqz v0, :goto_ret

    const/4 v1, 0x6

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x0

    move-object v6, p2

    invoke-static/range {v0 .. v6}, Ltown/pony/game/mod/PtInput;->post(Landroid/webkit/WebView;IFFIILjava/lang/String;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# public void mouseMove(String token, float x, float y)     [JS-visible]
# Real hover move at (x, y) physical pixels inside the WebView.
# ---------------------------------------------------------------------------
.method public mouseMove(Ljava/lang/String;FF)V
    .locals 8

    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_0
    invoke-static {p1}, Ltown/pony/game/mod/PtModBridge;->ok(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :goto_ret

    sget-object v0, Ltown/pony/game/mod/PtModBridge;->sWebView:Landroid/webkit/WebView;

    if-eqz v0, :goto_ret

    const/4 v1, 0x0

    move v2, p2

    move v3, p3

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    invoke-static/range {v0 .. v6}, Ltown/pony/game/mod/PtInput;->post(Landroid/webkit/WebView;IFFIILjava/lang/String;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# public void mouseBtn(String token, int phase, float x, float y, int buttons)
# phase 1 = button down, 2 = move while held, 3 = button up.
# buttons: 1 = primary (left), 2 = secondary (right).      [JS-visible]
# ---------------------------------------------------------------------------
.method public mouseBtn(Ljava/lang/String;IFFI)V
    .locals 8

    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_0
    invoke-static {p1}, Ltown/pony/game/mod/PtModBridge;->ok(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :goto_ret

    const/4 v1, 0x1

    if-lt p2, v1, :goto_ret

    const/4 v1, 0x3

    if-gt p2, v1, :goto_ret

    sget-object v0, Ltown/pony/game/mod/PtModBridge;->sWebView:Landroid/webkit/WebView;

    if-eqz v0, :goto_ret

    move v1, p2

    move v2, p3

    move v3, p4

    const/4 v4, 0x0

    move v5, p5

    const/4 v6, 0x0

    invoke-static/range {v0 .. v6}, Ltown/pony/game/mod/PtInput;->post(Landroid/webkit/WebView;IFFIILjava/lang/String;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
# ---------------------------------------------------------------------------
# public void mouseScroll(String token, float dx, float dy)     [JS-visible]
# Native wheel/trackpad scroll.  dx = horizontal axis, dy = vertical axis.
# ---------------------------------------------------------------------------
.method public mouseScroll(Ljava/lang/String;FF)V
    .locals 7

    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_0
    invoke-static {p1}, Ltown/pony/game/mod/PtModBridge;->ok(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :goto_ret

    sget-object v0, Ltown/pony/game/mod/PtModBridge;->sWebView:Landroid/webkit/WebView;

    if-eqz v0, :goto_ret

    const/4 v1, 0x7

    move v2, p2

    move v3, p3

    const/4 v4, 0x0

    const/4 v5, 0x0

    const/4 v6, 0x0

    invoke-static/range {v0 .. v6}, Ltown/pony/game/mod/PtInput;->post(Landroid/webkit/WebView;IFFIILjava/lang/String;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

.end method

# ---------------------------------------------------------------------------
# public void key(String token, int androidKeyCode, boolean down)  [JS-visible]
# ---------------------------------------------------------------------------
.method public key(Ljava/lang/String;IZ)V
    .locals 8

    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation

    :try_start_0
    invoke-static {p1}, Ltown/pony/game/mod/PtModBridge;->ok(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :goto_ret

    sget-object v0, Ltown/pony/game/mod/PtModBridge;->sWebView:Landroid/webkit/WebView;

    if-eqz v0, :goto_ret

    const/4 v1, 0x5

    if-eqz p3, :goto_mode

    const/4 v1, 0x4

    :goto_mode
    const/4 v2, 0x0

    const/4 v3, 0x0

    move v4, p2

    const/4 v5, 0x0

    const/4 v6, 0x0

    invoke-static/range {v0 .. v6}, Ltown/pony/game/mod/PtInput;->post(Landroid/webkit/WebView;IFFIILjava/lang/String;)V

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
# needs no permission and gives us a readable content:// Uri.
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
# hands (name, text) to the UI script -- see deliver().
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

    invoke-static {v1}, Ltown/pony/game/mod/PtModBridge;->pickedName(Landroid/net/Uri;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v3}, Ltown/pony/game/mod/PtModBridge;->deliver(Ljava/lang/String;Ljava/lang/String;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# ---------------------------------------------------------------------------
# private static String pickedName(Uri)
# File name guess: last path segment after the final '/'  ("script.js" if none).
# ---------------------------------------------------------------------------
.method private static pickedName(Landroid/net/Uri;)Ljava/lang/String;
    .locals 3

    :try_start_0
    invoke-virtual {p0}, Landroid/net/Uri;->getLastPathSegment()Ljava/lang/String;

    move-result-object v0

    if-nez v0, :goto_have

    const-string v0, "script.js"

    return-object v0

    :goto_have
    const/16 v1, 0x2f

    invoke-virtual {v0, v1}, Ljava/lang/String;->lastIndexOf(I)I

    move-result v1

    if-ltz v1, :goto_ret

    add-int/lit8 v1, v1, 0x1

    invoke-virtual {v0, v1}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    :goto_ret
    return-object v0

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    move-exception v0

    const-string v0, "script.js"

    return-object v0
.end method

# ---------------------------------------------------------------------------
# private static void deliver(String name, String text)
# UI thread.  Calls window.__ptOnPicked(name, text) in the game page, only if
# the WebView currently sits on a pony.town page.
# ---------------------------------------------------------------------------
.method private static deliver(Ljava/lang/String;Ljava/lang/String;)V
    .locals 3

    :try_start_0
    sget-object v0, Ltown/pony/game/mod/PtModBridge;->sWebView:Landroid/webkit/WebView;

    if-eqz v0, :goto_ret

    invoke-virtual {v0}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ltown/pony/game/mod/JsInjector;->isPonyTownUrl(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :goto_ret

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "window.__ptOnPicked&&window.__ptOnPicked("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p0}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ","

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lorg/json/JSONObject;->quote(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ");"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Ltown/pony/game/mod/PtModBridge;->evaluate(Landroid/webkit/WebView;Ljava/lang/String;)V

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
# Defensive wrapper around evaluateJavascript.
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
