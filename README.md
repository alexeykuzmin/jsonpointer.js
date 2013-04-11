## JavaScript JSON Pointer

[![Build Status](https://travis-ci.org/alexeykuzmin/js-json-pointer.png)](https://travis-ci.org/alexeykuzmin/js-json-pointer)

JavaScript implementation of JSON Pointer ([RFC 6901](http://tools.ietf.org/html/rfc6901)).  
Can be used as Node.js package, AMD module or a plain script.


## Installation

via [npm](https://npmjs.org/):

    $ npm install js-json-pointer
    
via [Bower](http://twitter.github.io/bower/):

    $ bower install js-json-pointer
    
or copy `src/jsonPointer.js` file from repo.


## Usage examples

```js
var jsonPointer = require('js-json-pointer');
// Available as window.jsonPointer if included via <script/> tag.

var targetJSON = JSON.stringify({
  foo: {
    bar: 'foobar'
  },
  baz: [true, false],
  '~': 'tilde',
  '/': 'slash'
});

// Please note that first argument of `.get()` method must be a string.
jsonPointer.get(targetJSON, "/foo");  // {bar: 'foobar'}
jsonPointer.get(targetJSON, "/foo/bar");  // 'foobar'
jsonPointer.get(targetJSON, "/some/nonexisting/path");  // undefined
jsonPointer.get(targetJSON, "/~0");  // 'tilde'
jsonPointer.get(targetJSON, "/~1");  // 'slash'
jsonPointer.get(targetJSON, "/baz");  // [true, false]
jsonPointer.get(targetJSON, "/baz/0");  // true
jsonPointer.get(targetJSON, "/baz/2");  // undefined

```

## Throwing exceptions
`jsonPointer#get` will throw an exception in following cases:
 - first argument is not valid JSON string
 - seconds argument is not valid JSON Pointer string
 - unacceptable token met during evaluation (check [section 4 of spec](http://tools.ietf.org/html/rfc6901#section-4) for examples)
 - "-" token used in JSON Pointer string and it`s going to be evaluated in Array context
