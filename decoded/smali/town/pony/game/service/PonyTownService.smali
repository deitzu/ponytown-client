.class public Ltown/pony/game/service/PonyTownService;
.super Landroid/app/Service;
.source "PonyTownService"

# static fields
# once-per-process guard, toggled by MainActivity.onCreate before starting
.field public static sStarted:Z

# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    return-void
.end method

# virtual methods
.method public final onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .locals 1

    const/4 v0, 0x0

    return-object v0
.end method

.method public final onCreate()V
    .locals 1

    invoke-super {p0}, Landroid/app/Service;->onCreate()V

    invoke-static {p0}, Ltown/pony/game/mod/PtWake;->apply(Landroid/content/Context;)V

    # same code path as onStartCommand so startForeground() is always
    # called promptly (5s window) regardless of how the service was started
    invoke-virtual {p0}, Ltown/pony/game/service/PonyTownService;->startAsForeground()V

    return-void
.end method

.method public final onStartCommand(Landroid/content/Intent;II)I
    .locals 2

    if-eqz p1, :cond_go

    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    const-string v1, "town.pony.game.WAKE_TOGGLE"

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_go

    invoke-static {p0}, Ltown/pony/game/mod/PtWake;->isOn(Landroid/content/Context;)Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    invoke-static {p0, v0}, Ltown/pony/game/mod/PtWake;->set(Landroid/content/Context;Z)V

    :cond_go
    invoke-virtual {p0}, Ltown/pony/game/service/PonyTownService;->startAsForeground()V

    const/4 v0, 0x1

    # START_STICKY: system recreates the service if the process is killed
    return v0
.end method

.method public final onDestroy()V
    .locals 1

    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    invoke-static {}, Ltown/pony/game/mod/PtWake;->release()V

    return-void
.end method

# Creates the notification channel (API 26+), builds the persistent
# notification (with an optional wake-lock toggle action) and calls startForeground().
.method public final startAsForeground()V
    .locals 6

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_build_old

    # ---- API 26+: create NotificationChannel, then build with channel ----
    const-string v0, "pony_town_running"

    const-string v1, "Pony Town Running"

    new-instance v2, Landroid/app/NotificationChannel;

    const/4 v3, 0x2

    invoke-direct {v2, v0, v1, v3}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    const-string v3, "notification"

    invoke-virtual {p0, v3}, Landroid/app/Service;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/app/NotificationManager;

    invoke-virtual {v3, v2}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    new-instance v2, Landroid/app/Notification$Builder;

    invoke-direct {v2, p0, v0}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    goto :goto_common

    # ---- API 23-25: plain builder (no channel) ----
    :cond_build_old
    new-instance v2, Landroid/app/Notification$Builder;

    invoke-direct {v2, p0}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;)V

    :goto_common
    const v0, 0x7f0d0000

    invoke-virtual {v2, v0}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    const-string v0, "Pony Town Running"

    invoke-virtual {v2, v0}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    const-string v0, "Keeping Pony Town active"

    invoke-virtual {v2, v0}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    const/4 v0, 0x1

    invoke-virtual {v2, v0}, Landroid/app/Notification$Builder;->setOngoing(Z)Landroid/app/Notification$Builder;

    const-class v1, Ltown/pony/game/MainActivity;

    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const/high16 v1, 0x10000000

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    const/4 v1, 0x0

    const/high16 v3, 0x4000000

    invoke-static {p0, v1, v0, v3}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v0

    invoke-virtual {v2, v0}, Landroid/app/Notification$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;

    # ---- wake-lock toggle action ----
    :try_start_w
    new-instance v0, Landroid/content/Intent;

    invoke-direct {v0}, Landroid/content/Intent;-><init>()V

    const-string v1, "town.pony.game.service.PonyTownService"

    invoke-virtual {v0, p0, v1}, Landroid/content/Intent;->setClassName(Landroid/content/Context;Ljava/lang/String;)Landroid/content/Intent;

    const-string v1, "town.pony.game.WAKE_TOGGLE"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const/4 v1, 0x1

    const/high16 v3, 0xc000000

    invoke-static {p0, v1, v0, v3}, Landroid/app/PendingIntent;->getService(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v0

    invoke-static {p0}, Ltown/pony/game/mod/PtWake;->isOn(Landroid/content/Context;)Z

    move-result v1

    if-eqz v1, :cond_w_off

    const-string v4, "Wake lock ON - tap to turn off"

    goto :goto_w_add

    :cond_w_off
    const-string v4, "Wake lock OFF - tap to turn on"

    :goto_w_add
    const v5, 0x7f0d0000

    invoke-virtual {v2, v5, v4, v0}, Landroid/app/Notification$Builder;->addAction(ILjava/lang/CharSequence;Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;
    :try_end_w
    .catch Ljava/lang/Throwable; {:try_start_w .. :try_end_w} :catch_w

    goto :goto_w_done

    :catch_w
    move-exception v0

    :goto_w_done
    invoke-virtual {v2}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {p0, v1, v0}, Landroid/app/Service;->startForeground(ILandroid/app/Notification;)V

    return-void
.end method