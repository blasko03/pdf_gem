const puppeteer = require('puppeteer');
const fs = require('fs');
const crypto = require('crypto');
const path = require('path');

(async () => {

    var stdinBuffer = fs.readFileSync(0);

    var tmp = path.join(path.dirname(__filename), 'tmp');

    if (!fs.existsSync(tmp)){
	fs.mkdirSync(tmp);
    }
    
    const filename = path.join(tmp, crypto.randomBytes(40).toString('hex')+ '.pdf');
    const browser = await puppeteer.launch({  headless: true,args: [ '--no-sandbox']});
    try{
	const params = {...JSON.parse(Buffer.from(stdinBuffer.toString(), 'base64').toString('utf-8')), ...{path: filename}};	
	const page = await browser.newPage();
	if(params.cookies != null){
	    for(var i = 0; i<params.cookies.length; i++)
		await page.setCookie(params.cookies[i])
	}
	
	await page.goto(params.url, {waitUntil: (params.waitUntil != null ? params.waitUntil : 'load'), timeout: (params.timeout == null ? 30000 : params.timeout)});
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
