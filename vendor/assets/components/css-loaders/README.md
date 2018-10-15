# css-loaders

a project to quickly prototype css loaders

* Loader 1 demo: http://codepen.io/javoire/pen/nkrGc/
* Loader 2 demo: http://codepen.io/javoire/pen/Gbidq

## Install

```
bower install css-loaders
```

## Use

In your main less file, include the loader you want. E.g.

```less
@import "../bower_components/css-loaders/source/loader1.less";
```

And check the demo file for the required markup. In this case:

```
../bower_components/css-loaders/source/loader1-demo.html
```

Which contains:

```html
  ...
  <body> <!-- the body tag is the parent in this demo. Position should be set to "relative". -->
    <div class="loader">
      <div class="dot"></div>
      <div class="dot"></div>
      <div class="dot"></div>
      <div class="dot"></div>
    </div>
  </body>
  ...
```

Usually, the parent element of the ```.loader``` div should have ```position: relative;``` set since the loaders are set to ```position: absolute; ```, so that they'll show up in the right position on the page.
