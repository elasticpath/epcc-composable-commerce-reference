# Overview
A demo of a multi-module commerce composite, featuring:
* Elasticsearch integration for product data
* API stats resource showing version and last deployment time

[IMAGE]

Modules *independently* contribute to the API and infrastructure:

[IMAGE]

## Tech Stack
* **AWS:** Hosting
  * AWS Lambda
  * AWS API Gateway
* **Terraform**: Infrastructure
* **npm**: Project structure and build script
* **Node.js**: Lambda Functions
* **Postman / Newman:** Configuration and integration tests

## API
This project provides the following API:
```
/_version
/{store_id}/search/{resource_name}
/{store_id}/webhooks/search/{resource_name}
/{store_id}/oauth
/{store_id}/products
/{store_id}/orders
etc.
```
`{resource_name}` indicates a generic integration pattern; in this case only `products` are supported since the minimal implementation provided here only indexes product data. However, this can easily be extended to support other EPCC data such as categories, customers, orders etc.

# Prerequisites
- AWS CLI 2.0.26 or later installed and configured
- Terraform 0.13.2 or later
- Elasticsearch server with basic authentication (user and password must be Base64 encoded, e.g. like this: `echo -n user:passw0rd | base64`)

# Usage
1. Edit configuration parameters in `config/config.json`
1. Run `npm install && npm run start`

`npm run start` will build the project, deploy infrastructure such as API gateway and Lambda functions into AWS, and configure EPCC with the appropriate integration webhook URL. (`npm run start` is equivalent to the command `npm run build && npm run deploy && npm run config`.)

Once everything is deployed and configured you can start the included integration test to ensure everything is working as expected: `npm run integration-test`

Available commands:
```
npm run start
npm run test
npm run build       
npm run deploy
npm run config
npm run integration-test
npm run undeploy
npm run clean
```

## Output
```
api_endpoint: https://{apigw_id_etc}.amazonaws.com/dev/{epcc_store_id}
```