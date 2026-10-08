.class public Ltown/pony/game/MainActivity;
.super Lg/i;
.source "r8-map-id-72568c339c850db02ef3375e1ae73f19aabc962be620a7ca6895e6b6a6a5456b"


# instance fields
.field public F:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

.field public G:Ld2/d;


# direct methods
.method public constructor <init>()V
    .locals 3

    .line 1
    invoke-direct {p0}, Lb1/y;-><init>()V

    .line 2
    .line 3
    .line 4
    iget-object v0, p0, Lb/q;->j:Lb1/g;

    .line 5
    .line 6
    iget-object v0, v0, Lb1/g;->i:Ljava/lang/Object;

    .line 7
    .line 8
    check-cast v0, Lb1/g;

    .line 9
    .line 10
    new-instance v1, Lg/g;

    .line 11
    .line 12
    invoke-direct {v1, p0}, Lg/g;-><init>(Ltown/pony/game/MainActivity;)V

    .line 13
    .line 14
    .line 15
    const-string v2, "androidx:appcompat"

    .line 16
    .line 17
    invoke-virtual {v0, v2, v1}, Lb1/g;->J(Ljava/lang/String;Ln1/c;)V

    .line 18
    .line 19
    .line 20
    new-instance v0, Lg/h;

    .line 21
    .line 22
    invoke-direct {v0, p0}, Lg/h;-><init>(Ltown/pony/game/MainActivity;)V

    .line 23
    .line 24
    .line 25
    invoke-virtual {p0, v0}, Lb/q;->h(Lc/b;)V

    .line 26
    .line 27
    .line 28
    return-void
.end method


