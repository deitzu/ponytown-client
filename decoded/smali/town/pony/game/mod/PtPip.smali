.class public final Ltown/pony/game/mod/PtPip;
.super Ljava/lang/Object;
.source "PtPip.java"

# UI-thread helper. mode 0 = user-leave-hint (auto PiP, honours sPipOff),
# mode 1 = enter PiP now (manual button), mode 2 = keep-screen-on window flag (flag).
.implements Ljava/lang/Runnable;


.field private final a:Landroid/app/Activity;

.field private final m:I

.field private final f:Z


.method public constructor <init>(Landroid/app/Activity;IZ)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Ltown/pony/game/mod/PtPip;->a:Landroid/app/Activity;

    iput p2, p0, Ltown/pony/game/mod/PtPip;->m:I

    iput-boolean p3, p0, Ltown/pony/game/mod/PtPip;->f:Z

    return-void
.end method


.method public run()V
    .locals 5

    :try_start_0
    iget v0, p0, Ltown/pony/game/mod/PtPip;->m:I

    const/4 v1, 0x2

    if-eq v0, v1, :cond_screen

    if-nez v0, :cond_enter

    sget-boolean v0, Ltown/pony/game/mod/PtModBridge;->sPipOff:Z

    if-nez v0, :goto_ret

    :cond_enter
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :goto_ret

    iget-object v1, p0, Ltown/pony/game/mod/PtPip;->a:Landroid/app/Activity;

    new-instance v0, Landroid/app/PictureInPictureParams$Builder;

    invoke-direct {v0}, Landroid/app/PictureInPictureParams$Builder;-><init>()V

    new-instance v2, Landroid/util/Rational;

    const/16 v3, 0x10

    const/16 v4, 0x9

    invoke-direct {v2, v3, v4}, Landroid/util/Rational;-><init>(II)V

    invoke-virtual {v0, v2}, Landroid/app/PictureInPictureParams$Builder;->setAspectRatio(Landroid/util/Rational;)Landroid/app/PictureInPictureParams$Builder;

    move-result-object v0

    invoke-virtual {v0}, Landroid/app/PictureInPictureParams$Builder;->build()Landroid/app/PictureInPictureParams;

    move-result-object v0

    invoke-virtual {v1, v0}, Landroid/app/Activity;->enterPictureInPictureMode(Landroid/app/PictureInPictureParams;)Z

    goto :goto_ret

    :cond_screen
    iget-object v0, p0, Ltown/pony/game/mod/PtPip;->a:Landroid/app/Activity;

    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    iget-boolean v1, p0, Ltown/pony/game/mod/PtPip;->f:Z

    const/16 v2, 0x80

    if-eqz v1, :cond_clear

    invoke-virtual {v0, v2}, Landroid/view/Window;->addFlags(I)V

    goto :goto_ret

    :cond_clear
    invoke-virtual {v0, v2}, Landroid/view/Window;->clearFlags(I)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method
