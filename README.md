<img src="https://www.elasticpath.com/themes/custom/bootstrap_sass/logo.svg" alt="" width="400" />

# Composable Commerce Reference

[![Stable Branch](https://img.shields.io/badge/stable%20branch-master-blue.svg)](https://github.com/elasticpath/epcc-composable-commerce-reference)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/elasticpath/epcc-react-pwa-reference-storefront/issues)
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
[![follow on Twitter](https://img.shields.io/twitter/follow/elasticpath?style=social&logo=twitter)](https://twitter.com/intent/follow?screen_name=elasticpath)

## Overview 🚀
The Elastic Path Commerce Cloud Composable Commerce Reference shows how to extend the business capabilities of EPCC with a modular serverless application, featuring:
* an Elasticsearch integration for product data,
* API stats resource showing version and last deployment time.

The project structure can serve as a blueprint for building and deploying modular serverless applications.

[IMAGE]

Modules *independently* contribute to the API and infrastructure:

[IMAGE]

## Documentation 📖

### API
Once deployed, this project will provide the following API:
```
/_version
/{store_id}/searches/{resource_name}
/{store_id}/webhooks/search/{resource_name}
/{store_id}/oauth
/{store_id}/products
/{store_id}/orders
/{store_id}/...
```
`{resource_name}` indicates a generic integration pattern. In this case only `products` are supported since the minimal implementation provided here only indexes product data. However, this can easily be extended to support other EPCC data such as categories, customers, orders etc.

### Prerequisites
Before you begin, ensure that you have the following configured:
- [Elastic Path Commerce Cloud account](https://dashboard.elasticpath.com/login)
- [Amazon Web Services account](https://aws.amazon.com/)
- [Elasticsearch](https://www.elastic.co/start) with basic authentication

### Development Tools
Building or extending EPCC Composable Commerce Reference requires the following software:
- [Git](https://git-scm.com/downloads)
- [Node.js and npm](https://nodejs.org/en/download/)
- [AWS Command Line Interface 2.0.26 or later](https://aws.amazon.com/cli/)
- [Terraform 0.13.2 or later](https://www.terraform.io/downloads.html)

### Building and Deploying
```bash
# Clone the Git repository
git clone https://github.com/elasticpath/epcc-composable-commerce-reference.git

# Go into the cloned directory
cd epcc-composable-commerce-reference

# Install all the dependencies for all sub-projects
npm install

# Configure the parameters in the file config/config.json.
# See section "Configuration Parameter Descriptions" below.

# Build and deploy:
npm run start
```
`npm run start` will build the project, deploy infrastructure such as API gateway and Lambda functions into AWS, and configure EPCC with the appropriate integration webhook URL.

> `npm run start` is equivalent to the command `npm run build && npm run deploy && npm run config`.

Once everything is deployed and configured you can start the included integration test to ensure everything is working as expected:
```bash
npm run integration-test
```

Available commands:
```
npm run start
npm run test
npm run build       
npm run deploy
npm run config
npm run integration-test
npm run unconfig
npm run undeploy
npm run clean
```

### API Endpoint
```
api_endpoint: https://{apigw_id_etc}.amazonaws.com/dev/{epcc_store_id}
```

## Configuration Parameter Descriptions ⚙️

Parameters that require configuration are in the `config/config.json` file:

|Parameter| Importance|Type|Description|
|--|--|--|--|
|`epcc_store_id`| Required| String| The Store ID of your EPCC store|
|`epcc_client_id`| Required| String| A client ID for accessing your EPCC store|
|`epcc_client_secret`| Required| String| The client secret for the client ID|
|`elasticsearch_url`| Required | String | Elasticsearch endpoint that allows searching and managing search documents|
|`elasticsearch_auth`| Required | String | Elasticsearch basic authentication, e.g. `"Basic dXNlcjpwYXNzdzByZA=="`|
|`api_version`| Required | String | API version, e.g. `"1.0.0"`|

Basic authentication requires that user and password are Base64 encoded:
```
echo -n user:passw0rd | base64
```

## Contributing
This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind are welcome!

## Terms And Conditions
- Any changes to this project must be reviewed and approved by the repository owner. For more information about contributing, see the [LINK TO Contribution Guide]
- For more information about the license, see [LINK TO LICENSE].