
jsonPointer = require "../lib/jsonPointer"
chai = require "chai"
chai.should()


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
        actual.should.deep.equal expected

      check(expression, expected) for expression, expected of specExamples
