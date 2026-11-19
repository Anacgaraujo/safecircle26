// SafeCircle store-art kit: icons, a drawn map, and HTML recreations of the
// app's screens (colors, type and copy taken from lib/core/theme/sc_theme.dart
// and the presentation widgets). Every screen renders into a 393 x 852 box.
/* eslint-disable */
const C = {
  brand: '#EC13A4', brand2: '#E41B68', tint: '#FCE7F5', tint50: '#FDF2FB',
  purple: '#37207B', mauve: '#89617C', ink: '#181116', s900: '#0F172A',
  s600: '#475569', s500: '#64748B', s400: '#94A3B8', s300: '#CBD5E1',
  s200: '#E2E8F0', s100: '#F1F5F9', canvas: '#F8F6F7', green: '#10B981',
  green6: '#22C55E', green50: '#ECFDF5', red: '#EF4444', red50: '#FEF2F2',
  amber8: '#92400E', amber1: '#FEF3C7', map: '#F2EFE9',
};

const ICONS = {
  'map-pin': '<path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>',
  users: '<path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>',
  'chevron-down': '<polyline points="6 9 12 15 18 9"/>',
  'chevron-right': '<polyline points="9 18 15 12 9 6"/>',
  bell: '<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/>',
  navigation: '<polygon points="3 11 22 2 13 21 11 13 3 11"/>',
  battery: '<rect x="1" y="6" width="18" height="12" rx="2" ry="2"/><line x1="23" y1="13" x2="23" y2="11"/>',
  'phone-call': '<path d="M15.05 5A5 5 0 0 1 19 8.95M15.05 1A9 9 0 0 1 23 8.94m-1 7.98v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>',
  'message-circle': '<path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/>',
  map: '<polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"/><line x1="8" y1="2" x2="8" y2="18"/><line x1="16" y1="6" x2="16" y2="22"/>',
  shield: '<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>',
  user: '<path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>',
  plus: '<line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>',
  'alert-triangle': '<path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>',
  check: '<polyline points="20 6 9 17 4 12"/>',
  clock: '<circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>',
  'check-circle': '<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>',
  'log-out': '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>',
  'arrow-left': '<line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/>',
  delete: '<path d="M21 4H8l-7 8 7 8h13a2 2 0 0 0 2-2V6a2 2 0 0 0-2-2z"/><line x1="18" y1="9" x2="12" y2="15"/><line x1="12" y1="9" x2="18" y2="15"/>',
  'eye-off': '<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/>',
  home: '<path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>',
  briefcase: '<rect x="2" y="7" width="20" height="14" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>',
  book: '<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/>',
  activity: '<polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>',
  lock: '<rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>',
  x: '<line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>',
  bellRing: '<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/>',
};

function ic(name, size = 18, color = 'currentColor', sw = 2) {
  return `<svg width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="${color}" stroke-width="${sw}" stroke-linecap="round" stroke-linejoin="round" style="flex:none;display:block">${ICONS[name]}</svg>`;
}
const circlesIcon = (size, color) => `<svg width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="${color}" stroke-width="2" stroke-linecap="round" style="flex:none;display:block"><circle cx="9" cy="9" r="5.4"/><circle cx="15.6" cy="14.6" r="5.4"/></svg>`;

const PEOPLE = {
  you: { name: 'Jess Rivera', first: 'Jess' },
  maya: { name: 'Maya Chen', first: 'Maya' },
  leo: { name: 'Leo Rivera', first: 'Leo' },
  mom: { name: 'Mom', first: 'Mom' },
  alex: { name: 'Alex Morgan', first: 'Alex' },
  sam: { name: 'Sam Patel', first: 'Sam' },
};
const initials = (n) => n.split(' ').map((w) => w[0]).slice(0, 2).join('').toUpperCase();

function avatar(p, size, ring) {
  const r = ring ? `box-shadow:0 0 0 2.5px ${C.canvas},0 0 0 4.5px ${ring};` : '';
  return `<div style="width:${size}px;height:${size}px;border-radius:50%;background:${C.tint};color:${C.brand};display:flex;align-items:center;justify-content:center;font:800 ${size * 0.34}px Manrope;flex:none;${r}">${initials(p.name)}</div>`;
}

// ---------------------------------------------------------------- map
function rng(seed) { let s = seed >>> 0; return () => ((s = (s * 1664525 + 1013904223) >>> 0) / 4294967296); }

