"use strict";

exports.handler = function(event, context, callback) {
    callback(null, { statusCode: 200, body: `{ "version": "${process.env.api_version}", "deployed_at": "${process.env.api_deployed_at}" }` });
};