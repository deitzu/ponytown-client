.class public final Ly5/m;
.super Landroid/webkit/WebViewClient;
.source "r8-map-id-72568c339c850db02ef3375e1ae73f19aabc962be620a7ca6895e6b6a6a5456b"


# instance fields
.field public final a:Ljava/util/regex/Pattern;

.field public final synthetic b:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;


# direct methods
.method public constructor <init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V
    .locals 1

    .line 1
    iput-object p1, p0, Ly5/m;->b:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 2
    .line 3
    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V

    .line 4
    .line 5
    .line 6
    const-string p1, "/?favicon(-\\d+x\\d+)?\\.(ico|png|jpg|jpeg|svg)"

    .line 7
    .line 8
    invoke-static {p1}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    .line 9
    .line 10
    .line 11
    move-result-object p1

    .line 12
    const-string v0, "compile(...)"

    .line 13
    .line 14
    invoke-static {p1, v0}, Ly4/f;->d(Ljava/lang/Object;Ljava/lang/String;)V

    .line 15
    .line 16
    .line 17
    iput-object p1, p0, Ly5/m;->a:Ljava/util/regex/Pattern;

    .line 18
    .line 19
    return-void
.end method


# virtual methods
.method public final doUpdateVisitedHistory(Landroid/webkit/WebView;Ljava/lang/String;Z)V
    .locals 5

    .line 1
    if-eqz p2, :cond_4

    .line 2
    .line 3
    iget-object v0, p0, Ly5/m;->b:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 4
    .line 5
    iget-object v0, v0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 6
    .line 7
    invoke-static {p2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    .line 8
    .line 9
    .line 10
    move-result-object v1

    .line 11
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 12
    .line 13
    .line 14
    const-string v2, "uri"

    .line 15
    .line 16
    invoke-static {v1, v2}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 17
    .line 18
    .line 19
    iget-object v2, v0, Ly5/f;->w:Landroid/net/Uri;

    .line 20
    .line 21
    invoke-virtual {v2}, Landroid/net/Uri;->getHost()Ljava/lang/String;

    .line 22
    .line 23
    .line 24
    move-result-object v2

    .line 25
    invoke-virtual {v1}, Landroid/net/Uri;->getHost()Ljava/lang/String;

    .line 26
    .line 27
    .line 28
    move-result-object v3

    .line 29
    invoke-static {v2, v3}, Ly4/f;->a(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 30
    .line 31
    .line 32
    move-result v2

    .line 33
    const/4 v3, 0x1

    .line 34
    const/4 v4, 0x0

    .line 35
    if-eqz v2, :cond_1

    .line 36
    .line 37
    iget-object v2, v0, Ly5/f;->w:Landroid/net/Uri;

    .line 38
    .line 39
    invoke-virtual {v2}, Landroid/net/Uri;->getPath()Ljava/lang/String;

    .line 40
    .line 41
    .line 42
    move-result-object v2

    .line 43
    invoke-virtual {v1}, Landroid/net/Uri;->getPath()Ljava/lang/String;

    .line 44
    .line 45
    .line 46
    move-result-object v1

    .line 47
    invoke-static {v2, v1}, Ly4/f;->a(Ljava/lang/Object;Ljava/lang/Object;)Z

    .line 48
    .line 49
    .line 50
    move-result v1

    .line 51
    if-nez v1, :cond_0

    .line 52
    .line 53
    goto :goto_0

    .line 54
    :cond_0
    move v1, v4

    .line 55
    goto :goto_1

    .line 56
    :cond_1
    :goto_0
    move v1, v3

    .line 57
    :goto_1
    iput-boolean v1, v0, Ly5/f;->v:Z

    .line 58
    .line 59
    iget-object v2, v0, Ly5/f;->y:Lb1/e0;

    .line 60
    .line 61
    iget-boolean v0, v0, Ly5/f;->s:Z

    .line 62
    .line 63
    if-nez v0, :cond_3

    .line 64
    .line 65
    if-eqz v1, :cond_2

    .line 66
    .line 67
    goto :goto_2

    .line 68
    :cond_2
    move v3, v4

    .line 69
    :cond_3
    :goto_2
    iput-boolean v3, v2, Lb1/e0;->a:Z

    .line 70
    .line 71
    iget-object v0, v2, Lb1/e0;->c:Ly4/e;

    .line 72
    .line 73
    if-eqz v0, :cond_4

    .line 74
    .line 75
    invoke-interface {v0}, Lx4/a;->a()Ljava/lang/Object;

    .line 76
    .line 77
    .line 78
    :cond_4
    invoke-super {p0, p1, p2, p3}, Landroid/webkit/WebViewClient;->doUpdateVisitedHistory(Landroid/webkit/WebView;Ljava/lang/String;Z)V

    .line 79
    .line 80
    .line 81
    return-void
.end method

.method public final onPageCommitVisible(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 0

    .line 1
    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->onPageCommitVisible(Landroid/webkit/WebView;Ljava/lang/String;)V

    .line 2
    .line 3
    .line 4
    iget-object p1, p0, Ly5/m;->b:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 5
    .line 6
    const-string p2, "Android.onResponseCode( (window.performance.getEntriesByType(\'navigation\')[0] || {}).responseStatus)"

    .line 7
    .line 8
    invoke-virtual {p1, p2}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->h(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    return-void
.end method

.method public final onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V
    .locals 2

    .line 1
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    invoke-virtual {v0}, Landroid/webkit/CookieManager;->flush()V

    .line 6
    .line 7
    .line 8
    const/4 v0, 0x0

    .line 9
    iget-object v1, p0, Ly5/m;->b:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 10
    .line 11
    invoke-static {v1, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->m(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Z)V

    .line 12
    .line 13
    .line 14
    invoke-static {v1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->j(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V

    .line 15
    .line 16
    .line 17
    const-string v0, "file:///android_asset/offline.html"

    .line 18
    .line 19
    invoke-virtual {v0, p2}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    .line 20
    .line 21
    .line 22
    move-result v0

    .line 23
    if-nez v0, :cond_0

    .line 24
    .line 25
    const-string v0, "Android.onBackgroundColor(window.getComputedStyle(document.body, null).getPropertyValue(\'background-color\'))"

    .line 26
    .line 27
    invoke-virtual {v1, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->h(Ljava/lang/String;)V

    .line 28
    .line 29
    .line 30
    goto :goto_0

    .line 31
    :cond_0
    sget v0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->L:I

    .line 32
    .line 33
    iput v0, v1, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->J:I

    .line 34
    .line 35
    :goto_0
    # ---- PonyTown Mod (Stage 3): custom JS injector, page-finished ----
    invoke-static {p1, p2}, Ltown/pony/game/mod/JsInjector;->onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V

    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->onPageFinished(Landroid/webkit/WebView;Ljava/lang/String;)V

    .line 36
    .line 37
    .line 38
    return-void
.end method

.method public final onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;Landroid/graphics/Bitmap;)V
    .locals 0

    .line 1
    invoke-super {p0, p1, p2, p3}, Landroid/webkit/WebViewClient;->onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;Landroid/graphics/Bitmap;)V

    # ---- PonyTown Mod (Stage 3): custom JS injector, earliest-safe (doc-start fallback) ----
    invoke-static {p1, p2}, Ltown/pony/game/mod/JsInjector;->onPageStarted(Landroid/webkit/WebView;Ljava/lang/String;)V

    .line 2
    .line 3
    .line 4
    const/4 p1, 0x0

    .line 5
    iget-object p3, p0, Ly5/m;->b:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 6
    .line 7
    invoke-static {p3, p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->m(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Z)V

    .line 8
    .line 9
    .line 10
    invoke-virtual {p3}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->s()V

    .line 11
    .line 12
    .line 13
    const-string p1, "file:///android_asset/offline.html"

    .line 14
    .line 15
    invoke-virtual {p1, p2}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    .line 16
    .line 17
    .line 18
    move-result p1

    .line 19
    if-nez p1, :cond_0

    .line 20
    .line 21
    const/4 p1, 0x0

    .line 22
    iput-object p1, p3, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->E:Ljava/lang/String;

    .line 23
    .line 24
    :cond_0
    return-void
.end method

.method public final onReceivedError(Landroid/webkit/WebView;ILjava/lang/String;Ljava/lang/String;)V
    .locals 2

    const-string v0, "view"

    invoke-static {p1, v0}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 1
    invoke-virtual {p1}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 2
    invoke-virtual {v0, p4}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 3
    iget-object v0, p0, Ly5/m;->b:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    iget-boolean v1, v0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->w:Z

    if-nez v1, :cond_2

    .line 4
    sget-object v1, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->M:Ljava/util/LinkedHashSet;

    .line 5
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-interface {v1, p2}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result p2

    if-eqz p2, :cond_1

    .line 6
    invoke-virtual {p1}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 7
    const-string p2, "file:///android_asset/offline.html"

    .line 8
    invoke-virtual {p1, p2}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_0

    .line 9
    iput-object p1, v0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->E:Ljava/lang/String;

    .line 10
    :cond_0
    invoke-static {v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->i(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V

    return-void

    .line 11
    :cond_1
    iget-object p1, v0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 12
    invoke-virtual {p1, p3, p4}, Ly5/f;->i(Ljava/lang/String;Ljava/lang/String;)V

    :cond_2
    return-void
.end method

.method public final onReceivedError(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;Landroid/webkit/WebResourceError;)V
    .locals 3

    const-string v0, "view"

    invoke-static {p1, v0}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    const-string v0, "request"

    invoke-static {p2, v0}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    const-string v0, "error"

    invoke-static {p3, v0}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 13
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->isForMainFrame()Z

    move-result v0

    if-eqz v0, :cond_2

    .line 14
    iget-object v0, p0, Ly5/m;->b:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    iget-boolean v1, v0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->w:Z

    if-nez v1, :cond_2

    .line 15
    sget-object v1, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->M:Ljava/util/LinkedHashSet;

    .line 16
    invoke-virtual {p3}, Landroid/webkit/WebResourceError;->getErrorCode()I

    move-result v2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-interface {v1, v2}, Ljava/util/Set;->contains(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 17
    invoke-virtual {p1}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    move-result-object p1

    if-eqz p1, :cond_0

    .line 18
    const-string p2, "file:///android_asset/offline.html"

    .line 19
    invoke-virtual {p1, p2}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result p2

    if-nez p2, :cond_0

    .line 20
    iput-object p1, v0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->E:Ljava/lang/String;

    .line 21
    :cond_0
    invoke-static {v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->i(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V

    return-void

    .line 22
    :cond_1
    iget-object p1, v0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 23
    invoke-virtual {p3}, Landroid/webkit/WebResourceError;->getErrorCode()I

    .line 24
    invoke-virtual {p3}, Landroid/webkit/WebResourceError;->getDescription()Ljava/lang/CharSequence;

    move-result-object p3

    invoke-virtual {p3}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p3

    .line 25
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object p2

    invoke-virtual {p2}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object p2

    .line 26
    invoke-virtual {p1, p3, p2}, Ly5/f;->i(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    .line 27
    :cond_2
    invoke-super {p0, p1, p2, p3}, Landroid/webkit/WebViewClient;->onReceivedError(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;Landroid/webkit/WebResourceError;)V

    return-void
.end method

.method public final shouldInterceptRequest(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;
    .locals 2

    .line 1
    const-string v0, "request"

    .line 2
    .line 3
    invoke-static {p2, v0}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    .line 7
    .line 8
    .line 9
    move-result-object v0

    .line 10
    if-nez v0, :cond_0

    .line 11
    .line 12
    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->shouldInterceptRequest(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;

    .line 13
    .line 14
    .line 15
    move-result-object p1

    .line 16
    return-object p1

    .line 17
    :cond_0
    invoke-virtual {v0}, Landroid/net/Uri;->getPath()Ljava/lang/String;

    .line 18
    .line 19
    .line 20
    move-result-object v0

    .line 21
    if-nez v0, :cond_1

    .line 22
    .line 23
    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->shouldInterceptRequest(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;

    .line 24
    .line 25
    .line 26
    move-result-object p1

    .line 27
    return-object p1

    .line 28
    :cond_1
    sget-object v1, Ljava/util/Locale;->ROOT:Ljava/util/Locale;

    .line 29
    .line 30
    invoke-virtual {v0, v1}, Ljava/lang/String;->toLowerCase(Ljava/util/Locale;)Ljava/lang/String;

    .line 31
    .line 32
    .line 33
    move-result-object v0

    .line 34
    const-string v1, "toLowerCase(...)"

    .line 35
    .line 36
    invoke-static {v0, v1}, Ly4/f;->d(Ljava/lang/Object;Ljava/lang/String;)V

    .line 37
    .line 38
    .line 39
    iget-object v1, p0, Ly5/m;->a:Ljava/util/regex/Pattern;

    .line 40
    .line 41
    invoke-virtual {v1, v0}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    .line 42
    .line 43
    .line 44
    move-result-object v0

    .line 45
    invoke-virtual {v0}, Ljava/util/regex/Matcher;->matches()Z

    .line 46
    .line 47
    .line 48
    move-result v0

    .line 49
    if-eqz v0, :cond_2

    .line 50
    .line 51
    new-instance p1, Landroid/webkit/WebResourceResponse;

    .line 52
    .line 53
    const-string p2, "image/png"

    .line 54
    .line 55
    const/4 v0, 0x0

    .line 56
    invoke-direct {p1, p2, v0, v0}, Landroid/webkit/WebResourceResponse;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/io/InputStream;)V

    .line 57
    .line 58
    .line 59
    return-object p1

    .line 60
    :cond_2
    invoke-super {p0, p1, p2}, Landroid/webkit/WebViewClient;->shouldInterceptRequest(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;

    .line 61
    .line 62
    .line 63
    move-result-object p1

    .line 64
    return-object p1
.end method

.method public final shouldOverrideUrlLoading(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Z
    .locals 1

    const-string p1, "request"

    invoke-static {p2, p1}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 1
    iget-object p1, p0, Ly5/m;->b:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    iget-object v0, p1, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 2
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;

    move-result-object p2

    invoke-virtual {v0, p2}, Ly5/f;->m(Landroid/net/Uri;)Z

    move-result p2

    xor-int/lit8 v0, p2, 0x1

    .line 3
    invoke-static {p1, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->m(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Z)V

    if-nez p2, :cond_0

    const/4 v0, 0x0

    .line 4
    iput-boolean v0, p1, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->w:Z

    .line 5
    invoke-virtual {p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p()V

    .line 6
    invoke-virtual {p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->s()V

    return p2

    .line 7
    :cond_0
    invoke-static {p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->j(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V

    return p2
.end method

.method public final shouldOverrideUrlLoading(Landroid/webkit/WebView;Ljava/lang/String;)Z
    .locals 1

    .line 8
    iget-object p1, p0, Ly5/m;->b:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    iget-object v0, p1, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 9
    invoke-static {p2}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object p2

    invoke-virtual {v0, p2}, Ly5/f;->m(Landroid/net/Uri;)Z

    move-result p2

    xor-int/lit8 v0, p2, 0x1

    .line 10
    invoke-static {p1, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->m(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Z)V

    if-nez p2, :cond_0

    const/4 v0, 0x0

    .line 11
    iput-boolean v0, p1, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->w:Z

    .line 12
    invoke-virtual {p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p()V

    .line 13
    invoke-virtual {p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->s()V

    return p2

    .line 14
    :cond_0
    invoke-static {p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->j(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V

    return p2
.end method
