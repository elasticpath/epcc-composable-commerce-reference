const fs = require('fs');
const config = JSON.parse(fs.readFileSync(process.argv[2]).toString());
const tfstate = JSON.parse(fs.readFileSync(process.argv[3]).toString());
// TODO: automatically generate from config.json contents, then add APIGW
fs.writeFileSync(process.argv[4], JSON.stringify(
	{
		"id": "4a95e040-epcc-41cc-9a21-0877fa72epcc",
		"name": "EPCC",
		"values": [
			{
				"key": "client_id",
				"value": config.epcc_client_id,
				"enabled": true
			},
			{
				"key": "client_secret",
				"value": config.epcc_client_secret,
				"enabled": true
			},
			{
				"key": "APIGW",
				"value": tfstate.outputs.api_endpoint.value + "/" + config.epcc_store_id,
				"enabled": true
			},
			{
				"key": "store_id",
				"value": config.epcc_store_id,
				"enabled": true
			}
		],
		"_postman_variable_scope": "environment"
	}, null, "  "));