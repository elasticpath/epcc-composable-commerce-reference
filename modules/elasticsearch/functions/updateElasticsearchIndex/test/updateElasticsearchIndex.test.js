var updateElasticsearchIndex = require("../updateElasticsearchIndex.js");
var fs = require("fs");
var https = require("https");
var stream = require("stream");
var sinon = require("sinon");
var chai = require("chai");
var sinonChai = require("sinon-chai");
var should = chai.should();
chai.use(sinonChai);

describe("updateElasticsearchIndex", function() {
    var productUpdatedEvent, productDeletedEvent, httpsRequest, req;

    before(function(done) {
        productUpdatedEvent = JSON.parse(fs.readFileSync("functions/updateElasticsearchIndex/test/assets/product-updated.json").toString());
        productDeletedEvent = JSON.parse(fs.readFileSync("functions/updateElasticsearchIndex/test/assets/product-deleted.json").toString());
        process.env.elasticsearch_url = "https://127.0.0.1:8080/elasticsearch";
        httpsRequest = sinon.stub(https, "request").callsFake(function (url, options, callback) {
            resStream = new stream.Readable();
            resStream._read = function(size) {};
            callback(resStream);
            resStream.emit("end");
            req = {
                "on": sinon.stub(),
                "write": sinon.stub(),
                "end": sinon.stub(),
                // Including HTTP method used in mocked request object for easy assertion
                "_method": options.method
            };
            return req;
        });
        done();
    });

    beforeEach(function(done) {
        sinon.resetHistory();
        done();
    });

    describe("Product was updated", function() {
        it("updates document in Elasticsearch index", async function() {
            var result = await updateElasticsearchIndex.handler(productUpdatedEvent);
            httpsRequest.should.have.been.calledOnce;
            req._method.should.equal("PUT");
            req.write.should.have.been.calledOnce;
        });
        it("returns HTTP status code 200 with an empty body", async function() {
            var result = await updateElasticsearchIndex.handler(productUpdatedEvent);
            result.should.be.an("object");
            result.should.have.all.keys("statusCode", "body");
            result.statusCode.should.equal(200);
            result.body.should.equal("");
        });
    });

    describe("Product was deleted", function() {
        it("deletes document from Elasticsearch index", async function() {
            var result = await updateElasticsearchIndex.handler(productDeletedEvent);
            httpsRequest.should.have.been.calledOnce;
            req._method.should.equal("DELETE");
            req.write.should.not.have.been.called;
        });
        it("returns HTTP status code 200 with an empty body", async function() {
            var result = await updateElasticsearchIndex.handler(productDeletedEvent);
            result.should.be.an("object");
            result.should.have.all.keys("statusCode", "body");
            result.statusCode.should.equal(200);
            result.body.should.equal("");
        });
    });
});