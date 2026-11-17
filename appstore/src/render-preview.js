// Captures preview.html frame by frame and encodes the App Preview with ffmpeg.
// usage: NODE_PATH=<dir with puppeteer-core> node render-preview.js <frames dir> [stills]
const path = require('path');
const fs = require('fs');
const { execFileSync } = require('child_process');
const puppeteer = require('puppeteer-core');

const FPS = 30, DUR = 26;
const framesDir = process.argv[2];
const stills = process.argv[3] === 'stills';
const out = path.join(__dirname, '..', 'preview', 'app-preview-6.9.mp4');

(async () => {
  fs.mkdirSync(framesDir, { recursive: true });
  const browser = await puppeteer.launch({ executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome', headless: 'new', args: ['--allow-file-access-from-files'] });
  const page = await browser.newPage();
  await page.setViewport({ width: 443, height: 960, deviceScaleFactor: 2 });
  await page.goto('file://' + path.join(__dirname, 'preview.html'), { waitUntil: 'networkidle0' });
  await page.waitForSelector('body[data-ready="1"]');
  const times = stills ? [1.5, 4, 7, 9.5, 11.5, 14, 17, 21, 25] : Array.from({ length: FPS * DUR }, (_, i) => i / FPS);
  for (let i = 0; i < times.length; i++) {
    await page.evaluate((t) => window.render(t), times[i]);
    await page.screenshot({ path: path.join(framesDir, `f${String(i).padStart(4, '0')}.png`), clip: { x: 0, y: 0, width: 443, height: 960 } });
    if (i % 150 === 0) console.log('frame', i);
  }
  await browser.close();
  if (stills) return;
  fs.mkdirSync(path.dirname(out), { recursive: true });
  execFileSync('ffmpeg', ['-loglevel', 'error', '-y', '-framerate', String(FPS), '-i', path.join(framesDir, 'f%04d.png'),
    '-f', 'lavfi', '-i', 'anullsrc=channel_layout=stereo:sample_rate=44100',
    '-vf', 'scale=886:1920,format=yuv420p', '-c:v', 'libx264', '-profile:v', 'high', '-level', '4.0', '-r', String(FPS),
    '-b:v', '10M', '-maxrate', '12M', '-bufsize', '20M', '-c:a', 'aac', '-b:a', '256k', '-shortest', '-movflags', '+faststart', out]);
  console.log('wrote', out);
})();
