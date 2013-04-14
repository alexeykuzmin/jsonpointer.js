# JavaScript JSON Pointer

[![Build Status](https://travis-ci.org/alexeykuzmin/jsonpointer.js.png)](https://travis-ci.org/alexeykuzmin/jsonpointer.js)

JavaScript implementation of JSON Pointer ([RFC 6901](http://tools.ietf.org/html/rfc6901)).  
Can be used as Node.js package, AMD module or a plain script.


## Installation

via [npm](https://npmjs.org/):

    $ npm install jsonpointer.js
    
via [Bower](http://twitter.github.io/bower/):

    $ bower install jsonpointer.js
    
or copy `src/jsonpointer.js` file from repo.


## Usage examples

### jsonpointer.get
```js
var jsonpointer = require('jsonpointer.js');  // Note that '.js' is a part of module name
// Available as window.jsonpointer if included via <script/> tag.

var targetJSON = JSON.stringify({
  foo: {
    bar: 'foobar'
  },
  baz: [true, false],
  '~': 'tilde',
  '/': 'slash'
});

// Please note that first argument of `.get()` method must be a string.
jsonpointer.get(targetJSON, "/foo");  // {bar: 'foobar'}
jsonpointer.get(targetJSON, "/foo/bar");  // 'foobar'
jsonpointer.get(targetJSON, "/some/nonexisting/path");  // undefined
jsonpointer.get(targetJSON, "/~0");  // 'tilde'
jsonpointer.get(targetJSON, "/~1");  // 'slash'
jsonpointer.get(targetJSON, "/baz");  // [true, false]
jsonpointer.get(targetJSON, "/baz/0");  // true
jsonpointer.get(targetJSON, "/baz/2");  // undefined

```

## Throwing exceptions
`jsonpointer#get` will throw an exception in following cases:
 - first argument is not valid JSON string
 - seconds argument is not valid JSON Pointer string
 - unacceptable token met during evaluation (check [section 4 of spec](http://tools.ietf.org/html/rfc6901#section-4) for examples)
 - "-" token used in JSON Pointer string and it`s going to be evaluated in Array context
