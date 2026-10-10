/*
 * PonyTown Mod UI  (injected natively by JsInjector, pony.town only)
 *
 * Wrapped as  (function(__PT_TOKEN){ <this file> })("<token>")  so only this
 * script can call window.PtModBridge (native side requires the token).
 *
 *  - Scripts : load .js from the file picker, view/edit, run, remove, enable/disable
 *  - Mouse   : virtual cursor driven by REAL native mouse events (hover, :hover,
 *              isTrusted) in "touch" (direct) or "trackpad" (relative) mode
 *  - Keys    : on-screen custom key buttons (WASD ...) sent as REAL key events
 *
 * Settings and scripts live in localStorage of the pony.town origin.
 */
(function () {
  'use strict';
  if (window.__ptmodLoaded) return;
  window.__ptmodLoaded = true;

  var VERSION = '1.0';
  var T = (typeof __PT_TOKEN === 'string') ? __PT_TOKEN : '';

  // ------------------------------------------------------------------ storage
  var LS_S = 'ptmod.settings.v1';
  var LS_C = 'ptmod.scripts.v1';
  function lsGet(k, d) { try { var v = localStorage.getItem(k); return v ? JSON.parse(v) : d; } catch (e) { return d; } }
  function lsSet(k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) { /* ignore */ } }
  function uid() { return Math.random().toString(36).slice(2, 10); }
  function esc(s) { return String(s).replace(/[&<>"']/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]; }); }

  // ------------------------------------------------------------------ key table
  var KD = {};
  (function () {
    var i, c;
    for (i = 0; i < 26; i++) { c = String.fromCharCode(65 + i); KD[c] = { label: c, android: 29 + i, key: c.toLowerCase(), code: 'Key' + c, kc: 65 + i }; }
    for (i = 0; i < 10; i++) { KD['' + i] = { label: '' + i, android: 7 + i, key: '' + i, code: 'Digit' + i, kc: 48 + i }; }
    KD.Space = { label: 'Space', android: 62, key: ' ', code: 'Space', kc: 32 };
    KD.Enter = { label: 'Enter', android: 66, key: 'Enter', code: 'Enter', kc: 13 };
    KD.Shift = { label: 'Shift', android: 59, key: 'Shift', code: 'ShiftLeft', kc: 16 };
    KD.Ctrl = { label: 'Ctrl', android: 113, key: 'Control', code: 'ControlLeft', kc: 17 };
    KD.Alt = { label: 'Alt', android: 57, key: 'Alt', code: 'AltLeft', kc: 18 };
    KD.Tab = { label: 'Tab', android: 61, key: 'Tab', code: 'Tab', kc: 9 };
    KD.Esc = { label: 'Esc', android: 111, key: 'Escape', code: 'Escape', kc: 27 };
    KD.Backspace = { label: 'Bksp', android: 67, key: 'Backspace', code: 'Backspace', kc: 8 };
    KD.Up = { label: '↑', android: 19, key: 'ArrowUp', code: 'ArrowUp', kc: 38 };
    KD.Down = { label: '↓', android: 20, key: 'ArrowDown', code: 'ArrowDown', kc: 40 };
    KD.Left = { label: '←', android: 21, key: 'ArrowLeft', code: 'ArrowLeft', kc: 37 };
    KD.Right = { label: '→', android: 22, key: 'ArrowRight', code: 'ArrowRight', kc: 39 };
  })();
  (function () {
    var i, n;
    for (i = 1; i <= 12; i++) KD['F' + i] = { label: 'F' + i, android: 130 + i, key: 'F' + i, code: 'F' + i, kc: 111 + i };
    for (i = 0; i < 10; i++) KD['Num' + i] = { label: 'N' + i, android: 144 + i, key: '' + i, code: 'Numpad' + i, kc: 96 + i };
    KD.Del = { label: 'Del', android: 112, key: 'Delete', code: 'Delete', kc: 46 };
    KD.Ins = { label: 'Ins', android: 124, key: 'Insert', code: 'Insert', kc: 45 };
    KD.Home = { label: 'Home', android: 122, key: 'Home', code: 'Home', kc: 36 };
    KD.End = { label: 'End', android: 123, key: 'End', code: 'End', kc: 35 };
    KD.PgUp = { label: 'PgUp', android: 92, key: 'PageUp', code: 'PageUp', kc: 33 };
    KD.PgDn = { label: 'PgDn', android: 93, key: 'PageDown', code: 'PageDown', kc: 34 };
    KD.RShift = { label: 'Shift', android: 60, key: 'Shift', code: 'ShiftRight', kc: 16 };
    KD.RCtrl = { label: 'Ctrl', android: 114, key: 'Control', code: 'ControlRight', kc: 17 };
    KD.RAlt = { label: 'Alt', android: 58, key: 'Alt', code: 'AltRight', kc: 18 };
    KD.Win = { label: 'Win', android: 117, key: 'Meta', code: 'MetaLeft', kc: 91 };
    KD.Menu = { label: 'Menu', android: 82, key: 'ContextMenu', code: 'ContextMenu', kc: 93 };
    KD.Caps = { label: 'Caps', android: 115, key: 'CapsLock', code: 'CapsLock', kc: 20 };
    // symbols: [name, android keycode, key char, code, keyCode, needs shift]
    [['-', 69, '-', 'Minus', 189, 0], ['_', 69, '_', 'Minus', 189, 1], ['=', 70, '=', 'Equal', 187, 0], ['+', 70, '+', 'Equal', 187, 1],
     ['[', 71, '[', 'BracketLeft', 219, 0], ['{', 71, '{', 'BracketLeft', 219, 1], [']', 72, ']', 'BracketRight', 221, 0], ['}', 72, '}', 'BracketRight', 221, 1],
     ['\\', 73, '\\', 'Backslash', 220, 0], ['|', 73, '|', 'Backslash', 220, 1], [';', 74, ';', 'Semicolon', 186, 0], [':', 74, ':', 'Semicolon', 186, 1],
     ["'", 75, "'", 'Quote', 222, 0], ['"', 75, '"', 'Quote', 222, 1], [',', 55, ',', 'Comma', 188, 0], ['<', 55, '<', 'Comma', 188, 1],
     ['.', 56, '.', 'Period', 190, 0], ['>', 56, '>', 'Period', 190, 1], ['/', 76, '/', 'Slash', 191, 0], ['?', 76, '?', 'Slash', 191, 1],
     ['`', 68, '`', 'Backquote', 192, 0], ['~', 68, '~', 'Backquote', 192, 1],
     ['!', 8, '!', 'Digit1', 49, 1], ['@', 9, '@', 'Digit2', 50, 1], ['#', 10, '#', 'Digit3', 51, 1], ['$', 11, '$', 'Digit4', 52, 1],
     ['%', 12, '%', 'Digit5', 53, 1], ['^', 13, '^', 'Digit6', 54, 1], ['&', 14, '&', 'Digit7', 55, 1], ['*', 15, '*', 'Digit8', 56, 1],
     ['(', 16, '(', 'Digit9', 57, 1], [')', 7, ')', 'Digit0', 48, 1]
    ].forEach(function (a) { KD[a[0]] = { label: a[0], android: a[1], key: a[2], code: a[3], kc: a[4], shift: !!a[5] }; });
  })();
  var KEY_NAMES = Object.keys(KD);

  var PRESETS = {
    'WASD': [['W', 0.15, 0.58], ['A', 0.07, 0.74], ['S', 0.15, 0.74], ['D', 0.23, 0.74]],
    'WASD + Space/Shift': [['W', 0.15, 0.58], ['A', 0.07, 0.74], ['S', 0.15, 0.74], ['D', 0.23, 0.74], ['Space', 0.9, 0.74], ['Shift', 0.82, 0.60]],
    'Arrows': [['Up', 0.15, 0.58], ['Left', 0.07, 0.74], ['Down', 0.15, 0.74], ['Right', 0.23, 0.74]]
  };
  var KEY_GAP = 3;
  // Tenkeyless physical layout (Esc/F-row, number row, QWERTY, home, shift, bottom row, nav cluster, arrows),
  // scaled to the current viewport. Key width is stored as a multiple of one unit (k.w).
  function fullKeyboard() {
    var W = window.innerWidth, H = window.innerHeight;
    var u = Math.max(20, Math.floor(Math.min(W * 0.96 / 18.5, H * 0.6 / 6.6)));
    var size = u - KEY_GAP, left0 = (W - 18.5 * u) / 2, top0 = H - 6.6 * u - 6, out = [];
    function row(y, x, items) {
      items.forEach(function (it) {
        if (typeof it === 'number') { x += it; return; }
        var w = it[1] || 1, cx = left0 + x * u + (u * w - KEY_GAP) / 2, cy = top0 + y * u + size / 2;
        out.push({ id: uid(), k: it[0], fx: cx / W, fy: cy / H, size: size, w: w });
        x += w;
      });
    }
    function chars(str) { return str.split('').map(function (c) { return [c, 1]; }); }
    row(0, 0, [['Esc', 1], 1, ['F1', 1], ['F2', 1], ['F3', 1], ['F4', 1], 0.5, ['F5', 1], ['F6', 1], ['F7', 1], ['F8', 1], 0.5, ['F9', 1], ['F10', 1], ['F11', 1], ['F12', 1]]);
    row(1.5, 0, chars('`1234567890-=').concat([['Backspace', 2], 0.5, ['Ins', 1], ['Home', 1], ['PgUp', 1]]));
    row(2.5, 0, [['Tab', 1.5]].concat(chars('QWERTYUIOP[]'), [['\\', 1.5], 0.5, ['Del', 1], ['End', 1], ['PgDn', 1]]));
    row(3.5, 0, [['Caps', 1.75]].concat(chars('ASDFGHJKL;\''), [['Enter', 2.25]]));
    row(4.5, 0, [['Shift', 2.25]].concat(chars('ZXCVBNM,./'), [['RShift', 2.75], 1.5, ['Up', 1]]));
    row(5.5, 0, [['Ctrl', 1.25], ['Win', 1.25], ['Alt', 1.25], ['Space', 6.25], ['RAlt', 1.25], ['Win', 1.25], ['Menu', 1.25], ['RCtrl', 1.25], 0.5, ['Left', 1], ['Down', 1], ['Right', 1]]);
    return out;
  }
  PRESETS['Full keyboard'] = fullKeyboard;
  function presetKeys(name) {
    var p = PRESETS[name];
    if (typeof p === 'function') return p();
    return (p || []).map(function (q) { return { id: uid(), k: q[0], fx: q[1], fy: q[2], size: 56 }; });
  }

  // ------------------------------------------------------------------ settings
  var DEF = {
    mouseOn: false, dragMethod: 0, touchCompat: false, fixEvents: true, mouseMode: 'touch', sens: 1.6, cursor: true, cursorSize: 28, lr: true, scrollOn: true, scrollBtns: true, scrollMode: 'native', spoofMedia: true,
    keysOn: false, keyMode: 'native', keyOpacity: 0.55, keyNoFill: false, keys: null,
    keySlide: true, snap: true, pip: true, screenOn: false, ctlOpacity: 0.9, ctlNoFill: false, ctlSize: 1, ctlPos: {},
    fab: { fx: 0.97, fy: 0.12 }, tab: 'scripts'
  };
  var S = lsGet(LS_S, {});
  Object.keys(DEF).forEach(function (k) { if (S[k] === undefined) S[k] = DEF[k]; });
  if (!S.keys) S.keys = presetKeys('WASD');
  function saveS() { lsSet(LS_S, S); }

  var scripts = lsGet(LS_C, []);
  function saveScripts() { lsSet(LS_C, scripts); }

  // ------------------------------------------------------------------ native bridge
  function B() { return window.PtModBridge || null; }
  function dpr() { return window.devicePixelRatio || 1; }
  function nHover(x, y) { var b = B(); if (b && b.mouseMove) { try { b.mouseMove(T, x * dpr(), y * dpr()); } catch (e) { /* ignore */ } } }
  function nBtn(phase, x, y, buttons) { var b = B(); if (b && b.mouseBtn) { try { b.mouseBtn(T, phase, x * dpr(), y * dpr(), buttons); } catch (e) { /* ignore */ } } }
  function nScroll(dx, dy) { var b = B(); if (b && b.mouseScroll) { try { b.mouseScroll(T, cur.x * dpr(), cur.y * dpr(), dx, dy); } catch (e) { /* ignore */ } } }
  function nKey(code, down) { var b = B(); if (b && b.key) { try { b.key(T, code, !!down); } catch (e) { /* ignore */ } } }
  function nExec(code) {
    var b = B();
    if (b && b.exec) { try { b.exec(T, code); return true; } catch (e) { /* fall through */ } }
    try { (0, eval)(code); return true; } catch (e2) { console.error('[ptmod] exec failed', e2); return false; }
  }
  function getWake() { var b = B(); if (b && b.getWake) { try { return !!b.getWake(T); } catch (e) { /* ignore */ } } return false; }
  function sendScreen() { var b = B(); if (b && b.setScreen) { try { b.setScreen(T, !!S.screenOn); } catch (e) { /* ignore */ } } }
  function sendPip() { var b = B(); if (b && b.setPip) { try { b.setPip(T, !!S.pip); } catch (e) { /* ignore */ } } }
  function bridgeOk() { var b = B(); return !!(b && b.mouseMove && b.mouseBtn && b.mouseScroll && b.key && b.exec && b.pickScript); }

  // ------------------------------------------------------------------ script manager
  function safeName(n) { return String(n).replace(/[^\w.\-]+/g, '_').slice(0, 60) || 'script'; }
  function wrapCode(s) {
    var n = safeName(s.name);
    return '(function(){try{\n' + s.code + '\n}catch(e){console.error("[ptmod] script error: ' + n + '",e)}})();\n//# sourceURL=ptmod/' + n;
  }
  function runScript(s) { return nExec(wrapCode(s)); }
  function findScript(id) { for (var i = 0; i < scripts.length; i++) if (scripts[i].id === id) return scripts[i]; return null; }
  function addOrReplace(name, code) {
    for (var i = 0; i < scripts.length; i++) {
      if (scripts[i].name === name) { scripts[i].code = code; scripts[i].enabled = true; saveScripts(); return scripts[i]; }
    }
    var s = { id: uid(), name: name, code: code, enabled: true, when: 'ready' };
    scripts.push(s); saveScripts(); return s;
  }
  var phaseDone = { start: false, ready: false, load: false };
  function runPhase(phase) {
    phaseDone[phase] = true;
    scripts.forEach(function (s) { if (s.enabled && (s.when || 'ready') === phase) runScript(s); });
  }
  function whenPhase(s) { return phaseDone[s.when || 'ready']; }

  // ------------------------------------------------------------------ DOM host + shadow
  var host = document.createElement('div');
  host.id = 'ptmod-host';
  host.style.cssText = 'all:initial;position:fixed;left:0;top:0;right:0;bottom:0;pointer-events:none;z-index:2147483647;';
  var root = host.attachShadow ? host.attachShadow({ mode: 'open' }) : host;

  var CSS = [
    ':host{all:initial}',
    '*{box-sizing:border-box;-webkit-tap-highlight-color:transparent;font-family:system-ui,-apple-system,Roboto,sans-serif}',
    '.fab{position:fixed;width:42px;height:42px;border-radius:21px;border:0;background:#1f6feb;color:#fff;font:700 13px sans-serif;opacity:.6;pointer-events:auto;touch-action:none;box-shadow:0 2px 8px #0008}',
    '.fab.open{opacity:.95}',
    '.panel{position:fixed;left:50%;bottom:8px;transform:translateX(-50%);width:min(94vw,540px);max-height:82vh;display:flex;flex-direction:column;background:#161b22f2;color:#e6edf3;border:1px solid #30363d;border-radius:12px;pointer-events:auto;font-size:13px;box-shadow:0 8px 30px #000a}',
    '.panel[hidden]{display:none}',
    '.tabs{display:flex;gap:2px;padding:6px 6px 0}',
    '.tab{flex:1;padding:8px 4px;border:0;background:#21262d;color:#9da7b3;border-radius:8px 8px 0 0;font-size:13px;font-weight:600}',
    '.tab.on{background:#30363d;color:#fff}',
    '.x{width:36px;border:0;background:transparent;color:#9da7b3;font-size:18px}',
    '.body{padding:10px;overflow:auto;-webkit-overflow-scrolling:touch;background:#0d1117;border-radius:0 0 12px 12px;border-top:1px solid #30363d}',
    '.row{display:flex;flex-wrap:wrap;gap:6px;align-items:center;margin:6px 0}',
    '.btn{padding:7px 11px;border-radius:8px;border:1px solid #30363d;background:#21262d;color:#e6edf3;font-size:13px}',
    '.btn.pri{background:#238636;border-color:#2ea043}',
    '.btn.danger{color:#ff7b72}',
    '.btn.on{background:#1f6feb;border-color:#388bfd}',
    '.muted{color:#8b949e;font-size:12px;line-height:1.4;margin:6px 0}',
    '.item{display:flex;flex-wrap:wrap;align-items:center;gap:6px;padding:8px;margin:6px 0;border:1px solid #30363d;border-radius:8px;background:#161b22}',
    '.item .name{flex:1 1 120px;min-width:0;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;font-weight:600}',
    '.item small{color:#8b949e;font-weight:400}',
    'select,input[type=text],textarea{background:#0d1117;color:#e6edf3;border:1px solid #30363d;border-radius:6px;padding:6px;font-size:13px}',
    'textarea{width:100%;min-height:42vh;font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;white-space:pre}',
    'input[type=text]{width:100%}',
    'label.f{display:flex;align-items:center;gap:8px;margin:8px 0}',
    'label.f span{flex:1}',
    'input[type=range]{flex:1.2}',
    '.hover{margin:8px 0;padding:14px;border:2px dashed #30363d;border-radius:10px;text-align:center;color:#8b949e;background:#161b22}',
    '.hover:hover{background:#12351f;border-color:#2ea043;color:#e6edf3}',
    'pre.spy{margin:6px 0;padding:8px;max-height:42vh;overflow:auto;background:#010409;border:1px solid #30363d;border-radius:6px;font:11px ui-monospace,Menlo,Consolas,monospace;white-space:pre-wrap;word-break:break-all;color:#c9d1d9}',
    '#dpad{position:relative;user-select:none;-webkit-user-select:none;touch-action:none}',
    '#dball{position:absolute;left:8px;top:8px;width:18px;height:18px;border-radius:9px;background:#f0b72f;pointer-events:none}',
    '.dnd{justify-content:center;margin:10px 0 4px}',
    '.chip{padding:8px 12px;border-radius:8px;background:#1f6feb;color:#fff;font-weight:700}',
    '.zone{padding:8px 12px;border-radius:8px;border:2px dashed #8b949e;color:#8b949e}',
    '.hover small{display:block;margin-top:4px;font-size:11px}',
    '.kv{display:grid;grid-template-columns:auto 1fr;gap:4px 10px;font-size:12px;margin:6px 0}',
    '.ok{color:#3fb950}.bad{color:#ff7b72}',
    '#cursor{position:fixed;left:0;top:0;pointer-events:none;display:none;will-change:transform;filter:drop-shadow(0 1px 2px #000a)}',
    '#cursor.press svg{transform:scale(.85)}',
    '.guide{position:fixed;background:#f0b72f;pointer-events:none;display:none}',
    '.guide.v{width:1px;top:0;bottom:0}',
    '.guide.h{height:1px;left:0;right:0}',
    '#keys{position:fixed;left:0;top:0;right:0;bottom:0;pointer-events:none}',
    '.kb{position:fixed;display:flex;align-items:center;justify-content:center;border-radius:12px;border:2px solid #ffffff88;background:#000;color:#fff;font:700 15px sans-serif;pointer-events:auto;touch-action:none;user-select:none;-webkit-user-select:none}',
    '.kb.down{background:#1f6feb;border-color:#fff}',
    '.kb.edit{outline:2px dashed #f0b72f}',
    '#ctl{position:fixed;left:0;top:0;right:0;bottom:0;pointer-events:none}',
    '.lrb{position:fixed;display:flex;align-items:center;justify-content:center;border-radius:12px;border:2px solid #ffffff88;background:#000a;color:#fff;font:700 14px sans-serif;pointer-events:auto;touch-action:none;user-select:none;-webkit-user-select:none}',
    '.lrb.down{background:#1f6feb}',
    '.lrb.edit{outline:2px dashed #f0b72f}',
    '.nofill{background:transparent!important}',
    '.nofill.down{background:#1f6feb88!important}',
    '.toast{position:fixed;left:50%;top:14px;transform:translateX(-50%);background:#000d;color:#fff;padding:8px 14px;border-radius:18px;font-size:13px;pointer-events:none;max-width:90vw}'
  ].join('\n');

  var styleEl = document.createElement('style');
  styleEl.textContent = CSS;
  root.appendChild(styleEl);

  function el(tag, cls, html) {
    var e = document.createElement(tag);
    if (cls) e.className = cls;
    if (html !== undefined) e.innerHTML = html;
    return e;
  }

  var fab = el('button', 'fab', 'PT');
  var panel = el('div', 'panel'); panel.hidden = true;
  var cursorEl = el('div'); cursorEl.id = 'cursor';
  var keysLayer = el('div'); keysLayer.id = 'keys';
  var ctlLayer = el('div'); ctlLayer.id = 'ctl';
  var toastEl = el('div', 'toast'); toastEl.style.display = 'none';
  root.appendChild(keysLayer);
  root.appendChild(ctlLayer);
  var guideV = el('div', 'guide v'), guideH = el('div', 'guide h');
  root.appendChild(guideV);
  root.appendChild(guideH);
  root.appendChild(fab);
  root.appendChild(panel);
  root.appendChild(cursorEl);
  root.appendChild(toastEl);

  var toastTimer = 0;
  function toast(msg) {
    toastEl.textContent = msg; toastEl.style.display = 'block';
    clearTimeout(toastTimer); toastTimer = setTimeout(function () { toastEl.style.display = 'none'; }, 2200);
  }

  // ------------------------------------------------------------------ launcher (draggable)
  function placeFab() {
    var w = window.innerWidth, h = window.innerHeight;
    fab.style.left = Math.max(2, Math.min(w - 44, S.fab.fx * w - 21)) + 'px';
    fab.style.top = Math.max(2, Math.min(h - 44, S.fab.fy * h - 21)) + 'px';
  }
  (function () {
    var drag = null;
    fab.addEventListener('pointerdown', function (e) {
      drag = { x: e.clientX, y: e.clientY, moved: false, id: e.pointerId };
      try { fab.setPointerCapture(e.pointerId); } catch (x) { /* ignore */ }
    });
    fab.addEventListener('pointermove', function (e) {
      if (!drag || e.pointerId !== drag.id) return;
      if (!drag.moved && Math.abs(e.clientX - drag.x) + Math.abs(e.clientY - drag.y) > 8) drag.moved = true;
      if (drag.moved) { S.fab.fx = e.clientX / window.innerWidth; S.fab.fy = e.clientY / window.innerHeight; placeFab(); }
    });
    function end(e) {
      if (!drag || e.pointerId !== drag.id) return;
      var moved = drag.moved; drag = null;
      if (moved) saveS(); else togglePanel();
    }
    fab.addEventListener('pointerup', end);
    fab.addEventListener('pointercancel', function () { drag = null; });
  })();

  // ------------------------------------------------------------------ panel
  var editing = null; // {id|null,name,code}
  function togglePanel(force) {
    var open = (force === undefined) ? panel.hidden : !!force;
    panel.hidden = !open;
    fab.className = 'fab' + (open ? ' open' : '');
    if (open) render();
  }
  function setTab(t) { S.tab = t; saveS(); editing = null; render(); }

  function render() {
    if (panel.hidden) return;
    var tabs = [['scripts', 'Scripts'], ['mouse', 'Mouse'], ['keys', 'Keys'], ['debug', 'Debug'], ['about', 'About']];
    var h = '<div class="tabs">';
    tabs.forEach(function (t) { h += '<button class="tab' + (S.tab === t[0] ? ' on' : '') + '" data-a="tab" data-v="' + t[0] + '">' + t[1] + '</button>'; });
    h += '<button class="x" data-a="close">✕</button></div><div class="body" id="body">';
    h += (S.tab === 'mouse') ? tabMouse() : (S.tab === 'keys') ? tabKeys() : (S.tab === 'about') ? tabAbout() : (S.tab === 'debug') ? tabDebug() : tabScripts();
    h += '</div>';
    panel.innerHTML = h;
    if (S.tab === 'mouse') { bindHoverTest(); bindDragTest(); }
  }

  function tabScripts() {
    if (editing) {
      return '<input type="text" id="ed-name" value="' + esc(editing.name) + '" placeholder="name.js">' +
        '<div class="row"></div><textarea id="ed-code" spellcheck="false" autocapitalize="off" autocomplete="off">' + esc(editing.code) + '</textarea>' +
        '<div class="row"><button class="btn pri" data-a="ed-save">Save</button><button class="btn" data-a="ed-run">Save &amp; run</button><button class="btn" data-a="ed-cancel">Cancel</button></div>';
    }
    var h = '<div class="row"><button class="btn pri" data-a="load">Load .js file</button><button class="btn" data-a="new">New</button><button class="btn" data-a="reload">Reload page</button></div>';
    h += '<div class="muted">' + scripts.length + ' script(s). Enabled scripts run automatically on every page load. Turning one off fully takes effect after a reload.</div>';
    scripts.forEach(function (s) {
      h += '<div class="item"><input type="checkbox" data-a="toggle" data-id="' + s.id + '"' + (s.enabled ? ' checked' : '') + '>' +
        '<div class="name">' + esc(s.name) + ' <small>' + s.code.length + ' chars</small></div>' +
        '<select data-a="when" data-id="' + s.id + '">' +
        ['start', 'ready', 'load'].map(function (w) { return '<option value="' + w + '"' + ((s.when || 'ready') === w ? ' selected' : '') + '>' + w + '</option>'; }).join('') +
        '</select><button class="btn" data-a="run" data-id="' + s.id + '">Run</button><button class="btn" data-a="view" data-id="' + s.id + '">View</button>' +
        '<button class="btn danger" data-a="del" data-id="' + s.id + '">Remove</button></div>';
    });
    if (!scripts.length) h += '<div class="muted">No scripts yet. Tap "Load .js file" to pick one from your phone, or "New" to paste code.</div>';
    h += '<div class="muted">Run timing: <b>start</b> = as early as possible, <b>ready</b> = DOMContentLoaded, <b>load</b> = window load.</div>';
    return h;
  }

  function tabMouse() {
    var h = '';
    h += '<label class="f"><span><b>Virtual mouse</b></span><input type="checkbox" data-a="mouseOn"' + (S.mouseOn ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Type</span><select data-a="mode"><option value="touch"' + (S.mouseMode === 'touch' ? ' selected' : '') + '>Touch (direct)</option><option value="trackpad"' + (S.mouseMode === 'trackpad' ? ' selected' : '') + '>Trackpad (relative)</option></select></label>';
    h += '<div class="muted">' + (S.mouseMode === 'touch'
      ? 'Touch: the cursor jumps to your finger; press = click, drag = drag. Hover happens wherever you touch.'
      : 'Trackpad: swipe anywhere to move the cursor (hover). Tap = left click, tap-then-hold = drag, two-finger tap = right click. L/R buttons below also work.') + '</div>';
    h += '<label class="f"><span>Sensitivity <b id="sensv">' + S.sens + '</b></span><input type="range" min="0.4" max="4" step="0.1" value="' + S.sens + '" data-a="sens"></label>';
    h += '<label class="f"><span>Drag method (try another if drag fails)</span><select data-a="dragm">' + [[0, 'Hover-move + button (default)'], [1, 'Move, generic'], [2, 'Move, touch path'], [3, 'Hover + touch']].map(function (o) { return '<option value="' + o[0] + '"' + ((S.dragMethod || 0) === o[0] ? ' selected' : '') + '>' + o[1] + '</option>'; }).join('') + '</select></label>';
    h += '<label class="f"><span>Normalise native mouse events (fix detail/buttons, block text selection while dragging)</span><input type="checkbox" data-a="fixev"' + (S.fixEvents ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Also emit touch events on press/drag (compat, off by default)</span><input type="checkbox" data-a="tcompat"' + (S.touchCompat ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Show cursor</span><input type="checkbox" data-a="cursor"' + (S.cursor ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Cursor size <b id="csv">' + S.cursorSize + '</b></span><input type="range" min="16" max="64" step="2" value="' + S.cursorSize + '" data-a="csize"></label>';
    h += '<label class="f"><span>On-screen L/R buttons (trackpad)</span><input type="checkbox" data-a="lr"' + (S.lr ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Two-finger scroll (trackpad)</span><input type="checkbox" data-a="scrollOn"' + (S.scrollOn ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Scroll buttons ⇞ ▲ ▼ ⇟ (right edge)</span><input type="checkbox" data-a="scrollBtns"' + (S.scrollBtns ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Scroll method</span><select data-a="scrollMode"><option value="native"' + (S.scrollMode === 'native' ? ' selected' : '') + '>Native wheel at cursor</option><option value="js"' + (S.scrollMode === 'js' ? ' selected' : '') + '>JS scroll of element under cursor</option></select></label>';
    h += '<label class="f"><span>Report hover/fine pointer to page (matchMedia)</span><input type="checkbox" data-a="spoof"' + (S.spoofMedia ? ' checked' : '') + '></label>';
    h += '<div class="hover" id="dpad">Drag test: hold L (or tap-hold) and move<div id="dball"></div><div class="row dnd"><div class="chip" id="dchip" draggable="true">drag me</div><div class="zone" id="dzone">drop here</div></div><small id="dlog">down 0 | move(held) 0 | up 0 | dragstart 0 | drop 0</small></div>';
    h += '<div class="hover" id="ht">Hover test area<small id="hti">move the cursor here (trackpad mode: swipe outside the panel)</small></div>';
    return h;
  }

  function sizeOptions(cur) {
    var list = [[24, 'XXS'], [32, 'XS'], [44, 'S'], [56, 'M'], [72, 'L']], known = false, h = '';
    list.forEach(function (z) { if (z[0] === cur) known = true; });
    if (!known) list.push([cur, cur + 'px']);
    list.sort(function (a, b) { return a[0] - b[0]; });
    list.forEach(function (z) { h += '<option value="' + z[0] + '"' + (cur === z[0] ? ' selected' : '') + '>' + z[1] + '</option>'; });
    return h;
  }

  function tabKeys() {
    var h = '';
    h += '<label class="f"><span><b>On-screen keys</b></span><input type="checkbox" data-a="keysOn"' + (S.keysOn ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Send as</span><select data-a="keyMode"><option value="native"' + (S.keyMode === 'native' ? ' selected' : '') + '>Real key events (native)</option><option value="synthetic"' + (S.keyMode === 'synthetic' ? ' selected' : '') + '>Page events (synthetic)</option></select></label>';
    h += '<label class="f"><span>Opacity <b id="kov">' + S.keyOpacity + '</b></span><input type="range" min="0.05" max="1" step="0.05" value="' + S.keyOpacity + '" data-a="kopacity"></label>';
    h += '<label class="f"><span>Slide between keys (release when finger leaves a key; press when it glides onto a neighbouring key)</span><input type="checkbox" data-a="keySlide"' + (S.keySlide ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Transparent key background</span><input type="checkbox" data-a="keyNoFill"' + (S.keyNoFill ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Snap &amp; align to neighbouring keys while editing</span><input type="checkbox" data-a="snap"' + (S.snap ? ' checked' : '') + '></label>';
    h += '<div class="muted"><b>Cursor controls</b> (L/R + scroll buttons)</div>';
    h += '<label class="f"><span>Opacity <b id="cov">' + S.ctlOpacity + '</b></span><input type="range" min="0.05" max="1" step="0.05" value="' + S.ctlOpacity + '" data-a="copacity"></label>';
    h += '<label class="f"><span>Size</span><select data-a="ctlsize">' + [[0.75, 'S'], [1, 'M'], [1.3, 'L'], [1.6, 'XL']].map(function (z) { return '<option value="' + z[0] + '"' + (S.ctlSize === z[0] ? ' selected' : '') + '>' + z[1] + '</option>'; }).join('') + '</select></label>';
    h += '<label class="f"><span>Transparent control background</span><input type="checkbox" data-a="ctlNoFill"' + (S.ctlNoFill ? ' checked' : '') + '></label>';
    h += '<div class="row"><button class="btn' + (keysEdit ? ' on' : '') + '" data-a="kedit">' + (keysEdit ? 'Done editing' : 'Edit layout (drag keys + cursor controls)') + '</button><button class="btn" data-a="ctlreset">Reset control layout</button></div>';
    h += '<div class="row"><button class="btn" data-a="kadd">+ Add key</button></div>';
    h += '<div class="row">Presets: ' + Object.keys(PRESETS).map(function (p) { return '<button class="btn" data-a="kpreset" data-v="' + esc(p) + '">' + esc(p) + '</button>'; }).join('') + '</div>';
    S.keys.forEach(function (k) {
      h += '<div class="item"><select data-a="kkey" data-id="' + k.id + '">' + KEY_NAMES.map(function (n) { return '<option' + (n === k.k ? ' selected' : '') + '>' + n + '</option>'; }).join('') + '</select>' +
        '<select data-a="ksize" data-id="' + k.id + '">' + sizeOptions(k.size) + '</select>' +
        '<select data-a="kslide" data-id="' + k.id + '" title="Slide"><option value=""' + (k.slide === undefined ? ' selected' : '') + '>Slide: default</option><option value="1"' + (k.slide === true ? ' selected' : '') + '>Slide: on</option><option value="0"' + (k.slide === false ? ' selected' : '') + '>Slide: off</option></select>' +
        '<div class="name"></div><button class="btn danger" data-a="kdel" data-id="' + k.id + '">Remove</button></div>';
    });
    h += '<div class="muted">Native mode sends real Android key events (keydown/keyup like a keyboard). Modifier keys held via buttons do not set shiftKey/ctrlKey on other keys.</div>';
    return h;
  }

  function tabDebug() {
    var nt = nTouches();
    var st = '<div class="hover"><b>Input state</b><div class="kv"><div>mouse held</div><div>' + held + '</div><div>L/R buttons down</div><div>' + btnHold + '</div><div>keys down</div><div>' + keysDown() + '</div><div>touch id</div><div>' + (tp.id === null ? '-' : tp.id) + '</div><div>click-through nodes</div><div>' + thruList.length + '</div><div>fingers (native)</div><div>' + (nt < 0 ? 'n/a' : nt) + '</div><div>auto-heals</div><div>' + heal.n + (heal.n ? ' (last: ' + esc(heal.last) + ')' : '') + '</div></div><div class="row"><button class="btn" data-a="resetinput">Reset input state</button><button class="btn" data-a="spyrefresh">Refresh</button></div></div>';
    return st + '<label class="f"><span><b>Event spy</b>: log what the page receives</span><input type="checkbox" data-a="spy"' + (spyOn ? ' checked' : '') + '></label>' +
      '<div class="row"><button class="btn" data-a="spyrefresh">Refresh</button><button class="btn" data-a="spyclear">Clear</button></div>' +
      '<div class="muted">Turn on, close this panel, drag something in the game (and your own bubble), then reopen this tab. <b>trusted=true</b> = real native event, <b>false</b> = script-made. Moves are logged only while a button is down.</div>' +
      '<pre class="spy" id="spyout">' + esc(spyText()) + '</pre>';
  }

  function tabAbout() {
    var ok = bridgeOk();
    return '<div class="kv"><div>Mod UI</div><div>v' + VERSION + '</div>' +
      '<div>Native bridge</div><div class="' + (ok ? 'ok' : 'bad') + '">' + (ok ? 'connected' : 'not available (limited mode)') + '</div>' +
      '<div>Token</div><div class="' + (T ? 'ok' : 'bad') + '">' + (T ? 'present' : 'missing') + '</div>' +
      '<div>Pixel ratio</div><div>' + dpr() + '</div>' +
      '<div>Viewport</div><div>' + window.innerWidth + '×' + window.innerHeight + '</div></div>' +
      '<div class="row"><button class="btn" data-a="pipnow">Enter Picture-in-Picture now</button></div>' +
      '<label class="f"><span>Wake lock: keep CPU awake in background (also toggleable from the notification)</span><input type="checkbox" data-a="wake"' + (getWake() ? ' checked' : '') + '></label>' +
      '<label class="f"><span>Keep screen on while the game is open</span><input type="checkbox" data-a="screen"' + (S.screenOn ? ' checked' : '') + '></label>' +
      '<label class="f"><span>Auto Picture-in-Picture when leaving the app</span><input type="checkbox" data-a="pip"' + (S.pip ? ' checked' : '') + '></label>' +
      '<div class="row"><button class="btn" data-a="reload">Reload page</button><button class="btn danger" data-a="reset">Reset all mod data</button></div>' +
      '<div class="muted">Scripts and settings are stored in this app’s pony.town storage. The mod only runs on pony.town. Page scripts can read <code>window.ptmod.mouse</code> and listen for the <code>ptmod:mouse</code> event.</div>';
  }

  // ------------------------------------------------------------------ event spy (debug)
  var spyOn = false, spyLog = [], spyCnt = {}, spyTimer = 0;
  var SPY_TYPES = ['mousedown', 'mouseup', 'click', 'pointerdown', 'pointerup', 'pointercancel', 'touchstart', 'touchend', 'touchcancel', 'dragstart', 'contextmenu', 'wheel', 'selectstart', 'mousemove', 'pointermove', 'touchmove'];
  function descNode(n) {
    if (!n || !n.tagName) return String((n && n.nodeName) || n);
    var s = n.tagName.toLowerCase();
    if (n.id) s += '#' + n.id;
    var c = (typeof n.className === 'string' ? n.className : '').trim().split(/\s+/).slice(0, 2).join('.');
    if (c) s += '.' + c;
    return s;
  }
  var spyMv = {};   // collapsed move events: line -> {line, n}
  function spyFlush() {
    Object.keys(spyMv).forEach(function (k) { spyLog.push({ line: spyMv[k].line, n: spyMv[k].n }); });
    spyMv = {};
    while (spyLog.length > 26) spyLog.shift();
  }
  function spyText() {
    var keys = Object.keys(spyCnt);
    var head = keys.length ? ('counts: ' + keys.map(function (k) { return k + '=' + spyCnt[k]; }).join(' ')) : 'no events logged yet';
    var rows = spyLog.map(function (l) { return l.line + (l.n > 1 ? '  x' + l.n : ''); });
    Object.keys(spyMv).forEach(function (k) { rows.push(spyMv[k].line + '  x' + spyMv[k].n); });
    return head + '\n' + rows.join('\n');
  }
  function spyHandler(e) {
    var p = e.composedPath ? e.composedPath() : [], i;
    for (i = 0; i < p.length; i++) if (p[i] === host) return;
    var mv = (e.type === 'mousemove' || e.type === 'pointermove' || e.type === 'touchmove');
    if ((e.type === 'mousemove' || e.type === 'pointermove') && !e.buttons) return;
    var isMouseish = (e.type.indexOf('mouse') === 0 || e.type === 'click' || e.type === 'contextmenu');
    var line = e.type + ' ' + descNode(p[0] || e.target) + ' trusted=' + e.isTrusted + (e.pointerType ? ' ' + e.pointerType : '') +
      (typeof e.buttons === 'number' ? ' b=' + e.buttons : '') + (isMouseish && typeof e.detail === 'number' ? ' d=' + e.detail : '');
    spyCnt[e.type] = (spyCnt[e.type] || 0) + 1;
    if (mv) {
      if (spyMv[line]) spyMv[line].n++; else spyMv[line] = { line: line, n: 1 };
    } else {
      spyFlush();
      var entry = { line: line, n: 1 };
      spyLog.push(entry);
      if (e.cancelable) setTimeout(function () { if (e.defaultPrevented) entry.line += ' PREVENTED'; }, 0);
    }
    if (!spyTimer) spyTimer = setTimeout(function () {
      spyTimer = 0;
      var o = panel.querySelector('#spyout');
      if (o) o.textContent = spyText();
    }, 250);
  }
  function setSpy(on) {
    if (on === spyOn) return;
    spyOn = on;
    SPY_TYPES.forEach(function (t) {
      if (on) window.addEventListener(t, spyHandler, true); else window.removeEventListener(t, spyHandler, true);
    });
  }

  // ------------------------------------------------------------------ panel events
  function bindDragTest() {
    var pad = panel.querySelector('#dpad'), ball = panel.querySelector('#dball'), chip = panel.querySelector('#dchip'),
        zone = panel.querySelector('#dzone'), log = panel.querySelector('#dlog');
    if (!pad || !ball || !chip || !zone || !log) return;
    var c = { down: 0, move: 0, up: 0, ds: 0, drop: 0 }, active = false;
    function show(e) {
      log.textContent = 'down ' + c.down + ' | move(held) ' + c.move + ' | up ' + c.up + ' | dragstart ' + c.ds + ' | drop ' + c.drop +
        (e ? ' | trusted=' + e.isTrusted + ' buttons=' + e.buttons : '');
    }
    function place(e) {
      var r = pad.getBoundingClientRect();
      ball.style.left = Math.max(0, Math.min(r.width - 18, e.clientX - r.left - 9)) + 'px';
      ball.style.top = Math.max(0, Math.min(r.height - 18, e.clientY - r.top - 9)) + 'px';
    }
    pad.addEventListener('mousedown', function (e) { active = true; c.down++; place(e); show(e); });
    pad.addEventListener('mousemove', function (e) { if (active && (e.buttons & 3)) { c.move++; place(e); show(e); } });
    panel.addEventListener('mouseup', function (e) { if (active) { active = false; c.up++; show(e); } });
    chip.addEventListener('dragstart', function (e) { c.ds++; try { e.dataTransfer.setData('text/plain', 'ptmod'); } catch (x) { /* ignore */ } show(e); });
    zone.addEventListener('dragover', function (e) { e.preventDefault(); });
    zone.addEventListener('drop', function (e) { e.preventDefault(); c.drop++; zone.textContent = 'dropped!'; show(e); });
  }
  function bindHoverTest() {
    var ht = root.getElementById ? root.getElementById('ht') : panel.querySelector('#ht');
    var hi = panel.querySelector('#hti');
    if (!ht || !hi) return;
    function info(e) { hi.textContent = e.type + ' • trusted=' + e.isTrusted + ' • ' + (e.pointerType || 'mouse') + ' • ' + Math.round(e.clientX) + ',' + Math.round(e.clientY); }
    ['mouseenter', 'mousemove', 'pointermove', 'mouseleave'].forEach(function (t) { ht.addEventListener(t, info); });
  }

  panel.addEventListener('click', function (e) {
    var t = e.target.closest ? e.target.closest('[data-a]') : null;
    if (!t) return;
    var a = t.getAttribute('data-a'), id = t.getAttribute('data-id'), v = t.getAttribute('data-v');
    var s;
    switch (a) {
      case 'tab': setTab(v); break;
      case 'close': togglePanel(false); break;
      case 'load': pickFile(); break;
      case 'new': editing = { id: null, name: 'new-script.js', code: '// your code\nconsole.log("hello from ptmod");\n' }; render(); break;
      case 'reload': try { location.reload(); } catch (x) { /* ignore */ } break;
      case 'spyclear': spyLog = []; spyCnt = {}; spyMv = {}; render(); break;
      case 'spyrefresh': render(); break;
      case 'run': s = findScript(id); if (s) { runScript(s); toast('Ran ' + s.name); } break;
      case 'view': s = findScript(id); if (s) { editing = { id: s.id, name: s.name, code: s.code }; render(); } break;
      case 'del': s = findScript(id); if (s && confirm('Remove ' + s.name + '?')) { scripts.splice(scripts.indexOf(s), 1); saveScripts(); render(); toast('Removed (reload to stop it)'); } break;
      case 'ed-cancel': editing = null; render(); break;
      case 'ed-save': case 'ed-run': saveEditor(a === 'ed-run'); break;
      case 'pipnow': (function () { var b = B(); if (b && b.pipNow) { try { b.pipNow(T); } catch (e) { toast('PiP failed'); } } else toast('PiP not available'); })(); break;
      case 'resetinput': resetInput('manual'); toast('Input state reset'); render(); break;
      case 'kedit': keysEdit = !keysEdit; buildKeys(); applyCtl(); render(); break;
      case 'ctlreset': S.ctlPos = {}; saveS(); applyCtl(); toast('Control layout reset'); break;
      case 'kadd': S.keys.push({ id: uid(), k: 'E', fx: 0.5, fy: 0.5, size: 56 }); saveS(); buildKeys(); render(); break;
      case 'kpreset': S.keys = presetKeys(v); saveS(); buildKeys(); render(); break;
      case 'kdel': S.keys = S.keys.filter(function (k) { return k.id !== id; }); saveS(); buildKeys(); render(); break;
      case 'reset':
        if (confirm('Delete all ptmod scripts and settings?')) { try { localStorage.removeItem(LS_S); localStorage.removeItem(LS_C); } catch (x) { /* ignore */ } toast('Reset. Reloading...'); setTimeout(function () { location.reload(); }, 600); }
        break;
    }
  });

  panel.addEventListener('change', function (e) {
    var t = e.target, a = t.getAttribute && t.getAttribute('data-a'), id = t.getAttribute && t.getAttribute('data-id');
    if (!a) return;
    var s;
    switch (a) {
      case 'toggle': s = findScript(id); if (s) { s.enabled = t.checked; saveScripts(); if (s.enabled && whenPhase(s)) runScript(s); toast(s.enabled ? 'Enabled' : 'Disabled (reload to stop it)'); } break;
      case 'when': s = findScript(id); if (s) { s.when = t.value; saveScripts(); } break;
      case 'mouseOn': S.mouseOn = t.checked; saveS(); applyMouse(); break;
      case 'mode': S.mouseMode = t.value; saveS(); applyMouse(); render(); break;
      case 'fixev': S.fixEvents = t.checked; saveS(); break;
      case 'tcompat': S.touchCompat = t.checked; saveS(); break;
      case 'spy': setSpy(t.checked); break;
      case 'dragm': S.dragMethod = parseInt(t.value, 10) || 0; saveS(); break;
      case 'cursor': S.cursor = t.checked; saveS(); applyMouse(); break;
      case 'lr': S.lr = t.checked; saveS(); applyMouse(); break;
      case 'keyNoFill': S.keyNoFill = t.checked; saveS(); buildKeys(); break;
      case 'ctlNoFill': S.ctlNoFill = t.checked; saveS(); applyCtl(); break;
      case 'ctlsize': S.ctlSize = parseFloat(t.value); saveS(); applyCtl(); break;
      case 'scrollOn': S.scrollOn = t.checked; saveS(); applyMouse(); break;
      case 'scrollBtns': S.scrollBtns = t.checked; saveS(); applyMouse(); break;
      case 'scrollMode': S.scrollMode = (t.value === 'js') ? 'js' : 'native'; saveS(); break;
      case 'spoof': S.spoofMedia = t.checked; saveS(); fireMediaChange(); break;
      case 'keysOn': S.keysOn = t.checked; saveS(); buildKeys(); break;
      case 'keyMode': S.keyMode = t.value; saveS(); break;
      case 'kkey': S.keys.forEach(function (k) { if (k.id === id) k.k = t.value; }); saveS(); buildKeys(); break;
      case 'kslide': S.keys.forEach(function (k) { if (k.id === id) k.slide = t.value === '' ? undefined : t.value === '1'; }); saveS(); break;
      case 'snap': S.snap = t.checked; saveS(); break;
      case 'keySlide': S.keySlide = t.checked; saveS(); break;
      case 'wake': (function () { var b = B(); if (b && b.setWake) { try { b.setWake(T, t.checked); } catch (e) { /* ignore */ } } setTimeout(render, 400); })(); break;
      case 'screen': S.screenOn = t.checked; saveS(); sendScreen(); break;
      case 'pip': S.pip = t.checked; saveS(); sendPip(); break;
      case 'ksize': S.keys.forEach(function (k) { if (k.id === id) k.size = parseInt(t.value, 10) || 56; }); saveS(); buildKeys(); break;
    }
  });

  panel.addEventListener('input', function (e) {
    var t = e.target, a = t.getAttribute && t.getAttribute('data-a');
    var n;
    if (a === 'sens') { S.sens = parseFloat(t.value); saveS(); n = panel.querySelector('#sensv'); if (n) n.textContent = S.sens; }
    else if (a === 'csize') { S.cursorSize = parseInt(t.value, 10); saveS(); n = panel.querySelector('#csv'); if (n) n.textContent = S.cursorSize; drawCursor(); }
    else if (a === 'copacity') { S.ctlOpacity = parseFloat(t.value); saveS(); n = panel.querySelector('#cov'); if (n) n.textContent = S.ctlOpacity; applyCtl(); }
    else if (a === 'kopacity') { S.keyOpacity = parseFloat(t.value); saveS(); n = panel.querySelector('#kov'); if (n) n.textContent = S.keyOpacity; buildKeys(); }
  });

  function saveEditor(runIt) {
    var nm = panel.querySelector('#ed-name'), cd = panel.querySelector('#ed-code');
    if (!nm || !cd) return;
    var name = (nm.value || '').trim() || 'script.js';
    var s = editing && editing.id ? findScript(editing.id) : null;
    if (s) { s.name = name; s.code = cd.value; }
    else { s = { id: uid(), name: name, code: cd.value, enabled: true, when: 'ready' }; scripts.push(s); }
    saveScripts(); editing = null; render();
    if (runIt) { runScript(s); toast('Saved & ran ' + s.name); } else toast('Saved ' + s.name);
  }

  function pickFile() {
    var b = B();
    if (b && b.pickScript) { try { b.pickScript(T); return; } catch (e) { /* fall through */ } }
    toast('File picker not available');
  }
  // called natively with the picked file (pony.town only)
  window.__ptOnPicked = function (name, text) {
    try {
      if (typeof name !== 'string' || typeof text !== 'string') return;
      var s = addOrReplace(name, text);
      if (S.tab !== 'scripts') S.tab = 'scripts';
      if (!panel.hidden) render();
      runScript(s);
      toast('Loaded ' + name + ' (' + text.length + ' chars)');
    } catch (e) { console.error('[ptmod] pick failed', e); }
  };

  // ------------------------------------------------------------------ virtual mouse
  var cur = { x: Math.round(window.innerWidth / 2), y: Math.round(window.innerHeight / 2) };
  var held = 0;           // 0 = none, 1 = left, 2 = right
  var mouseApi = { on: false, mode: 'touch', x: cur.x, y: cur.y, pressed: false };

  function clampCur() {
    cur.x = Math.max(0, Math.min(window.innerWidth - 1, cur.x));
    cur.y = Math.max(0, Math.min(window.innerHeight - 1, cur.y));
  }
  function drawCursor() {
    var on = S.mouseOn && S.cursor;
    cursorEl.style.display = on ? 'block' : 'none';
    if (!on) return;
    var z = S.cursorSize;
    cursorEl.innerHTML = '<svg viewBox="0 0 24 24" width="' + z + '" height="' + z + '"><path d="M2 2 L2 19 L6.5 14.8 L9.6 22 L12.8 20.6 L9.7 13.6 L16 13.6 Z" fill="#fff" stroke="#000" stroke-width="1.4" stroke-linejoin="round"/></svg>';
    cursorEl.className = held ? 'press' : '';
    cursorEl.id = 'cursor';
    var off = 2 * z / 24;
    cursorEl.style.transform = 'translate(' + (cur.x - off) + 'px,' + (cur.y - off) + 'px)';
  }
  var lastEmit = 0;
  function publish(type) {
    mouseApi.on = S.mouseOn; mouseApi.mode = S.mouseMode; mouseApi.x = cur.x; mouseApi.y = cur.y; mouseApi.pressed = !!held;
    var now = Date.now();
    if (type !== 'move' || now - lastEmit > 30) {
      lastEmit = now;
      try { window.dispatchEvent(new CustomEvent('ptmod:mouse', { detail: { type: type, x: cur.x, y: cur.y, pressed: !!held, mode: S.mouseMode } })); } catch (e) { /* ignore */ }
    }
  }
  function moveTo(x, y) { cur.x = x; cur.y = y; clampCur(); drawCursor(); publish('move'); }
  function mHover() { nHover(cur.x, cur.y); }
  // Optional compat: also emit (script-made) touch events at the cursor so UI that only listens to touch can drag.
  var synthTarget = null;
  function emitTouch(type) {
    if (!S.touchCompat || typeof Touch !== 'function' || typeof TouchEvent !== 'function') return;
    try {
      if (type === 'touchstart') synthTarget = document.elementFromPoint(cur.x, cur.y);
      var tgt = synthTarget;
      if (!tgt) return;
      var tc = new Touch({ identifier: 9001, target: tgt, clientX: cur.x, clientY: cur.y, pageX: cur.x + (window.scrollX || 0), pageY: cur.y + (window.scrollY || 0), screenX: cur.x, screenY: cur.y, radiusX: 1, radiusY: 1, force: 1 });
      var end = (type === 'touchend');
      tgt.dispatchEvent(new TouchEvent(type, { bubbles: true, cancelable: true, composed: true, touches: end ? [] : [tc], targetTouches: end ? [] : [tc], changedTouches: [tc] }));
      if (end) synthTarget = null;
    } catch (x) { /* ignore */ }
  }
  // Pass-through: while the cursor clicks, our own overlay buttons under it ignore the pointer so the click reaches the page.
  var thruList = [], thruTimer = 0;
  function thruEnd() {
    clearTimeout(thruTimer); thruTimer = 0;
    thruList.forEach(function (n) { n.style.pointerEvents = ''; });
    thruList = [];
  }
  function thruBegin(except) {
    thruEnd();
    if (keysEdit) return;
    [keysLayer, ctlLayer].forEach(function (layer) {
      for (var i = 0; i < layer.children.length; i++) {
        var n = layer.children[i];
        if (n === except || n.style.display === 'none' || / down/.test(' ' + n.className)) continue;   // never detach a node a finger is pressing
        var r = n.getBoundingClientRect();
        if (r.width && cur.x >= r.left && cur.x <= r.right && cur.y >= r.top && cur.y <= r.bottom) { n.style.pointerEvents = 'none'; thruList.push(n); }
      }
    });
  }
  function mDown(b, except) {
    if (held) mUp();
    thruBegin(except);
    held = b || 1; nHover(cur.x, cur.y); nBtn(1, cur.x, cur.y, held); emitTouch('touchstart'); drawCursor(); publish('down');
  }
  function mDrag() { if (held) { nBtn(2, cur.x, cur.y, held | ((S.dragMethod || 0) << 8)); emitTouch('touchmove'); } else mHover(); }
  function mUp() {
    if (!held) { if (thruList.length && !thruTimer) thruTimer = setTimeout(thruEnd, 150); return; }
    var released = held;
    held = 0; nBtn(3, cur.x, cur.y, released); emitTouch('touchend'); drawCursor(); publish('up'); mHover();
    if (thruList.length) { clearTimeout(thruTimer); thruTimer = setTimeout(thruEnd, 150); }
  }
  // Nearest scrollable ancestor of the element under the cursor (for "JS scrollBy" mode)
  function scrollableAt(x, y) {
    var n = document.elementFromPoint(x, y), cs;
    while (n && n !== document.documentElement) {
      try {
        cs = getComputedStyle(n);
        if (((/(auto|scroll|overlay)/.test(cs.overflowY) && n.scrollHeight > n.clientHeight + 1) ||
             (/(auto|scroll|overlay)/.test(cs.overflowX) && n.scrollWidth > n.clientWidth + 1))) return n;
      } catch (e) { /* ignore */ }
      n = n.parentElement;
    }
    return null;
  }
  // dx/dy in wheel notches (positive dy = scroll up / content moves down)
  function mScroll(dx, dy) {
    if (!dx && !dy) return;
    if (S.scrollMode === 'js') {
      var n = scrollableAt(cur.x, cur.y);
      if (n) { n.scrollBy(dx * 48, -dy * 48); publish('scroll'); return; }
    }
    nScroll(dx, dy);
    publish('scroll');
  }
  function mClick(b) { mDown(b); setTimeout(mUp, 45); }

  // Cursor controls: L/R + scroll buttons, individually placed (layout editable in Keys tab)
  var btnHold = 0;   // number of on-screen L/R buttons currently pressed
  var CTL = [
    { id: 'L', label: 'L', btn: 1, w: 74, h: 46, fx: 0.42, fy: 0.92, grp: 'lr' },
    { id: 'R', label: 'R', btn: 2, w: 74, h: 46, fx: 0.58, fy: 0.92, grp: 'lr' },
    { id: 'pu', label: '⇞', dy: 6.0, every: 180, w: 54, h: 46, fx: 0.95, fy: 0.30, grp: 'sc' },
    { id: 'u', label: '▲', dy: 1.0, every: 90, w: 54, h: 46, fx: 0.95, fy: 0.42, grp: 'sc' },
    { id: 'd', label: '▼', dy: -1.0, every: 90, w: 54, h: 46, fx: 0.95, fy: 0.54, grp: 'sc' },
    { id: 'pd', label: '⇟', dy: -6.0, every: 180, w: 54, h: 46, fx: 0.95, fy: 0.66, grp: 'sc' }
  ];
  var ctlNodes = {};
  var ctlStops = [];
  // Snap/align a dragged overlay node (keys + cursor controls) to its neighbours: edges, centres and
  // flush placement with a fixed gap. (cx, cy) = wanted centre in px. Returns the adjusted centre.
  function hideGuides() { guideV.style.display = 'none'; guideH.style.display = 'none'; }
  function snapPos(node, cx, cy) {
    if (!S.snap) { hideGuides(); return { x: cx, y: cy }; }
    var TH = 12, w = node.offsetWidth, h = node.offsetHeight, W = window.innerWidth, H = window.innerHeight;
    var bx = null, by = null;
    function tryX(pos, line) { var d = Math.abs(pos - cx); if (d <= TH && (!bx || d < bx.d)) bx = { d: d, pos: pos, line: line }; }
    function tryY(pos, line) { var d = Math.abs(pos - cy); if (d <= TH && (!by || d < by.d)) by = { d: d, pos: pos, line: line }; }
    var rects = [];
    [keysLayer, ctlLayer].forEach(function (layer) {
      for (var i = 0; i < layer.children.length; i++) {
        var n = layer.children[i];
        if (n === node || !n.offsetWidth) continue;
        rects.push(n.getBoundingClientRect());
      }
    });
    rects.forEach(function (r) {
      var rowNear = cy + h / 2 >= r.top - TH && cy - h / 2 <= r.bottom + TH;   // vertically overlapping -> side by side
      var colNear = cx + w / 2 >= r.left - TH && cx - w / 2 <= r.right + TH;   // horizontally overlapping -> stacked
      tryX(r.left + w / 2, r.left); tryX(r.right - w / 2, r.right); tryX((r.left + r.right) / 2, (r.left + r.right) / 2);
      tryY(r.top + h / 2, r.top); tryY(r.bottom - h / 2, r.bottom); tryY((r.top + r.bottom) / 2, (r.top + r.bottom) / 2);
      if (rowNear) { tryX(r.right + KEY_GAP + w / 2, r.right + KEY_GAP / 2); tryX(r.left - KEY_GAP - w / 2, r.left - KEY_GAP / 2); }
      if (colNear) { tryY(r.bottom + KEY_GAP + h / 2, r.bottom + KEY_GAP / 2); tryY(r.top - KEY_GAP - h / 2, r.top - KEY_GAP / 2); }
    });
    // screen edges / centre lines
    tryX(w / 2, 0); tryX(W - w / 2, W); tryX(W / 2, W / 2);
    tryY(h / 2, 0); tryY(H - h / 2, H); tryY(H / 2, H / 2);
    if (bx) { guideV.style.left = Math.round(bx.line) + 'px'; guideV.style.display = 'block'; } else guideV.style.display = 'none';
    if (by) { guideH.style.top = Math.round(by.line) + 'px'; guideH.style.display = 'block'; } else guideH.style.display = 'none';
    return { x: bx ? bx.pos : cx, y: by ? by.pos : cy };
  }
  function nodeCentre(n) { var r = n.getBoundingClientRect(); return { x: r.left + r.width / 2, y: r.top + r.height / 2 }; }

  function ctlPos(c) { var p = S.ctlPos && S.ctlPos[c.id]; return p || { fx: c.fx, fy: c.fy }; }
  function placeCtl(c) {
    var n = ctlNodes[c.id], w = window.innerWidth, h = window.innerHeight, p = ctlPos(c);
    var bw = Math.round(c.w * S.ctlSize), bh = Math.round(c.h * S.ctlSize);
    n.style.width = bw + 'px'; n.style.height = bh + 'px';
    n.style.left = Math.max(0, Math.min(w - bw, p.fx * w - bw / 2)) + 'px';
    n.style.top = Math.max(0, Math.min(h - bh, p.fy * h - bh / 2)) + 'px';
  }
  function applyCtl() {
    var lrOn = S.mouseOn && S.mouseMode === 'trackpad' && S.lr, scOn = S.mouseOn && S.scrollBtns;
    CTL.forEach(function (c) {
      var n = ctlNodes[c.id];
      n.style.display = (keysEdit || (c.grp === 'lr' ? lrOn : scOn)) ? 'flex' : 'none';
      n.style.opacity = S.ctlOpacity;
      n.className = 'lrb' + (S.ctlNoFill ? ' nofill' : '') + (keysEdit ? ' edit' : '');
      placeCtl(c);
    });
  }
  (function () {
    CTL.forEach(function (c) {
      var b = el('button', 'lrb', c.label);
      ctlNodes[c.id] = b;
      var downId = null, timer = 0, drag = null;
      function cls(on) { b.className = 'lrb' + (S.ctlNoFill ? ' nofill' : '') + (keysEdit ? ' edit' : '') + (on ? ' down' : ''); }
      function stop() {
        if (timer) { clearInterval(timer); timer = 0; }
        if (downId !== null) {
          downId = null;
          if (c.btn) { if (btnHold > 0) btnHold--; if (held === c.btn) mUp(); }
        }
        cls(false);
      }
      ctlStops.push(function () { stop(); });
      b.addEventListener('pointerdown', function (e) {
        if (e.pointerType === 'mouse' && !keysEdit) return;   // the virtual cursor never presses our own controls
        e.preventDefault();
        try { b.setPointerCapture(e.pointerId); } catch (x) { /* ignore */ }
        if (keysEdit) { var cc = nodeCentre(b); drag = { id: e.pointerId, dx: cc.x - e.clientX, dy: cc.y - e.clientY }; return; }
        if (downId !== null) return;
        downId = e.pointerId; cls(true);
        if (c.btn) { btnHold++; mDown(c.btn, b); }
        else { mScroll(0, c.dy); timer = setInterval(function () { mScroll(0, c.dy); }, c.every); }
      });
      b.addEventListener('pointermove', function (e) {
        if (keysEdit && drag && e.pointerId === drag.id) {
          if (!S.ctlPos) S.ctlPos = {};
          var sp = snapPos(b, e.clientX + drag.dx, e.clientY + drag.dy);
          S.ctlPos[c.id] = { fx: sp.x / window.innerWidth, fy: sp.y / window.innerHeight }; placeCtl(c);
        }
      });
      var up = function (e) {
        if (keysEdit) { if (drag) { drag = null; hideGuides(); saveS(); } return; }
        if (e && downId !== null && e.pointerId !== downId) return;
        stop();
      };
      b.addEventListener('pointerup', up); b.addEventListener('pointercancel', up); b.addEventListener('lostpointercapture', up);
      ctlLayer.appendChild(b);
    });
    applyCtl();
  })();

  function inUi(e) {
    var p = e.composedPath ? e.composedPath() : [];
    for (var i = 0; i < p.length; i++) if (p[i] === host) return true;
    return false;
  }

  var tp = { id: null, sx: 0, sy: 0, lx: 0, ly: 0, st: 0, moved: false, two: false, twoMoved: false, drag: false, lastTapEnd: 0 };
  function getTouch(e, id) {
    var l = e.changedTouches;
    for (var i = 0; i < l.length; i++) if (l[i].identifier === id) return l[i];
    return null;
  }
  // Fingers on the game area only: a finger resting on an on-screen L/R/scroll
  // button (its target is retargeted to our shadow host) must NOT count, or a
  // held L/R button turns every swipe into a "two-finger scroll".
  function gameTouches(e) {
    var out = [], l = e.touches;
    for (var i = 0; i < l.length; i++) {
      var n = l[i].target, ui = (n === host);
      try { if (!ui && n && n.getRootNode && n.getRootNode() === root) ui = true; } catch (x) { /* ignore */ }
      if (!ui) out.push(l[i]);
    }
    return out;
  }
  function onTouch(e) {
    if (!e.isTrusted) return;   // our own compat touch events must reach the game untouched
    if (!S.mouseOn || inUi(e)) return;
    if (e.cancelable) e.preventDefault();
    e.stopImmediatePropagation();
    var t, now = Date.now();
    if (S.mouseMode === 'touch') {
      if (e.type === 'touchstart') {
        if (tp.id === null) { t = e.changedTouches[0]; tp.id = t.identifier; moveTo(t.clientX, t.clientY); mDown(1); }
      } else if (e.type === 'touchmove') {
        t = getTouch(e, tp.id); if (t) { moveTo(t.clientX, t.clientY); mDrag(); }
      } else if (tp.id !== null && getTouch(e, tp.id)) { tp.id = null; mUp(); }
      return;
    }
    // ---- trackpad
    var gt = gameTouches(e);
    if (e.type === 'touchstart') {
      if (tp.id === null) {
        t = e.changedTouches[0]; tp.id = t.identifier; tp.sx = tp.lx = t.clientX; tp.sy = tp.ly = t.clientY;
        tp.st = now; tp.moved = false; tp.two = false; tp.twoMoved = false; tp.drag = false;
        // tap-then-hold drag (only when no L/R button is already held)
        if (!btnHold && now - tp.lastTapEnd < 350) { tp.drag = true; mDown(1); }
      }
      if (gt.length >= 2) tp.two = true;
    } else if (e.type === 'touchmove') {
      t = getTouch(e, tp.id);
      if (!t) return;
      if (gt.length >= 2) {
        var sdx = t.clientX - tp.lx;
        var sdy = t.clientY - tp.ly;
        if (Math.abs(t.clientX - tp.sx) + Math.abs(t.clientY - tp.sy) > 14) tp.twoMoved = true;
        tp.lx = t.clientX; tp.ly = t.clientY;
        if (S.scrollOn && Math.abs(sdx) + Math.abs(sdy) > 0) mScroll(-sdx * S.sens * 0.08, -sdy * S.sens * 0.08);
        return;
      }
      moveTo(cur.x + (t.clientX - tp.lx) * S.sens, cur.y + (t.clientY - tp.ly) * S.sens);
      tp.lx = t.clientX; tp.ly = t.clientY;
      if (Math.abs(t.clientX - tp.sx) + Math.abs(t.clientY - tp.sy) > 8) tp.moved = true;
      mDrag();   // sends a MOVE with the button held while L/R (or tap-drag) is down
    } else { // touchend / touchcancel
      if (gt.length === 0) {
        if (tp.id !== null) {
          var dt = now - tp.st;
          if (tp.drag) { mUp(); tp.drag = false; }
          else if (!btnHold && e.type === 'touchend' && tp.two && !tp.twoMoved && dt < 320) { mHover(); mClick(2); }
          else if (!btnHold && e.type === 'touchend' && !tp.two && !tp.moved && dt < 260) { mHover(); mClick(1); tp.lastTapEnd = now; }
        }
        tp.id = null; tp.two = false; tp.twoMoved = false;
      } else if (getTouch(e, tp.id)) {
        // tracked finger lifted but another game finger remains: keep tracking that one
        tp.id = gt[0].identifier; tp.lx = gt[0].clientX; tp.ly = gt[0].clientY;
      }
    }
  }
  function onPointerBlock(e) {
    if (S.mouseOn && e.pointerType === 'touch' && !inUi(e)) e.stopImmediatePropagation();
  }
  // Native Android mouse events can arrive with detail=0 / buttons=0, which UI frameworks (Angular CDK drag)
  // treat as "fake mousedown from a screen reader" and ignore.  Normalise them on the event instance.
  function fixNativeMouse(e) {
    if (!S.mouseOn || !S.fixEvents || !e.isTrusted) return;
    try {
      var keyboardClick = (e.type === 'click' && e.pointerType !== 'mouse');
      if (e.detail === 0 && !keyboardClick) Object.defineProperty(e, 'detail', { value: 1, configurable: true });
      if (e.type === 'mousedown' && e.buttons === 0) Object.defineProperty(e, 'buttons', { value: held || 1, configurable: true });
    } catch (x) { /* ignore */ }
  }
  ['mousedown', 'mouseup', 'click'].forEach(function (t) { window.addEventListener(t, fixNativeMouse, true); });
  // No blue text selection while a virtual mouse button is held (inputs/textareas excluded)
  window.addEventListener('selectstart', function (e) {
    if (!S.mouseOn || !held || !S.fixEvents) return;
    var n = e.target;
    if (n && n.nodeType === 3) n = n.parentElement;
    if (n && n.closest && n.closest('input,textarea,[contenteditable="true"],[contenteditable=""]')) return;
    if (e.cancelable) e.preventDefault();
  }, true);
  ['touchstart', 'touchmove', 'touchend', 'touchcancel'].forEach(function (t) { window.addEventListener(t, onTouch, { capture: true, passive: false }); });
  ['pointerdown', 'pointermove', 'pointerup', 'pointercancel'].forEach(function (t) { window.addEventListener(t, onPointerBlock, true); });

  function applyMouse() {
    if (!S.mouseOn && held) mUp();
    tp.id = null;
    applyCtl();
    clampCur(); drawCursor(); publish('mode');
    if (S.mouseOn) mHover();
    fireMediaChange();
  }

  // ------------------------------------------------------------------ matchMedia (hover / pointer features)
  var mmEntries = [];
  var MM = { 'hover:hover': 1, 'any-hover:hover': 1, 'pointer:fine': 1, 'any-pointer:fine': 1, 'hover:none': 0, 'any-hover:none': 0, 'pointer:coarse': 0, 'any-pointer:coarse': 0 };
  function mmValue(q) {
    var s = String(q).toLowerCase().replace(/\s+/g, '');
    var m = /^\(([a-z-]+:[a-z]+)\)$/.exec(s);
    return (m && Object.prototype.hasOwnProperty.call(MM, m[1])) ? !!MM[m[1]] : null;
  }
  function mmActive() { return S.mouseOn && S.spoofMedia; }
  function fireMediaChange() {
    mmEntries.forEach(function (en) {
      var now = mmActive() ? en.v : en.real.matches;
      if (now !== en.last) {
        en.last = now;
        en.cbs.slice().forEach(function (cb) { try { cb.call(en.proxy, { type: 'change', matches: now, media: en.q, target: en.proxy }); } catch (e) { /* ignore */ } });
      }
    });
  }
  if (typeof window.matchMedia === 'function' && typeof Proxy === 'function') {
    var origMM = window.matchMedia.bind(window);
    window.matchMedia = function (q) {
      var real = origMM(q), v = mmValue(q);
      if (v === null) return real;
      var en = { real: real, v: v, q: String(q), cbs: [], last: mmActive() ? v : real.matches, proxy: null };
      en.proxy = new Proxy(real, {
        get: function (target, prop) {
          if (prop === 'matches') return mmActive() ? en.v : target.matches;
          if (prop === 'addEventListener') return function (type, cb, o) { if (type === 'change' && cb) en.cbs.push(cb); return target.addEventListener(type, cb, o); };
          if (prop === 'addListener') return function (cb) { if (cb) en.cbs.push(cb); return target.addListener(cb); };
          if (prop === 'removeEventListener') return function (type, cb, o) { en.cbs = en.cbs.filter(function (c) { return c !== cb; }); return target.removeEventListener(type, cb, o); };
          if (prop === 'removeListener') return function (cb) { en.cbs = en.cbs.filter(function (c) { return c !== cb; }); return target.removeListener(cb); };
          var val = target[prop];
          return (typeof val === 'function') ? val.bind(target) : val;
        }
      });
      mmEntries.push(en);
      return en.proxy;
    };
  }

  // ------------------------------------------------------------------ on-screen keys
  var keysEdit = false;
  var pressedKeys = {};  // pointerId -> key def
  function synth(d, down) {
    try {
      var ev = new KeyboardEvent(down ? 'keydown' : 'keyup', { key: d.key, code: d.code, shiftKey: !!d.shift, bubbles: true, cancelable: true, composed: true });
      try { Object.defineProperty(ev, 'keyCode', { get: function () { return d.kc; } }); Object.defineProperty(ev, 'which', { get: function () { return d.kc; } }); } catch (x) { /* ignore */ }
      (document.activeElement || document.body || document).dispatchEvent(ev);
    } catch (e) { /* ignore */ }
  }
  function sendKey(def, down) {
    var d = KD[def.k]; if (!d) return;
    if (S.keyMode === 'native' && B() && B().key) {
      if (d.shift) { if (down) { nKey(59, true); nKey(d.android, true); } else { nKey(d.android, false); nKey(59, false); } }
      else nKey(d.android, down);
    } else synth(d, down);
  }
  var slidePtr = {};   // pointerId -> last point seen inside a slide-enabled key
  function slideOn(k) { return k.slide === undefined ? !!S.keySlide : !!k.slide; }
  function keyAt(x, y) {
    var c = keysLayer.children;
    for (var i = 0; i < c.length; i++) {
      var r = c[i].getBoundingClientRect();
      if (x >= r.left && x <= r.right && y >= r.top && y <= r.bottom) return c[i];
    }
    return null;
  }
  function keyCls(n, down) { n.className = 'kb' + (S.keyNoFill ? ' nofill' : '') + (down ? ' down' : ''); }
  keysLayer.addEventListener('pointermove', function (e) {
    if (keysEdit || e.pointerType === 'mouse') return;
    var sp = slidePtr[e.pointerId]; if (!sp) return;
    var pk = pressedKeys[e.pointerId], hn = keyAt(e.clientX, e.clientY), hk = hn && hn._k;
    if (pk && hn === pk.node) { sp.x = e.clientX; sp.y = e.clientY; sp.t = Date.now(); return; }
    if (hk && slideOn(hk)) {
      var near = pk || (Date.now() - sp.t < 200) || (Math.abs(sp.x - e.clientX) + Math.abs(sp.y - e.clientY) <= 28);
      if (!near) return;
      if (pk) { keyCls(pk.node, false); sendKey(pk.def, false); }
      pressedKeys[e.pointerId] = { def: hk, node: hn }; keyCls(hn, true); sendKey(hk, true);
      sp.x = e.clientX; sp.y = e.clientY; sp.t = Date.now();
    } else if (pk) {
      delete pressedKeys[e.pointerId]; keyCls(pk.node, false); sendKey(pk.def, false);
    }
  });
  function releaseAllKeys() {
    slidePtr = {};
    Object.keys(pressedKeys).forEach(function (pid) { sendKey(pressedKeys[pid].def, false); pressedKeys[pid].node.className = pressedKeys[pid].node.className.replace(' down', ''); });
    pressedKeys = {};
  }
  function placeKey(node, k) {
    var w = window.innerWidth, h = window.innerHeight, m = k.w || 1;
    var kw = Math.round(k.size * m + KEY_GAP * (m - 1));
    node.style.width = kw + 'px'; node.style.height = k.size + 'px';
    node.style.fontSize = Math.max(8, Math.min(15, Math.round(k.size * 0.38))) + 'px';
    node.style.left = Math.max(0, Math.min(w - kw, k.fx * w - kw / 2)) + 'px';
    node.style.top = Math.max(0, Math.min(h - k.size, k.fy * h - k.size / 2)) + 'px';
  }
  function buildKeys() {
    releaseAllKeys();
    keysLayer.innerHTML = '';
    if (!S.keysOn) return;
    S.keys.forEach(function (k) {
      var d = KD[k.k]; if (!d) return;
      var n = el('div', 'kb' + (keysEdit ? ' edit' : ''), esc(d.label));
      n._k = k;
      n.style.opacity = S.keyOpacity;
      if (S.keyNoFill) n.className += ' nofill';
      placeKey(n, k);
      var drag = null;
      n.addEventListener('pointerdown', function (e) {
        if (e.pointerType === 'mouse' && !keysEdit) return;   // the virtual cursor never presses on-screen keys
        e.preventDefault();
        try { n.setPointerCapture(e.pointerId); } catch (x) { /* ignore */ }
        if (keysEdit) { var kc0 = nodeCentre(n); drag = { id: e.pointerId, dx: kc0.x - e.clientX, dy: kc0.y - e.clientY }; return; }
        n.className = 'kb down' + (S.keyNoFill ? ' nofill' : '');
        pressedKeys[e.pointerId] = { def: k, node: n };
        if (slideOn(k)) slidePtr[e.pointerId] = { x: e.clientX, y: e.clientY, t: Date.now() };
        sendKey(k, true);
      });
      n.addEventListener('pointermove', function (e) {
        if (keysEdit && drag && e.pointerId === drag.id) {
          var sp = snapPos(n, e.clientX + drag.dx, e.clientY + drag.dy);
          k.fx = sp.x / window.innerWidth; k.fy = sp.y / window.innerHeight; placeKey(n, k);
        }
      });
      var up = function (e) {
        if (keysEdit) { if (drag) { drag = null; hideGuides(); saveS(); } return; }
        var pk = pressedKeys[e.pointerId];
        delete slidePtr[e.pointerId];
        if (pk) { delete pressedKeys[e.pointerId]; pk.node.className = 'kb' + (S.keyNoFill ? ' nofill' : ''); sendKey(pk.def, false); }
      };
      n.addEventListener('pointerup', up);
      n.addEventListener('pointercancel', up);
      n.addEventListener('lostpointercapture', up);
      keysLayer.appendChild(n);
    });
  }

  // ------------------------------------------------------------------ self-heal (stuck input)
  // If a touchend/pointerup never reaches us (the game removed the element under the finger, a gesture was
  // taken over, ...) the mouse button, keys, scroll timers and the click-through overrides on overlay
  // buttons could stay "held" forever: overlay + cursor stop responding and touches fall through to the game.
  // Truth source: the native finger count of the WebView (bridge.getTouches). With zero fingers on screen
  // nothing may stay pressed.
  var heal = { n: 0, last: '-', lastAt: 0 };
  var lastTouchStart = 0;
  function nTouches() { var b = B(); if (b && b.getTouches) { try { return b.getTouches(T); } catch (e) { /* ignore */ } } return -1; }
  function keysDown() { return Object.keys(pressedKeys).length; }
  function inputBusy() { return !!(held || tp.id !== null || btnHold > 0 || keysDown()); }
  function resetInput(why, silent) {
    var busy = inputBusy();
    try { ctlStops.forEach(function (f) { f(); }); } catch (e) { /* ignore */ }
    releaseAllKeys();
    btnHold = 0; tp.id = null; tp.two = false; tp.twoMoved = false; tp.drag = false;
    if (held) mUp();
    thruEnd();
    if (busy && !silent) { heal.n++; heal.last = why; heal.lastAt = Date.now(); publish('heal'); }
    return busy;
  }
  window.addEventListener('touchstart', function () { lastTouchStart = Date.now(); }, { capture: true, passive: true });
  ['touchend', 'touchcancel'].forEach(function (t) {
    window.addEventListener(t, function (e) {
      if (e.touches && e.touches.length === 0) {
        var t0 = Date.now();
        setTimeout(function () { if (lastTouchStart < t0 && inputBusy()) resetInput('last finger lifted'); }, 350);
      }
    }, { capture: true, passive: true });
  });
  var zeroTicks = 0;
  setInterval(function () {
    var n = nTouches();
    if (n === 0) {
      zeroTicks++;
      if (zeroTicks >= 2) { if (inputBusy()) resetInput('no fingers on screen'); else if (thruList.length && !thruTimer) thruEnd(); }
    }
    else zeroTicks = 0;
  }, 200);

  // ------------------------------------------------------------------ lifecycle
  window.addEventListener('resize', function () {
    placeFab(); clampCur(); drawCursor(); applyCtl(); checkPip();
    var nodes = keysLayer.children;
    for (var i = 0; i < nodes.length && i < S.keys.length; i++) placeKey(nodes[i], S.keys[i]);
  });
  document.addEventListener('visibilitychange', function () { if (document.hidden) resetInput('app hidden', true); });

  function checkPip() { try { host.style.display = (window.innerWidth < 520 && window.innerHeight < 330) ? 'none' : ''; } catch (e) { /* ignore */ } }

  function mount() {
    var parent = document.documentElement;
    if (!parent) { setTimeout(mount, 30); return; }
    if (!host.isConnected) parent.appendChild(host);
  }
  setInterval(function () { if (!host.isConnected && document.documentElement) document.documentElement.appendChild(host); }, 2000);

  window.ptmod = {
    version: VERSION,
    mouse: mouseApi,
    runScript: function (name) { for (var i = 0; i < scripts.length; i++) if (scripts[i].name === name) return runScript(scripts[i]); return false; },
    scripts: function () { return scripts.map(function (s) { return { name: s.name, enabled: s.enabled, when: s.when }; }); }
  };

  mount();
  placeFab();
  buildKeys();
  applyMouse();
  sendPip(); sendScreen(); checkPip();

  runPhase('start');
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', function () { runPhase('ready'); });
  else runPhase('ready');
  if (document.readyState === 'complete') runPhase('load');
  else window.addEventListener('load', function () { runPhase('load'); });
})();
