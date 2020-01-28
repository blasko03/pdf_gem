const puppeteer = require('puppeteer');
const fs = require('fs');
const crypto = require('crypto');
const path = require('path');

(async () => {

    var stdinBuffer = fs.readFileSync(0);
    const filename = path.join(path.dirname(__filename), 'tmp', crypto.randomBytes(40).toString('hex')+ '.pdf');
    const browser = await puppeteer.launch();
    try{
	const params = {...JSON.parse(Buffer.from(stdinBuffer.toString(), 'base64').toString('utf-8')), ...{path: filename}};	
	const page = await browser.newPage();
	await page.goto(params.url, {waitUntil: 'networkidle2', timeout: (params.timeout == null ? 30000 : params.timeout)});
	await page.pdf(params);
	process.stdout.write(filename)
    }
    catch(e){
	console.error(e)
	process.exit(1);
    }
    finally{
	await browser.close();
	process.exit(0);
    }
})();