function mapSvg(w, h, o = {}) {
  const ox = o.ox || 0, oy = o.oy || 0;
  const cx = w / 2, cy = h / 2, R = Math.hypot(w, h);
  const step = 44;
  let minor = '', major = '', casing = '', parks = '', blocks = '';
  const rand = rng(o.seed || 7);
  for (let i = -Math.ceil(R / step); i <= Math.ceil(R / step); i++) {
    const x = cx + i * step - (ox % step);
    const isMajor = (i + 200) % 4 === 0;
    const line = `<line x1="${x}" y1="${cy - R}" x2="${x}" y2="${cy + R}"/>`;
    if (isMajor) { casing += line; major += line; } else minor += line;
  }
  for (let j = -Math.ceil(R / step); j <= Math.ceil(R / step); j++) {
    const y = cy + j * (step * 1.35) - (oy % (step * 1.35));
    const isMajor = (j + 200) % 3 === 0;
    const line = `<line x1="${cx - R}" y1="${y}" x2="${cx + R}" y2="${y}"/>`;
    if (isMajor) { casing += line; major += line; } else minor += line;
  }
  for (let k = 0; k < 40; k++) {
    const bx = cx + (Math.floor(rand() * 24) - 12) * step - (ox % step) + 5;
    const by = cy + (Math.floor(rand() * 20) - 10) * step * 1.35 - (oy % (step * 1.35)) + 5;
    blocks += `<rect x="${bx}" y="${by}" width="${step - 10}" height="${step * 1.35 - 10}" rx="3" fill="#E9E4DA"/>`;
  }
  const park = (gx, gy, gw, gh) => `<rect x="${cx + gx * step - (ox % step) + 4}" y="${cy + gy * step * 1.35 - (oy % (step * 1.35)) + 4}" width="${gw * step - 8}" height="${gh * step * 1.35 - 8}" rx="8" fill="#CFE8C3"/>`;
  parks = park(-5, -6, 3, 2) + park(2, 3, 2, 3) + park(-3, 5, 2, 1);
  const water = `<path d="M${w * 0.78} -20 C ${w * 0.7} ${h * 0.25}, ${w * 0.95} ${h * 0.4}, ${w * 0.86} ${h * 0.62} S ${w * 0.9} ${h * 0.95}, ${w + 40} ${h + 20} L ${w + 40} -20 Z" fill="#AAD3F2"/>`;
  const diag = `M ${-40} ${h * 0.86} L ${w + 40} ${h * 0.18}`;
  return `<svg width="${w}" height="${h}" viewBox="0 0 ${w} ${h}" style="position:absolute;inset:0;display:block">
    <rect width="${w}" height="${h}" fill="${C.map}"/>
    <g transform="rotate(-13 ${cx} ${cy})">
      ${blocks}${parks}
      <g stroke="#FFFFFF" stroke-width="7" stroke-linecap="square">${minor}</g>
      <g stroke="#E3DBCC" stroke-width="15">${casing}</g>
      <g stroke="#FFFFFF" stroke-width="12">${major}</g>
    </g>
    <path d="${diag}" stroke="#EBCB7E" stroke-width="16" fill="none"/>
    <path d="${diag}" stroke="#FFE7A6" stroke-width="12" fill="none"/>
    ${water}
    ${o.route || ''}
  </svg>`;
}

function memberPin(p, x, y, ring, { focused = false, low = '', scale } = {}) {
  const s = scale ?? (focused ? 1.15 : 0.9);
  const pulse = focused ? `<div style="position:absolute;left:50%;bottom:-4px;width:22px;height:22px;margin-left:-11px;border-radius:50%;background:${ring};opacity:.28"></div>` : '';
  const lowB = low ? `<div style="position:absolute;right:-6px;top:-4px;background:${C.red};border:2px solid #fff;border-radius:99px;padding:1px 5px;font:700 9.5px 'Roboto Mono';color:#fff">${low}</div>` : '';
  return `<div style="position:absolute;left:${x}px;top:${y}px;transform:translate(-50%,-100%) scale(${s});transform-origin:50% 100%;display:flex;flex-direction:column;align-items:center">
    <div style="position:relative;padding:3px;background:${ring};border-radius:50%;box-shadow:0 8px 18px -4px rgba(0,0,0,.35)">${avatar(p, 44)}${lowB}</div>
    <div style="width:0;height:0;border-left:4px solid transparent;border-right:4px solid transparent;border-top:12px solid ${ring}"></div>
    <div style="position:relative;width:10px;height:10px">${pulse}<div style="position:absolute;inset:0;border-radius:50%;background:${ring};border:2px solid #fff"></div></div>
  </div>`;
}

function geofence(x, y, r, label, icon = 'home') {
  return `<div style="position:absolute;left:${x - r}px;top:${y - r}px;width:${2 * r}px;height:${2 * r}px;border-radius:50%;background:rgba(236,19,164,.08);border:1.5px solid rgba(236,19,164,.35)"></div>
  <div style="position:absolute;left:${x}px;top:${y + r * 0.35}px;transform:translateX(-50%);display:flex;align-items:center;gap:5px;background:#fff;border-radius:99px;padding:4px 9px 4px 7px;box-shadow:0 2px 6px rgba(0,0,0,.12);font:800 11.5px Manrope;color:${C.ink}">${ic(icon, 12, C.brand, 2.4)}${label}</div>`;
}

