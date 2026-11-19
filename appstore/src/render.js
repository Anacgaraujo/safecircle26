// Renders the store images with headless Chrome.
// usage: NODE_PATH=<dir with puppeteer-core> node render.js [shots|header|search|one <shot> <device>]
const path = require('path');
const fs = require('fs');
const puppeteer = require('puppeteer-core');

const CHROME = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const SRC = __dirname;
const OUT = path.join(SRC, '..');

const SIZES = {
  'iphone-6.9': { w: 440, h: 956, dpr: 3, device: 'phone' },   // 1320 x 2868
  'iphone-6.5': { w: 428, h: 926, dpr: 3, device: 'phone' },   // 1284 x 2778
  'ipad-13': { w: 1032, h: 1376, dpr: 2, device: 'ipad' },     // 2064 x 2752
};

async function shoot(browser, url, w, h, dpr, out) {
  const page = await browser.newPage();
  await page.setViewport({ width: w, height: h, deviceScaleFactor: dpr });
  await page.goto(url, { waitUntil: 'networkidle0' });
  await page.waitForSelector('body[data-ready="1"]');
  await new Promise((r) => setTimeout(r, 150));
  fs.mkdirSync(path.dirname(out), { recursive: true });
  await page.screenshot({ path: out, type: 'png', clip: { x: 0, y: 0, width: w, height: h } });
  await page.close();
  console.log('wrote', path.relative(OUT, out));
}

(async () => {
  const [mode = 'shots', a, b] = process.argv.slice(2);
  const browser = await puppeteer.launch({ executablePath: CHROME, headless: 'new', args: ['--allow-file-access-from-files'] });
  const file = (f) => 'file://' + path.join(SRC, f);
  if (mode === 'one') {
    const s = SIZES[b || 'iphone-6.9'];
    await shoot(browser, `${file('shot.html')}?shot=${a}&device=${s.device}&w=${s.w}&h=${s.h}`, s.w, s.h, s.dpr, path.join(OUT, 'screenshots', b || 'iphone-6.9', `0${a}.png`));
  }
  if (mode === 'shots') {
    for (const [dir, s] of Object.entries(SIZES)) {
      for (let i = 1; i <= 6; i++) {
        await shoot(browser, `${file('shot.html')}?shot=${i}&device=${s.device}&w=${s.w}&h=${s.h}`, s.w, s.h, s.dpr, path.join(OUT, 'screenshots', dir, `0${i}.png`));
      }
    }
  }
  if (mode === 'header' || mode === 'shots') {
    await shoot(browser, file('header.html'), 1920, 1080, 1, path.join(OUT, 'header', 'header-1920x1080.png'));
    await shoot(browser, file('header.html') + '?clean=1', 1920, 1080, 1, path.join(OUT, 'header', 'event-card-1920x1080-no-text.png'));
  }
  if (mode === 'search' || mode === 'shots') {
    await shoot(browser, file('search.html'), 440, 560, 3, path.join(OUT, 'header', 'search-preview.png'));
  }
  await browser.close();
})();
