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


## Include
###Node.js
```js
var jsonpoiner = require('jsonpointer.js');  // XXX: '.js' is part of package name!
console.log(typeof jsonpointer);  // 'object'
```

###[AMD](https://github.com/amdjs/amdjs-api/wiki/AMD)
```js
require('jsonpointer', function(jsonpointer) {
  console.log(typeof jsonpointer);  // 'object'
});
```

### &lt;script&gt; tag
```html
<script src="/path/to/jsonpointer.js" type="text/javascript"></script>
<script>
   console.log(typeof window.jsonpointer);  // 'object'
</script>
```

## Methods
### jsonpointer.get
```js
var targetJSON = JSON.stringify({
  foo: {
    bar: 'foobar'
  },
  baz: [true, false],
  '~': 'tilde',
  '/': 'slash'
});

// Please note that first argument of `.get()` method must be a string.
jsonpointer.get(targetJSON, '/foo');  // {bar: 'foobar'}
jsonpointer.get(targetJSON, '/foo/bar');  // 'foobar'
jsonpointer.get(targetJSON, '/some/nonexisting/path');  // undefined
jsonpointer.get(targetJSON, '/~0');  // 'tilde'
jsonpointer.get(targetJSON, '/~1');  // 'slash'
jsonpointer.get(targetJSON, '/baz');  // [true, false]
jsonpointer.get(targetJSON, '/baz/0');  // true
jsonpointer.get(targetJSON, '/baz/2');  // undefined

// Second argument might be omitted, in such case `.get()` returns a function
// that takes pointer as argument and evaluates it.
var evaluate = jsonpointer.get(targetJSON);
evaluate('/foo/bar');  // 'foobar'
```

There are several cases when `.get()` throws an exception:

 - First argument is not valid JSON string.
 - Seconds argument is not valid JSON Pointer string.
 - Unacceptable token met during evaluation (check [section 4 of spec](http://tools.ietf.org/html/rfc6901#section-4) for examples).
 - '-' token used in JSON Pointer string and it`s going to be evaluated in Array context.
