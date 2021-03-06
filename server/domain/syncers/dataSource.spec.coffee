DataSource = require("./dataSource")
FixedLengthParser = require("../parsers/fixedLengthParser")
Excel2003Parser = require("../parsers/excel2003Parser.coffee")
require("producteca-sdk").Api::initializeClient = =>

describe "DataSource", ->
  dummyUser = null
  beforeEach -> dummyUser = tokens: {}

  it "puede instanciar el fixed length parser", ->
    parser = new DataSource(dummyUser, parser: "fixedLength")._getParser()
    parser.should.be.an.instanceOf FixedLengthParser

  it "puede instanciar el Excel parser", ->
    parser = new DataSource(dummyUser, parser: "excel2003")._getParser()
    parser.should.be.an.instanceOf Excel2003Parser
