const { chromium } = require('playwright-core');

(async () => {
  console.log('[Example] Connecting to Chrome via CDP (http://localhost:9222)...');
  const browser = await chromium.connectOverCDP('http://localhost:9222');
  
  const context = browser.contexts()[0];
  const page = context.pages()[0] || await context.newPage();

  console.log('[Example] Navigating to Google...');
  await page.goto('https://www.google.com', { waitUntil: 'domcontentloaded' });
  console.log('[Example] Page title:', await page.title());

  console.log('[Example] Done!');
  await browser.close();
})();
