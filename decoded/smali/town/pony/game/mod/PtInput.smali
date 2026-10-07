#
# PonyTown Mod: native input injector.
#
# Mouse input is delivered through WebView generic-motion dispatch so Chromium
# sees SOURCE_MOUSE hover, button, drag, and scroll events.
#
.class public final Ltown/pony/game/mod/PtInput;
.super Ljava/lang/Object;

# interfaces
.implements Ljava/lang/Runnable;

# static fields
.field private static sDownTime:J

# instance fields
.field public buttons:I
.field public code:I
.field public mode:I
.field public str:Ljava/lang/String;
.field public wv:Landroid/webkit/WebView;
.field public x:F
.field public y:F

# direct methods
.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

# public static void post(WebView wv, int mode, float x, float y,
#                         int code, int buttons, String str)
.method public static post(Landroid/webkit/WebView;IFFIILjava/lang/String;)V
    .locals 1
    if-eqz p0, :goto_ret

    new-instance v0, Ltown/pony/game/mod/PtInput;
    invoke-direct {v0}, Ltown/pony/game/mod/PtInput;-><init>()V
    iput-object p0, v0, Ltown/pony/game/mod/PtInput;->wv:Landroid/webkit/WebView;
    iput p1, v0, Ltown/pony/game/mod/PtInput;->mode:I
    iput p2, v0, Ltown/pony/game/mod/PtInput;->x:F
    iput p3, v0, Ltown/pony/game/mod/PtInput;->y:F
    iput p4, v0, Ltown/pony/game/mod/PtInput;->code:I
    iput p5, v0, Ltown/pony/game/mod/PtInput;->buttons:I
    iput-object p6, v0, Ltown/pony/game/mod/PtInput;->str:Ljava/lang/String;
    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    :goto_ret
    return-void
.end method

# public void run() (UI thread)
.method public run()V
    .locals 8

    :try_start_0
    iget-object v0, p0, Ltown/pony/game/mod/PtInput;->wv:Landroid/webkit/WebView;
    if-eqz v0, :goto_ret

    iget v1, p0, Ltown/pony/game/mod/PtInput;->mode:I
    iget v4, p0, Ltown/pony/game/mod/PtInput;->buttons:I
    iget v5, p0, Ltown/pony/game/mod/PtInput;->code:I

    const/4 v6, 0x4
    if-ge v1, v6, :cond_nonmouse

    # mode 0: hover
    if-nez v1, :cond_m1
    const/4 v6, 0x7
    const/4 v4, 0x0
    const/4 v7, 0x1
    const/4 v5, 0x0
    invoke-direct {p0, v6, v4, v7, v5}, Ltown/pony/game/mod/PtInput;->dispatchMouse(IIZI)V
    goto :goto_ret

    # mode 1: mouse button down
    :cond_m1
    const/4 v6, 0x1
    if-ne v1, v6, :cond_m2
    const/16 v6, 0xB
    const/4 v7, 0x1
    invoke-direct {p0, v6, v4, v7, v4}, Ltown/pony/game/mod/PtInput;->dispatchMouse(IIZI)V
    goto :goto_ret

    # mode 2: move while held
    :cond_m2
    const/4 v6, 0x2
    if-ne v1, v6, :cond_m3
    const/4 v7, 0x1
    invoke-direct {p0, v6, v4, v7, v5}, Ltown/pony/game/mod/PtInput;->dispatchMouse(IIZI)V
    goto :goto_ret

    # mode 3: mouse button up
    :cond_m3
    const/16 v6, 0xC
    move v5, v4
    const/4 v4, 0x0
    const/4 v7, 0x1
    invoke-direct {p0, v6, v4, v7, v5}, Ltown/pony/game/mod/PtInput;->dispatchMouse(IIZI)V
    goto :goto_ret

    :cond_nonmouse
    const/4 v6, 0x4
    if-ne v1, v6, :cond_k5
    const/4 v6, 0x1
    invoke-static {v0, v5, v6}, Ltown/pony/game/mod/PtInput;->dispatchKey(Landroid/webkit/WebView;IZ)V
    goto :goto_ret

    :cond_k5
    const/4 v6, 0x5
    if-ne v1, v6, :cond_e6
    const/4 v6, 0x0
    invoke-static {v0, v5, v6}, Ltown/pony/game/mod/PtInput;->dispatchKey(Landroid/webkit/WebView;IZ)V
    goto :goto_ret

    :cond_e6
    const/4 v6, 0x6
    if-ne v1, v6, :cond_scroll
    iget-object v6, p0, Ltown/pony/game/mod/PtInput;->str:Ljava/lang/String;
    if-eqz v6, :goto_ret
    invoke-virtual {v0}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;
    move-result-object v7
    invoke-static {v7}, Ltown/pony/game/mod/JsInjector;->isPonyTownUrl(Ljava/lang/String;)Z
    move-result v7
    if-eqz v7, :goto_ret
    const/4 v7, 0x0
    invoke-virtual {v0, v6, v7}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V
    goto :goto_ret

    :cond_scroll
    invoke-direct {p0}, Ltown/pony/game/mod/PtInput;->dispatchScroll()V

    :try_end_0
    .catch Ljava/lang/Throwable; {:try_start_0 .. :try_end_0} :catch_0

    :goto_ret
    return-void

    :catch_0
    move-exception v0
    goto :goto_ret
