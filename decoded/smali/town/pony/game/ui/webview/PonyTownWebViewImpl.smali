.class public final Ltown/pony/game/ui/webview/PonyTownWebViewImpl;
.super Ly5/a;
.source "r8-map-id-72568c339c850db02ef3375e1ae73f19aabc962be620a7ca6895e6b6a6a5456b"


# annotations
.annotation build Landroid/annotation/SuppressLint;
    value = {
        "ViewConstructor"
    }
.end annotation


# static fields
.field public static final L:I

.field public static final M:Ljava/util/LinkedHashSet;


# instance fields
.field public A:I

.field public B:Z

.field public C:Lo5/h;

.field public D:Z

.field public E:Ljava/lang/String;

.field public final F:Lc4/l;

.field public G:F

.field public final H:Ljava/util/concurrent/atomic/AtomicBoolean;

.field public I:Z

.field public J:I

.field public K:I

.field public final g:Ly5/f;

.field public final h:Lk5/c;

.field public i:Lg5/q0;

.field public j:Lg5/q0;

.field public k:Lg5/e1;

.field public l:Lg5/e1;

.field public m:Lg5/e1;

.field public n:Lg5/e1;

.field public final o:Lv5/e;

.field public final p:Lw5/b;

.field public final q:Z

.field public final r:F

.field public s:Ld/f;

.field public t:Ld/f;

.field public u:Ld/f;

.field public v:Z

.field public w:Z

.field public x:I

.field public y:I

.field public z:I


