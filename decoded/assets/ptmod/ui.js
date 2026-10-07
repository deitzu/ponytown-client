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
  var KEY_NAMES = Object.keys(KD);

  var PRESETS = {
    'WASD': [['W', 0.15, 0.58], ['A', 0.07, 0.74], ['S', 0.15, 0.74], ['D', 0.23, 0.74]],
    'WASD + Space/Shift': [['W', 0.15, 0.58], ['A', 0.07, 0.74], ['S', 0.15, 0.74], ['D', 0.23, 0.74], ['Space', 0.9, 0.74], ['Shift', 0.82, 0.60]],
    'Arrows': [['Up', 0.15, 0.58], ['Left', 0.07, 0.74], ['Down', 0.15, 0.74], ['Right', 0.23, 0.74]]
  };
  function presetKeys(name) {
    return (PRESETS[name] || []).map(function (p) { return { id: uid(), k: p[0], fx: p[1], fy: p[2], size: 56 }; });
  }

  // ------------------------------------------------------------------ settings
  var DEF = {
    mouseOn: false, dragMethod: 0, mouseMode: 'touch', sens: 1.6, cursor: true, cursorSize: 28, lr: true, scrollOn: true, spoofMedia: true,
    keysOn: false, keyMode: 'native', keyOpacity: 0.55, keys: null,
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
  function nScroll(dx, dy) { var b = B(); if (b && b.mouseScroll) { try { b.mouseScroll(T, dx, dy); } catch (e) { /* ignore */ } } }
  function nKey(code, down) { var b = B(); if (b && b.key) { try { b.key(T, code, !!down); } catch (e) { /* ignore */ } } }
  function nExec(code) {
    var b = B();
    if (b && b.exec) { try { b.exec(T, code); return true; } catch (e) { /* fall through */ } }
    try { (0, eval)(code); return true; } catch (e2) { console.error('[ptmod] exec failed', e2); return false; }
  }
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
    '#keys{position:fixed;left:0;top:0;right:0;bottom:0;pointer-events:none}',
    '.kb{position:fixed;display:flex;align-items:center;justify-content:center;border-radius:12px;border:2px solid #ffffff88;background:#000;color:#fff;font:700 15px sans-serif;pointer-events:auto;touch-action:none;user-select:none;-webkit-user-select:none}',
    '.kb.down{background:#1f6feb;border-color:#fff}',
    '.kb.edit{outline:2px dashed #f0b72f}',
    '#lr{position:fixed;left:50%;bottom:14px;transform:translateX(-50%);display:none;gap:10px;pointer-events:none}',
    '#lr .lrb{width:74px;height:46px;border-radius:12px;border:2px solid #ffffff88;background:#000a;color:#fff;font:700 14px sans-serif;pointer-events:auto;touch-action:none;user-select:none;-webkit-user-select:none}',
    '#lr .lrb.down{background:#1f6feb}',
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
  var lrBar = el('div'); lrBar.id = 'lr';
  var toastEl = el('div', 'toast'); toastEl.style.display = 'none';
  root.appendChild(keysLayer);
  root.appendChild(lrBar);
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
    var tabs = [['scripts', 'Scripts'], ['mouse', 'Mouse'], ['keys', 'Keys'], ['about', 'About']];
    var h = '<div class="tabs">';
    tabs.forEach(function (t) { h += '<button class="tab' + (S.tab === t[0] ? ' on' : '') + '" data-a="tab" data-v="' + t[0] + '">' + t[1] + '</button>'; });
    h += '<button class="x" data-a="close">✕</button></div><div class="body" id="body">';
    h += (S.tab === 'mouse') ? tabMouse() : (S.tab === 'keys') ? tabKeys() : (S.tab === 'about') ? tabAbout() : tabScripts();
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
    h += '<label class="f"><span>Show cursor</span><input type="checkbox" data-a="cursor"' + (S.cursor ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Cursor size <b id="csv">' + S.cursorSize + '</b></span><input type="range" min="16" max="64" step="2" value="' + S.cursorSize + '" data-a="csize"></label>';
    h += '<label class="f"><span>On-screen L/R buttons (trackpad)</span><input type="checkbox" data-a="lr"' + (S.lr ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Two-finger scroll + ▲▼ buttons</span><input type="checkbox" data-a="scrollOn"' + (S.scrollOn ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Report hover/fine pointer to page (matchMedia)</span><input type="checkbox" data-a="spoof"' + (S.spoofMedia ? ' checked' : '') + '></label>';
    h += '<div class="hover" id="dpad">Drag test: hold L (or tap-hold) and move<div id="dball"></div><div class="row dnd"><div class="chip" id="dchip" draggable="true">drag me</div><div class="zone" id="dzone">drop here</div></div><small id="dlog">down 0 | move(held) 0 | up 0 | dragstart 0 | drop 0</small></div>';
    h += '<div class="hover" id="ht">Hover test area<small id="hti">move the cursor here (trackpad mode: swipe outside the panel)</small></div>';
    return h;
  }

  function tabKeys() {
    var h = '';
    h += '<label class="f"><span><b>On-screen keys</b></span><input type="checkbox" data-a="keysOn"' + (S.keysOn ? ' checked' : '') + '></label>';
    h += '<label class="f"><span>Send as</span><select data-a="keyMode"><option value="native"' + (S.keyMode === 'native' ? ' selected' : '') + '>Real key events (native)</option><option value="synthetic"' + (S.keyMode === 'synthetic' ? ' selected' : '') + '>Page events (synthetic)</option></select></label>';
    h += '<label class="f"><span>Opacity <b id="kov">' + S.keyOpacity + '</b></span><input type="range" min="0.2" max="1" step="0.05" value="' + S.keyOpacity + '" data-a="kopacity"></label>';
    h += '<div class="row"><button class="btn' + (keysEdit ? ' on' : '') + '" data-a="kedit">' + (keysEdit ? 'Done editing' : 'Edit layout (drag buttons)') + '</button><button class="btn" data-a="kadd">+ Add key</button></div>';
    h += '<div class="row">Presets: ' + Object.keys(PRESETS).map(function (p) { return '<button class="btn" data-a="kpreset" data-v="' + esc(p) + '">' + esc(p) + '</button>'; }).join('') + '</div>';
    S.keys.forEach(function (k) {
      h += '<div class="item"><select data-a="kkey" data-id="' + k.id + '">' + KEY_NAMES.map(function (n) { return '<option' + (n === k.k ? ' selected' : '') + '>' + n + '</option>'; }).join('') + '</select>' +
        '<select data-a="ksize" data-id="' + k.id + '">' + [[44, 'S'], [56, 'M'], [72, 'L']].map(function (z) { return '<option value="' + z[0] + '"' + (k.size === z[0] ? ' selected' : '') + '>' + z[1] + '</option>'; }).join('') + '</select>' +
        '<div class="name"></div><button class="btn danger" data-a="kdel" data-id="' + k.id + '">Remove</button></div>';
    });
    h += '<div class="muted">Native mode sends real Android key events (keydown/keyup like a keyboard). Modifier keys held via buttons do not set shiftKey/ctrlKey on other keys.</div>';
    return h;
  }

  function tabAbout() {
    var ok = bridgeOk();
    return '<div class="kv"><div>Mod UI</div><div>v' + VERSION + '</div>' +
      '<div>Native bridge</div><div class="' + (ok ? 'ok' : 'bad') + '">' + (ok ? 'connected' : 'not available (limited mode)') + '</div>' +
      '<div>Token</div><div class="' + (T ? 'ok' : 'bad') + '">' + (T ? 'present' : 'missing') + '</div>' +
      '<div>Pixel ratio</div><div>' + dpr() + '</div>' +
      '<div>Viewport</div><div>' + window.innerWidth + '×' + window.innerHeight + '</div></div>' +
      '<div class="row"><button class="btn" data-a="reload">Reload page</button><button class="btn danger" data-a="reset">Reset all mod data</button></div>' +
      '<div class="muted">Scripts and settings are stored in this app’s pony.town storage. The mod only runs on pony.town. Page scripts can read <code>window.ptmod.mouse</code> and listen for the <code>ptmod:mouse</code> event.</div>';
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
      case 'run': s = findScript(id); if (s) { runScript(s); toast('Ran ' + s.name); } break;
      case 'view': s = findScript(id); if (s) { editing = { id: s.id, name: s.name, code: s.code }; render(); } break;
      case 'del': s = findScript(id); if (s && confirm('Remove ' + s.name + '?')) { scripts.splice(scripts.indexOf(s), 1); saveScripts(); render(); toast('Removed (reload to stop it)'); } break;
      case 'ed-cancel': editing = null; render(); break;
      case 'ed-save': case 'ed-run': saveEditor(a === 'ed-run'); break;
      case 'kedit': keysEdit = !keysEdit; buildKeys(); render(); break;
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
      case 'dragm': S.dragMethod = parseInt(t.value, 10) || 0; saveS(); break;
      case 'cursor': S.cursor = t.checked; saveS(); applyMouse(); break;
      case 'lr': S.lr = t.checked; saveS(); applyMouse(); break;
      case 'scrollOn': S.scrollOn = t.checked; saveS(); applyMouse(); break;
      case 'spoof': S.spoofMedia = t.checked; saveS(); fireMediaChange(); break;
      case 'keysOn': S.keysOn = t.checked; saveS(); buildKeys(); break;
      case 'keyMode': S.keyMode = t.value; saveS(); break;
      case 'kkey': S.keys.forEach(function (k) { if (k.id === id) k.k = t.value; }); saveS(); buildKeys(); break;
      case 'ksize': S.keys.forEach(function (k) { if (k.id === id) k.size = parseInt(t.value, 10) || 56; }); saveS(); buildKeys(); break;
    }
  });

  panel.addEventListener('input', function (e) {
    var t = e.target, a = t.getAttribute && t.getAttribute('data-a');
    var n;
    if (a === 'sens') { S.sens = parseFloat(t.value); saveS(); n = panel.querySelector('#sensv'); if (n) n.textContent = S.sens; }
    else if (a === 'csize') { S.cursorSize = parseInt(t.value, 10); saveS(); n = panel.querySelector('#csv'); if (n) n.textContent = S.cursorSize; drawCursor(); }
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
  function mDown(b) {
    if (held) mUp();
    held = b || 1; nHover(cur.x, cur.y); nBtn(1, cur.x, cur.y, held); drawCursor(); publish('down');
  }
  function mDrag() { if (held) nBtn(2, cur.x, cur.y, held | ((S.dragMethod || 0) << 8)); else mHover(); }
  function mUp() {
    if (!held) return;
    var released = held;
    held = 0; nBtn(3, cur.x, cur.y, released); drawCursor(); publish('up'); mHover();
  }
  function mScroll(dx, dy) {
    if (!S.scrollOn) return;
    if (!dx && !dy) return;
    nScroll(dx, dy);
    publish('scroll');
  }
  function mClick(b) { mDown(b); setTimeout(mUp, 45); }

  // L/R buttons (trackpad)
  var btnHold = 0;   // number of on-screen L/R buttons currently pressed
  (function () {
    function mk(label, btn) {
      var b = el('button', 'lrb', label);
      var downId = null;
      b.addEventListener('pointerdown', function (e) {
        e.preventDefault();
        try { b.setPointerCapture(e.pointerId); } catch (x) { /* ignore */ }
        if (downId === null) btnHold++;
        downId = e.pointerId; b.className = 'lrb down'; mDown(btn);
      });
      var up = function () {
        b.className = 'lrb';
        if (downId !== null) { downId = null; if (btnHold > 0) btnHold--; }
        if (held === btn) mUp();
      };
      b.addEventListener('pointerup', up); b.addEventListener('pointercancel', up); b.addEventListener('lostpointercapture', up);
      return b;
    }
    lrBar.appendChild(mk('L', 1)); lrBar.appendChild(mk('R', 2));
    function mkScroll(label, dy) {
      var b = el('button', 'lrb', label);
      var timer = 0;
      function stop() {
        if (timer) { clearInterval(timer); timer = 0; }
        b.className = 'lrb';
      }
      b.addEventListener('pointerdown', function (e) {
        e.preventDefault();
        try { b.setPointerCapture(e.pointerId); } catch (x) { /* ignore */ }
        b.className = 'lrb down';
        mScroll(0, dy);
        timer = setInterval(function () { mScroll(0, dy); }, 90);
      });
      b.addEventListener('pointerup', stop);
      b.addEventListener('pointercancel', stop);
      b.addEventListener('lostpointercapture', stop);
      lrBar.appendChild(b);
    }
    mkScroll('▲', 1.0);
    mkScroll('▼', -1.0);
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
        if (Math.abs(sdx) + Math.abs(sdy) > 0) mScroll(-sdx * S.sens * 0.08, -sdy * S.sens * 0.08);
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
  ['touchstart', 'touchmove', 'touchend', 'touchcancel'].forEach(function (t) { window.addEventListener(t, onTouch, { capture: true, passive: false }); });
  ['pointerdown', 'pointermove', 'pointerup', 'pointercancel'].forEach(function (t) { window.addEventListener(t, onPointerBlock, true); });

  function applyMouse() {
    if (!S.mouseOn && held) mUp();
    tp.id = null;
    lrBar.style.display = (S.mouseOn && S.mouseMode === 'trackpad' && (S.lr || S.scrollOn)) ? 'flex' : 'none';
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
      var ev = new KeyboardEvent(down ? 'keydown' : 'keyup', { key: d.key, code: d.code, bubbles: true, cancelable: true, composed: true });
      try { Object.defineProperty(ev, 'keyCode', { get: function () { return d.kc; } }); Object.defineProperty(ev, 'which', { get: function () { return d.kc; } }); } catch (x) { /* ignore */ }
      (document.activeElement || document.body || document).dispatchEvent(ev);
    } catch (e) { /* ignore */ }
  }
  function sendKey(def, down) {
    var d = KD[def.k]; if (!d) return;
    if (S.keyMode === 'native' && B() && B().key) nKey(d.android, down); else synth(d, down);
  }
  function releaseAllKeys() {
    Object.keys(pressedKeys).forEach(function (pid) { sendKey(pressedKeys[pid].def, false); pressedKeys[pid].node.className = pressedKeys[pid].node.className.replace(' down', ''); });
    pressedKeys = {};
  }
  function placeKey(node, k) {
    var w = window.innerWidth, h = window.innerHeight;
    node.style.width = node.style.height = k.size + 'px';
    node.style.left = Math.max(0, Math.min(w - k.size, k.fx * w - k.size / 2)) + 'px';
    node.style.top = Math.max(0, Math.min(h - k.size, k.fy * h - k.size / 2)) + 'px';
  }
  function buildKeys() {
    releaseAllKeys();
    keysLayer.innerHTML = '';
    if (!S.keysOn) return;
    S.keys.forEach(function (k) {
      var d = KD[k.k]; if (!d) return;
      var n = el('div', 'kb' + (keysEdit ? ' edit' : ''), esc(d.label));
      n.style.opacity = S.keyOpacity;
      placeKey(n, k);
      var drag = null;
      n.addEventListener('pointerdown', function (e) {
        e.preventDefault();
        try { n.setPointerCapture(e.pointerId); } catch (x) { /* ignore */ }
        if (keysEdit) { drag = { id: e.pointerId }; return; }
        n.className = 'kb down';
        pressedKeys[e.pointerId] = { def: k, node: n };
        sendKey(k, true);
      });
      n.addEventListener('pointermove', function (e) {
        if (keysEdit && drag && e.pointerId === drag.id) {
          k.fx = e.clientX / window.innerWidth; k.fy = e.clientY / window.innerHeight; placeKey(n, k);
        }
      });
      var up = function (e) {
        if (keysEdit) { if (drag) { drag = null; saveS(); } return; }
        var pk = pressedKeys[e.pointerId];
        if (pk) { delete pressedKeys[e.pointerId]; n.className = 'kb'; sendKey(k, false); }
      };
      n.addEventListener('pointerup', up);
      n.addEventListener('pointercancel', up);
      n.addEventListener('lostpointercapture', up);
      keysLayer.appendChild(n);
    });
  }

  // ------------------------------------------------------------------ lifecycle
  window.addEventListener('resize', function () {
    placeFab(); clampCur(); drawCursor();
    var nodes = keysLayer.children;
    for (var i = 0; i < nodes.length && i < S.keys.length; i++) placeKey(nodes[i], S.keys[i]);
  });
  document.addEventListener('visibilitychange', function () { if (document.hidden) { releaseAllKeys(); mUp(); } });

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

  runPhase('start');
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', function () { runPhase('ready'); });
  else runPhase('ready');
  if (document.readyState === 'complete') runPhase('load');
  else window.addEventListener('load', function () { runPhase('load'); });
})();
