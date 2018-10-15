// $(document).on('page:load', function(){
//    Paloma.start();
// });

__ = {
  ready: function(callback) {
    return __.on(document, 'DOMContentLoaded', callback)({
      get: function(id) {
        return document.getElementById(id);
      },
      qs: function(selector) {
        return document.querySelector(selector);
      },
      qsa: function(selector) {
        return document.querySelectorAll(selector);
      }
    });
  },
  on: function(input, ename, callback) {
    var node = this.__selectorOrNode(input);
    if (node) {
      node.addEventListener(ename, callback);
      return node;
    }
  },
  whichAnimationEvent: function() {
    var animations, el, t;
    el = document.createElement('fakeelement');
    animations = {
      'animation': 'animationend',
      'OAnimation': 'oanimationend',
      'MozAnimation': 'animationend',
      'WebkitAnimation': 'webkitAnimationEnd',
      'MSAnimation': 'msAnimationEnd'
    };
    for (t in animations) {
      if (el.style[t] !== void 0) {
        return animations[t];
      }
    }
  },
  __selectorOrNode: function(input) {
    if (typeof input === "string") {
      return this.qs(input);
    } else {
      return input;
    }
  }
};
