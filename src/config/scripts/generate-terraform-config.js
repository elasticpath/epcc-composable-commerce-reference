const fs = require('fs');
const config = JSON.parse(fs.readFileSync(process.argv[2]).toString());

var fileContents = "";
for (const [key, value] of Object.entries(config)) {
    fileContents += `variable ${key} {\n`;
    fileContents += `  default = "${value}"\n`;
    fileContents += `}\n`
}

fs.writeFileSync(process.argv[3], fileContents);