# virtual methods
.method public final onCreate(Landroid/os/Bundle;)V
    .locals 10

    .line 1
    invoke-super {p0, p1}, Lb1/y;->onCreate(Landroid/os/Bundle;)V

    # ---- PonyTown Mod: auto PiP (Lb/q.onUserLeaveHint is final -> use its listener list) ----
    :try_start_pip
    new-instance v0, Ltown/pony/game/mod/PtPip;

    const/4 v1, 0x0

    invoke-direct {v0, p0, v1, v1}, Ltown/pony/game/mod/PtPip;-><init>(Landroid/app/Activity;IZ)V

    iget-object v1, p0, Lb/q;->u:Ljava/util/concurrent/CopyOnWriteArrayList;

    invoke-virtual {v1, v0}, Ljava/util/concurrent/CopyOnWriteArrayList;->add(Ljava/lang/Object;)Z
    :try_end_pip
    .catch Ljava/lang/Throwable; {:try_start_pip .. :try_end_pip} :catch_pip

    goto :goto_pip_done

    :catch_pip
    move-exception v0

    :goto_pip_done

    # ---- PonyTown Mod (Stage 2): start keep-alive foreground service once ----
    sget-boolean v0, Ltown/pony/game/service/PonyTownService;->sStarted:Z

    if-nez v0, :goto_fgs_done

    const/4 v0, 0x1

    sput-boolean v0, Ltown/pony/game/service/PonyTownService;->sStarted:Z

    :try_start_fgs
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    const-string v1, "town.pony.game.service.PonyTownService"

    invoke-virtual {v0, p0, v1}, Landroid/content/Intent;->setClassName(Landroid/content/Context;Ljava/lang/String;)Landroid/content/Intent;

    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x1a

    if-lt v1, v2, :cond_fgs_old

    invoke-virtual {p0, v0}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    goto :goto_fgs_done

    :cond_fgs_old
    invoke-virtual {p0, v0}, Landroid/content/Context;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_fgs
    .catch Ljava/lang/Throwable; {:try_start_fgs .. :try_end_fgs} :catch_fgs

    :goto_fgs_done
    goto :goto_fgs_after

    :catch_fgs
    move-exception v0

    :goto_fgs_after
    # ---- end service start block ----

    .line 2
    .line 3
    .line 4
    new-instance p1, Landroid/widget/FrameLayout;

    .line 5
    .line 6
    invoke-direct {p1, p0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 7
    .line 8
    .line 9
    const/high16 v0, -0x1000000

    .line 10
    .line 11
    invoke-virtual {p1, v0}, Landroid/view/View;->setBackgroundColor(I)V

    .line 12
    .line 13
    .line 14
    new-instance v1, Ly5/f;

    .line 15
    .line 16
    new-instance v2, Lr5/b;

    .line 17
    .line 18
    const/4 v0, 0x1

    .line 19
    invoke-direct {v2, p0, v0}, Lr5/b;-><init>(Ltown/pony/game/MainActivity;I)V

    .line 20
    .line 21
    .line 22
    new-instance v3, Lr5/b;

    .line 23
    .line 24
    const/4 v0, 0x2

    .line 25
    invoke-direct {v3, p0, v0}, Lr5/b;-><init>(Ltown/pony/game/MainActivity;I)V

    .line 26
    .line 27
    .line 28
    new-instance v4, Lr5/b;

    .line 29
    .line 30
    const/4 v0, 0x0

    .line 31
    invoke-direct {v4, p0, v0}, Lr5/b;-><init>(Ltown/pony/game/MainActivity;I)V

    .line 32
    .line 33
    .line 34
    new-instance v5, Lr5/a;

    .line 35
    .line 36
    invoke-direct {v5, p0, v0}, Lr5/a;-><init>(Ltown/pony/game/MainActivity;I)V

    .line 37
    .line 38
    .line 39
    new-instance v6, Lr5/a;

    .line 40
    .line 41
    const/4 v0, 0x1

    .line 42
    invoke-direct {v6, p0, v0}, Lr5/a;-><init>(Ltown/pony/game/MainActivity;I)V

    .line 43
    .line 44
    .line 45
    new-instance v7, Lr5/b;

    .line 46
    .line 47
    const/4 v0, 0x3

    .line 48
    invoke-direct {v7, p0, v0}, Lr5/b;-><init>(Ltown/pony/game/MainActivity;I)V

    .line 49
    .line 50
    .line 51
    new-instance v8, Lw0/b;

    .line 52
    .line 53
    invoke-direct {v8}, Ljava/lang/Object;-><init>()V

    .line 54
    .line 55
    .line 56
    const-string v0, "https://google.com"

    .line 57
    .line 58
    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    .line 59
    .line 60
    .line 61
    move-result-object v0

    .line 62
    iput-object v0, v8, Lw0/b;->h:Ljava/lang/Object;

    .line 63
    .line 64
    new-instance v0, Ljava/lang/ref/WeakReference;

    .line 65
    .line 66
    invoke-direct {v0, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    .line 67
    .line 68
    .line 69
    iput-object v0, v8, Lw0/b;->g:Ljava/lang/Object;

    .line 70
    .line 71
    new-instance v9, Lp5/c;

    .line 72
    .line 73
    invoke-direct {v9, p0}, Lp5/c;-><init>(Ltown/pony/game/MainActivity;)V

    .line 74
    .line 75
    .line 76
    invoke-direct/range {v1 .. v9}, Ly5/f;-><init>(Lr5/b;Lr5/b;Lr5/b;Lr5/a;Lr5/a;Lr5/b;Lw0/b;Lp5/c;)V

    .line 77
    .line 78
    .line 79
    new-instance v0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 80
    .line 81
    invoke-direct {v0, p0, v1, p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;-><init>(Ltown/pony/game/MainActivity;Ly5/f;Landroid/widget/FrameLayout;)V

    .line 82
    .line 83
    .line 84
    iput-object v0, p0, Ltown/pony/game/MainActivity;->F:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 85
    .line 86
    new-instance v2, Ld2/d;

    .line 87
    .line 88
    invoke-direct {v2, p0, v0}, Ld2/d;-><init>(Ltown/pony/game/MainActivity;Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V

    .line 89
    .line 90
    .line 91
    iput-object v2, p0, Ltown/pony/game/MainActivity;->G:Ld2/d;

    .line 92
    .line 93
    iget-object v0, p0, Ltown/pony/game/MainActivity;->F:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 94
    .line 95
    invoke-virtual {p1, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    .line 96
    .line 97
    .line 98
    iget-object v0, p0, Ld0/h;->g:Landroidx/lifecycle/w;

    .line 99
    .line 100
    iget-object v2, p0, Ltown/pony/game/MainActivity;->F:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 101
    .line 102
    invoke-virtual {v0, v2}, Landroidx/lifecycle/w;->a(Landroidx/lifecycle/t;)V

    .line 103
    .line 104
    .line 105
    iget-object v0, p0, Ltown/pony/game/MainActivity;->F:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 106
    .line 107
    const-string v2, "view"

    .line 108
    .line 109
    invoke-static {v0, v2}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 110
    .line 111
    .line 112
    iput-object v0, v1, Ly5/f;->x:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 113
    .line 114
    invoke-virtual {p0, p1}, Lg/i;->setContentView(Landroid/view/View;)V

    .line 115
    .line 116
    .line 117
    invoke-virtual {p0}, Landroid/app/Activity;->getIntent()Landroid/content/Intent;

    .line 118
    .line 119
    .line 120
    move-result-object p1

    .line 121
    if-eqz p1, :cond_0

    .line 122
    .line 123
    iget-object v0, p0, Ltown/pony/game/MainActivity;->F:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 124
    .line 125
    if-eqz v0, :cond_0

    .line 126
    .line 127
    invoke-virtual {p1}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    .line 128
    .line 129
    .line 130
    move-result-object p1

    .line 131
    invoke-static {p1}, Ln4/k;->s(Landroid/net/Uri;)Landroid/net/Uri;

    .line 132
    .line 133
    .line 134
    move-result-object p1

    .line 135
    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    .line 136
    .line 137
    .line 138
    move-result-object p1

    .line 139
    invoke-virtual {v0, p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->loadUrl(Ljava/lang/String;)V

    .line 140
    .line 141
    .line 142
    :cond_0
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    .line 143
    .line 144
    .line 145
    move-result-object p1

    .line 146
    if-nez p1, :cond_1

    .line 147
    .line 148
    return-void

    .line 149
    :cond_1
    invoke-virtual {p1}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    .line 150
    .line 151
    .line 152
    move-result-object p1

    .line 153
    new-instance v0, Lo5/a;

    .line 154
    .line 155
    invoke-direct {v0, p0}, Lo5/a;-><init>(Ltown/pony/game/MainActivity;)V

    .line 156
    .line 157
    .line 158
    invoke-virtual {p1, v0}, Landroid/view/View;->setOnSystemUiVisibilityChangeListener(Landroid/view/View$OnSystemUiVisibilityChangeListener;)V

    .line 159
    .line 160
    .line 161
    return-void
.end method

# ---- PonyTown Mod (SAF picker): forward the file-picker result ----
.method public onActivityResult(IILandroid/content/Intent;)V
    .locals 0

    invoke-super {p0, p1, p2, p3}, Lg/i;->onActivityResult(IILandroid/content/Intent;)V

    invoke-static {p1, p2, p3}, Ltown/pony/game/mod/PtModBridge;->onActivityResult(IILandroid/content/Intent;)V

    return-void
.end method

.method public final onDestroy()V
    .locals 3

    .line 1
    invoke-super {p0}, Lg/i;->onDestroy()V

    .line 2
    .line 3
    .line 4
    iget-object v0, p0, Ltown/pony/game/MainActivity;->G:Ld2/d;

    .line 5
    .line 6
    if-eqz v0, :cond_0

    .line 7
    .line 8
    :try_start_0
    iget-object v1, v0, Ld2/d;->k:Ljava/lang/Object;

    .line 9
    .line 10
    check-cast v1, Landroid/net/ConnectivityManager;

    .line 11
    .line 12
    iget-object v2, v0, Ld2/d;->l:Ljava/lang/Object;

    .line 13
    .line 14
    check-cast v2, Lo5/d;

    .line 15
    .line 16
    invoke-virtual {v1, v2}, Landroid/net/ConnectivityManager;->unregisterNetworkCallback(Landroid/net/ConnectivityManager$NetworkCallback;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 17
    .line 18
    .line 19
    :catch_0
    iget-object v0, v0, Ld2/d;->i:Ljava/lang/Object;

    .line 20
    .line 21
    check-cast v0, Lk5/c;

    .line 22
    .line 23
    invoke-static {v0}, Lg5/u;->b(Lk5/c;)V

    .line 24
    .line 25
    .line 26
    :cond_0
    return-void
.end method

.method public final onMultiWindowModeChanged(Z)V
    .locals 1

    .line 1
    iget-object v0, p0, Ltown/pony/game/MainActivity;->F:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 2
    .line 3
    invoke-virtual {v0, p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->setInMultiWindowMode(Z)V

    .line 4
    .line 5
    .line 6
    invoke-super {p0, p1}, Lb/q;->onMultiWindowModeChanged(Z)V

    .line 7
    .line 8
    .line 9
    return-void
.end method

.method public final onNewIntent(Landroid/content/Intent;)V
    .locals 3

    .line 1
    invoke-super {p0, p1}, Lb/q;->onNewIntent(Landroid/content/Intent;)V

    .line 2
    .line 3
    .line 4
    iget-object v0, p0, Ltown/pony/game/MainActivity;->F:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 5
    .line 6
    if-nez v0, :cond_0

    .line 7
    .line 8
    goto :goto_1

    .line 9
    :cond_0
    invoke-virtual {p1}, Landroid/content/Intent;->getData()Landroid/net/Uri;

    .line 10
    .line 11
    .line 12
    move-result-object p1

    .line 13
    if-nez p1, :cond_1

    .line 14
    .line 15
    goto :goto_1

    .line 16
    :cond_1
    invoke-virtual {p1}, Landroid/net/Uri;->getScheme()Ljava/lang/String;

    .line 17
    .line 18
    .line 19
    move-result-object v0

    .line 20
    const-string v1, "ponytown"

    .line 21
    .line 22
    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    .line 23
    .line 24
    .line 25
    move-result v1

    .line 26
    if-eqz v1, :cond_2

    .line 27
    .line 28
    goto :goto_0

    .line 29
    :cond_2
    invoke-virtual {p1}, Landroid/net/Uri;->getHost()Ljava/lang/String;

    .line 30
    .line 31
    .line 32
    move-result-object v1

    .line 33
    const-string v2, "https"

    .line 34
    .line 35
    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    .line 36
    .line 37
    .line 38
    move-result v0

    .line 39
    if-eqz v0, :cond_3

    .line 40
    .line 41
    if-eqz v1, :cond_3

    .line 42
    .line 43
    const-string v0, "pony.town"

    .line 44
    .line 45
    invoke-virtual {v1, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    .line 46
    .line 47
    .line 48
    move-result v0

    .line 49
    if-eqz v0, :cond_3

    .line 50
    .line 51
    :goto_0
    iget-object v0, p0, Ltown/pony/game/MainActivity;->F:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 52
    .line 53
    invoke-static {p1}, Ln4/k;->s(Landroid/net/Uri;)Landroid/net/Uri;

    .line 54
    .line 55
    .line 56
    move-result-object p1

    .line 57
    invoke-virtual {p1}, Landroid/net/Uri;->toString()Ljava/lang/String;

    .line 58
    .line 59
    .line 60
    move-result-object p1

    .line 61
    invoke-virtual {v0, p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->loadUrl(Ljava/lang/String;)V

    .line 62
    .line 63
    .line 64
    :cond_3
    :goto_1
    return-void
.end method

.method public final onResume()V
    .locals 3

    .line 1
    invoke-super {p0}, Lb1/y;->onResume()V

    .line 2
    .line 3
    .line 4
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    .line 5
    .line 6
    .line 7
    move-result-object v0

    .line 8
    if-nez v0, :cond_0

    .line 9
    .line 10
    goto :goto_0

    .line 11
    :cond_0
    const/high16 v1, 0x4000000

    .line 12
    .line 13
    invoke-virtual {v0, v1}, Landroid/view/Window;->addFlags(I)V

    .line 14
    .line 15
    .line 16
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    .line 17
    .line 18
    const/16 v2, 0x1c

    .line 19
    .line 20
    if-lt v1, v2, :cond_1

    .line 21
    .line 22
    invoke-virtual {v0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;

    .line 23
    .line 24
    .line 25
    move-result-object v0

    .line 26
    invoke-static {v0}, Lm0/g;->r(Landroid/view/WindowManager$LayoutParams;)V

    .line 27
    .line 28
    .line 29
    :cond_1
    :goto_0
    return-void
.end method