// ---------------------------------------------------------------- chrome
function statusBar(dark = false) {
  const c = dark ? '#fff' : '#000';
  return `<div style="position:absolute;top:0;left:0;right:0;height:54px;display:flex;align-items:center;justify-content:space-between;padding:4px 34px 0 46px;z-index:50;pointer-events:none">
    <div style="font:600 17px -apple-system,'SF Pro Text',system-ui;color:${c};letter-spacing:-.2px">9:41</div>
    <div style="display:flex;gap:6px;align-items:center">
      <svg width="18" height="12" viewBox="0 0 18 12"><g fill="${c}"><rect x="0" y="8" width="3" height="4" rx="1"/><rect x="5" y="5.5" width="3" height="6.5" rx="1"/><rect x="10" y="3" width="3" height="9" rx="1"/><rect x="15" y="0" width="3" height="12" rx="1"/></g></svg>
      <svg width="16" height="12" viewBox="0 0 16 12"><path fill="${c}" d="M8 2.3c2.3 0 4.4.9 5.9 2.4l1.1-1.1A9.9 9.9 0 0 0 8 .7 9.9 9.9 0 0 0 1 3.6l1.1 1.1A8.3 8.3 0 0 1 8 2.3zm0 3.2c1.4 0 2.7.6 3.6 1.5l1.1-1.1A6.7 6.7 0 0 0 8 3.9a6.7 6.7 0 0 0-4.7 2l1.1 1.1c.9-.9 2.2-1.5 3.6-1.5zm0 3.2c.6 0 1.1.2 1.5.6L8 10.8 6.5 9.3c.4-.4.9-.6 1.5-.6z"/></svg>
      <svg width="27" height="13" viewBox="0 0 27 13"><rect x=".5" y=".5" width="23" height="12" rx="3.5" fill="none" stroke="${c}" opacity=".4"/><rect x="2" y="2" width="20" height="9" rx="2" fill="${c}"/><rect x="24.5" y="4.5" width="1.5" height="4" rx=".75" fill="${c}" opacity=".45"/></svg>
    </div></div>`;
}
const island = `<div style="position:absolute;top:11px;left:50%;margin-left:-62px;width:124px;height:36px;border-radius:20px;background:#000;z-index:60"></div>`;
const homeBar = (dark) => `<div style="position:absolute;bottom:8px;left:50%;margin-left:-67px;width:134px;height:5px;border-radius:3px;background:${dark ? '#fff' : '#000'};z-index:60"></div>`;

function bottomNav(active = 'home') {
  const tab = (key, label, icon) => {
    const on = key === active;
    const col = on ? C.brand : C.s400;
    return `<div style="flex:1;display:flex;flex-direction:column;align-items:center;gap:4px;padding:4px 0">${icon ? ic(icon, 24, col) : circlesIcon(24, col)}<div style="font:${on ? 800 : 600} 10px Manrope;color:${col};letter-spacing:.2px">${label}</div></div>`;
  };
  return `<div style="position:absolute;left:0;right:0;bottom:0;z-index:20">
    <div style="position:absolute;top:-16px;left:50%;margin-left:-30px;width:60px;height:60px;border-radius:50%;background:${C.ink};border:4px solid #fff;box-sizing:border-box;box-shadow:0 10px 26px rgba(0,0,0,.14);display:flex;align-items:center;justify-content:center;z-index:2">${ic('plus', 26, '#fff')}</div>
    <div style="background:#fff;border-top:1px solid ${C.s100};padding:10px 16px ${12 + 34}px;display:flex">
      <div style="flex:1;display:flex">${tab('home', 'Map', 'map')}${tab('circles', 'Circles')}</div><div style="width:72px"></div>
      <div style="flex:1;display:flex">${tab('emergency', 'Emergency', 'shield')}${tab('profile', 'Profile', 'user')}</div>
    </div></div>`;
}

const card = (inner, pad = 16, radius = 20, extra = '') => `<div style="background:#fff;border-radius:${radius}px;padding:${pad}px;box-shadow:0 0 0 1px ${C.s100},0 1px 2px rgba(0,0,0,.05);${extra}">${inner}</div>`;

function button(label, { variant = 'primary', icon, height = 56, full = true, rightIcon } = {}) {
  const v = {
    primary: [C.brand, '#fff', '0 10px 15px -3px rgba(236,19,164,.3),0 4px 6px -4px rgba(236,19,164,.3)'],
    secondary: [C.tint, C.brand, 'none'], danger: [C.red, '#fff', 'none'], ink: [C.ink, '#fff', 'none'],
  }[variant];
  return `<div style="height:${height}px;${full ? 'flex:1;' : 'padding:0 18px;'}border-radius:15px;background:${v[0]};color:${v[1]};box-shadow:${v[2]};display:flex;align-items:center;justify-content:center;gap:9px;font:800 ${height < 40 ? 14 : 16}px Manrope;white-space:nowrap">${icon ? ic(icon, 19, v[1]) : ''}${label}${rightIcon ? ic(rightIcon, 19, v[1]) : ''}</div>`;
}
const roundBtn = (icon, color = C.s900, dot = false) => `<div style="position:relative;width:44px;height:44px;border-radius:50%;background:#fff;box-shadow:0 0 0 1px ${C.s100},0 1px 2px rgba(0,0,0,.05);display:flex;align-items:center;justify-content:center">${ic(icon, 20, color)}${dot ? `<div style="position:absolute;top:10px;right:11px;width:9px;height:9px;border-radius:50%;background:${C.brand};border:2px solid #fff"></div>` : ''}</div>`;
const sectionLabel = (t, icon) => `<div style="display:flex;align-items:center;gap:7px;font:700 11px Manrope;letter-spacing:1px;color:${C.s400};text-transform:uppercase">${icon ? ic(icon, 13, C.s400) : ''}${t}</div>`;

// ---------------------------------------------------------------- screens
// Each returns inner HTML for a 393 x 852 screen. `t` (0..1) drives motion.

