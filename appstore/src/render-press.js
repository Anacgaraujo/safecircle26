// Renders press.html to press/SafeCircle-3.0-press-release.pdf (+ PNG previews with "png" arg).
// usage: NODE_PATH=<dir with puppeteer-core> node render-press.js [png <outdir>]
const path = require('path');
const fs = require('fs');
const puppeteer = require('puppeteer-core');
(async () => {
  const browser = await puppeteer.launch({ executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome', headless: 'new', args: ['--allow-file-access-from-files'] });
  const page = await browser.newPage();
  await page.setViewport({ width: 816, height: 1056, deviceScaleFactor: 2 });
  await page.goto('file://' + path.join(__dirname, 'press.html'), { waitUntil: 'networkidle0' });
  await page.waitForSelector('body[data-ready="1"]');
  await new Promise((r) => setTimeout(r, 300));
  if (process.argv[2] === 'png') {
    const n = await page.$$eval('.page', (p) => p.length);
    for (let i = 0; i < n; i++) await page.screenshot({ path: path.join(process.argv[3], `p${i + 1}.png`), clip: { x: 0, y: i * 1056, width: 816, height: 1056 } });
  }
  const out = path.join(__dirname, '..', 'press', 'SafeCircle-3.0-press-release.pdf');
  fs.mkdirSync(path.dirname(out), { recursive: true });
  await page.pdf({ path: out, width: '8.5in', height: '11in', printBackground: true, preferCSSPageSize: true });
  console.log('wrote', out);
  await browser.close();
})();
