"use strict";
const https = require('https');
const URL = require('url').URL;

exports.handler = async (event) => {
    var storeId = event.pathParameters.store_id;
    var resourceName = event.pathParameters.resource_name;
    var epccEvent = JSON.parse(event.body);
    
    if(epccEvent.triggered_by.endsWith(".deleted")) {
        await handleDeletedEvent(storeId, resourceName, epccEvent);
    } else {
        await handleIndexableEvent(storeId, resourceName, epccEvent);
    }

    return { statusCode: 200, body: "" };
};

async function handleIndexableEvent(storeId, resourceName, epccEvent) {
    var searchDoc = createSearchDocument(storeId, resourceName, epccEvent);
    if(searchDoc !== null) {
        await updateSearchIndex(storeId, resourceName, searchDoc);
    }
}

function createSearchDocument(storeId, resourceName, epccEvent) {
    var searchDoc = null;
    if(epccEvent.triggered_by === "product.created" || epccEvent.triggered_by === "product.updated") {
        searchDoc = epccEvent.payload.data;
        delete(searchDoc.relationships);
    }
    return searchDoc;
}

async function updateSearchIndex(storeId, resourceName, searchDoc) {
    var esUri = composeEsUri(storeId, resourceName, searchDoc.id);
    //console.log("Updating " + esUri);
    await new Promise((resolve, reject) => {
        const req = https.request(new URL(process.env.elasticsearch_url + esUri), withOptions('PUT'),
            (res) => {
                res.on('data', () => {});
                res.on('end', () => { /* console.log(respBody); */ resolve(); });
            });
        req.on('error', (error) => { console.error(error); reject(); });
        req.write(JSON.stringify(searchDoc));
        req.end();
    });
}

async function handleDeletedEvent(storeId, resourceName, epccEvent) {
    var esUri = composeEsUri(storeId, resourceName, epccEvent.payload.id);
    //console.log("Deleting " + esUri);
    await new Promise((resolve, reject) => {
        const req = https.request(new URL(process.env.elasticsearch_url + esUri), withOptions('DELETE'),
            (res) => {
                res.on('data', () => {});
                res.on('end', () => { /* console.log(respBody); */ resolve(); });
            });
        req.on('error', (error) => { console.error(error); reject(); });
        req.end();
    });
}

function composeEsUri(storeId, resourceName, id) {
    return "/epcc_" + storeId + "_" + resourceName + "/_doc/" + id;
}

function withOptions(httpMethod) {
    return {
        method: httpMethod,
        headers: {
            'Content-Type': 'application/json',
            'Authorization': process.env.elasticsearch_auth
        }
    };
}