function memberCard(p, { me = false, chip, chipKind = 'safe', battery = 82, place, fresh = 'Live · updated just now', trips }) {
  const chipC = chipKind === 'moving' ? [C.brand2, C.tint] : [C.green6, C.green50];
  const ringC = chipKind === 'moving' ? C.brand : C.green6;
  return card(`
    <div style="display:flex;align-items:center;gap:12px">
      ${avatar(p, 52, ringC)}
      <div style="flex:1;min-width:0"><div style="font:800 18px Manrope;letter-spacing:-.3px;color:${C.s900}">${me ? 'You' : p.name}</div>
        <div style="margin-top:5px;display:inline-flex;align-items:center;gap:6px;background:${chipC[1]};border-radius:99px;padding:4px 9px"><div style="width:6px;height:6px;border-radius:50%;background:${chipC[0]}"></div><span style="font:700 12px Manrope;color:${chipC[0]}">${chip}</span></div></div>
      <div style="text-align:right;color:${C.s500}"><div style="display:flex;align-items:center;gap:5px">${ic('battery', 18, C.s500)}<span style="font:700 14px 'Roboto Mono'">${battery}%</span></div><div style="font:600 11px Manrope;margin-top:1px">Battery</div></div>
    </div>
    <div style="display:flex;align-items:center;gap:7px;margin-top:12px">${ic('map-pin', 15, C.brand)}<div style="font:700 14.5px Manrope;color:${C.s900};white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${place}</div></div>
    <div style="display:flex;align-items:center;gap:6px;margin-top:3px"><div style="width:6px;height:6px;border-radius:50%;background:${C.green}"></div><div style="font:600 12.5px Manrope;color:${C.s400}">${fresh}</div></div>
    <div style="margin-top:12px;background:${C.s100};border-radius:14px;padding:10px 12px;display:flex;align-items:center;gap:8px">${ic('navigation', 15, C.s500)}<div style="flex:1;font:700 12.5px Manrope;color:${C.s500}">Trip history · ${trips}</div>${ic('chevron-right', 16, C.brand)}</div>
    <div style="display:flex;gap:10px;margin-top:12px">${button('Call', { icon: 'phone-call', height: 46 })}${button('Message', { variant: 'secondary', icon: 'message-circle', height: 46 })}</div>
  `, 16, 20);
}

function screenMap(o = {}) {
  const w = o.w || 393, h = o.h || 852;
  const t = o.t ?? 0;
  const panX = o.panX || 0, panY = o.panY || 0;
  const mx = (x) => x - panX, my = (y) => y - panY;
  const cardW = Math.min(w - 28 - 10, 420);
  const focus = o.focus ?? 0;
  const cards = [
    memberCard(PEOPLE.maya, { chip: 'At place since 6:12 PM', place: 'Home · 24th St & Valencia', trips: '3 trips · 4.2 mi today', battery: 82 }),
    memberCard(PEOPLE.leo, { chip: 'Moving · 12 mph', chipKind: 'moving', place: 'Mission St near 16th St', trips: '2 trips · 6.8 mi today', battery: 64 }),
    memberCard(PEOPLE.mom, { chip: 'At place since 9:05 AM', place: 'Work · Market St', trips: '1 trip · 3.1 mi today', battery: 91 }),
  ];
  const slide = o.slide ?? focus; // fractional page position
  const pins = [
    memberPin(PEOPLE.maya, mx(w * 0.36), my(318), C.green, { focused: Math.round(slide) === 0 }),
    memberPin(PEOPLE.leo, mx(w * 0.7), my(222), C.brand, { focused: Math.round(slide) === 1 }),
    memberPin(PEOPLE.you, mx(w * 0.2), my(178), C.ink, {}),
  ];
  return `<div style="position:absolute;inset:0;overflow:hidden;background:${C.map}">
    <div style="position:absolute;left:${-panX - 100}px;top:${-panY - 100}px;width:${w + 200}px;height:${h + 200}px">${mapSvg(w + 200, h + 200, { seed: 11 })}</div>
    ${geofence(mx(w * 0.36), my(306), 58, 'Home')}
    ${geofence(mx(w * 0.8), my(330), 40, 'School', 'book')}
    ${pins.join('')}
    <div style="position:absolute;top:64px;left:16px;right:16px;display:flex;gap:8px;align-items:center">
      <div style="flex:1;display:flex"><div style="height:44px;background:#fff;border-radius:99px;box-shadow:0 0 0 1px ${C.s100},0 1px 2px rgba(0,0,0,.05);display:flex;align-items:center;padding:0 12px 0 7px;gap:9px">
        <div style="width:30px;height:30px;border-radius:50%;background:${C.tint};display:flex;align-items:center;justify-content:center">${ic('users', 16, C.brand)}</div>
        <div style="font:800 15px Manrope;color:${C.s900}">Family</div>${ic('chevron-down', 18, C.s400)}</div></div>
      ${roundBtn('map-pin')}${roundBtn('bell', C.s900, true)}
    </div>
    <div style="position:absolute;left:0;right:0;bottom:${o.navH ?? 92}px;z-index:5">
      <div style="display:flex;gap:10px;padding:0 20px 10px;align-items:center">
        <div style="flex:1;height:44px;border-radius:99px;background:${C.ink};color:#fff;display:flex;align-items:center;gap:9px;padding:0 16px;font:800 14px Manrope;box-shadow:0 10px 26px rgba(0,0,0,.14)">${ic('navigation', 16, '#fff')}<span style="flex:1">1 friend on a journey</span>${ic('chevron-right', 17, '#fff')}</div>
        ${roundBtn('navigation', C.brand)}
      </div>
      <div style="background:${C.canvas};border-radius:26px 26px 0 0;box-shadow:0 -8px 30px rgba(0,0,0,.12);padding:10px 0 14px">
        <div style="width:40px;height:5px;border-radius:3px;background:${C.s200};margin:0 auto 12px"></div>
        <div style="overflow:hidden"><div style="display:flex;gap:10px;padding-left:20px;transform:translateX(${-slide * (cardW + 10)}px)">${cards.map((c) => `<div style="width:${cardW}px;flex:none">${c}</div>`).join('')}</div></div>
        <div style="display:flex;justify-content:center;gap:5px;margin-top:10px">${[0, 1, 2].map((i) => `<div style="height:6px;border-radius:3px;width:${Math.round(slide) === i ? 18 : 6}px;background:${Math.round(slide) === i ? C.brand : C.s200}"></div>`).join('')}</div>
      </div>
    </div>
    ${bottomNav('home')}
  </div>`;
}

