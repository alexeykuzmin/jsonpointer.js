
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


    it "should return undefined if value is not found", () ->
      target =
        foo: "bar",
        baz: [1, 2, 3]
      targetAsString = JSON.stringify target
      pointers = ["/oof", "/baz/4", "/foo/bar", "/foo/bar/baz"]

      evaluate = (pointer) -> jsonPointer.get targetAsString, pointer
      expect(evaluate(p)).to.be.undefined for p in pointers


    it "should throw an error if target is not valid JSON document", () ->
      invalidTargets = [null, "", [], {}, "invalid", 1, "{o}"]
      pointer = ""

      evaluate = (target) -> () -> jsonPointer.get target, pointer
      expect(evaluate(t)).to.throw Error for t in invalidTargets


    describe "pointer validation", () ->
      target =
        foo: "bar"
        baz: [1, 2, 3]
        "-": "valid"
      targetAsString = JSON.stringify target
      getTestFunction = (pointer) ->
        () -> jsonPointer.get targetAsString, pointer

      it "should throw an error if pointer is not valid", () ->
        invalidPointers = ["a", "/baz/01", "/baz/-", "-"]
        testFunctions = invalidPointers.map getTestFunction

        expect(f).to.throw Error for f in testFunctions


      it "should not throw an error if pointer is valid", () ->
        validPointers = ["", "/", "//", "/a", "/0", "/10", "/a/0", "/1/a", "/-"]
        testFunctions = validPointers.map getTestFunction

        expect(f).to.not.throw Error for f in testFunctions
