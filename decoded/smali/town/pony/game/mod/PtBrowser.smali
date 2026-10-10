.class public final Ltown/pony/game/mod/PtBrowser;
.super Ljava/lang/Object;
.source "PtBrowser.java"

# Floating "web app" window: a second, isolated WebView (no JS bridge, http/https only) docked
# over the game with a small toolbar. Created on open, destroyed on close to keep memory low.
# modes: 0 open(url, packed), 1 close, 10 back, 11 reload, 12 cycle size, 13 flip dock, 14 close
# packed = size(0..2) | 0x10 (dock bottom) | 0x20 (desktop user agent)
.implements Ljava/lang/Runnable;
.implements Landroid/view/View$OnClickListener;


.field private static sRoot:Landroid/widget/LinearLayout;

.field private static sWeb:Landroid/webkit/WebView;

.field private static sSize:I

.field private static sBottom:Z


.field private final a:Landroid/app/Activity;

.field private final m:I

.field private final u:Ljava/lang/String;

.field private final p:I


.method public constructor <init>(Landroid/app/Activity;ILjava/lang/String;I)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Ltown/pony/game/mod/PtBrowser;->a:Landroid/app/Activity;

    iput p2, p0, Ltown/pony/game/mod/PtBrowser;->m:I

    iput-object p3, p0, Ltown/pony/game/mod/PtBrowser;->u:Ljava/lang/String;

    iput p4, p0, Ltown/pony/game/mod/PtBrowser;->p:I

    return-void
.end method


# height in px for size 0 (40%), 1 (65%), 2 (100%) of the screen
.method private static calcHeight(Landroid/content/Context;I)I
    .locals 4

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    int-to-float v0, v0

    if-nez p1, :cond_not0

    const v1, 0x3ecccccd

    goto :goto_mul

    :cond_not0
    const/4 v2, 0x1

    if-ne p1, v2, :cond_not1

    const v1, 0x3f266666

    goto :goto_mul

    :cond_not1
    const/high16 v1, 0x3f800000

    :goto_mul
    mul-float/2addr v0, v1

    float-to-int v0, v0

    return v0
.end method