function checkRow(label, sub, state, place) {
  const icons = {
    done: [C.green50, ic('check', 18, C.green)], due: [C.amber1, ic('bell', 17, C.amber8)],
    next: [C.tint, `<div style="width:9px;height:9px;border-radius:50%;background:${C.brand}"></div>`],
    future: [C.s100, `<div style="width:8px;height:8px;border-radius:50%;background:${C.s200}"></div>`],
  }[state];
  const right = {
    done: `<div style="display:flex;align-items:center;gap:5px;font:700 13px Manrope;color:${C.green}">${ic('check-circle', 15, C.green)}Confirmed</div>`,
    due: button('Confirm', { full: false, height: 36 }),
    next: `<div style="font:800 14px Manrope;color:${C.brand}">Confirm</div>`,
    future: `<div style="font:600 12.5px Manrope;color:${C.s400}">Upcoming</div>`,
  }[state];
  const lc = state === 'done' ? C.s500 : state === 'future' ? C.s400 : C.ink;
  const sc = state === 'due' ? C.amber8 : C.s400;
  return `<div style="display:flex;align-items:center;gap:14px;padding:13px 0;border-bottom:1px solid ${C.s100}">
    <div style="width:34px;height:34px;border-radius:50%;background:${icons[0]};display:flex;align-items:center;justify-content:center;flex:none">${icons[1]}</div>
    <div style="flex:1;min-width:0"><div style="font:700 15px Manrope;color:${lc}">${label}</div><div style="font:500 12.5px 'Roboto Mono';color:${sc};margin-top:1px">${sub}</div>
    ${place ? `<div style="display:flex;align-items:center;gap:4px;margin-top:2px">${ic('map-pin', 12, C.green)}<span style="font:500 12px Manrope;color:${C.s500}">${place}</span></div>` : ''}</div>${right}</div>`;
}

function screenJourney(o = {}) {
  const w = o.w || 393, h = o.h || 852;
  const mapH = Math.round(h * 0.44);
  const due = o.due ?? true;
  const confirmed2 = o.confirmed2 ?? false;
  const route = `<path d="M ${w * 0.18 + 100} ${mapH * 0.95 + 100} C ${w * 0.3 + 100} ${mapH * 0.7 + 100}, ${w * 0.35 + 100} ${mapH * 0.62 + 100}, ${w * 0.52 + 100} ${mapH * 0.5 + 100}" stroke="#fff" stroke-width="9" fill="none" stroke-linecap="round"/><path d="M ${w * 0.18 + 100} ${mapH * 0.95 + 100} C ${w * 0.3 + 100} ${mapH * 0.7 + 100}, ${w * 0.35 + 100} ${mapH * 0.62 + 100}, ${w * 0.52 + 100} ${mapH * 0.5 + 100}" stroke="${C.brand}" stroke-width="5" fill="none" stroke-linecap="round"/>`;
  const status = confirmed2 ? [C.green, 'Journey active · Valencia St', C.s500] : due ? [C.amber8, 'Check-in due now', C.amber8] : [C.green, 'Journey active · Valencia St', C.s500];
  const rows = [
    checkRow('Leaving the bar', 'Today · 10:30 PM', 'done', '16th St & Valencia'),
    confirmed2 ? checkRow('Walking home', 'Today · 11:15 PM', 'done', 'Valencia St & 21st St') : checkRow('Walking home', due ? '11:15 PM · Due now' : 'Today · 11:15 PM', due ? 'due' : 'next'),
    checkRow('Check-out', 'Today · 11:45 PM', confirmed2 ? 'next' : 'future'),
  ];
  const banner = due && !confirmed2 ? `<div style="margin-top:16px;margin-bottom:14px;background:${C.amber1};border:1px solid rgba(146,64,14,.35);border-radius:14px;padding:12px 14px;display:flex;align-items:center;gap:12px">${ic('bell', 22, C.amber8)}
      <div style="flex:1"><div style="font:800 14.5px/18px Manrope;color:${C.amber8}">Check-in due — are you safe?</div><div style="font:500 12.5px/16px Manrope;color:${C.s500};margin-top:2px">Confirm within 5 min or your circle will be alerted.</div></div>${button('Confirm', { full: false, height: 38 })}</div>` : '<div style="height:22px"></div>';
  return `<div style="position:absolute;inset:0;background:${C.canvas};overflow:hidden">
    <div style="position:absolute;left:0;right:0;top:0;height:${mapH}px;overflow:hidden">
      <div style="position:absolute;left:-100px;top:-100px">${mapSvg(w + 200, mapH + 200, { seed: 3, ox: 20, oy: 30, route })}</div>
      ${memberPin(PEOPLE.you, w * 0.52, mapH * 0.5, C.ink, { focused: true })}
      <div style="position:absolute;inset:0;background:linear-gradient(to bottom,rgba(248,246,247,0) 72%,${C.canvas})"></div>
      <div style="position:absolute;top:70px;left:50%;transform:translateX(-50%);background:rgba(255,255,255,.92);border-radius:99px;padding:6px 12px;display:flex;align-items:center;gap:6px;box-shadow:0 2px 6px rgba(0,0,0,.08);white-space:nowrap"><div style="width:7px;height:7px;border-radius:50%;background:${status[0]}"></div><span style="font:700 12px Manrope;color:${status[2]}">${status[1]}</span></div>
    </div>
    <div style="position:absolute;left:0;right:0;top:${mapH - 68}px;bottom:0;background:${C.canvas};border-radius:26px 26px 0 0;box-shadow:0 -8px 30px rgba(0,0,0,.12);padding:10px 24px 50px;display:flex;flex-direction:column">
      <div style="width:40px;height:5px;border-radius:3px;background:${C.s200};margin:0 auto 16px"></div>
      <div style="display:flex;align-items:center;gap:9px"><span style="font:500 14px Manrope;color:${C.s400}">Circle:</span><span style="flex:1;font:800 17px Manrope;color:${C.ink}">Night out</span>
        <div style="display:flex">${[PEOPLE.maya, PEOPLE.alex, PEOPLE.mom].map((p, i) => `<div style="margin-left:${i ? -6 : 0}px;border:2px solid ${C.canvas};border-radius:50%">${avatar(p, 28)}</div>`).join('')}</div></div>
      ${banner}
      ${sectionLabel('Check-ins', 'clock')}<div style="height:12px"></div>
      <div style="flex:1">${rows.join('')}</div>
      <div style="display:flex">${button('Get me out of here', { variant: 'danger', icon: 'log-out' })}</div>
      <div style="display:flex;align-items:center;justify-content:center;gap:8px;margin-top:14px;font:700 15px Manrope;color:${C.s500}">${ic('message-circle', 18, C.s500)}Messages</div>
    </div></div>`;
}

