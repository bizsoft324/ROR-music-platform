/*!LICENSE
 A portion of this code is © Tyler Benziger under the following license:

 Copyright (c) 2016 - Tyler Benziger - http://codepen.io/tybenz/pen/dPRWJa/

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction,
 including without limitation the rights to use, copy, modify,
 merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 DEALINGS IN THE SOFTWARE.
 */

window.Waveform = function(selector, songUrl, precomputedPeaks) {

  // feel free to change any of these values
  var barCount            = 65; // how many discrete units of the fast fourier transform to show
  var waveSurferPeaks     = 60;
  var lineWidth           = 1;
  var heightFactor        = 1.5;
  var delay               = 11;
  var background          = '#FFF';
  var emptyBar            = '#EBEBEB';
  var wavePlayed          = '#2BB673';
  var waveUnplayed        = '#D0D0D0';
  var buttonFill          = wavePlayed;
  var buttonInner         = '#FFF';
  var buttonPadding       = 15; // in pixels
  var buttonFontSize      = 20; // in pixels
  var timeFieldWidth      = 25; // in pixels
  var timeFieldHeight     = 20; // in pixels
  var timeFieldBackground = '#FFF'; // in pixels
  var timeFieldColor      = '#000'; // in pixels
  var timeline            = '#494949';
  var timelineHeight      = 2;
  var collapseFrames      = 15; // how many frames until the waveform collapses

  // INITIALIZATION

  if (typeof ac !== 'undefined') {
    ac = ac;
  } else {
    ac = null;
  }
  var framesToCollapse  = collapseFrames;
  var hasStarted        = false;
  var getContext = function() {
    if ( !window.AudioContext && !window.webkitAudioContext ) {
      console.warn('Web Audio API not supported in this browser');
    } else {
      ac =  ac || new ( window.AudioContext || window.webkitAudioContext )();
    }
    return function() {
      return ac;
    };
  }();

  var context   = getContext();
  window.playerContext = context;
  var analyser  = context.createAnalyser();

  analyser.fftSize                = 1024;
  analyser.smoothingTimeConstant  = 0.3;

  var playing       = false;
  var songSource    = null;
  var songBuffer    = null;
  var audioEl       = null; // used if AudioContext is not available
  var startOffset   = 0;
  var startTime     = 0;
  var canvas        = document.querySelector(selector);
  var ctx           = canvas.getContext( '2d' );
  var canvas_parent = canvas.parentElement;
  var bars          = Array( 300 );
  var forward       = true;
  var collapsed     = false;

  var beat_id = canvas.closest('#beat').dataset.id;
  var rating_list = document.getElementById("rating_list_" + beat_id);
  var critiques_link = document.getElementById("critiques_link_" + beat_id);

  var listeners   = {};
  var me          = this;

  var playButton = document.createElement('button');
  playButton.textContent = '▶';
  playButton.addEventListener('click', togglePlayback);
  playButton.classList.add('waveform-play');
  playButton.style.borderRadius = '50px';
  playButton.style.border = 'none';
  playButton.style.paddingTop = buttonPadding + 'px';
  playButton.style.paddingBottom = buttonPadding + 'px';
  playButton.style.width = buttonPadding*2 + buttonFontSize + 'px';
  playButton.style.lineHeight = buttonFontSize + 'px';
  playButton.style.fontSize = buttonFontSize + 'px';
  playButton.style.color = buttonInner;
  playButton.style.background = buttonFill;
  playButton.style.textAlign = 'center';
  playButton.style.fontWeight = 'bold';
  playButton.style.cursor = 'pointer';
  playButton.style.position = 'absolute';
  playButton.style.outline = 'none';
  playButton.style.visibility = 'hidden';

  var timeField = document.createElement('input');
  var durationField = document.createElement('input');

  [timeField, durationField].forEach(function(field) {
    field.type      = 'text';
    field.disabled  = 'disabled';
    field.style.zIndex          = 0;
    field.style.backgroundColor = timeFieldBackground;
    field.style.position        = 'absolute';
    field.style.textAlign       = 'center';
    field.style.border          = 'none';
    field.style.color           = timeFieldColor;
    field.style.width           = timeFieldWidth + 'px';
    field.style.height          = timeFieldHeight + 'px';
    field.style.lineHeight      = timeFieldHeight + 'px';
    field.style.visibility      = 'hidden';
    field.style.fontSize        = '10px';

  });

  canvas.parentElement.appendChild(timeField);
  canvas.parentElement.appendChild(durationField);
  canvas.parentElement.appendChild(playButton);

  var pbBox = playButton.getBoundingClientRect();

  function togglePlayback(e) {
    e.stopPropagation();
    if(playing) {
      pause();
    }
    else
    {
      play();
    }
  }

  /**
   *!LICENSE from Wavesurfer, CC BY 3.0. getPeaks method modified to
   * use local variables. http://wavesurfer-js.org/, for full license, see
   * https://creativecommons.org/licenses/by/3.0/legalcode
   */
  /*
   * Compute the max and min value of the waveform when broken into
   * <length> subranges.
   * @param {Number} How many subranges to break the waveform into.
   * @returns {Array} Array of 2*<length> peaks or array of arrays
   * of peaks consisting of (max, min) values for each subrange.
   */
  function getPeaks(length) {
    var sampleSize = songBuffer.length / length;
    var sampleStep = ~~(sampleSize / 10) || 1;
    var channels = songBuffer.numberOfChannels;
    var splitPeaks = [];
    var mergedPeaks = [];

    for (var c = 0; c < channels; c++) {
      var peaks = splitPeaks[c] = [];
      var chan = songBuffer.getChannelData(c);

      for (var i = 0; i < length; i++) {
        var start = ~~(i * sampleSize);
        var end = ~~(start + sampleSize);
        var min = 0;
        var max = 0;

        for (var j = start; j < end; j += sampleStep) {
          var value = chan[j];

          if (value > max) {
            max = value;
          }

          if (value < min) {
            min = value;
          }
        }

        peaks[2 * i] = max;
        peaks[2 * i + 1] = min;

        if (c == 0 || max > mergedPeaks[2 * i]) {
          mergedPeaks[2 * i] = max;
        }

        if (c == 0 || min < mergedPeaks[2 * i + 1]) {
          mergedPeaks[2 * i + 1] = min;
        }
      }
    }

    return mergedPeaks;
  }

  function emit(name, arg1, arg2, argn) {
    if(listeners[name]) {
      listeners[name].forEach(function(cb) {
        cb.call(me, Array.prototype.slice.call(arguments, 1));
      });
    }
  }

  function on(ev, cb) {
    listeners[ev] = listeners[ev] || [];
    listeners[ev].push(cb);
  }

  function loadSong( url ) {
    if(!AudioContext) {
      audioEl = document.createElement('audio');
      audioEl.style.display = 'none';
      audioEl.src = url;
      canvas.parentElement.appendChild(audioEl);
      audioEl.addEventListener('durationchange', function() {
        emit('ready');
        update();
      });
      return;
    }

    var request = new XMLHttpRequest();
    request.open( 'GET', url, true );
    request.responseType = 'arraybuffer';

    request.onload = function() {
      var arraybuffer = request.response;
      context.decodeAudioData( arraybuffer, function( buffer ) {
        songBuffer = buffer;
        window.songBuffer = buffer;
        update();
        emit('ready');
      }, emit.bind(me, 'error') );
    };
    request.send();
  }


  function update() {
    if(!playing) {
      requestAnimationFrame( update );
      return;
    }
    if(!AudioContext) {
      draw();
      requestAnimationFrame( update );
      return;
    }
    // get the average, bincount is fftsize / 2
    var array =  new Uint8Array( analyser.frequencyBinCount );
    analyser.getByteFrequencyData( array );
    var average = getAverageVolume( array );
    average *= heightFactor;

    bars[ 0 ] = average;
    average *= 0.8;
    if ( playing ) {
      var reduce = 0;
      for ( var i = 1; i < barCount; i++ ) {
        average = average - Math.sqrt( average ) + 1;
        if ( average < 0 ) {
          average = 0;
        }
        (function( i, average ) {
          setTimeout( function() {
            bars[ i ] = average;
          }, delay * ( forward ? i : 60 - i ) );
        })( i, average );
      }
    }

    draw();
    requestAnimationFrame( update );
  }

  function drawWaveform() {
    var completion  = 0; // 0-1, percentage
    if(songBuffer || audioEl) {
      completion    = me.currentTime / me.duration;
    }
    var canvasWidth   = canvas.width;
    var canvasHeight  = canvas.height;
    var peaks   = precomputedPeaks && precomputedPeaks.length ?
      precomputedPeaks : getPeaks(waveSurferPeaks);
    var centerY = canvasHeight/2;
    ctx.beginPath();
    ctx.strokeStyle = wavePlayed;
    ctx.lineWidth = 2;
    ctx.moveTo(0, canvasHeight/2);
    var hasStruck = false;
    for(var i = 0; i<canvasWidth; i++) {
      var peak = peaks[Math.floor(peaks.length/canvasWidth * i)];
      if(AudioContext) {
        peak = peak * framesToCollapse/collapseFrames;
      }
      ctx.lineTo(i, peak*canvasHeight/2 + canvasHeight/2);
      if(!hasStruck && i/canvasWidth >= completion) {
        ctx.stroke(); // close up previous stroke
        ctx.beginPath();
        ctx.lineWidth = 2;
        ctx.moveTo(i, peak*canvasHeight/2 + canvasHeight/2);
        ctx.strokeStyle = waveUnplayed;
      }
    }
    ctx.stroke();
    framesToCollapse -= 1;
    if(framesToCollapse <= 0) {
      collapsed = true;
    }
  }

  function formatTime(t) {
    var mm = Math.floor(t/60);
    var ss = Math.floor(t%60);
    if((ss + '').length < 2) {
      ss = '0' + ss;
    }
    return  mm + ':' + ss;
  }

  function drawScrubber() {
    var completion = 0; // 0-1, percentage

    if( songBuffer || audioEl ) {
      completion = me.currentTime / me.duration;
    }

    if(completion >= 1) {
      me.currentTime = 0;
      me.pause();
      completion = 0;
      canvas_parent.style.opacity = 0.6;
      showAnimation()
    }

    var canvasWidth = canvas.width/1.03;
    var canvasHeight = canvas.height;
    // scrubber
    ctx.fillStyle = wavePlayed;
    ctx.fillRect( 0, canvasHeight/2-timelineHeight, canvasWidth, timelineHeight );

    ctx.fillStyle = timeline;
    ctx.fillRect( 0, canvasHeight/2-timelineHeight, canvasWidth*completion, timelineHeight );

    var left = completion * canvasWidth - pbBox.width/2;

    if ( me.currentTime == 0 ) left = '-40px';

    playButton.style.left = left + 'px';
    timeField.value = formatTime(me.currentTime);
  }

  function showAnimation() {
    critiques_link.classList.add('beat__critiques--active');
    rating_list.classList.add('beat__ratings--active');
  }

  function drawBackground() {
    var canvasWidth = canvas.width;
    var canvasHeight = canvas.height;

    // clear the current state
    ctx.fillStyle = background;
    ctx.fillRect( 0, 0, canvasWidth, canvasHeight );

    for(var i = 0; i<canvasWidth; i+=2*lineWidth) {
      // background lines
      var x = i;
      rect(x, 0, lineWidth, canvasHeight, emptyBar);
    }
  }

  function draw() {
    drawBackground();
    if(hasStarted && collapsed && AudioContext) {
      drawPulse();
    }
    else
    {
      drawWaveform();
    }
    drawScrubber();
  }

  function getCurrentTime() {
    if(!AudioContext) {
      return audioEl.currentTime;
    }
    var ct;
    if(!playing) {
      ct = startOffset;
    }
    else
    {
      ct = (context.currentTime - startTime + startOffset);
    }
    if(ct > me.duration) {
      ct = me.duration;
    }
    return ct;
  }

  function drawPulse() {
    var canvasWidth = canvas.width;
    var canvasHeight = canvas.height;

    var completion = 0;

    if(songBuffer || audioEl) {
      completion = getCurrentTime() / me.duration;
    }

    for(var i = 0; i<canvasWidth; i+=2*lineWidth) {
      var x = i;
      // determine the bucket to use for data
      var avg = 0;
      if(i >= canvasWidth/2) {
        avg = bars[Math.floor(barCount/canvasWidth * (i-canvasWidth/2))];
      }
      else
      {
        avg = bars[Math.floor(barCount/canvasWidth * (canvasWidth/2-i))];
      }
      var y = ( canvasHeight / 2 ) - ( avg / 2 );
      var height = avg;
      var color = wavePlayed;
      if(i/canvasWidth >= completion) {
        color = waveUnplayed;
      }
      rect(x, y, lineWidth, height, color);
    }

  }

  function rect( x, y, width, height, color ) {
    ctx.save();
    ctx.beginPath();
    ctx.rect( x, y, width, height );
    ctx.clip();

    ctx.fillStyle = color;
    ctx.fillRect( 0, 0, canvas.width,canvas.height );
    ctx.restore();
  }

  function getAverageVolume( array ) {
    var values = 0;
    var average;

    var length = array.length;

    // get all the frequency amplitudes
    for ( var i = 0; i < length; i++ ) {
      values += array[ i ];
    }

    average = values / length;
    return average;
  }

  function play() {
    playing     = true;
    hasStarted  = true;

    playButton.textContent = '||';

    canvas_parent.style.opacity = 1;
    rating_list.classList.remove('beat__ratings--active');
    critiques_link.classList.remove('beat__critiques--active');

    if(!AudioContext) {
      audioEl.play();
      return;
    }

    startTime = context.currentTime;
    songSource = context.createBufferSource();
    songSource.connect( analyser );
    songSource.buffer = songBuffer;
    songSource.connect( context.destination );
    songSource.start( 0, startOffset % me.duration );
  }

  function pause() {
    playing = false;
    playButton.textContent = '▶';

    if(!AudioContext) {
      audioEl.pause();
      return;
    }

    if(songSource) {
      songSource.stop( 0 );
    }
    startOffset += context.currentTime - startTime;
  }

  Object.defineProperty(this, 'duration', {
    get: function() {
      return AudioContext ? songBuffer.duration : audioEl.duration;
    }
  });

  Object.defineProperty(this, 'currentTime', {
    get: function() {
      return getCurrentTime();
    },
    set: function(t) {
      if(AudioContext) {
        pause();
        startOffset = t;
        play();
      }
      else
      {
        audioEl.currentTime = t;
        draw();
      }
    }
  });

  this.on       = on;
  this.play     = play;
  this.pause    = pause;
  this._context = context;

  this.on('ready', function() {
    canvas.addEventListener('click', function(e) {
      var time = e.offsetX / canvas.width * me.duration;
      me.currentTime = time;
    });
    playButton.style.visibility     = 'visible';
    timeField.style.visibility      = 'visible';
    durationField.style.visibility  = 'visible';
    durationField.value = formatTime(me.duration);
    resize();
    draw();
  });


  function resize() {
    var width     = canvas.parentElement.offsetWidth;
    var height    = canvas.parentElement.offsetHeight;
    canvas.height = height;
    canvas.width  = width;

    var canvasHeight          = canvas.height;
    timeField.style.left      = '0px';
    durationField.style.right = '0px';
    playButton.style.left     = '-20px';
    playButton.style.top      = (canvasHeight/2 - (buttonPadding*2 + buttonFontSize)/2) + 'px';
    timeField.style.top       = (canvasHeight/2 - timeFieldHeight/2) + 'px';
    durationField.style.top   = (canvasHeight/2 - timeFieldHeight/2) + 'px';
    draw();
  }

  window.addEventListener('resize', resize);
  loadSong( songUrl );
};
