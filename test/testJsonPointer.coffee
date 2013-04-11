
jsonPointer = require "../src/jsonPointer"
chai = require "chai"
chai.should()
expect = chai.expect


describe "jsonPointer", () ->

  describe "#get", () ->

    it "should evaluate spec examples", () ->
      target =
        "foo": ["bar", "baz"]
        "": 0
        "a/b": 1,
        "c%d": 2,
        "e^f": 3,
        "g|h": 4,
        "i\\j": 5,
        "k\"l": 6,
        " ": 7,
        "m~n": 8

      targetAsString = JSON.stringify target

      specExamples =
        "": target
        "/foo": ["bar", "baz"],
        "/foo/0": "bar",
        "/": 0,
        "/a~1b": 1,
        "/c%d": 2,
        "/e^f": 3,
        "/g|h": 4,
        "/i\\j": 5,
        "/k\"l": 6,
        "/ ": 7,
        "/m~0n": 8

      check = (expression, expected) ->
        actual = jsonPointer.get targetAsString, expression
        actual.should.be.deep.equal expected

      check(expression, expected) for expression, expected of specExamples


    it "returns undefined if value is not found", () ->
      target =
        foo: "bar"

      targetAsString = JSON.stringify target

      actual = jsonPointer.get targetAsString, "/baz/0"
      expect(actual).to.be.undefined


    describe "validates pointer and", () ->
      target =
        foo: "bar"
        baz: [1, 2, 3]
        "-": "valid"
      targetAsString = JSON.stringify target
      getTestFunction = (pointer) ->
        () -> jsonPointer.get targetAsString, pointer

      it "throws an error if pointer is not valid", () ->
        invalidPointers = ["a", "/baz/01", "/baz/-", "-"]
        testFunctions = invalidPointers.map getTestFunction

        expect(f).to.throw Error for f in testFunctions


      it "does not throw an error if pointer is valid", () ->
        validPointers = ["", "/", "//", "/a", "/0", "/10", "/a/0", "/1/a", "/-"]
        testFunctions = validPointers.map getTestFunction

        expect(f).to.not.throw Error for f in testFunctions