function pinBoxes(n, err) {
  const acc = err ? C.red : C.brand;
  return `<div style="display:flex;gap:14px;justify-content:center">${[0, 1, 2, 3].map((i) => `<div style="width:56px;height:64px;border-radius:16px;background:#fff;box-shadow:0 0 0 1px ${C.s100},0 1px 2px rgba(0,0,0,.05);${i === n ? `border:2px solid ${acc};` : ''}box-sizing:border-box;display:flex;align-items:center;justify-content:center">${i < n ? `<div style="width:15px;height:15px;border-radius:50%;background:${acc}"></div>` : ''}</div>`).join('')}</div>`;
}
function keypad(pressed) {
  const k = (d) => `<div style="width:76px;height:76px;border-radius:50%;background:${pressed === d ? C.tint : '#fff'};box-shadow:0 0 0 1px ${C.s100},0 1px 2px rgba(0,0,0,.05);display:flex;align-items:center;justify-content:center;font:800 30px Manrope;color:${pressed === d ? C.brand : C.s900}">${d}</div>`;
  const rows = [['1', '2', '3'], ['4', '5', '6'], ['7', '8', '9']];
  return `<div style="display:flex;flex-direction:column;gap:16px;align-items:center">${rows.map((r) => `<div style="display:flex;gap:26px">${r.map(k).join('')}</div>`).join('')}
    <div style="display:flex;gap:26px"><div style="width:76px"></div>${k('0')}<div style="width:76px;height:76px;display:flex;align-items:center;justify-content:center">${ic('delete', 26, C.s500)}</div></div></div>`;
}
function screenPin(o = {}) {
  const n = o.n ?? 3;
  return `<div style="position:absolute;inset:0;background:${C.canvas};padding:62px 26px 60px;display:flex;flex-direction:column;align-items:center">
    <div style="align-self:flex-start;padding:8px">${ic('arrow-left', 22, C.s500)}</div>
    <div style="margin-top:14px;font:800 26px/32px Manrope;letter-spacing:-.5px;color:${C.ink};text-align:center">Confirm your check-in</div>
    <div style="margin-top:8px;font:600 15px Manrope;color:${C.mauve}">Walking home · <span style="font:500 14px 'Roboto Mono';color:${C.brand}">Today · 11:15 PM</span></div>
    <div style="height:34px"></div>${pinBoxes(n)}
    <div style="flex:1"></div>${keypad(o.pressed)}
  </div>`;
}