.end method

# private void dispatchMouse(int action, int buttonState, boolean generic, int actionButton)
.method private dispatchMouse(IIZI)V
    .locals 16

    move-object/from16 v0, p0
    move/from16 v8, p1
    move/from16 v9, p2

    new-instance v1, Landroid/view/MotionEvent$PointerProperties;
    invoke-direct {v1}, Landroid/view/MotionEvent$PointerProperties;-><init>()V
    const/4 v2, 0x0
    iput v2, v1, Landroid/view/MotionEvent$PointerProperties;->id:I
    const/4 v2, 0x3
    iput v2, v1, Landroid/view/MotionEvent$PointerProperties;->toolType:I

    new-instance v4, Landroid/view/MotionEvent$PointerCoords;
    invoke-direct {v4}, Landroid/view/MotionEvent$PointerCoords;-><init>()V
    iget v2, v0, Ltown/pony/game/mod/PtInput;->x:F
    iput v2, v4, Landroid/view/MotionEvent$PointerCoords;->x:F
    iget v2, v0, Ltown/pony/game/mod/PtInput;->y:F
    iput v2, v4, Landroid/view/MotionEvent$PointerCoords;->y:F

    const/4 v2, 0x0
    if-eqz v9, :cond_nopress
    const/high16 v2, 0x3f800000
    :cond_nopress
    iput v2, v4, Landroid/view/MotionEvent$PointerCoords;->pressure:F
    const/high16 v2, 0x3f800000
    iput v2, v4, Landroid/view/MotionEvent$PointerCoords;->size:F

    const/4 v3, 0x1
    new-array v6, v3, [Landroid/view/MotionEvent$PointerProperties;
    const/4 v5, 0x0
    aput-object v1, v6, v5
    new-array v7, v3, [Landroid/view/MotionEvent$PointerCoords;
    aput-object v4, v7, v5

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v2

    const/16 v4, 0xB
    if-ne v8, v4, :cond_keepdown
    sput-wide v2, Ltown/pony/game/mod/PtInput;->sDownTime:J
    :cond_keepdown

    sget-wide v0, Ltown/pony/game/mod/PtInput;->sDownTime:J
    move v4, v8
    const/4 v5, 0x1
    const/4 v8, 0x0
    const/high16 v10, 0x3f800000
    const/high16 v11, 0x3f800000
    const/4 v12, 0x0
    const/4 v13, 0x0
    const/16 v14, 0x2002
    const/4 v15, 0x0

    invoke-static/range {v0 .. v15}, Landroid/view/MotionEvent;->obtain(JJII[Landroid/view/MotionEvent$PointerProperties;[Landroid/view/MotionEvent$PointerCoords;IIFFIIII)Landroid/view/MotionEvent;
    move-result-object v1

    const/16 v4, 0xB
    if-ne p1, v4, :cond_not_press
    move/from16 v4, p4
    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->setActionButton(I)V
    goto :cond_dispatch

    :cond_not_press
    const/16 v4, 0xC
    if-ne p1, v4, :cond_dispatch
    move/from16 v4, p4
    invoke-virtual {v1, v4}, Landroid/view/MotionEvent;->setActionButton(I)V

    :cond_dispatch
    move-object/from16 v2, p0
    iget-object v0, v2, Ltown/pony/game/mod/PtInput;->wv:Landroid/webkit/WebView;
    if-eqz p3, :cond_touch
    invoke-virtual {v0, v1}, Landroid/view/View;->dispatchGenericMotionEvent(Landroid/view/MotionEvent;)Z
    goto :goto_recycle
    :cond_touch
    invoke-virtual {v0, v1}, Landroid/view/View;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z

    :goto_recycle
    invoke-virtual {v1}, Landroid/view/MotionEvent;->recycle()V
    return-void
.end method

# private void dispatchScroll()
.method private dispatchScroll()V
    .locals 16

    move-object/from16 v0, p0

    new-instance v1, Landroid/view/MotionEvent$PointerProperties;
    invoke-direct {v1}, Landroid/view/MotionEvent$PointerProperties;-><init>()V
    const/4 v2, 0x0
    iput v2, v1, Landroid/view/MotionEvent$PointerProperties;->id:I
    const/4 v2, 0x3
    iput v2, v1, Landroid/view/MotionEvent$PointerProperties;->toolType:I

    new-instance v4, Landroid/view/MotionEvent$PointerCoords;
    invoke-direct {v4}, Landroid/view/MotionEvent$PointerCoords;-><init>()V
    iget v2, v0, Ltown/pony/game/mod/PtInput;->x:F
    iput v2, v4, Landroid/view/MotionEvent$PointerCoords;->x:F
    iget v2, v0, Ltown/pony/game/mod/PtInput;->y:F
    iput v2, v4, Landroid/view/MotionEvent$PointerCoords;->y:F
    const/4 v2, 0x0
    iput v2, v4, Landroid/view/MotionEvent$PointerCoords;->pressure:F
    const/high16 v2, 0x3f800000
    iput v2, v4, Landroid/view/MotionEvent$PointerCoords;->size:F

    const/16 v2, 0xA
    iget v3, v0, Ltown/pony/game/mod/PtInput;->x:F
    invoke-virtual {v4, v2, v3}, Landroid/view/MotionEvent$PointerCoords;->setAxisValue(IF)V
    const/16 v2, 0x9
    iget v3, v0, Ltown/pony/game/mod/PtInput;->y:F
    invoke-virtual {v4, v2, v3}, Landroid/view/MotionEvent$PointerCoords;->setAxisValue(IF)V

    const/4 v3, 0x1
    new-array v6, v3, [Landroid/view/MotionEvent$PointerProperties;
    const/4 v5, 0x0
    aput-object v1, v6, v5
    new-array v7, v3, [Landroid/view/MotionEvent$PointerCoords;
    aput-object v4, v7, v5

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v2

    const-wide/16 v0, 0x0
    const/16 v4, 0x8
    const/4 v5, 0x1
    const/4 v8, 0x0
    const/4 v9, 0x0
    const/high16 v10, 0x3f800000
    const/high16 v11, 0x3f800000
    const/4 v12, 0x0
    const/4 v13, 0x0
    const/16 v14, 0x2002
    const/4 v15, 0x0

    invoke-static/range {v0 .. v15}, Landroid/view/MotionEvent;->obtain(JJII[Landroid/view/MotionEvent$PointerProperties;[Landroid/view/MotionEvent$PointerCoords;IIFFIIII)Landroid/view/MotionEvent;
    move-result-object v1

    move-object/from16 v2, p0
    iget-object v0, v2, Ltown/pony/game/mod/PtInput;->wv:Landroid/webkit/WebView;
    invoke-virtual {v0, v1}, Landroid/view/View;->dispatchGenericMotionEvent(Landroid/view/MotionEvent;)Z
    invoke-virtual {v1}, Landroid/view/MotionEvent;->recycle()V
    return-void
.end method

# private static void dispatchKey(WebView wv, int androidKeyCode, boolean down)
.method private static dispatchKey(Landroid/webkit/WebView;IZ)V
    .locals 8

    new-instance v0, Landroid/view/KeyEvent;
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J
    move-result-wide v1
    move-wide v3, v1
    const/4 v5, 0x0
    if-nez p2, :cond_act
    const/4 v5, 0x1
    :cond_act
    move v6, p1
    const/4 v7, 0x0
    invoke-direct/range {v0 .. v7}, Landroid/view/KeyEvent;-><init>(JJIII)V
    if-eqz p2, :cond_nofocus
    invoke-virtual {p0}, Landroid/view/View;->requestFocus()Z
    :cond_nofocus
    invoke-virtual {p0, v0}, Landroid/webkit/WebView;->dispatchKeyEvent(Landroid/view/KeyEvent;)Z
    return-void
.end method
