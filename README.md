# Overview
A demo of a multi-module commerce composite, featuring:
* Hello World resource ... of course
* Elasticsearch integration for product data
* Postmark integration for order confirmation emails
* Wishlist flows
* API stats resource showing version and last deployment time

![](docs/composable-commerce-demo-overview.png)

Modules *independently* contribute to the API and infrastructure:

![](docs/composable-commerce-demo-overview-modules.png)

## Tech Stack
* Terraform
* npm
* Node
* AWS Lambda
* AWS API Gateway
* Swagger
* Postman / Newman

## API
An empty project will simply create a slightly streamlined EPCC proxy:
```
/{store_id}/oauth
/{store_id}/products
/{store_id}/orders
etc.
```
This demo also adds:
```
/{store_id}/helloworld
/{store_id}/search/{resource_name}
/{store_id}/webhooks/search/{resource_name}
/{store_id}/webhooks/order
/_version
```
`{resource_name}` could be something like `products`, `orders`, `customers` etc., even though the minimal implementation provided here only indexes product data.

# Prerequisites
- Elasticsearch server with basic authentication
  - User and password must be Base64 encoded, e.g. like this: `echo -n user:passw0rd | base64`
- Postmark account
- AWS CLI installed and configured
- Terraform installed

# Usage
1. Edit configuration parameters in `config/config.json`
1. Run `npm install && npm run build && npm run deploy && npm run config`

Once everything is deployed and configured you can run an integration test to ensure everything is working as expected: `npm run integration-test`

Available commands:
```
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