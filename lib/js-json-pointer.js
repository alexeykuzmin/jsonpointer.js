/**
 * @author Alexey Kuzmin <alex.s.kuzmin@gmail.com>
 * @fileoverview JavaScript implementation of JSON Pointer.
 * @see http://tools.ietf.org/html/rfc6901
 */



;(function() {
  'use strict';

  /**
   * List of special characters and their escape sequences.
   * Special characters will be unescaped in order they are listed.
   * @type {Array.<Array.<string>>}
   * @const
   */
  var SPECIAL_CHARACTERS = [
    ['/', '~1'],
    ['~', '~0']
  ];


  /**
   * Returns |target| object's value pointed by |pointer|.
   * If |pointer| is not provided returns curried function bound to |target|.
   * @param {!string} target JSON document.
   * @param {string=} pointer JSON Pointer string. Optional.
   * @return {(*|Function)} Some value or function.
   */
  function getPointedValue(target, pointer) {
    // TODO (alexeykuzmin): Implement function.
    return 0;
  }


  // Expose API

  var jsonPointer = {
    get: getPointedValue
  };

  if ('object' === typeof exports) {
    // Node.js
    module.exports = jsonPointer;
  } else if ('function' === typeof define && define.amd) {
    // AMD
    define(function() {
      return jsonPointer;
    });
  } else {
    // Browser
    this.jsonPointer = jsonPointer;
  }

}).call((function() {
  'use strict';
  return this || (typeof window !== 'undefined' ? window : global);
})());