.method private static addBtn(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/lang/String;I)V
    .locals 5

    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v1, 0xffffffff

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v1, 0x41a00000

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    invoke-virtual {v1}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v1

    iget v1, v1, Landroid/util/DisplayMetrics;->density:F

    const/high16 v2, 0x41400000

    mul-float/2addr v1, v2

    float-to-int v1, v1

    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/view/View;->setPadding(IIII)V

    new-instance v2, Ltown/pony/game/mod/PtBrowser;

    const/4 v3, 0x0

    const/4 v4, 0x0

    invoke-direct {v2, p0, p3, v3, v4}, Ltown/pony/game/mod/PtBrowser;-><init>(Landroid/app/Activity;ILjava/lang/String;I)V

    invoke-virtual {v0, v2}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {p1, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    return-void
.end method


.method private doOpen()V
    .locals 13

    iget-object v0, p0, Ltown/pony/game/mod/PtBrowser;->u:Ljava/lang/String;

    if-eqz v0, :goto_ret

    const-string v1, "https://"

    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_url_ok

    const-string v1, "http://"

    invoke-virtual {v0, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :goto_ret

    :cond_url_ok
    sget-object v1, Ltown/pony/game/mod/PtBrowser;->sWeb:Landroid/webkit/WebView;

    if-eqz v1, :cond_create

    invoke-virtual {v1, v0}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    goto :goto_ret

    :cond_create
    iget-object v2, p0, Ltown/pony/game/mod/PtBrowser;->a:Landroid/app/Activity;

    iget v3, p0, Ltown/pony/game/mod/PtBrowser;->p:I

    and-int/lit8 v4, v3, 0xf

    sput v4, Ltown/pony/game/mod/PtBrowser;->sSize:I

    and-int/lit8 v5, v3, 0x10

    const/4 v6, 0x0

    if-eqz v5, :cond_notbottom

    const/4 v6, 0x1

    :cond_notbottom
    sput-boolean v6, Ltown/pony/game/mod/PtBrowser;->sBottom:Z

    # ---- root (vertical) ----
    new-instance v7, Landroid/widget/LinearLayout;

    invoke-direct {v7, v2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v8, 0x1

    invoke-virtual {v7, v8}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const v8, 0xff111111

    invoke-virtual {v7, v8}, Landroid/view/View;->setBackgroundColor(I)V

    # ---- toolbar (horizontal) ----
    new-instance v8, Landroid/widget/LinearLayout;

    invoke-direct {v8, v2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v9, 0x0

    invoke-virtual {v8, v9}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const v9, 0xff202225

    invoke-virtual {v8, v9}, Landroid/view/View;->setBackgroundColor(I)V

    const/16 v9, 0x10

    invoke-virtual {v8, v9}, Landroid/widget/LinearLayout;->setGravity(I)V

    const-string v9, "←"

    const/16 v10, 0xa

    invoke-static {v2, v8, v9, v10}, Ltown/pony/game/mod/PtBrowser;->addBtn(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/lang/String;I)V

    const-string v9, "↻"

    const/16 v10, 0xb

    invoke-static {v2, v8, v9, v10}, Ltown/pony/game/mod/PtBrowser;->addBtn(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/lang/String;I)V

    # title (host name), takes the remaining width
    new-instance v9, Landroid/widget/TextView;

    invoke-direct {v9, v2}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v10

    invoke-virtual {v10}, Landroid/net/Uri;->getHost()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v10, 0xffb9bbbe

    invoke-virtual {v9, v10}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v10, 0x1

    invoke-virtual {v9, v10}, Landroid/widget/TextView;->setSingleLine(Z)V

    new-instance v10, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v11, 0x0

    const/4 v12, -0x2

    invoke-direct {v10, v11, v12}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/high16 v11, 0x3f800000

    iput v11, v10, Landroid/widget/LinearLayout$LayoutParams;->weight:F

    invoke-virtual {v8, v9, v10}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const-string v9, "□"

    const/16 v10, 0xc

    invoke-static {v2, v8, v9, v10}, Ltown/pony/game/mod/PtBrowser;->addBtn(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/lang/String;I)V

    const-string v9, "↕"

    const/16 v10, 0xd

    invoke-static {v2, v8, v9, v10}, Ltown/pony/game/mod/PtBrowser;->addBtn(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/lang/String;I)V

    const-string v9, "✕"

    const/16 v10, 0xe

    invoke-static {v2, v8, v9, v10}, Ltown/pony/game/mod/PtBrowser;->addBtn(Landroid/app/Activity;Landroid/widget/LinearLayout;Ljava/lang/String;I)V

    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v10, -0x1

    const/4 v11, -0x2

    invoke-direct {v9, v10, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v7, v8, v9}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ---- the web view ----
    new-instance v8, Landroid/webkit/WebView;

    invoke-direct {v8, v2}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v8}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    move-result-object v9

    const/4 v10, 0x1

    invoke-virtual {v9, v10}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    invoke-virtual {v9, v10}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V

    const/4 v11, 0x0

    invoke-virtual {v9, v11}, Landroid/webkit/WebSettings;->setAllowFileAccess(Z)V

    invoke-virtual {v9, v11}, Landroid/webkit/WebSettings;->setAllowContentAccess(Z)V

    and-int/lit8 v12, v3, 0x20

    if-eqz v12, :cond_noua

    const-string v12, "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36"

    invoke-virtual {v9, v12}, Landroid/webkit/WebSettings;->setUserAgentString(Ljava/lang/String;)V

    invoke-virtual {v9, v10}, Landroid/webkit/WebSettings;->setUseWideViewPort(Z)V

    invoke-virtual {v9, v10}, Landroid/webkit/WebSettings;->setLoadWithOverviewMode(Z)V

    :cond_noua
    new-instance v9, Landroid/webkit/WebViewClient;

    invoke-direct {v9}, Landroid/webkit/WebViewClient;-><init>()V

    invoke-virtual {v8, v9}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    new-instance v9, Landroid/webkit/WebChromeClient;

    invoke-direct {v9}, Landroid/webkit/WebChromeClient;-><init>()V

    invoke-virtual {v8, v9}, Landroid/webkit/WebView;->setWebChromeClient(Landroid/webkit/WebChromeClient;)V

    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object v9

    invoke-virtual {v9, v8, v10}, Landroid/webkit/CookieManager;->setAcceptThirdPartyCookies(Landroid/webkit/WebView;Z)V

    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v10, -0x1

    const/4 v11, 0x0

    invoke-direct {v9, v10, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/high16 v10, 0x3f800000

    iput v10, v9, Landroid/widget/LinearLayout$LayoutParams;->weight:F

    invoke-virtual {v7, v8, v9}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    sput-object v7, Ltown/pony/game/mod/PtBrowser;->sRoot:Landroid/widget/LinearLayout;

    sput-object v8, Ltown/pony/game/mod/PtBrowser;->sWeb:Landroid/webkit/WebView;

    # ---- dock over the activity content ----
    invoke-static {v2, v4}, Ltown/pony/game/mod/PtBrowser;->calcHeight(Landroid/content/Context;I)I

    move-result v9

    const/16 v10, 0x30

    if-eqz v6, :cond_gravity

    const/16 v10, 0x50

    :cond_gravity
    new-instance v11, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v12, -0x1

    invoke-direct {v11, v12, v9, v10}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    invoke-virtual {v2, v7, v11}, Landroid/app/Activity;->addContentView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v8, v0}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    :goto_ret
    return-void
.end method


.method private static doClose()V
    .locals 3

    sget-object v0, Ltown/pony/game/mod/PtBrowser;->sRoot:Landroid/widget/LinearLayout;

    if-eqz v0, :goto_ret

    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    instance-of v2, v1, Landroid/view/ViewGroup;

    if-eqz v2, :cond_nopar

    check-cast v1, Landroid/view/ViewGroup;

    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_nopar
    sget-object v1, Ltown/pony/game/mod/PtBrowser;->sWeb:Landroid/webkit/WebView;

    if-eqz v1, :cond_noweb

    invoke-virtual {v1}, Landroid/webkit/WebView;->stopLoading()V

    const-string v2, "about:blank"

    invoke-virtual {v1, v2}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    invoke-virtual {v1}, Landroid/webkit/WebView;->destroy()V

    :cond_noweb
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    move-result-object v1

    invoke-virtual {v1}, Landroid/webkit/CookieManager;->flush()V

    const/4 v1, 0x0

    sput-object v1, Ltown/pony/game/mod/PtBrowser;->sRoot:Landroid/widget/LinearLayout;

    sput-object v1, Ltown/pony/game/mod/PtBrowser;->sWeb:Landroid/webkit/WebView;

    :goto_ret
    return-void
.end method


# toolbar actions
.method private static doAction(I)V
    .locals 6

    sget-object v0, Ltown/pony/game/mod/PtBrowser;->sRoot:Landroid/widget/LinearLayout;

    sget-object v1, Ltown/pony/game/mod/PtBrowser;->sWeb:Landroid/webkit/WebView;

    if-eqz v0, :goto_ret

    if-eqz v1, :goto_ret

    const/16 v2, 0xa

    if-ne p0, v2, :cond_not_back

    invoke-virtual {v1}, Landroid/webkit/WebView;->canGoBack()Z

    move-result v2

    if-eqz v2, :goto_ret

    invoke-virtual {v1}, Landroid/webkit/WebView;->goBack()V

    goto :goto_ret

    :cond_not_back
    const/16 v2, 0xb

    if-ne p0, v2, :cond_not_reload

    invoke-virtual {v1}, Landroid/webkit/WebView;->reload()V

    goto :goto_ret

    :cond_not_reload
    const/16 v2, 0xc

    if-ne p0, v2, :cond_not_size

    sget v2, Ltown/pony/game/mod/PtBrowser;->sSize:I

    add-int/lit8 v2, v2, 0x1

    rem-int/lit8 v2, v2, 0x3

    sput v2, Ltown/pony/game/mod/PtBrowser;->sSize:I

    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v3

    invoke-static {v3, v2}, Ltown/pony/game/mod/PtBrowser;->calcHeight(Landroid/content/Context;I)I

    move-result v2

    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    iput v2, v3, Landroid/view/ViewGroup$LayoutParams;->height:I

    invoke-virtual {v0, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    goto :goto_ret

    :cond_not_size
    const/16 v2, 0xd

    if-ne p0, v2, :cond_not_dock

    sget-boolean v2, Ltown/pony/game/mod/PtBrowser;->sBottom:Z

    xor-int/lit8 v2, v2, 0x1

    sput-boolean v2, Ltown/pony/game/mod/PtBrowser;->sBottom:Z

    const/16 v3, 0x30

    if-eqz v2, :cond_top

    const/16 v3, 0x50

    :cond_top
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v4

    check-cast v4, Landroid/widget/FrameLayout$LayoutParams;

    iput v3, v4, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    invoke-virtual {v0, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    goto :goto_ret

    :cond_not_dock
    const/16 v2, 0xe

    if-ne p0, v2, :goto_ret

    invoke-static {}, Ltown/pony/game/mod/PtBrowser;->doClose()V

    :goto_ret
    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 1

    :try_start_0
    invoke-virtual {p0}, Ltown/pony/game/mod/PtBrowser;->run()V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method


.method public run()V
    .locals 2

    :try_start_0
    iget v0, p0, Ltown/pony/game/mod/PtBrowser;->m:I

    if-nez v0, :cond_notopen

    invoke-direct {p0}, Ltown/pony/game/mod/PtBrowser;->doOpen()V

    goto :goto_ret

    :cond_notopen
    const/4 v1, 0x1

    if-ne v0, v1, :cond_notclose

    invoke-static {}, Ltown/pony/game/mod/PtBrowser;->doClose()V

    goto :goto_ret

    :cond_notclose
    invoke-static {v0}, Ltown/pony/game/mod/PtBrowser;->doAction(I)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method
