.class public final Ltown/pony/game/mod/PtWake;
.super Ljava/lang/Object;
.source "PtWake.java"

# Optional partial WakeLock (CPU awake in background). State lives in SharedPreferences
# so the notification action, the in-page UI and a process restart all agree.

.field private static sLock:Landroid/os/PowerManager$WakeLock;


.method public static isOn(Landroid/content/Context;)Z
    .locals 3

    const/4 v0, 0x0

    :try_start_0
    const-string v1, "ptmod_prefs"

    invoke-virtual {p0, v1, v0}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v2, "wake"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return v0

    :catch_0
    move-exception v1

    const/4 v0, 0x0

    goto :goto_ret
.end method

.method public static set(Landroid/content/Context;Z)V
    .locals 4

    :try_start_0
    const-string v0, "ptmod_prefs"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "wake"

    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    invoke-static {p0}, Ltown/pony/game/mod/PtWake;->apply(Landroid/content/Context;)V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# Make the held WakeLock match the stored preference.
.method public static apply(Landroid/content/Context;)V
    .locals 4

    :try_start_0
    invoke-static {p0}, Ltown/pony/game/mod/PtWake;->isOn(Landroid/content/Context;)Z

    move-result v0

    sget-object v1, Ltown/pony/game/mod/PtWake;->sLock:Landroid/os/PowerManager$WakeLock;

    if-eqz v0, :cond_off

    if-nez v1, :goto_ret

    const-string v2, "power"

    invoke-virtual {p0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/PowerManager;

    const/4 v3, 0x1

    const-string v0, "ptmod:wake"

    invoke-virtual {v2, v3, v0}, Landroid/os/PowerManager;->newWakeLock(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;

    move-result-object v1

    const/4 v3, 0x0

    invoke-virtual {v1, v3}, Landroid/os/PowerManager$WakeLock;->setReferenceCounted(Z)V

    invoke-virtual {v1}, Landroid/os/PowerManager$WakeLock;->acquire()V

    sput-object v1, Ltown/pony/game/mod/PtWake;->sLock:Landroid/os/PowerManager$WakeLock;

    goto :goto_ret

    :cond_off
    if-eqz v1, :goto_ret

    invoke-virtual {v1}, Landroid/os/PowerManager$WakeLock;->release()V

    const/4 v2, 0x0

    sput-object v2, Ltown/pony/game/mod/PtWake;->sLock:Landroid/os/PowerManager$WakeLock;

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method

# Release the lock without touching the stored preference (service destroyed).
.method public static release()V
    .locals 2

    :try_start_0
    sget-object v0, Ltown/pony/game/mod/PtWake;->sLock:Landroid/os/PowerManager$WakeLock;

    if-eqz v0, :goto_ret

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->release()V

    const/4 v1, 0x0

    sput-object v1, Ltown/pony/game/mod/PtWake;->sLock:Landroid/os/PowerManager$WakeLock;

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0

    goto :goto_ret
.end method
