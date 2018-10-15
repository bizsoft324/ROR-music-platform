#!/usr/bin/env node

var lingon = require('lingon'),
    less = require('gulp-less'),
    prefix = require('gulp-autoprefixer'),
    lingonWatch = require('lingon-watch');

lingonWatch(lingon);

lingon.sourcePath = 'source';
lingon.buildPath = 'dist';

lingon.postProcessor('less', function() {
  return [
    less(),
    prefix()
  ];
});