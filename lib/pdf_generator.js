const puppeteer = require('puppeteer');
const fs = require('fs');
const crypto = require('crypto');
const path = require('path');
(async () => {    
    const filename = path.join(path.dirname(__filename), 'tmp', crypto.randomBytes(40).toString('hex')+ '.pdf');
    const browser = await puppeteer.launch();
    try{
	const params = {...JSON.parse(Buffer.from(process.argv.slice(2)[0], 'base64').toString('utf-8')), ...{path: filename}};	
	const page = await browser.newPage();
	await page.goto(params.url);
	await page.pdf(params);
	console.log(Buffer.from(fs.readFileSync(filename, 'binary'), 'binary').toString('base64'))	
    }
    catch(e){
	console.error(e)
	process.exit(1);
    }
    finally{
	fs.unlinkSync(filename)
	await browser.close();
	process.exit(0);
    }
})();
