
global = if typeof window isnt 'undefined' then window else this
jsonpointer = global.jsonpointer || require "../src/jsonpointer"
chai = global.chai || require "chai"
chai.should()
expect = chai.expect


describe "jsonpointer", () ->

  describe ".get()", () ->

    input =
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

    specExamples =
      "": input
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


    it "should evaluate spec examples on string target", () ->
      targetAsString = JSON.stringify input

      check = (expression, expected) ->
        actual = jsonpointer.get targetAsString, expression
        actual.should.be.deep.equal expected

      check(expression, expected) for expression, expected of specExamples


    it "should evaluate spec examples on object target", () ->

      check = (expression, expected) ->
        actual = jsonpointer.get input, expression
        actual.should.be.deep.equal expected

      check(expression, expected) for expression, expected of specExamples

    it "should evaluate on array target", () ->

      target = [
        { foo: "bar", baz: [1, 2, 3] }
        foo: "foobar"
      ]

      expressions =
        "/0/foo" : "bar"
        "/0/baz/1" : 2
        "/1":
          foo: "foobar"

      check = (expression, expected) ->
        actual = jsonpointer.get target, expression
        actual.should.be.deep.equal expected

      check(expression, expected) for expression, expected of expressions


    it "should return undefined if value is not found", () ->
      target =
        foo: "bar",
        baz: [1, 2, 3]
      targetAsString = JSON.stringify target
      pointers = ["/oof", "/baz/4", "/foo/bar", "/foo/bar/baz"]

      evaluate = (pointer) -> jsonpointer.get targetAsString, pointer
      expect(evaluate(p)).to.be.undefined for p in pointers


    it "should throw an error if target is not object or valid JSON document string", () ->
      invalidTargets = [null, "", false, "{{{", "invalid", 1, "{o}"]
      pointer = ""

      evaluate = (target) -> () -> jsonpointer.get target, pointer
      expect(evaluate(t)).to.throw Error for t in invalidTargets


    describe "call w/o second argument", () ->

      it "should return function if first argument is valid", () ->
        validJSON = "null"

        actual = jsonpointer.get validJSON
        actual.should.to.be.a "function"


      it "should throw an exception if first argument is not valid", () ->
        invalidJSON = "invalid"
        curryGet = (json) -> () -> jsonpointer.get json

        expect(curryGet(invalidJSON)).to.throw Error


    describe "result of call w/o second argument", () ->

      it "should evaluate given pointer on previously passed document", () ->
        target =
          foo: "bar"
        targetAsString = JSON.stringify target
        evaluate = jsonpointer.get targetAsString
        expectedResults =
          "/foo": target.foo
          "/baz": undefined

        check = (pointer, expected) ->
          expect(evaluate pointer).to.be.deep.equal expected
        check(pointer, expected) for pointer, expected of expectedResults


    describe "pointer validation", () ->
      target =
        foo: "bar"
        baz: [1, 2, 3]
        "-": "valid"
      targetAsString = JSON.stringify target
      getTestFunction = (pointer) ->
        () -> jsonpointer.get targetAsString, pointer

      it "should throw an error if pointer is not valid", () ->
        invalidPointers = ["a", "/baz/01", "/baz/-", "-"]
        testFunctions = invalidPointers.map getTestFunction

        expect(f).to.throw Error for f in testFunctions


      it "should not throw an error if pointer is valid", () ->
        validPointers = ["", "/", "//", "/a", "/0", "/10", "/a/0", "/1/a", "/-"]
        testFunctions = validPointers.map getTestFunction

        expect(f).to.not.throw Error for f in testFunctions