# direct methods
.method static constructor <clinit>()V
    .locals 9

    .line 1
    const-string v0, "#333333"

    .line 2
    .line 3
    invoke-static {v0}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    .line 4
    .line 5
    .line 6
    move-result v0

    .line 7
    sput v0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->L:I

    .line 8
    .line 9
    const/4 v0, -0x2

    .line 10
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 11
    .line 12
    .line 13
    move-result-object v0

    .line 14
    const/4 v1, -0x6

    .line 15
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 16
    .line 17
    .line 18
    move-result-object v1

    .line 19
    const/16 v2, -0xb

    .line 20
    .line 21
    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 22
    .line 23
    .line 24
    move-result-object v2

    .line 25
    const/4 v3, -0x7

    .line 26
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 27
    .line 28
    .line 29
    move-result-object v3

    .line 30
    const/4 v4, -0x8

    .line 31
    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 32
    .line 33
    .line 34
    move-result-object v4

    .line 35
    const/4 v5, -0x1

    .line 36
    invoke-static {v5}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 37
    .line 38
    .line 39
    move-result-object v5

    .line 40
    const/4 v6, 0x6

    .line 41
    new-array v7, v6, [Ljava/lang/Integer;

    .line 42
    .line 43
    const/4 v8, 0x0

    .line 44
    aput-object v0, v7, v8

    .line 45
    .line 46
    const/4 v0, 0x1

    .line 47
    aput-object v1, v7, v0

    .line 48
    .line 49
    const/4 v0, 0x2

    .line 50
    aput-object v2, v7, v0

    .line 51
    .line 52
    const/4 v0, 0x3

    .line 53
    aput-object v3, v7, v0

    .line 54
    .line 55
    const/4 v0, 0x4

    .line 56
    aput-object v4, v7, v0

    .line 57
    .line 58
    const/4 v0, 0x5

    .line 59
    aput-object v5, v7, v0

    .line 60
    .line 61
    new-instance v0, Ljava/util/LinkedHashSet;

    .line 62
    .line 63
    invoke-static {v6}, Ln4/v;->e0(I)I

    .line 64
    .line 65
    .line 66
    move-result v1

    .line 67
    invoke-direct {v0, v1}, Ljava/util/LinkedHashSet;-><init>(I)V

    .line 68
    .line 69
    .line 70
    :goto_0
    if-ge v8, v6, :cond_0

    .line 71
    .line 72
    aget-object v1, v7, v8

    .line 73
    .line 74
    invoke-interface {v0, v1}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z

    .line 75
    .line 76
    .line 77
    add-int/lit8 v8, v8, 0x1

    .line 78
    .line 79
    goto :goto_0

    .line 80
    :cond_0
    sput-object v0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->M:Ljava/util/LinkedHashSet;

    .line 81
    .line 82
    return-void
.end method

.method public constructor <init>(Ltown/pony/game/MainActivity;Ly5/f;Landroid/widget/FrameLayout;)V
    .locals 9

    .line 1
    const-string v0, "PTWebView"

    .line 2
    .line 3
    invoke-direct {p0, p1}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V

    .line 4
    .line 5
    .line 6
    iput-object p2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 7
    .line 8
    new-instance v1, Lg5/f1;

    .line 9
    .line 10
    invoke-direct {v1}, Lg5/t0;-><init>()V

    .line 11
    .line 12
    .line 13
    sget-object v2, Lg5/a0;->a:Lm5/e;

    .line 14
    .line 15
    sget-object v2, Lk5/m;->a:Lh5/d;

    .line 16
    .line 17
    iget-object v2, v2, Lh5/d;->k:Lh5/d;

    .line 18
    .line 19
    invoke-static {v1, v2}, Ln4/k;->H(Lp4/g;Lp4/i;)Lp4/i;

    .line 20
    .line 21
    .line 22
    move-result-object v1

    .line 23
    new-instance v2, Lk5/c;

    .line 24
    .line 25
    sget-object v3, Lg5/q;->h:Lg5/q;

    .line 26
    .line 27
    invoke-interface {v1, v3}, Lp4/i;->h(Lp4/h;)Lp4/g;

    .line 28
    .line 29
    .line 30
    move-result-object v3

    .line 31
    if-eqz v3, :cond_0

    .line 32
    .line 33
    goto :goto_0

    .line 34
    :cond_0
    new-instance v3, Lg5/t0;

    .line 35
    .line 36
    invoke-direct {v3}, Lg5/t0;-><init>()V

    .line 37
    .line 38
    .line 39
    invoke-interface {v1, v3}, Lp4/i;->f(Lp4/i;)Lp4/i;

    .line 40
    .line 41
    .line 42
    move-result-object v1

    .line 43
    :goto_0
    invoke-direct {v2, v1}, Lk5/c;-><init>(Lp4/i;)V

    .line 44
    .line 45
    .line 46
    iput-object v2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->h:Lk5/c;

    .line 47
    .line 48
    new-instance v1, Lv5/e;

    .line 49
    .line 50
    new-instance v2, Lcom/google/android/gms/internal/play_billing/l;

    .line 51
    .line 52
    invoke-direct {v2}, Lcom/google/android/gms/internal/play_billing/l;-><init>()V

    .line 53
    .line 54
    .line 55
    invoke-direct {v1, p0, v2}, Lv5/e;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Lcom/google/android/gms/internal/play_billing/l;)V

    .line 56
    .line 57
    .line 58
    iput-object v1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->o:Lv5/e;

    .line 59
    .line 60
    const/4 v1, 0x3

    .line 61
    iput v1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->K:I

    .line 62
    .line 63
    const/4 v2, 0x1

    .line 64
    iput-boolean v2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->B:Z

    .line 65
    .line 66
    sget-object v3, Lo5/g;->a:Lo5/g;

    .line 67
    .line 68
    iput-object v3, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->C:Lo5/h;

    .line 69
    .line 70
    new-instance v3, Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 71
    .line 72
    const/4 v4, 0x0

    .line 73
    invoke-direct {v3, v4}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    .line 74
    .line 75
    .line 76
    iput-object v3, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->H:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 77
    .line 78
    iput-boolean v2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->I:Z

    .line 79
    .line 80
    sget v3, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->L:I

    .line 81
    .line 82
    iput v3, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->J:I

    .line 83
    .line 84
    invoke-virtual {p1}, Lg/i;->getResources()Landroid/content/res/Resources;

    .line 85
    .line 86
    .line 87
    move-result-object v3

    .line 88
    const-string v5, "dimen"

    .line 89
    .line 90
    const-string v6, "android"

    .line 91
    .line 92
    const-string v7, "status_bar_height"

    .line 93
    .line 94
    invoke-virtual {v3, v7, v5, v6}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    .line 95
    .line 96
    .line 97
    move-result v3

    .line 98
    if-lez v3, :cond_1

    .line 99
    .line 100
    invoke-virtual {p1}, Lg/i;->getResources()Landroid/content/res/Resources;

    .line 101
    .line 102
    .line 103
    move-result-object v5

    .line 104
    invoke-virtual {v5, v3}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    .line 105
    .line 106
    .line 107
    move-result v3

    .line 108
    int-to-float v3, v3

    .line 109
    goto :goto_1

    .line 110
    :cond_1
    const/4 v3, 0x0

    .line 111
    :goto_1
    iput v3, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->r:F

    .line 112
    .line 113
    invoke-virtual {p1}, Lb/q;->i()Lb/i0;

    .line 114
    .line 115
    .line 116
    move-result-object v3

    .line 117
    iget-object p2, p2, Ly5/f;->y:Lb1/e0;

    .line 118
    .line 119
    const-string v5, "getCallback(...)"

    .line 120
    .line 121
    invoke-static {p2, v5}, Ly4/f;->d(Ljava/lang/Object;Ljava/lang/String;)V

    .line 122
    .line 123
    .line 124
    invoke-virtual {v3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 125
    .line 126
    .line 127
    invoke-virtual {v3, p2}, Lb/i0;->a(Lb1/e0;)Lb/g0;

    .line 128
    .line 129
    .line 130
    const p2, 0x1020002

    .line 131
    .line 132
    .line 133
    const/4 v3, 0x0

    .line 134
    :try_start_0
    invoke-virtual {p1, p2}, Lg/i;->findViewById(I)Landroid/view/View;

    .line 135
    .line 136
    .line 137
    move-result-object p2

    .line 138
    if-eqz p2, :cond_3

    .line 139
    .line 140
    invoke-static {p2}, Lc4/l;->f(Landroid/view/View;)Lc4/l;

    .line 141
    .line 142
    .line 143
    move-result-object p2

    .line 144
    const-string v5, "Retry"

    .line 145
    .line 146
    new-instance v6, Lcom/google/android/material/datepicker/n;

    .line 147
    .line 148
    const/4 v7, 0x4

    .line 149
    invoke-direct {v6, v7, p0}, Lcom/google/android/material/datepicker/n;-><init>(ILjava/lang/Object;)V

    .line 150
    .line 151
    .line 152
    iget-object v7, p2, Lc4/i;->i:Lc4/h;

    .line 153
    .line 154
    invoke-virtual {v7, v4}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    .line 155
    .line 156
    .line 157
    move-result-object v7

    .line 158
    check-cast v7, Lcom/google/android/material/snackbar/SnackbarContentLayout;

    .line 159
    .line 160
    invoke-virtual {v7}, Lcom/google/android/material/snackbar/SnackbarContentLayout;->getActionView()Landroid/widget/Button;

    .line 161
    .line 162
    .line 163
    move-result-object v7

    .line 164
    invoke-static {v5}, Landroid/text/TextUtils;->isEmpty(Ljava/lang/CharSequence;)Z

    .line 165
    .line 166
    .line 167
    move-result v8

    .line 168
    if-nez v8, :cond_2

    .line 169
    .line 170
    iput-boolean v2, p2, Lc4/l;->B:Z

    .line 171
    .line 172
    invoke-virtual {v7, v4}, Landroid/view/View;->setVisibility(I)V

    .line 173
    .line 174
    .line 175
    invoke-virtual {v7, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 176
    .line 177
    .line 178
    new-instance v5, Lc4/k;

    .line 179
    .line 180
    invoke-direct {v5, p2, v6}, Lc4/k;-><init>(Lc4/l;Lcom/google/android/material/datepicker/n;)V

    .line 181
    .line 182
    .line 183
    invoke-virtual {v7, v5}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 184
    .line 185
    .line 186
    goto :goto_2

    .line 187
    :cond_2
    const/16 v5, 0x8

    .line 188
    .line 189
    invoke-virtual {v7, v5}, Landroid/view/View;->setVisibility(I)V

    .line 190
    .line 191
    .line 192
    invoke-virtual {v7, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 193
    .line 194
    .line 195
    iput-boolean v4, p2, Lc4/l;->B:Z

    .line 196
    .line 197
    :goto_2
    iput-object p2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->F:Lc4/l;

    .line 198
    .line 199
    goto :goto_4

    .line 200
    :catch_0
    move-exception p2

    .line 201
    goto :goto_3

    .line 202
    :cond_3
    const-string p2, "Failed to initialize Snackbar: content view not found."

    .line 203
    .line 204
    invoke-static {v0, p2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 205
    .line 206
    .line 207
    goto :goto_4

    .line 208
    :goto_3
    invoke-virtual {p2}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    .line 209
    .line 210
    .line 211
    move-result-object p2

    .line 212
    new-instance v5, Ljava/lang/StringBuilder;

    .line 213
    .line 214
    const-string v6, "Failed to initialize Snackbar: "

    .line 215
    .line 216
    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 217
    .line 218
    .line 219
    invoke-virtual {v5, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 220
    .line 221
    .line 222
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 223
    .line 224
    .line 225
    move-result-object p2

    .line 226
    invoke-static {v0, p2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 227
    .line 228
    .line 229
    :goto_4
    invoke-direct {p0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->getActivity()Landroid/app/Activity;

    .line 230
    .line 231
    .line 232
    move-result-object p2

    .line 233
    if-eqz p2, :cond_6

    .line 234
    .line 235
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    .line 236
    .line 237
    const/16 v5, 0x1e

    .line 238
    .line 239
    if-lt v0, v5, :cond_5

    .line 240
    .line 241
    invoke-virtual {p2}, Landroid/app/Activity;->getWindowManager()Landroid/view/WindowManager;

    .line 242
    .line 243
    .line 244
    move-result-object p2

    .line 245
    invoke-static {p2}, Lp0/b;->d(Landroid/view/WindowManager;)Landroid/view/WindowMetrics;

    .line 246
    .line 247
    .line 248
    move-result-object p2

    .line 249
    invoke-static {p2}, Lp0/b;->c(Landroid/view/WindowMetrics;)Landroid/view/WindowInsets;

    .line 250
    .line 251
    .line 252
    move-result-object p2

    .line 253
    invoke-static {}, Ln2/d;->t()I

    .line 254
    .line 255
    .line 256
    move-result v0

    .line 257
    invoke-static {p2, v0}, Lp0/b;->a(Landroid/view/WindowInsets;I)Landroid/graphics/Insets;

    .line 258
    .line 259
    .line 260
    move-result-object p2

    .line 261
    const-string v0, "getInsetsIgnoringVisibility(...)"

    .line 262
    .line 263
    invoke-static {p2, v0}, Ly4/f;->d(Ljava/lang/Object;Ljava/lang/String;)V

    .line 264
    .line 265
    .line 266
    invoke-static {p2}, Landroidx/lifecycle/k0;->A(Landroid/graphics/Insets;)I

    .line 267
    .line 268
    .line 269
    move-result v0

    .line 270
    if-gtz v0, :cond_4

    .line 271
    .line 272
    invoke-static {p2}, Landroidx/lifecycle/k0;->s(Landroid/graphics/Insets;)I

    .line 273
    .line 274
    .line 275
    move-result v0

    .line 276
    if-gtz v0, :cond_4

    .line 277
    .line 278
    invoke-static {p2}, Landroidx/lifecycle/k0;->w(Landroid/graphics/Insets;)I

    .line 279
    .line 280
    .line 281
    move-result v0

    .line 282
    if-gtz v0, :cond_4

    .line 283
    .line 284
    invoke-static {p2}, Landroidx/lifecycle/k0;->b(Landroid/graphics/Insets;)I

    .line 285
    .line 286
    .line 287
    move-result p2

    .line 288
    if-lez p2, :cond_6

    .line 289
    .line 290
    :cond_4
    :goto_5
    move p2, v2

    .line 291
    goto :goto_6

    .line 292
    :cond_5
    invoke-virtual {p2}, Landroid/app/Activity;->getWindowManager()Landroid/view/WindowManager;

    .line 293
    .line 294
    .line 295
    move-result-object p2

    .line 296
    invoke-interface {p2}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    .line 297
    .line 298
    .line 299
    move-result-object p2

    .line 300
    new-instance v0, Landroid/util/DisplayMetrics;

    .line 301
    .line 302
    invoke-direct {v0}, Landroid/util/DisplayMetrics;-><init>()V

    .line 303
    .line 304
    .line 305
    invoke-virtual {p2, v0}, Landroid/view/Display;->getRealMetrics(Landroid/util/DisplayMetrics;)V

    .line 306
    .line 307
    .line 308
    iget v5, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    .line 309
    .line 310
    iget v0, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 311
    .line 312
    new-instance v6, Landroid/util/DisplayMetrics;

    .line 313
    .line 314
    invoke-direct {v6}, Landroid/util/DisplayMetrics;-><init>()V

    .line 315
    .line 316
    .line 317
    invoke-virtual {p2, v6}, Landroid/view/Display;->getMetrics(Landroid/util/DisplayMetrics;)V

    .line 318
    .line 319
    .line 320
    iget p2, v6, Landroid/util/DisplayMetrics;->heightPixels:I

    .line 321
    .line 322
    iget v6, v6, Landroid/util/DisplayMetrics;->widthPixels:I

    .line 323
    .line 324
    sub-int/2addr v0, v6

    .line 325
    if-gtz v0, :cond_4

    .line 326
    .line 327
    sub-int/2addr v5, p2

    .line 328
    if-lez v5, :cond_6

    .line 329
    .line 330
    goto :goto_5

    .line 331
    :cond_6
    move p2, v4

    .line 332
    :goto_6
    iput-boolean p2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->q:Z

    .line 333
    .line 334
    new-instance p2, Ly5/i;

    .line 335
    .line 336
    invoke-direct {p2, p0, p3, p1}, Ly5/i;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Landroid/widget/FrameLayout;Ltown/pony/game/MainActivity;)V

    .line 337
    .line 338
    .line 339
    invoke-virtual {p3, p2}, Landroid/view/View;->setOnApplyWindowInsetsListener(Landroid/view/View$OnApplyWindowInsetsListener;)V

    .line 340
    .line 341
    .line 342
    new-instance p2, Lw5/b;

    .line 343
    .line 344
    invoke-direct {p2, p1}, Lw5/b;-><init>(Ltown/pony/game/MainActivity;)V

    .line 345
    .line 346
    .line 347
    new-instance p3, Ly5/j;

    .line 348
    .line 349
    invoke-direct {p3, p0, v4}, Ly5/j;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;I)V

    .line 350
    .line 351
    .line 352
    iput-object p3, p2, Lw5/b;->k:Ly5/j;

    .line 353
    .line 354
    iput-object p2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p:Lw5/b;

    .line 355
    .line 356
    const/4 p2, 0x2

    .line 357
    invoke-virtual {p0, p2, v3}, Landroid/view/View;->setLayerType(ILandroid/graphics/Paint;)V

    .line 358
    .line 359
    .line 360
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    .line 361
    .line 362
    .line 363
    move-result-object p3

    .line 364
    invoke-virtual {p3, p0, v2}, Landroid/webkit/CookieManager;->setAcceptThirdPartyCookies(Landroid/webkit/WebView;Z)V

    .line 365
    .line 366
    .line 367
    invoke-virtual {p0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;

    .line 368
    .line 369
    .line 370
    move-result-object p3

    .line 371
    const-string v0, "getSettings(...)"

    .line 372
    .line 373
    invoke-static {p3, v0}, Ly4/f;->d(Ljava/lang/Object;Ljava/lang/String;)V

    .line 374
    .line 375
    .line 376
    invoke-virtual {p3, v2}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V

    .line 377
    .line 378
    .line 379
    invoke-virtual {p3, v2}, Landroid/webkit/WebSettings;->setJavaScriptCanOpenWindowsAutomatically(Z)V

    .line 380
    .line 381
    .line 382
    invoke-virtual {p3, v4}, Landroid/webkit/WebSettings;->setMediaPlaybackRequiresUserGesture(Z)V

    .line 383
    .line 384
    .line 385
    invoke-virtual {p3, v4}, Landroid/webkit/WebSettings;->setBuiltInZoomControls(Z)V

    .line 386
    .line 387
    .line 388
    const/16 v0, 0x64

    .line 389
    .line 390
    invoke-virtual {p3, v0}, Landroid/webkit/WebSettings;->setTextZoom(I)V

    .line 391
    .line 392
    .line 393
    invoke-virtual {p3, v2}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V

    .line 394
    .line 395
    .line 396
    invoke-virtual {p3, v2}, Landroid/webkit/WebSettings;->setUseWideViewPort(Z)V

    .line 397
    .line 398
    .line 399
    const/4 v0, -0x1

    .line 400
    invoke-virtual {p3, v0}, Landroid/webkit/WebSettings;->setCacheMode(I)V

    .line 401
    .line 402
    .line 403
    sget-object v0, Landroid/webkit/WebSettings$RenderPriority;->HIGH:Landroid/webkit/WebSettings$RenderPriority;

    .line 404
    .line 405
    invoke-virtual {p3, v0}, Landroid/webkit/WebSettings;->setRenderPriority(Landroid/webkit/WebSettings$RenderPriority;)V

    .line 406
    .line 407
    .line 408
    invoke-virtual {p3}, Landroid/webkit/WebSettings;->getUserAgentString()Ljava/lang/String;

    .line 409
    .line 410
    .line 411
    move-result-object v0

    .line 412
    new-instance v3, Ljava/lang/StringBuilder;

    .line 413
    .line 414
    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    .line 415
    .line 416
    .line 417
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 418
    .line 419
    .line 420
    const-string v0, " PonyTownApp/1.3"

    .line 421
    .line 422
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 423
    .line 424
    .line 425
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 426
    .line 427
    .line 428
    move-result-object v0

    .line 429
    invoke-virtual {p3, v0}, Landroid/webkit/WebSettings;->setUserAgentString(Ljava/lang/String;)V

    .line 430
    .line 431
    .line 432
    new-instance p3, Ly5/k;

    .line 433
    .line 434
    invoke-direct {p3, p0}, Ly5/k;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V

    .line 435
    .line 436
    .line 437
    invoke-virtual {p0, p3}, Landroid/webkit/WebView;->setDownloadListener(Landroid/webkit/DownloadListener;)V

    .line 438
    .line 439
    .line 440
    new-instance p3, Ly5/m;

    .line 441
    .line 442
    invoke-direct {p3, p0}, Ly5/m;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V

    .line 443
    .line 444
    .line 445
    invoke-virtual {p0, p3}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V

    .line 446
    .line 447
    .line 448
    new-instance p3, Ly5/o;

    .line 449
    .line 450
    invoke-direct {p3, p0}, Ly5/o;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V

    .line 451
    .line 452
    .line 453
    invoke-virtual {p0, p3}, Landroid/webkit/WebView;->setWebChromeClient(Landroid/webkit/WebChromeClient;)V

    .line 454
    .line 455
    .line 456
    iget-object p3, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 457
    .line 458
    invoke-virtual {p3}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 459
    .line 460
    .line 461
    new-instance v0, Ltown/pony/game/ui/webview/PonyTownInterface;

    .line 462
    .line 463
    invoke-direct {v0, p3}, Ltown/pony/game/ui/webview/PonyTownInterface;-><init>(Ly5/f;)V

    .line 464
    .line 465
    .line 466
    const-string p3, "Android"

    .line 467
    .line 468
    invoke-virtual {p0, v0, p3}, Landroid/webkit/WebView;->addJavascriptInterface(Ljava/lang/Object;Ljava/lang/String;)V

    # PonyTown Mod: register PtModBridge at creation (before first load) so window.PtModBridge exists on the page
    :try_start_ptb
    invoke-static {p0}, Ltown/pony/game/mod/PtModBridge;->ensureBridge(Landroid/webkit/WebView;)V
    :try_end_ptb
    .catch Ljava/lang/Throwable; {:try_start_ptb .. :try_end_ptb} :catch_ptb

    goto :goto_ptb

    :catch_ptb
    move-exception p3

    :goto_ptb

    .line 469
    .line 470
    .line 471
    new-instance p3, Ljava/lang/StringBuilder;

    .line 472
    .line 473
    invoke-direct {p3}, Ljava/lang/StringBuilder;-><init>()V

    .line 474
    .line 475
    .line 476
    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    .line 477
    .line 478
    .line 479
    move-result-object v0

    .line 480
    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 481
    .line 482
    .line 483
    const-string v0, "_preferences"

    .line 484
    .line 485
    invoke-virtual {p3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 486
    .line 487
    .line 488
    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 489
    .line 490
    .line 491
    move-result-object p3

    .line 492
    invoke-virtual {p1, p3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    .line 493
    .line 494
    .line 495
    move-result-object p1

    .line 496
    const-string p3, "IM"

    .line 497
    .line 498
    invoke-interface {p1, p3, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    .line 499
    .line 500
    .line 501
    move-result p1

    .line 502
    if-ne p1, v2, :cond_7

    .line 503
    .line 504
    move v1, p2

    .line 505
    goto :goto_7

    .line 506
    :cond_7
    if-nez p1, :cond_8

    .line 507
    .line 508
    move v1, v2

    .line 509
    :cond_8
    :goto_7
    invoke-virtual {p0, v1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->q(I)V

    .line 510
    .line 511
    .line 512
    return-void
.end method

.method private final getActivity()Landroid/app/Activity;
    .locals 1

    .line 1
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    invoke-static {v0}, Ln4/k;->m(Landroid/content/Context;)Landroid/app/Activity;

    .line 6
    .line 7
    .line 8
    move-result-object v0

    .line 9
    return-object v0
.end method

.method public static final i(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V
    .locals 2

    .line 1
    invoke-virtual {p0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p()V

    .line 2
    .line 3
    .line 4
    const/4 v0, 0x1

    .line 5
    invoke-direct {p0, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->setHideContent(Z)V

    .line 6
    .line 7
    .line 8
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->C:Lo5/h;

    .line 9
    .line 10
    instance-of v1, v0, Lo5/g;

    .line 11
    .line 12
    if-eqz v1, :cond_0

    .line 13
    .line 14
    const-wide/16 v0, 0x4b0

    .line 15
    .line 16
    goto :goto_0

    .line 17
    :cond_0
    instance-of v1, v0, Lo5/e;

    .line 18
    .line 19
    if-eqz v1, :cond_1

    .line 20
    .line 21
    const-wide/16 v0, 0x190

    .line 22
    .line 23
    goto :goto_0

    .line 24
    :cond_1
    instance-of v0, v0, Lo5/f;

    .line 25
    .line 26
    if-eqz v0, :cond_2

    .line 27
    .line 28
    const-wide/16 v0, 0x0

    .line 29
    .line 30
    :goto_0
    invoke-virtual {p0, v0, v1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->u(J)V

    .line 31
    .line 32
    .line 33
    return-void

    .line 34
    :cond_2
    new-instance p0, Lb1/u;

    .line 35
    .line 36
    invoke-direct {p0}, Ljava/lang/RuntimeException;-><init>()V

    .line 37
    .line 38
    .line 39
    throw p0
.end method

.method public static final j(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V
    .locals 6

    .line 1
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->H:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 2
    .line 3
    const/4 v1, 0x1

    .line 4
    const/4 v2, 0x0

    .line 5
    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    .line 6
    .line 7
    .line 8
    move-result v0

    .line 9
    if-nez v0, :cond_0

    .line 10
    .line 11
    goto :goto_1

    .line 12
    :cond_0
    const/4 v0, -0x1

    .line 13
    invoke-virtual {p0, v0}, Landroid/view/View;->setBackgroundColor(I)V

    .line 14
    .line 15
    .line 16
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->o:Lv5/e;

    .line 17
    .line 18
    const/4 v1, 0x3

    .line 19
    invoke-virtual {v0, v1}, Lv5/e;->a(I)V

    .line 20
    .line 21
    .line 22
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p:Lw5/b;

    .line 23
    .line 24
    iget-object v2, v0, Lw5/b;->d:Landroidx/lifecycle/f0;

    .line 25
    .line 26
    iget-object v3, v0, Lw5/b;->c:Landroid/os/Handler;

    .line 27
    .line 28
    iget-object v0, v0, Lw5/b;->e:Landroid/graphics/drawable/Drawable;

    .line 29
    .line 30
    if-nez v0, :cond_1

    .line 31
    .line 32
    goto :goto_0

    .line 33
    :cond_1
    invoke-virtual {v3, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 34
    .line 35
    .line 36
    const-wide/16 v4, 0x226

    .line 37
    .line 38
    invoke-virtual {v3, v2, v4, v5}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 39
    .line 40
    .line 41
    :goto_0
    invoke-virtual {p0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p()V

    .line 42
    .line 43
    .line 44
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->j:Lg5/q0;

    .line 45
    .line 46
    if-eqz v0, :cond_2

    .line 47
    .line 48
    invoke-static {v0}, Lg5/u;->a(Lg5/q0;)V

    .line 49
    .line 50
    .line 51
    :cond_2
    const/4 v0, 0x0

    .line 52
    iput-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->j:Lg5/q0;

    .line 53
    .line 54
    iget-object p0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->F:Lc4/l;

    .line 55
    .line 56
    if-eqz p0, :cond_3

    .line 57
    .line 58
    invoke-virtual {p0, v1}, Lc4/i;->a(I)V

    .line 59
    .line 60
    .line 61
    :cond_3
    :goto_1
    return-void
.end method

.method public static final synthetic k(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;IIII)V
    .locals 0

    .line 1
    invoke-super {p0, p1, p2, p3, p4}, Landroid/webkit/WebView;->onSizeChanged(IIII)V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method public static final l(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;)V
    .locals 4

    .line 1
    invoke-virtual {p0}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    iget-boolean v1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->w:Z

    .line 6
    .line 7
    if-nez v1, :cond_5

    .line 8
    .line 9
    if-eqz v0, :cond_5

    .line 10
    .line 11
    const-string v1, "file:///android_asset/offline.html"

    .line 12
    .line 13
    invoke-virtual {v0, v1}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    .line 14
    .line 15
    .line 16
    move-result v2

    .line 17
    if-eqz v2, :cond_0

    .line 18
    .line 19
    goto :goto_0

    .line 20
    :cond_0
    iget-object v2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->C:Lo5/h;

    .line 21
    .line 22
    instance-of v3, v2, Lo5/g;

    .line 23
    .line 24
    if-eqz v3, :cond_1

    .line 25
    .line 26
    const/4 v0, 0x0

    .line 27
    invoke-direct {p0, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->setHideContent(Z)V

    .line 28
    .line 29
    .line 30
    return-void

    .line 31
    :cond_1
    instance-of v3, v2, Lo5/e;

    .line 32
    .line 33
    if-eqz v3, :cond_2

    .line 34
    .line 35
    const-wide/16 v0, 0x190

    .line 36
    .line 37
    invoke-virtual {p0, v0, v1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->u(J)V

    .line 38
    .line 39
    .line 40
    return-void

    .line 41
    :cond_2
    instance-of v2, v2, Lo5/f;

    .line 42
    .line 43
    if-eqz v2, :cond_4

    .line 44
    .line 45
    iget-object v2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->E:Ljava/lang/String;

    .line 46
    .line 47
    if-nez v2, :cond_3

    .line 48
    .line 49
    iput-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->E:Ljava/lang/String;

    .line 50
    .line 51
    :cond_3
    const/4 v0, 0x1

    .line 52
    invoke-direct {p0, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->setHideContent(Z)V

    .line 53
    .line 54
    .line 55
    invoke-virtual {p0, v1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->loadUrl(Ljava/lang/String;)V

    .line 56
    .line 57
    .line 58
    return-void

    .line 59
    :cond_4
    new-instance p0, Lb1/u;

    .line 60
    .line 61
    invoke-direct {p0}, Ljava/lang/RuntimeException;-><init>()V

    .line 62
    .line 63
    .line 64
    throw p0

    .line 65
    :cond_5
    :goto_0
    return-void
.end method

.method public static final synthetic m(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Z)V
    .locals 0

    .line 1
    invoke-direct {p0, p1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->setHideContent(Z)V

    .line 2
    .line 3
    .line 4
    return-void
.end method

.method private final setHideContent(Z)V
    .locals 3

    .line 1
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->m:Lg5/e1;

    .line 2
    .line 3
    if-eqz v0, :cond_0

    .line 4
    .line 5
    invoke-static {v0}, Lg5/u;->a(Lg5/q0;)V

    .line 6
    .line 7
    .line 8
    :cond_0
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->h:Lk5/c;

    .line 9
    .line 10
    const/4 v1, 0x0

    .line 11
    if-eqz p1, :cond_1

    .line 12
    .line 13
    const/4 p1, 0x1

    .line 14
    iput-boolean p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->D:Z

    .line 15
    .line 16
    new-instance p1, Ly5/l;

    .line 17
    .line 18
    const/4 v2, 0x3

    .line 19
    invoke-direct {p1, p0, v1, v2}, Ly5/l;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Lp4/d;I)V

    .line 20
    .line 21
    .line 22
    invoke-static {v0, p1}, Lg5/u;->i(Lg5/r;Lx4/p;)Lg5/e1;

    .line 23
    .line 24
    .line 25
    move-result-object p1

    .line 26
    iput-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->m:Lg5/e1;

    .line 27
    .line 28
    return-void

    .line 29
    :cond_1
    new-instance p1, Ly5/l;

    .line 30
    .line 31
    const/4 v2, 0x4

    .line 32
    invoke-direct {p1, p0, v1, v2}, Ly5/l;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Lp4/d;I)V

    .line 33
    .line 34
    .line 35
    invoke-static {v0, p1}, Lg5/u;->i(Lg5/r;Lx4/p;)Lg5/e1;

    .line 36
    .line 37
    .line 38
    move-result-object p1

    .line 39
    iput-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->m:Lg5/e1;

    .line 40
    .line 41
    return-void
.end method


# virtual methods
.method public final a(Landroidx/lifecycle/u;)V
    .locals 5

    .line 1
    invoke-virtual {p0}, Landroid/webkit/WebView;->resumeTimers()V

    .line 2
    .line 3
    .line 4
    iget-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 5
    .line 6
    iget-object v0, p1, Ly5/f;->n:Lp5/c;

    .line 7
    .line 8
    iget-object v1, p1, Ly5/f;->p:Landroid/os/Handler;

    .line 9
    .line 10
    iget-object v2, p1, Ly5/f;->z:Lb1/h;

    .line 11
    .line 12
    const-wide/16 v3, 0x64

    .line 13
    .line 14
    invoke-virtual {v1, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 15
    .line 16
    .line 17
    iget-boolean v1, p1, Ly5/f;->s:Z

    .line 18
    .line 19
    if-eqz v1, :cond_0

    .line 20
    .line 21
    iget-wide v1, p1, Ly5/f;->r:D

    .line 22
    .line 23
    const-wide/16 v3, 0x0

    .line 24
    .line 25
    cmpl-double v3, v1, v3

    .line 26
    .line 27
    if-lez v3, :cond_0

    .line 28
    .line 29
    iget-object p1, p1, Ly5/f;->x:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 30
    .line 31
    if-eqz p1, :cond_0

    .line 32
    .line 33
    new-instance v3, Ljava/lang/StringBuilder;

    .line 34
    .line 35
    const-string v4, "window.api_setCurrentVolume("

    .line 36
    .line 37
    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 38
    .line 39
    .line 40
    invoke-virtual {v3, v1, v2}, Ljava/lang/StringBuilder;->append(D)Ljava/lang/StringBuilder;

    .line 41
    .line 42
    .line 43
    const-string v1, ")"

    .line 44
    .line 45
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 46
    .line 47
    .line 48
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 49
    .line 50
    .line 51
    move-result-object v1

    .line 52
    invoke-virtual {p1, v1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->h(Ljava/lang/String;)V

    .line 53
    .line 54
    .line 55
    :cond_0
    invoke-virtual {v0}, Lp5/c;->d()V

    .line 56
    .line 57
    .line 58
    invoke-virtual {v0}, Lp5/c;->c()V

    .line 59
    .line 60
    .line 61
    iget-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->k:Lg5/e1;

    .line 62
    .line 63
    if-eqz p1, :cond_1

    .line 64
    .line 65
    invoke-static {p1}, Lg5/u;->a(Lg5/q0;)V

    .line 66
    .line 67
    .line 68
    :cond_1
    new-instance p1, Ly5/l;

    .line 69
    .line 70
    const/4 v0, 0x0

    .line 71
    const/4 v1, 0x0

    .line 72
    invoke-direct {p1, p0, v1, v0}, Ly5/l;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Lp4/d;I)V

    .line 73
    .line 74
    .line 75
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->h:Lk5/c;

    .line 76
    .line 77
    invoke-static {v0, p1}, Lg5/u;->i(Lg5/r;Lx4/p;)Lg5/e1;

    .line 78
    .line 79
    .line 80
    move-result-object p1

    .line 81
    iput-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->k:Lg5/e1;

    .line 82
    .line 83
    return-void
.end method

.method public final b(Landroidx/lifecycle/u;)V
    .locals 0

    .line 1
    :try_start_0
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    .line 2
    .line 3
    .line 4
    move-result-object p1

    .line 5
    invoke-virtual {p1}, Landroid/webkit/CookieManager;->flush()V

    .line 6
    .line 7
    .line 8
    invoke-virtual {p0}, Landroid/webkit/WebView;->clearHistory()V

    .line 9
    .line 10
    .line 11
    invoke-virtual {p0}, Landroid/view/ViewGroup;->removeAllViews()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 12
    .line 13
    .line 14
    goto :goto_0

    .line 15
    :catch_0
    move-exception p1

    .line 16
    invoke-virtual {p1}, Ljava/lang/Throwable;->printStackTrace()V

    .line 17
    .line 18
    .line 19
    :goto_0
    iget-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->h:Lk5/c;

    .line 20
    .line 21
    invoke-static {p1}, Lg5/u;->b(Lk5/c;)V

    .line 22
    .line 23
    .line 24
    return-void
.end method

.method public final c(Landroidx/lifecycle/u;)V
    .locals 5

    .line 1
    invoke-direct {p0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->getActivity()Landroid/app/Activity;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    const/4 v1, 0x1

    .line 6
    invoke-direct {p0, v1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->setHideContent(Z)V

    .line 7
    .line 8
    .line 9
    :try_start_0
    iget-object v2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p:Lw5/b;

    .line 10
    .line 11
    invoke-virtual {p0}, Landroid/view/View;->getResources()Landroid/content/res/Resources;

    .line 12
    .line 13
    .line 14
    move-result-object v3

    .line 15
    invoke-virtual {v3}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    .line 16
    .line 17
    .line 18
    move-result-object v3

    .line 19
    const/high16 v4, 0x40000000    # 2.0f

    .line 20
    .line 21
    invoke-static {v1, v4, v3}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    .line 22
    .line 23
    .line 24
    move-result v1

    .line 25
    iget-object v2, v2, Lw5/b;->g:Landroid/graphics/Paint;

    .line 26
    .line 27
    invoke-virtual {v2, v1}, Landroid/graphics/Paint;->setStrokeWidth(F)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 28
    .line 29
    .line 30
    goto :goto_0

    .line 31
    :catch_0
    move-exception v1

    .line 32
    invoke-virtual {v1}, Ljava/lang/Throwable;->printStackTrace()V

    .line 33
    .line 34
    .line 35
    :goto_0
    instance-of v1, v0, Lg/i;

    .line 36
    .line 37
    if-eqz v1, :cond_0

    .line 38
    .line 39
    check-cast v0, Lg/i;

    .line 40
    .line 41
    iget-object v0, v0, Lb/q;->o:Lb/n;

    .line 42
    .line 43
    new-instance v1, Lq5/a;

    .line 44
    .line 45
    const/4 v2, 0x2

    .line 46
    invoke-direct {v1, v2}, Lq5/a;-><init>(I)V

    .line 47
    .line 48
    .line 49
    new-instance v2, Ly5/h;

    .line 50
    .line 51
    const/4 v3, 0x0

    .line 52
    invoke-direct {v2, p0, v3}, Ly5/h;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;I)V

    .line 53
    .line 54
    .line 55
    const-string v3, "PTGoogleLogIn"

    .line 56
    .line 57
    invoke-virtual {v0, v3, p1, v1, v2}, Lb/n;->c(Ljava/lang/String;Landroidx/lifecycle/u;Lv2/a;Ld/b;)Ld/f;

    .line 58
    .line 59
    .line 60
    move-result-object v1

    .line 61
    iput-object v1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->s:Ld/f;

    .line 62
    .line 63
    new-instance v1, Lq5/a;

    .line 64
    .line 65
    const/4 v2, 0x1

    .line 66
    invoke-direct {v1, v2}, Lq5/a;-><init>(I)V

    .line 67
    .line 68
    .line 69
    const/4 v2, 0x0

    .line 70
    iput-object v2, v1, Lq5/a;->j:Ljava/lang/Object;

    .line 71
    .line 72
    new-instance v3, Ly5/h;

    .line 73
    .line 74
    const/4 v4, 0x1

    .line 75
    invoke-direct {v3, p0, v4}, Ly5/h;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;I)V

    .line 76
    .line 77
    .line 78
    const-string v4, "PTExternalSave"

    .line 79
    .line 80
    invoke-virtual {v0, v4, p1, v1, v3}, Lb/n;->c(Ljava/lang/String;Landroidx/lifecycle/u;Lv2/a;Ld/b;)Ld/f;

    .line 81
    .line 82
    .line 83
    move-result-object v1

    .line 84
    iput-object v1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->u:Ld/f;

    .line 85
    .line 86
    new-instance v1, Lq5/a;

    .line 87
    .line 88
    const/4 v3, 0x0

    .line 89
    invoke-direct {v1, v3}, Lq5/a;-><init>(I)V

    .line 90
    .line 91
    .line 92
    iput-object v2, v1, Lq5/a;->j:Ljava/lang/Object;

    .line 93
    .line 94
    new-instance v2, Ld4/a0;

    .line 95
    .line 96
    const/16 v3, 0x9

    .line 97
    .line 98
    invoke-direct {v2, v3}, Ld4/a0;-><init>(I)V

    .line 99
    .line 100
    .line 101
    const-string v3, "PTFileChooser"

    .line 102
    .line 103
    invoke-virtual {v0, v3, p1, v1, v2}, Lb/n;->c(Ljava/lang/String;Landroidx/lifecycle/u;Lv2/a;Ld/b;)Ld/f;

    .line 104
    .line 105
    .line 106
    move-result-object p1

    .line 107
    iput-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->t:Ld/f;

    .line 108
    .line 109
    :cond_0
    return-void
.end method

.method public final e(Landroidx/lifecycle/u;)V
    .locals 2

    .line 1
    iget-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->k:Lg5/e1;

    .line 2
    .line 3
    if-eqz p1, :cond_0

    .line 4
    .line 5
    invoke-static {p1}, Lg5/u;->a(Lg5/q0;)V

    .line 6
    .line 7
    .line 8
    :cond_0
    invoke-static {}, Landroid/webkit/CookieManager;->getInstance()Landroid/webkit/CookieManager;

    .line 9
    .line 10
    .line 11
    move-result-object p1

    .line 12
    invoke-virtual {p1}, Landroid/webkit/CookieManager;->flush()V

    .line 13
    .line 14
    .line 15
    const/4 p1, 0x0

    .line 16
    invoke-virtual {p0, p1}, Landroid/view/View;->setKeepScreenOn(Z)V

    .line 17
    .line 18
    .line 19
    iget-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 20
    .line 21
    iget-object v0, p1, Ly5/f;->p:Landroid/os/Handler;

    .line 22
    .line 23
    iget-object v1, p1, Ly5/f;->z:Lb1/h;

    .line 24
    .line 25
    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 26
    .line 27
    .line 28
    iget-boolean v0, p1, Ly5/f;->u:Z

    .line 29
    .line 30
    if-eqz v0, :cond_1

    .line 31
    .line 32
    iget-object p1, p1, Ly5/f;->x:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 33
    .line 34
    if-eqz p1, :cond_1

    .line 35
    .line 36
    const-string v0, "Android.setVolume(window.api_getCurrentVolume());window.api_setCurrentVolume(0);"

    .line 37
    .line 38
    invoke-virtual {p1, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->h(Ljava/lang/String;)V

    .line 39
    .line 40
    .line 41
    :cond_1
    # PonyTown Mod: do NOT pauseTimers() on stop -- it freezes the game's JS
    # heartbeat in background and the server drops the connection.

    .line 42
    .line 43
    .line 44
    return-void
.end method

.method public final getPullToRefresh()Lv5/a;
    .locals 1

    .line 1
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->o:Lv5/e;

    .line 2
    .line 3
    return-object v0
.end method

.method public final h(Ljava/lang/String;)V
    .locals 2

    .line 1
    if-nez p1, :cond_0

    .line 2
    .line 3
    return-void

    .line 4
    :cond_0
    new-instance v0, Ljava/lang/StringBuilder;

    .line 5
    .line 6
    const-string v1, "try { "

    .line 7
    .line 8
    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 9
    .line 10
    .line 11
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 12
    .line 13
    .line 14
    const-string p1, " }catch(ex){ console.error(\'Error in App-side JS execution:\', ex);}"

    .line 15
    .line 16
    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 17
    .line 18
    .line 19
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 20
    .line 21
    .line 22
    move-result-object p1

    .line 23
    const/4 v0, 0x0

    .line 24
    invoke-virtual {p0, p1, v0}, Landroid/webkit/WebView;->evaluateJavascript(Ljava/lang/String;Landroid/webkit/ValueCallback;)V

    .line 25
    .line 26
    .line 27
    return-void
.end method

.method public final loadUrl(Ljava/lang/String;)V
    .locals 1

    const-string v0, "url"

    invoke-static {p1, v0}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 1
    invoke-super {p0, p1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 2
    iput-boolean v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->w:Z

    .line 3
    invoke-virtual {p0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p()V

    .line 4
    const-string v0, "file:///android_asset/offline.html"

    .line 5
    invoke-virtual {v0, p1}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 6
    invoke-virtual {p0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->s()V

    :cond_0
    return-void
.end method

.method public final loadUrl(Ljava/lang/String;Ljava/util/Map;)V
    .locals 1

    const-string v0, "url"

    invoke-static {p1, v0}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    const-string v0, "additionalHttpHeaders"

    invoke-static {p2, v0}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 7
    invoke-super {p0, p1, p2}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;Ljava/util/Map;)V

    const/4 p2, 0x0

    .line 8
    iput-boolean p2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->w:Z

    .line 9
    invoke-virtual {p0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p()V

    .line 10
    const-string p2, "file:///android_asset/offline.html"

    .line 11
    invoke-virtual {p2, p1}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_0

    .line 12
    invoke-virtual {p0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->s()V

    :cond_0
    return-void
.end method

.method public final n()V
    .locals 4

    .line 1
    iget v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->K:I

    .line 2
    .line 3
    const/4 v1, 0x2

    .line 4
    if-ne v0, v1, :cond_0

    .line 5
    .line 6
    iget-boolean v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->q:Z

    .line 7
    .line 8
    if-nez v0, :cond_0

    .line 9
    .line 10
    const/4 v0, 0x3

    .line 11
    iput v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->K:I

    .line 12
    .line 13
    :cond_0
    invoke-direct {p0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->getActivity()Landroid/app/Activity;

    .line 14
    .line 15
    .line 16
    move-result-object v0

    .line 17
    if-nez v0, :cond_1

    .line 18
    .line 19
    goto :goto_0

    .line 20
    :cond_1
    invoke-virtual {v0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    .line 21
    .line 22
    .line 23
    move-result-object v0

    .line 24
    if-nez v0, :cond_2

    .line 25
    .line 26
    :goto_0
    return-void

    .line 27
    :cond_2
    iget v2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->K:I

    .line 28
    .line 29
    invoke-static {v2}, Lu/e;->b(I)I

    .line 30
    .line 31
    .line 32
    move-result v2

    .line 33
    const/16 v3, 0x400

    .line 34
    .line 35
    if-eqz v2, :cond_4

    .line 36
    .line 37
    if-eq v2, v1, :cond_3

    .line 38
    .line 39
    invoke-virtual {v0, v3}, Landroid/view/Window;->clearFlags(I)V

    .line 40
    .line 41
    .line 42
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    .line 43
    .line 44
    .line 45
    move-result-object v0

    .line 46
    const/16 v1, 0x1504

    .line 47
    .line 48
    invoke-virtual {v0, v1}, Landroid/view/View;->setSystemUiVisibility(I)V

    .line 49
    .line 50
    .line 51
    goto :goto_1

    .line 52
    :cond_3
    invoke-virtual {v0, v3}, Landroid/view/Window;->clearFlags(I)V

    .line 53
    .line 54
    .line 55
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    .line 56
    .line 57
    .line 58
    move-result-object v0

    .line 59
    const/4 v1, 0x0

    .line 60
    invoke-virtual {v0, v1}, Landroid/view/View;->setSystemUiVisibility(I)V

    .line 61
    .line 62
    .line 63
    goto :goto_1

    .line 64
    :cond_4
    invoke-virtual {v0, v3}, Landroid/view/Window;->clearFlags(I)V

    .line 65
    .line 66
    .line 67
    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    .line 68
    .line 69
    .line 70
    move-result-object v0

    .line 71
    const/16 v1, 0x1706

    .line 72
    .line 73
    invoke-virtual {v0, v1}, Landroid/view/View;->setSystemUiVisibility(I)V

    .line 74
    .line 75
    .line 76
    :goto_1
    invoke-virtual {p0}, Landroid/view/View;->requestLayout()V

    .line 77
    .line 78
    .line 79
    return-void
.end method

.method public final o()V
    .locals 1

    .line 1
    const/4 v0, 0x1

    .line 2
    iput-boolean v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->w:Z

    .line 3
    .line 4
    invoke-virtual {p0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p()V

    .line 5
    .line 6
    .line 7
    const/4 v0, 0x0

    .line 8
    invoke-direct {p0, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->setHideContent(Z)V

    .line 9
    .line 10
    .line 11
    return-void
.end method

.method public final onCreateInputConnection(Landroid/view/inputmethod/EditorInfo;)Landroid/view/inputmethod/InputConnection;
    .locals 4

    .line 1
    const-string v0, "outAttrs"

    .line 2
    .line 3
    invoke-static {p1, v0}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    invoke-super {p0, p1}, Landroid/webkit/WebView;->onCreateInputConnection(Landroid/view/inputmethod/EditorInfo;)Landroid/view/inputmethod/InputConnection;

    .line 7
    .line 8
    .line 9
    move-result-object v0

    .line 10
    iget v1, p1, Landroid/view/inputmethod/EditorInfo;->inputType:I

    .line 11
    .line 12
    and-int/lit16 v2, v1, 0xe0

    .line 13
    .line 14
    const/16 v3, 0xe0

    .line 15
    .line 16
    if-eq v2, v3, :cond_0

    .line 17
    .line 18
    const v2, -0x90001

    .line 19
    .line 20
    .line 21
    and-int/2addr v1, v2

    .line 22
    const v2, 0x8000

    .line 23
    .line 24
    .line 25
    or-int/2addr v1, v2

    .line 26
    iput v1, p1, Landroid/view/inputmethod/EditorInfo;->inputType:I

    .line 27
    .line 28
    :cond_0
    return-object v0
.end method

.method public final onDraw(Landroid/graphics/Canvas;)V
    .locals 14

    .line 1
    move-object v0, p1

    .line 2
    const-string v1, "canvas"

    .line 3
    .line 4
    invoke-static {p1, v1}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 5
    .line 6
    .line 7
    iget-boolean v1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->D:Z

    .line 8
    .line 9
    if-eqz v1, :cond_0

    .line 10
    .line 11
    iget v1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->J:I

    .line 12
    .line 13
    invoke-virtual {p1, v1}, Landroid/graphics/Canvas;->drawColor(I)V

    .line 14
    .line 15
    .line 16
    goto :goto_0

    .line 17
    :cond_0
    invoke-super/range {p0 .. p1}, Landroid/webkit/WebView;->onDraw(Landroid/graphics/Canvas;)V

    .line 18
    .line 19
    .line 20
    :goto_0
    iget-object v1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->o:Lv5/e;

    .line 21
    .line 22
    iget-object v2, v1, Lv5/e;->a:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 23
    .line 24
    iget-object v9, v1, Lv5/e;->b:Lcom/google/android/gms/internal/play_billing/l;

    .line 25
    .line 26
    iget v3, v1, Lv5/e;->j:I

    .line 27
    .line 28
    invoke-static {v3}, Lu/e;->b(I)I

    .line 29
    .line 30
    .line 31
    move-result v3

    .line 32
    const/high16 v4, 0x3f800000    # 1.0f

    .line 33
    .line 34
    const/high16 v5, 0x40000000    # 2.0f

    .line 35
    .line 36
    const/high16 v6, 0x43af0000    # 350.0f

    .line 37
    .line 38
    const/high16 v7, 0x42480000    # 50.0f

    .line 39
    .line 40
    const/high16 v8, 0x41700000    # 15.0f

    .line 41
    .line 42
    if-eqz v3, :cond_3

    .line 43
    .line 44
    const/4 v10, 0x1

    .line 45
    if-eq v3, v10, :cond_1

    .line 46
    .line 47
    goto/16 :goto_1

    .line 48
    .line 49
    :cond_1
    iget v10, v1, Lv5/e;->e:F

    .line 50
    .line 51
    invoke-virtual {v2}, Landroid/view/View;->getScrollY()I

    .line 52
    .line 53
    .line 54
    move-result v1

    .line 55
    int-to-float v1, v1

    .line 56
    const v2, 0x3c23d70a    # 0.01f

    .line 57
    .line 58
    .line 59
    cmpg-float v2, v10, v2

    .line 60
    .line 61
    if-gtz v2, :cond_2

    .line 62
    .line 63
    invoke-virtual {v9}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 64
    .line 65
    .line 66
    goto/16 :goto_1

    .line 67
    .line 68
    :cond_2
    invoke-virtual {v9}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 69
    .line 70
    .line 71
    invoke-static {v4, v10}, Ljava/lang/Math;->min(FF)F

    .line 72
    .line 73
    .line 74
    move-result v2

    .line 75
    neg-float v3, v2

    .line 76
    add-float/2addr v3, v4

    .line 77
    mul-float/2addr v2, v5

    .line 78
    add-float/2addr v2, v4

    .line 79
    mul-float/2addr v2, v3

    .line 80
    mul-float/2addr v2, v3

    .line 81
    mul-float/2addr v2, v3

    .line 82
    sub-float/2addr v4, v2

    .line 83
    invoke-virtual {p1}, Landroid/graphics/Canvas;->getWidth()I

    .line 84
    .line 85
    .line 86
    move-result v2

    .line 87
    int-to-float v2, v2

    .line 88
    div-float v11, v2, v5

    .line 89
    .line 90
    mul-float/2addr v6, v4

    .line 91
    add-float v12, v6, v1

    .line 92
    .line 93
    const/high16 v1, 0x43870000    # 270.0f

    .line 94
    .line 95
    mul-float/2addr v1, v4

    .line 96
    const/high16 v2, 0x42b40000    # 90.0f

    .line 97
    .line 98
    add-float v5, v1, v2

    .line 99
    .line 100
    const/high16 v1, 0x43960000    # 300.0f

    .line 101
    .line 102
    mul-float v6, v4, v1

    .line 103
    .line 104
    iget-object v1, v9, Lcom/google/android/gms/internal/play_billing/l;->h:Ljava/lang/Object;

    .line 105
    .line 106
    check-cast v1, Landroid/graphics/Paint;

    .line 107
    .line 108
    invoke-virtual {p1, v11, v12, v7, v1}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 109
    .line 110
    .line 111
    sub-float v1, v11, v7

    .line 112
    .line 113
    add-float/2addr v1, v8

    .line 114
    sub-float v2, v12, v7

    .line 115
    .line 116
    add-float/2addr v2, v8

    .line 117
    add-float v3, v11, v7

    .line 118
    .line 119
    sub-float/2addr v3, v8

    .line 120
    add-float/2addr v7, v12

    .line 121
    sub-float v4, v7, v8

    .line 122
    .line 123
    iget-object v7, v9, Lcom/google/android/gms/internal/play_billing/l;->i:Ljava/lang/Object;

    .line 124
    .line 125
    move-object v8, v7

    .line 126
    check-cast v8, Landroid/graphics/Paint;

    .line 127
    .line 128
    const/4 v7, 0x0

    .line 129
    invoke-virtual/range {v0 .. v8}, Landroid/graphics/Canvas;->drawArc(FFFFFFZLandroid/graphics/Paint;)V

    .line 130
    .line 131
    .line 132
    add-float/2addr v5, v6

    .line 133
    const v1, 0x406aaaab

    .line 134
    .line 135
    .line 136
    add-float/2addr v5, v1

    .line 137
    float-to-double v1, v5

    .line 138
    invoke-static {v1, v2}, Ljava/lang/Math;->toRadians(D)D

    .line 139
    .line 140
    .line 141
    move-result-wide v3

    .line 142
    invoke-static {v3, v4}, Ljava/lang/Math;->cos(D)D

    .line 143
    .line 144
    .line 145
    move-result-wide v3

    .line 146
    double-to-float v3, v3

    .line 147
    invoke-static {v1, v2}, Ljava/lang/Math;->toRadians(D)D

    .line 148
    .line 149
    .line 150
    move-result-wide v1

    .line 151
    invoke-static {v1, v2}, Ljava/lang/Math;->sin(D)D

    .line 152
    .line 153
    .line 154
    move-result-wide v1

    .line 155
    double-to-float v1, v1

    .line 156
    const/high16 v2, 0x420c0000    # 35.0f

    .line 157
    .line 158
    mul-float v4, v3, v2

    .line 159
    .line 160
    add-float/2addr v4, v11

    .line 161
    mul-float/2addr v2, v1

    .line 162
    add-float/2addr v2, v12

    .line 163
    const/high16 v5, 0x42220000    # 40.5f

    .line 164
    .line 165
    mul-float/2addr v3, v5

    .line 166
    add-float/2addr v3, v11

    .line 167
    sub-float/2addr v3, v4

    .line 168
    mul-float/2addr v3, v10

    .line 169
    mul-float/2addr v1, v5

    .line 170
    add-float/2addr v1, v12

    .line 171
    sub-float/2addr v1, v2

    .line 172
    mul-float/2addr v1, v10

    .line 173
    new-instance v5, Landroid/graphics/Path;

    .line 174
    .line 175
    invoke-direct {v5}, Landroid/graphics/Path;-><init>()V

    .line 176
    .line 177
    .line 178
    add-float v6, v3, v4

    .line 179
    .line 180
    add-float v7, v1, v2

    .line 181
    .line 182
    invoke-virtual {v5, v6, v7}, Landroid/graphics/Path;->moveTo(FF)V

    .line 183
    .line 184
    .line 185
    neg-float v1, v1

    .line 186
    const v6, 0x3f99999a    # 1.2f

    .line 187
    .line 188
    .line 189
    mul-float v7, v1, v6

    .line 190
    .line 191
    add-float/2addr v7, v4

    .line 192
    mul-float/2addr v6, v3

    .line 193
    add-float/2addr v6, v2

    .line 194
    invoke-virtual {v5, v7, v6}, Landroid/graphics/Path;->lineTo(FF)V

    .line 195
    .line 196
    .line 197
    sub-float/2addr v4, v3

    .line 198
    add-float/2addr v1, v2

    .line 199
    invoke-virtual {v5, v4, v1}, Landroid/graphics/Path;->lineTo(FF)V

    .line 200
    .line 201
    .line 202
    invoke-virtual {v5}, Landroid/graphics/Path;->close()V

    .line 203
    .line 204
    .line 205
    iget-object v1, v9, Lcom/google/android/gms/internal/play_billing/l;->j:Ljava/lang/Object;

    .line 206
    .line 207
    check-cast v1, Landroid/graphics/Paint;

    .line 208
    .line 209
    invoke-virtual {p1, v5, v1}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 210
    .line 211
    .line 212
    goto :goto_1

    .line 213
    :cond_3
    iget v3, v1, Lv5/e;->i:F

    .line 214
    .line 215
    invoke-virtual {v2}, Landroid/view/View;->getScrollY()I

    .line 216
    .line 217
    .line 218
    move-result v2

    .line 219
    int-to-float v2, v2

    .line 220
    iget v10, v1, Lv5/e;->m:F

    .line 221
    .line 222
    iget v11, v1, Lv5/e;->l:F

    .line 223
    .line 224
    iget v1, v1, Lv5/e;->k:F

    .line 225
    .line 226
    invoke-virtual {v9}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 227
    .line 228
    .line 229
    invoke-virtual {p1}, Landroid/graphics/Canvas;->getWidth()I

    .line 230
    .line 231
    .line 232
    move-result v12

    .line 233
    int-to-float v12, v12

    .line 234
    div-float/2addr v12, v5

    .line 235
    invoke-static {v4, v3}, Ljava/lang/Math;->min(FF)F

    .line 236
    .line 237
    .line 238
    move-result v3

    .line 239
    neg-float v13, v3

    .line 240
    add-float/2addr v13, v4

    .line 241
    mul-float/2addr v3, v5

    .line 242
    add-float/2addr v3, v4

    .line 243
    mul-float/2addr v3, v13

    .line 244
    mul-float/2addr v3, v13

    .line 245
    mul-float/2addr v3, v13

    .line 246
    sub-float/2addr v4, v3

    .line 247
    mul-float/2addr v4, v6

    .line 248
    add-float/2addr v4, v2

    .line 249
    iget-object v2, v9, Lcom/google/android/gms/internal/play_billing/l;->h:Ljava/lang/Object;

    .line 250
    .line 251
    check-cast v2, Landroid/graphics/Paint;

    .line 252
    .line 253
    invoke-virtual {p1, v12, v4, v7, v2}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 254
    .line 255
    .line 256
    sub-float v2, v12, v7

    .line 257
    .line 258
    add-float/2addr v2, v8

    .line 259
    sub-float v3, v4, v7

    .line 260
    .line 261
    add-float/2addr v3, v8

    .line 262
    add-float/2addr v12, v7

    .line 263
    sub-float/2addr v12, v8

    .line 264
    add-float/2addr v4, v7

    .line 265
    sub-float/2addr v4, v8

    .line 266
    add-float v5, v10, v11

    .line 267
    .line 268
    iget-object v6, v9, Lcom/google/android/gms/internal/play_billing/l;->i:Ljava/lang/Object;

    .line 269
    .line 270
    move-object v8, v6

    .line 271
    check-cast v8, Landroid/graphics/Paint;

    .line 272
    .line 273
    const/4 v7, 0x0

    .line 274
    move v6, v1

    .line 275
    move v1, v2

    .line 276
    move v2, v3

    .line 277
    move v3, v12

    .line 278
    invoke-virtual/range {v0 .. v8}, Landroid/graphics/Canvas;->drawArc(FFFFFFZLandroid/graphics/Paint;)V

    .line 279
    .line 280
    .line 281
    :goto_1
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p:Lw5/b;

    .line 282
    .line 283
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 284
    .line 285
    .line 286
    iget-boolean v1, v0, Lw5/b;->i:Z

    .line 287
    .line 288
    if-eqz v1, :cond_6

    .line 289
    .line 290
    iget-object v1, v0, Lw5/b;->e:Landroid/graphics/drawable/Drawable;

    .line 291
    .line 292
    if-eqz v1, :cond_6

    .line 293
    .line 294
    iget v1, v0, Lw5/b;->j:F

    .line 295
    .line 296
    const/4 v2, 0x0

    .line 297
    cmpg-float v1, v1, v2

    .line 298
    .line 299
    if-gtz v1, :cond_4

    .line 300
    .line 301
    goto :goto_2

    .line 302
    :cond_4
    iget v1, v0, Lw5/b;->h:F

    .line 303
    .line 304
    const v2, 0x3e99999a    # 0.3f

    .line 305
    .line 306
    .line 307
    cmpg-float v1, v1, v2

    .line 308
    .line 309
    if-gez v1, :cond_5

    .line 310
    .line 311
    iput v2, v0, Lw5/b;->h:F

    .line 312
    .line 313
    :cond_5
    invoke-virtual {p1}, Landroid/graphics/Canvas;->getWidth()I

    .line 314
    .line 315
    .line 316
    move-result v1

    .line 317
    int-to-float v1, v1

    .line 318
    iget v2, v0, Lw5/b;->j:F

    .line 319
    .line 320
    const v3, 0x3e8a3d71    # 0.27f

    .line 321
    .line 322
    .line 323
    iget v4, v0, Lw5/b;->h:F

    .line 324
    .line 325
    invoke-static {v2, v3, v4}, Lv2/a;->s(FFF)F

    .line 326
    .line 327
    .line 328
    move-result v2

    .line 329
    mul-float v3, v2, v1

    .line 330
    .line 331
    const/4 v4, 0x0

    .line 332
    iget-object v5, v0, Lw5/b;->g:Landroid/graphics/Paint;

    .line 333
    .line 334
    const/4 v1, 0x0

    .line 335
    const/4 v2, 0x0

    .line 336
    move-object v0, p1

    .line 337
    invoke-virtual/range {v0 .. v5}, Landroid/graphics/Canvas;->drawLine(FFFFLandroid/graphics/Paint;)V

    .line 338
    .line 339
    .line 340
    :cond_6
    :goto_2
    return-void
.end method

.method public final onOverScrolled(IIZZ)V
    .locals 0

    .line 1
    invoke-super {p0, p1, p2, p3, p4}, Landroid/webkit/WebView;->onOverScrolled(IIZZ)V

    .line 2
    .line 3
    .line 4
    iget-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 5
    .line 6
    iget-boolean p1, p1, Ly5/f;->s:Z

    .line 7
    .line 8
    if-nez p1, :cond_0

    .line 9
    .line 10
    iget-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->o:Lv5/e;

    .line 11
    .line 12
    iget-boolean p3, p1, Lv5/e;->d:Z

    .line 13
    .line 14
    if-nez p3, :cond_0

    .line 15
    .line 16
    if-nez p2, :cond_0

    .line 17
    .line 18
    if-eqz p4, :cond_0

    .line 19
    .line 20
    const/4 p2, 0x2

    .line 21
    invoke-virtual {p1, p2}, Lv5/e;->a(I)V

    .line 22
    .line 23
    .line 24
    const/4 p2, 0x1

    .line 25
    iput-boolean p2, p1, Lv5/e;->d:Z

    .line 26
    .line 27
    iget p2, p1, Lv5/e;->g:F

    .line 28
    .line 29
    iput p2, p1, Lv5/e;->f:F

    .line 30
    .line 31
    :cond_0
    return-void
.end method

.method public onSizeChanged(IIII)V
    .locals 0
    .annotation build Landroidx/annotation/Keep;
    .end annotation

    .line 1
    iput p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->x:I

    .line 2
    .line 3
    iput p2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->y:I

    .line 4
    .line 5
    iget-boolean p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->B:Z

    .line 6
    .line 7
    if-eqz p1, :cond_0

    .line 8
    .line 9
    iput p3, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->z:I

    .line 10
    .line 11
    iput p4, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->A:I

    .line 12
    .line 13
    :cond_0
    iget-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->l:Lg5/e1;

    .line 14
    .line 15
    if-eqz p1, :cond_1

    .line 16
    .line 17
    invoke-static {p1}, Lg5/u;->a(Lg5/q0;)V

    .line 18
    .line 19
    .line 20
    :cond_1
    const/4 p1, 0x0

    .line 21
    iput-boolean p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->B:Z

    .line 22
    .line 23
    new-instance p1, Ly5/l;

    .line 24
    .line 25
    const/4 p2, 0x1

    .line 26
    const/4 p3, 0x0

    .line 27
    invoke-direct {p1, p0, p3, p2}, Ly5/l;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Lp4/d;I)V

    .line 28
    .line 29
    .line 30
    iget-object p2, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->h:Lk5/c;

    .line 31
    .line 32
    invoke-static {p2, p1}, Lg5/u;->i(Lg5/r;Lx4/p;)Lg5/e1;

    .line 33
    .line 34
    .line 35
    move-result-object p1

    .line 36
    iput-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->l:Lg5/e1;

    .line 37
    .line 38
    return-void
.end method

.method public final onTouchEvent(Landroid/view/MotionEvent;)Z
    .locals 9

    .line 1
    const-string v0, "event"

    .line 2
    .line 3
    invoke-static {p1, v0}, Ly4/f;->e(Ljava/lang/Object;Ljava/lang/String;)V

    .line 4
    .line 5
    .line 6
    iget v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->K:I

    .line 7
    .line 8
    const/4 v1, 0x3

    .line 9
    const/4 v2, 0x5

    .line 10
    const/4 v3, 0x2

    .line 11
    const/4 v4, 0x1

    .line 12
    if-eq v0, v1, :cond_2

    .line 13
    .line 14
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    .line 15
    .line 16
    .line 17
    move-result v0

    .line 18
    if-eqz v0, :cond_1

    .line 19
    .line 20
    if-eq v0, v3, :cond_0

    .line 21
    .line 22
    if-eq v0, v2, :cond_1

    .line 23
    .line 24
    goto :goto_0

    .line 25
    :cond_0
    iget v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->G:F

    .line 26
    .line 27
    iget v5, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->r:F

    .line 28
    .line 29
    cmpg-float v0, v0, v5

    .line 30
    .line 31
    if-gtz v0, :cond_2

    .line 32
    .line 33
    iput v5, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->G:F

    .line 34
    .line 35
    return v4

    .line 36
    :cond_1
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    .line 37
    .line 38
    .line 39
    move-result v0

    .line 40
    iput v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->G:F

    .line 41
    .line 42
    :cond_2
    :goto_0
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    .line 43
    .line 44
    .line 45
    move-result v0

    .line 46
    if-ne v0, v1, :cond_3

    .line 47
    .line 48
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 49
    .line 50
    iget-boolean v0, v0, Ly5/f;->s:Z

    .line 51
    .line 52
    if-eqz v0, :cond_3

    .line 53
    .line 54
    invoke-static {p1}, Landroid/view/MotionEvent;->obtain(Landroid/view/MotionEvent;)Landroid/view/MotionEvent;

    .line 55
    .line 56
    .line 57
    move-result-object p1

    .line 58
    invoke-virtual {p1, v4}, Landroid/view/MotionEvent;->setAction(I)V

    .line 59
    .line 60
    .line 61
    invoke-super {p0, p1}, Landroid/webkit/WebView;->onTouchEvent(Landroid/view/MotionEvent;)Z

    .line 62
    .line 63
    .line 64
    move-result v0

    .line 65
    invoke-virtual {p1}, Landroid/view/MotionEvent;->recycle()V

    .line 66
    .line 67
    .line 68
    return v0

    .line 69
    :cond_3
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->o:Lv5/e;

    .line 70
    .line 71
    iget-object v5, v0, Lv5/e;->a:Ltown/pony/game/ui/webview/PonyTownWebViewImpl;

    .line 72
    .line 73
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    .line 74
    .line 75
    .line 76
    move-result v6

    .line 77
    const/4 v7, 0x0

    .line 78
    if-eqz v6, :cond_a

    .line 79
    .line 80
    const/4 v8, 0x0

    .line 81
    if-eq v6, v4, :cond_8

    .line 82
    .line 83
    if-eq v6, v3, :cond_4

    .line 84
    .line 85
    if-eq v6, v1, :cond_8

    .line 86
    .line 87
    if-eq v6, v2, :cond_a

    .line 88
    .line 89
    const/4 v2, 0x6

    .line 90
    if-eq v6, v2, :cond_8

    .line 91
    .line 92
    goto :goto_1

    .line 93
    :cond_4
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    .line 94
    .line 95
    .line 96
    move-result v2

    .line 97
    iput v2, v0, Lv5/e;->g:F

    .line 98
    .line 99
    iget-boolean v3, v0, Lv5/e;->d:Z

    .line 100
    .line 101
    if-eqz v3, :cond_b

    .line 102
    .line 103
    iget v3, v0, Lv5/e;->f:F

    .line 104
    .line 105
    sub-float v3, v2, v3

    .line 106
    .line 107
    const/high16 v6, 0x44160000    # 600.0f

    .line 108
    .line 109
    cmpl-float v3, v3, v6

    .line 110
    .line 111
    if-lez v3, :cond_5

    .line 112
    .line 113
    sub-float v3, v2, v6

    .line 114
    .line 115
    iput v3, v0, Lv5/e;->f:F

    .line 116
    .line 117
    :cond_5
    iget v3, v0, Lv5/e;->f:F

    .line 118
    .line 119
    sub-float/2addr v2, v3

    .line 120
    div-float/2addr v2, v6

    .line 121
    iput v2, v0, Lv5/e;->e:F

    .line 122
    .line 123
    iget v3, v0, Lv5/e;->h:F

    .line 124
    .line 125
    cmpl-float v3, v3, v2

    .line 126
    .line 127
    if-eqz v3, :cond_6

    .line 128
    .line 129
    iput v2, v0, Lv5/e;->h:F

    .line 130
    .line 131
    invoke-virtual {v5}, Landroid/view/View;->postInvalidate()V

    .line 132
    .line 133
    .line 134
    :cond_6
    iget v2, v0, Lv5/e;->e:F

    .line 135
    .line 136
    cmpl-float v2, v2, v8

    .line 137
    .line 138
    if-lez v2, :cond_7

    .line 139
    .line 140
    goto :goto_2

    .line 141
    :cond_7
    iput-boolean v7, v0, Lv5/e;->d:Z

    .line 142
    .line 143
    invoke-virtual {v0, v1}, Lv5/e;->a(I)V

    .line 144
    .line 145
    .line 146
    goto :goto_1

    .line 147
    :cond_8
    iget-boolean v2, v0, Lv5/e;->d:Z

    .line 148
    .line 149
    if-eqz v2, :cond_b

    .line 150
    .line 151
    iput-boolean v7, v0, Lv5/e;->d:Z

    .line 152
    .line 153
    iget v2, v0, Lv5/e;->e:F

    .line 154
    .line 155
    const v3, 0x3f333333    # 0.7f

    .line 156
    .line 157
    .line 158
    cmpl-float v3, v2, v3

    .line 159
    .line 160
    if-ltz v3, :cond_9

    .line 161
    .line 162
    invoke-virtual {v0, v4}, Lv5/e;->a(I)V

    .line 163
    .line 164
    .line 165
    invoke-virtual {v5}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->t()V

    .line 166
    .line 167
    .line 168
    goto :goto_1

    .line 169
    :cond_9
    cmpl-float v2, v2, v8

    .line 170
    .line 171
    if-lez v2, :cond_b

    .line 172
    .line 173
    invoke-virtual {v0, v1}, Lv5/e;->a(I)V

    .line 174
    .line 175
    .line 176
    goto :goto_1

    .line 177
    :cond_a
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    .line 178
    .line 179
    .line 180
    move-result v2

    .line 181
    iput v2, v0, Lv5/e;->f:F

    .line 182
    .line 183
    iput-boolean v7, v0, Lv5/e;->d:Z

    .line 184
    .line 185
    invoke-virtual {v0, v1}, Lv5/e;->a(I)V

    .line 186
    .line 187
    .line 188
    :cond_b
    :goto_1
    invoke-super {p0, p1}, Landroid/webkit/WebView;->onTouchEvent(Landroid/view/MotionEvent;)Z

    .line 189
    .line 190
    .line 191
    move-result p1

    .line 192
    if-eqz p1, :cond_c

    .line 193
    .line 194
    :goto_2
    return v4

    .line 195
    :cond_c
    return v7
.end method

.method public final p()V
    .locals 1

    .line 1
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->i:Lg5/q0;

    .line 2
    .line 3
    if-eqz v0, :cond_0

    .line 4
    .line 5
    invoke-static {v0}, Lg5/u;->a(Lg5/q0;)V

    .line 6
    .line 7
    .line 8
    :cond_0
    const/4 v0, 0x0

    .line 9
    iput-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->i:Lg5/q0;

    .line 10
    .line 11
    return-void
.end method

.method public final q(I)V
    .locals 5

    .line 1
    if-nez p1, :cond_2

    .line 2
    .line 3
    new-instance p1, Ljava/lang/NullPointerException;

    .line 4
    .line 5
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    .line 6
    .line 7
    .line 8
    move-result-object v0

    .line 9
    invoke-virtual {v0}, Ljava/lang/Thread;->getStackTrace()[Ljava/lang/StackTraceElement;

    .line 10
    .line 11
    .line 12
    move-result-object v0

    .line 13
    const-class v1, Ly4/f;

    .line 14
    .line 15
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    .line 16
    .line 17
    .line 18
    move-result-object v2

    .line 19
    const/4 v3, 0x0

    .line 20
    :goto_0
    aget-object v4, v0, v3

    .line 21
    .line 22
    invoke-virtual {v4}, Ljava/lang/StackTraceElement;->getClassName()Ljava/lang/String;

    .line 23
    .line 24
    .line 25
    move-result-object v4

    .line 26
    invoke-virtual {v4, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    .line 27
    .line 28
    .line 29
    move-result v4

    .line 30
    if-nez v4, :cond_0

    .line 31
    .line 32
    add-int/lit8 v3, v3, 0x1

    .line 33
    .line 34
    goto :goto_0

    .line 35
    :cond_0
    :goto_1
    aget-object v4, v0, v3

    .line 36
    .line 37
    invoke-virtual {v4}, Ljava/lang/StackTraceElement;->getClassName()Ljava/lang/String;

    .line 38
    .line 39
    .line 40
    move-result-object v4

    .line 41
    invoke-virtual {v4, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    .line 42
    .line 43
    .line 44
    move-result v4

    .line 45
    if-eqz v4, :cond_1

    .line 46
    .line 47
    add-int/lit8 v3, v3, 0x1

    .line 48
    .line 49
    goto :goto_1

    .line 50
    :cond_1
    aget-object v0, v0, v3

    .line 51
    .line 52
    invoke-virtual {v0}, Ljava/lang/StackTraceElement;->getClassName()Ljava/lang/String;

    .line 53
    .line 54
    .line 55
    move-result-object v2

    .line 56
    invoke-virtual {v0}, Ljava/lang/StackTraceElement;->getMethodName()Ljava/lang/String;

    .line 57
    .line 58
    .line 59
    move-result-object v0

    .line 60
    new-instance v3, Ljava/lang/StringBuilder;

    .line 61
    .line 62
    const-string v4, "Parameter specified as non-null is null: method "

    .line 63
    .line 64
    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 65
    .line 66
    .line 67
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 68
    .line 69
    .line 70
    const-string v2, "."

    .line 71
    .line 72
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 73
    .line 74
    .line 75
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 76
    .line 77
    .line 78
    const-string v0, ", parameter "

    .line 79
    .line 80
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 81
    .line 82
    .line 83
    const-string v0, "mode"

    .line 84
    .line 85
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 86
    .line 87
    .line 88
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 89
    .line 90
    .line 91
    move-result-object v0

    .line 92
    invoke-direct {p1, v0}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    .line 93
    .line 94
    .line 95
    invoke-virtual {v1}, Ljava/lang/Class;->getName()Ljava/lang/String;

    .line 96
    .line 97
    .line 98
    move-result-object v0

    .line 99
    invoke-static {p1, v0}, Ly4/f;->f(Ljava/lang/RuntimeException;Ljava/lang/String;)V

    .line 100
    .line 101
    .line 102
    throw p1

    .line 103
    :cond_2
    iget v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->K:I

    .line 104
    .line 105
    if-eq v0, p1, :cond_3

    .line 106
    .line 107
    iput p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->K:I

    .line 108
    .line 109
    new-instance v0, Ly5/j;

    .line 110
    .line 111
    const/4 v1, 0x1

    .line 112
    invoke-direct {v0, p0, v1}, Ly5/j;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;I)V

    .line 113
    .line 114
    .line 115
    invoke-virtual {p0, v0}, Landroid/view/View;->post(Ljava/lang/Runnable;)Z

    .line 116
    .line 117
    .line 118
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    .line 119
    .line 120
    .line 121
    move-result-object v0

    .line 122
    new-instance v1, Ljava/lang/StringBuilder;

    .line 123
    .line 124
    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 125
    .line 126
    .line 127
    invoke-virtual {v0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    .line 128
    .line 129
    .line 130
    move-result-object v2

    .line 131
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 132
    .line 133
    .line 134
    const-string v2, "_preferences"

    .line 135
    .line 136
    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 137
    .line 138
    .line 139
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 140
    .line 141
    .line 142
    move-result-object v1

    .line 143
    const/4 v2, 0x0

    .line 144
    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    .line 145
    .line 146
    .line 147
    move-result-object v0

    .line 148
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    .line 149
    .line 150
    .line 151
    move-result-object v0

    .line 152
    const-string v1, "IM"

    .line 153
    .line 154
    invoke-static {p1}, Lu/e;->b(I)I

    .line 155
    .line 156
    .line 157
    move-result p1

    .line 158
    invoke-interface {v0, v1, p1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    .line 159
    .line 160
    .line 161
    move-result-object p1

    .line 162
    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 163
    .line 164
    .line 165
    :cond_3
    return-void
.end method

.method public final r(Landroid/graphics/Rect;)Z
    .locals 2

    .line 1
    iget v0, p1, Landroid/graphics/Rect;->bottom:I

    .line 2
    .line 3
    if-lez v0, :cond_1

    .line 4
    .line 5
    iget v0, p1, Landroid/graphics/Rect;->top:I

    .line 6
    .line 7
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    .line 8
    .line 9
    .line 10
    move-result v1

    .line 11
    if-ge v0, v1, :cond_1

    .line 12
    .line 13
    iget v0, p1, Landroid/graphics/Rect;->right:I

    .line 14
    .line 15
    if-lez v0, :cond_1

    .line 16
    .line 17
    iget p1, p1, Landroid/graphics/Rect;->left:I

    .line 18
    .line 19
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    .line 20
    .line 21
    .line 22
    move-result v0

    .line 23
    if-lt p1, v0, :cond_0

    .line 24
    .line 25
    goto :goto_0

    .line 26
    :cond_0
    const/4 p1, 0x0

    .line 27
    return p1

    .line 28
    :cond_1
    :goto_0
    const/4 p1, 0x1

    .line 29
    return p1
.end method

.method public final s()V
    .locals 4

    .line 1
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->H:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 2
    .line 3
    const/4 v1, 0x0

    .line 4
    const/4 v2, 0x1

    .line 5
    invoke-virtual {v0, v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    .line 6
    .line 7
    .line 8
    move-result v0

    .line 9
    if-nez v0, :cond_0

    .line 10
    .line 11
    goto :goto_0

    .line 12
    :cond_0
    iget v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->J:I

    .line 13
    .line 14
    invoke-virtual {p0, v0}, Landroid/view/View;->setBackgroundColor(I)V

    .line 15
    .line 16
    .line 17
    invoke-virtual {p0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p()V

    .line 18
    .line 19
    .line 20
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->j:Lg5/q0;

    .line 21
    .line 22
    if-eqz v0, :cond_1

    .line 23
    .line 24
    invoke-static {v0}, Lg5/u;->a(Lg5/q0;)V

    .line 25
    .line 26
    .line 27
    :cond_1
    const/4 v0, 0x0

    .line 28
    iput-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->j:Lg5/q0;

    .line 29
    .line 30
    new-instance v1, Ly5/l;

    .line 31
    .line 32
    const/4 v3, 0x2

    .line 33
    invoke-direct {v1, p0, v0, v3}, Ly5/l;-><init>(Ltown/pony/game/ui/webview/PonyTownWebViewImpl;Lp4/d;I)V

    .line 34
    .line 35
    .line 36
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->h:Lk5/c;

    .line 37
    .line 38
    invoke-static {v0, v1}, Lg5/u;->i(Lg5/r;Lx4/p;)Lg5/e1;

    .line 39
    .line 40
    .line 41
    move-result-object v0

    .line 42
    iput-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->j:Lg5/q0;

    .line 43
    .line 44
    const-wide/16 v0, 0x4e20

    .line 45
    .line 46
    invoke-virtual {p0, v0, v1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->u(J)V

    .line 47
    .line 48
    .line 49
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->p:Lw5/b;

    .line 50
    .line 51
    iget-object v1, v0, Lw5/b;->e:Landroid/graphics/drawable/Drawable;

    .line 52
    .line 53
    if-eqz v1, :cond_3

    .line 54
    .line 55
    iget-boolean v1, v0, Lw5/b;->i:Z

    .line 56
    .line 57
    if-eqz v1, :cond_2

    .line 58
    .line 59
    goto :goto_0

    .line 60
    :cond_2
    iput-boolean v2, v0, Lw5/b;->i:Z

    .line 61
    .line 62
    iget-object v1, v0, Lw5/b;->c:Landroid/os/Handler;

    .line 63
    .line 64
    iget-object v2, v0, Lw5/b;->d:Landroidx/lifecycle/f0;

    .line 65
    .line 66
    invoke-virtual {v1, v2}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 67
    .line 68
    .line 69
    iget-boolean v1, v0, Lw5/b;->i:Z

    .line 70
    .line 71
    if-eqz v1, :cond_3

    .line 72
    .line 73
    iget-object v0, v0, Lw5/b;->f:Landroid/animation/ValueAnimator;

    .line 74
    .line 75
    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->start()V

    .line 76
    .line 77
    .line 78
    :cond_3
    :goto_0
    return-void
.end method

.method public setInMultiWindowMode(Z)V
    .locals 0

    .line 1
    iput-boolean p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->v:Z

    .line 2
    .line 3
    return-void
.end method

.method public setLastBackgroundColor(I)V
    .locals 0

    .line 1
    if-eqz p1, :cond_0

    .line 2
    .line 3
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 4
    .line 5
    .line 6
    move-result-object p1

    .line 7
    invoke-virtual {p1}, Ljava/lang/Number;->intValue()I

    .line 8
    .line 9
    .line 10
    move-result p1

    .line 11
    goto :goto_0

    .line 12
    :cond_0
    sget p1, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->L:I

    .line 13
    .line 14
    :goto_0
    iput p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->J:I

    .line 15
    .line 16
    return-void
.end method

.method public final t()V
    .locals 3

    .line 1
    invoke-virtual {p0}, Landroid/webkit/WebView;->getUrl()Ljava/lang/String;

    .line 2
    .line 3
    .line 4
    move-result-object v0

    .line 5
    const/4 v1, 0x1

    .line 6
    if-nez v0, :cond_0

    .line 7
    .line 8
    invoke-direct {p0, v1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->setHideContent(Z)V

    .line 9
    .line 10
    .line 11
    invoke-virtual {p0}, Landroid/webkit/WebView;->reload()V

    .line 12
    .line 13
    .line 14
    return-void

    .line 15
    :cond_0
    const-string v2, "file:///android_asset/offline.html"

    .line 16
    .line 17
    invoke-virtual {v0, v2}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    .line 18
    .line 19
    .line 20
    move-result v2

    .line 21
    if-eqz v2, :cond_2

    .line 22
    .line 23
    invoke-direct {p0, v1}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->setHideContent(Z)V

    .line 24
    .line 25
    .line 26
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->E:Ljava/lang/String;

    .line 27
    .line 28
    if-eqz v0, :cond_1

    .line 29
    .line 30
    invoke-virtual {p0, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->loadUrl(Ljava/lang/String;)V

    .line 31
    .line 32
    .line 33
    goto :goto_0

    .line 34
    :cond_1
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->g:Ly5/f;

    .line 35
    .line 36
    iget-object v0, v0, Ly5/f;->w:Landroid/net/Uri;

    .line 37
    .line 38
    const-string v1, "currentMainServer"

    .line 39
    .line 40
    invoke-static {v0, v1}, Ly4/f;->d(Ljava/lang/Object;Ljava/lang/String;)V

    .line 41
    .line 42
    .line 43
    invoke-virtual {v0}, Landroid/net/Uri;->toString()Ljava/lang/String;

    .line 44
    .line 45
    .line 46
    move-result-object v0

    .line 47
    const-string v1, "toString(...)"

    .line 48
    .line 49
    invoke-static {v0, v1}, Ly4/f;->d(Ljava/lang/Object;Ljava/lang/String;)V

    .line 50
    .line 51
    .line 52
    invoke-virtual {p0, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->loadUrl(Ljava/lang/String;)V

    .line 53
    .line 54
    .line 55
    :goto_0
    const/4 v0, 0x0

    .line 56
    iput-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->E:Ljava/lang/String;

    .line 57
    .line 58
    return-void

    .line 59
    :cond_2
    invoke-virtual {p0, v0}, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->loadUrl(Ljava/lang/String;)V

    .line 60
    .line 61
    .line 62
    return-void
.end method

.method public final u(J)V
    .locals 2

    .line 1
    iget-object v0, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->i:Lg5/q0;

    .line 2
    .line 3
    if-eqz v0, :cond_0

    .line 4
    .line 5
    invoke-static {v0}, Lg5/u;->a(Lg5/q0;)V

    .line 6
    .line 7
    .line 8
    :cond_0
    new-instance v0, Ly5/r;

    .line 9
    .line 10
    const/4 v1, 0x0

    .line 11
    invoke-direct {v0, p1, p2, p0, v1}, Ly5/r;-><init>(JLtown/pony/game/ui/webview/PonyTownWebViewImpl;Lp4/d;)V

    .line 12
    .line 13
    .line 14
    iget-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->h:Lk5/c;

    .line 15
    .line 16
    invoke-static {p1, v0}, Lg5/u;->i(Lg5/r;Lx4/p;)Lg5/e1;

    .line 17
    .line 18
    .line 19
    move-result-object p1

    .line 20
    iput-object p1, p0, Ltown/pony/game/ui/webview/PonyTownWebViewImpl;->i:Lg5/q0;

    .line 21
    .line 22
    return-void
.end method