function screenSos(o = {}) {
  const p = o.progress ?? 0.68;
  const holding = p > 0;
  const R = 127, L = 2 * Math.PI * R;
  const halo = holding ? [1.7, 2.1].map((s, i) => { const k = ((o.haloT ?? 0.4) + i * 0.5) % 1; return `<div style="position:absolute;left:26px;top:26px;width:212px;height:212px;border-radius:50%;background:rgba(239,68,68,${(i ? 0.12 : 0.16) * (1 - k)});transform:scale(${1 + (s - 1) * k})"></div>`; }).join('') : '';
  const caption = p >= 0.99 ? 'SENDING…' : holding ? 'KEEP HOLDING…' : 'HOLD TO ALERT';
  const chips = [PEOPLE.mom, PEOPLE.alex, PEOPLE.sam].map((c) => `<div style="display:flex;align-items:center;gap:9px;background:#fff;border-radius:99px;padding:7px 13px 7px 7px;box-shadow:0 0 0 1px ${C.s100},0 1px 2px rgba(0,0,0,.05)">${avatar(c, 30)}<span style="font:700 14px Manrope;color:${C.s900}">${c.first}</span></div>`).join('');
  return `<div style="position:absolute;inset:0;background:radial-gradient(150% 100% at 50% -5%,#FFE3EC 0%,#FBEEF2 42%,${C.canvas} 100%);overflow:hidden">
    <div style="position:absolute;top:62px;left:26px;display:flex;align-items:center;gap:10px"><div style="width:34px;height:34px;border-radius:11px;background:${C.red50};display:flex;align-items:center;justify-content:center">${ic('alert-triangle', 19, C.red)}</div><div style="font:800 24px/28px Manrope;letter-spacing:-.5px;color:${C.ink}">Emergency SOS</div></div>
    <div style="position:absolute;left:26px;right:26px;top:110px;bottom:100px;display:flex;flex-direction:column;align-items:center;justify-content:center">
      <div style="position:relative;width:264px;height:264px;flex:none">${halo}
        <svg width="264" height="264" style="position:absolute;inset:0"><circle cx="132" cy="132" r="${R}" fill="none" stroke="rgba(214,31,70,.14)" stroke-width="10"/>${p > 0 ? `<circle cx="132" cy="132" r="${R}" fill="none" stroke="#EF2B57" stroke-width="10" stroke-linecap="round" stroke-dasharray="${L * p} ${L}" transform="rotate(-90 132 132)"/>` : ''}</svg>
        <div style="position:absolute;left:26px;top:26px;width:212px;height:212px;border-radius:50%;background:radial-gradient(circle at 50% 34%,#FF3D6E 0%,#EF2B57 46%,#D61F46 100%);box-shadow:0 0 0 12px rgba(239,68,68,.10),0 22px 42px -10px rgba(214,31,70,.55);transform:scale(${holding ? 0.96 : 1});display:flex;flex-direction:column;align-items:center;justify-content:center">
          <div style="font:700 46px 'Roboto Mono';letter-spacing:2.7px;color:#fff">SOS</div><div style="margin-top:6px;font:800 13px Manrope;letter-spacing:2px;color:rgba(255,255,255,.95)">${caption}</div></div>
      </div>
      <div style="margin-top:12px;width:300px;text-align:center;font:500 14.5px/21px Manrope;color:${C.mauve}">This alerts your circle in the app and texts your circle and emergency contacts your location.</div>
      <div style="align-self:stretch;margin-top:20px">${sectionLabel('Your emergency contacts · 3', 'users')}</div>
      <div style="align-self:stretch;display:flex;gap:8px;margin-top:11px">${chips}</div>
    </div>
    ${bottomNav('emergency')}
  </div>`;
}

function screenSent(o = {}) {
  const shown = o.shown ?? 3;
  const row = (p, i) => `<div style="opacity:${i < shown ? 1 : 0};transform:translateY(${i < shown ? 0 : 8}px);margin-bottom:10px">${card(`<div style="display:flex;align-items:center;gap:13px">${avatar(p, 42)}<div style="flex:1"><div style="font:700 15.5px Manrope;color:${C.s900}">${p.name}</div><div style="display:flex;align-items:center;gap:6px;margin-top:3px">${ic('check', 13, C.green)}<span style="font:600 12.5px Manrope;color:${C.s500}">Call or text to make sure</span></div></div><div style="display:flex;gap:18px;padding-right:6px">${ic('phone-call', 16, C.s400)}${ic('message-circle', 16, C.s400)}</div></div>`, 12, 20)}</div>`;
  return `<div style="position:absolute;inset:0;background:${C.canvas};display:flex;flex-direction:column">
    <div style="flex:1;padding:82px 26px 0">
      <div style="margin:0 auto;width:72px;height:72px;border-radius:50%;background:${C.green50};box-shadow:0 8px 20px -6px rgba(16,185,129,.45);display:flex;align-items:center;justify-content:center;transform:scale(${o.pop ?? 1})">${ic('check', 34, C.green)}</div>
      <div style="margin-top:16px;text-align:center;font:800 26px/31px Manrope;letter-spacing:-.6px;color:${C.ink}">Alert sent</div>
      <div style="margin-top:8px;display:flex;justify-content:center;align-items:center;gap:7px;font:600 13.5px Manrope;color:${C.mauve}">${ic('clock', 14, C.mauve)}11:42 PM · just now</div>
      <div style="margin-top:22px">${card(`<div style="display:flex;align-items:center;gap:12px"><div style="width:40px;height:40px;border-radius:12px;background:${C.tint};display:flex;align-items:center;justify-content:center">${ic('map-pin', 20, C.brand)}</div><div style="flex:1"><div style="font:700 14.5px Manrope;color:${C.ink}">Location shared</div><div style="font:500 12px 'Roboto Mono';color:${C.s400};margin-top:2px">Valencia St & 21st St</div></div><div style="display:flex;align-items:center;gap:6px"><div style="width:7px;height:7px;border-radius:50%;background:${C.green}"></div><span style="font:700 11.5px Manrope;color:${C.green}">Live</span></div></div>`, 13, 20)}</div>
      <div style="margin-top:24px;margin-bottom:12px">${sectionLabel('Alerted in the app · 3 people', 'users')}</div>
      ${[PEOPLE.mom, PEOPLE.alex, PEOPLE.sam].map(row).join('')}
    </div>
    <div style="background:#fff;box-shadow:0 -6px 22px rgba(0,0,0,.06);padding:14px 26px 40px">
      <div style="display:flex">${button('Text my location to contacts', { variant: 'secondary', icon: 'message-circle', height: 54 })}</div>
      <div style="display:flex;margin-top:10px">${button('Also call 911', { variant: 'ink', icon: 'phone-call', height: 54 })}</div>
      <div style="display:flex;justify-content:center;align-items:center;gap:6px;margin-top:14px;font:700 14px Manrope;color:${C.red}">${ic('x', 16, C.red)}Cancel alert — I'm safe</div>
    </div></div>`;
}

function placeCard(name, addr, icon, rule, watchers, on = true) {
  return card(`<div style="display:flex;align-items:center;gap:12px"><div style="width:44px;height:44px;border-radius:12px;background:${C.tint};display:flex;align-items:center;justify-content:center">${ic(icon, 20, C.brand)}</div>
    <div style="flex:1;min-width:0"><div style="font:800 16px Manrope;color:${C.s900}">${name}</div><div style="font:600 12.5px Manrope;color:${C.s400};margin-top:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${addr}</div></div>
    <div style="width:52px;height:32px;border-radius:16px;background:${on ? C.brand : C.s200};position:relative;flex:none"><div style="position:absolute;top:4px;${on ? 'right:4px' : 'left:4px'};width:24px;height:24px;border-radius:50%;background:#fff"></div></div></div>
    <div style="height:1px;background:${C.s100};margin:12px 0 10px"></div>
    <div style="display:flex;align-items:center"><div style="flex:1;font:700 12.5px Manrope;color:${C.s500}">${rule}</div><div style="display:flex">${watchers.map((p, i) => `<div style="margin-left:-6px;border:2px solid #fff;border-radius:50%">${avatar(p, 24)}</div>`).join('')}</div></div>`, 14, 18);
}
function screenPlaces(o = {}) {
  const show = o.show ?? 4;
  const items = [
    placeCard('Home', '24th St & Valencia · 330 ft', 'home', 'Alert on arrive & leave', [PEOPLE.maya, PEOPLE.leo, PEOPLE.mom]),
    placeCard('School', 'Mission High School · 490 ft', 'book', 'Alert on arrive & leave', [PEOPLE.leo]),
    placeCard('Work', 'Market St · 330 ft', 'briefcase', 'Alert on arrive', [PEOPLE.mom, PEOPLE.you]),
    placeCard('Gym', 'Folsom St · 160 ft', 'activity', 'Alert on leave', [PEOPLE.maya]),
  ];
  return `<div style="position:absolute;inset:0;background:${C.canvas};padding:62px 20px 0">
    <div style="padding:8px 0">${ic('arrow-left', 22, C.s500)}</div>
    <div style="margin-top:8px;font:800 30px/38px Manrope;letter-spacing:-.6px;color:${C.ink}">Places</div>
    <div style="margin-top:6px;font:500 15px/22px Manrope;color:${C.mauve}">Your circle gets an alert when someone arrives at or leaves these places.</div>
    <div style="margin-top:20px;display:flex;flex-direction:column;gap:12px">${items.map((h, i) => `<div style="opacity:${i < show ? 1 : 0};transform:translateY(${i < show ? 0 : 14}px)">${h}</div>`).join('')}</div>
    <div style="position:absolute;left:20px;right:20px;bottom:44px;display:flex">${button('Add Place', { icon: 'plus' })}</div>
  </div>`;
}

const SCREENS = { map: screenMap, journey: screenJourney, pin: screenPin, sos: screenSos, sent: screenSent, places: screenPlaces };

// wraps a screen with status bar, island and home indicator
function phoneScreen(name, opts = {}, w = 393, h = 852) {
  return `<div style="position:relative;width:${w}px;height:${h}px;overflow:hidden;background:${C.canvas}">${SCREENS[name]({ ...opts, w, h })}${statusBar()}${island}${homeBar()}</div>`;
}

// ---------------------------------------------------------------- overlays
function notif(title, body, time = 'now', w = 340) {
  return `<div style="width:${w}px;border-radius:22px;background:rgba(255,255,255,.94);backdrop-filter:blur(20px);box-shadow:0 18px 40px -10px rgba(24,17,22,.35);padding:13px 15px;display:flex;gap:11px;align-items:center;box-sizing:border-box">
    <img src="icon.png" style="width:38px;height:38px;border-radius:9px;flex:none">
    <div style="flex:1;min-width:0"><div style="display:flex;justify-content:space-between;font:700 14px -apple-system,system-ui;color:#111"><span>${title}</span><span style="font-weight:400;color:#8a8a8e;font-size:13px">${time}</span></div>
    <div style="font:400 14px/18px -apple-system,system-ui;color:#222;margin-top:2px">${body}</div></div></div>`;
}
function smsBubble(text, w = 330) {
  return `<div style="width:${w}px;box-sizing:border-box;border-radius:22px;background:#fff;box-shadow:0 18px 40px -10px rgba(24,17,22,.35);padding:12px 14px 14px">
    <div style="display:flex;align-items:center;gap:8px;font:600 12px -apple-system,system-ui;color:#8a8a8e;margin-bottom:8px">${ic('message-circle', 14, '#34C759', 2.4)}TEXT MESSAGE · to Mom</div>
    <div style="background:#E9E9EB;border-radius:18px;padding:10px 13px;font:400 14.5px/19px -apple-system,system-ui;color:#000">${text}</div></div>`;
}
function pill(iconName, text, bg = '#fff', fg = C.ink, ic2 = C.brand) {
  return `<div style="display:inline-flex;align-items:center;gap:9px;background:${bg};border-radius:99px;padding:11px 16px 11px 12px;box-shadow:0 14px 30px -10px rgba(24,17,22,.35);font:800 15px Manrope;color:${fg};white-space:nowrap">${ic(iconName, 18, ic2, 2.4)}${text}</div>`;
}

if (typeof module !== 'undefined') module.exports = {};
