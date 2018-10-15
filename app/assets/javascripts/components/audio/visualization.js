/**
 * Created by Jimmy on 12/7/16.
 */
'use strict';
var visualization =function(audioManager)
{
    this.audioManager = audioManager;
    this.ctx= this.audioManager.canvas.getContext( '2d' );
    this.pbBox = this.audioManager.playButton.getBoundingClientRect();
    this.collapsed = false;
    this.forward = true;
    this.timelineHeight= 2;
    this.framesToCollapse = 15;
    this.delay = 11;
    this.lineWidth = 1;
    this.barCount = 65;
    this.timeline = '#494949';
    this.waveUnplayed = '#D0D0D0';
    this.background          = '#FFF';
    this.emptyBar            = '#EBEBEB';
    this.wavePlayed = this.audioManager.wavePlayed;
    this.bars = Array( 300 );
    var me =this;
    this.repaint =function() {
        update();
    };
    function update(){
        var play = me.audioManager.playing;
        if(!play) {
            requestAnimationFrame(update);
            return;
        }
        var analyzer = me.audioManager.analyzer;
        // get the average, bincount is fftsize / 2
        var array =  new Uint8Array( analyzer.frequencyBinCount );
        analyzer.getByteFrequencyData( array );
        var average = me.getAverageVolume( array );
        average = average*1.5;

        me.bars[ 0 ] = average;
        average *= 0.8;
        if (play ) {
            var reduce = 0;
            for ( var i = 1; i < me.barCount; i++ ) {
                average = average - Math.sqrt( average ) + 1;
                if ( average < 0 ) {
                    average = 0;
                }
                (function( i, average ) {
                    setTimeout( function() {
                        me.bars[ i ] = average;
                    }, me.delay * ( me.forward ? i : 60 - i ) );
                })( i, average );
            }
        }
        me.draw();
        window.requestAnimationFrame(update);
    }
}
visualization.prototype.getPeaks =function(length) {
    var sampleSize = this.audioManager.songBuffer.length / length;
    var sampleStep = ~~(sampleSize / 10) || 1;
    var channels = this.audioManager.songBuffer.numberOfChannels;
    var splitPeaks = [];
    var mergedPeaks = [];

    for (var c = 0; c < channels; c++) {
        var peaks = splitPeaks[c] = [];
        var chan = this.audioManager.songBuffer.getChannelData(c);

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

visualization.prototype.draw = function(){
    this.drawBackground();
    if(this.audioManager.hasStarted && this.collapsed) {
        this.drawPulse();
    }
    else
    {
        this.drawWaveform();
    }
    this.drawScrubber();
    //display footer player if audio manager is playing
    if(($("#beat_play-controller").length >0) && (this.audioManager.selector == window.currentSong))
    {
        this.drawFooterPlayer();
    }
}

visualization.prototype.drawPulse =function(){
    var canvasWidth = this.audioManager.canvas.width;
    var canvasHeight = this.audioManager.canvas.height;

    var completion = 0;

    if(this.audioManager.songBuffer) {
        completion = this.audioManager.getCurrentTime() / this.audioManager.duration;
    }

    for(var i = 0; i<canvasWidth; i+=2*this.lineWidth) {
        var x = i;
        // determine the bucket to use for data
        var avg = 0;
        if(i >= canvasWidth/2) {
            avg = this.bars[Math.floor(this.barCount/canvasWidth * (i-canvasWidth/2))];
        }
        else
        {
            avg = this.bars[Math.floor(this.barCount/canvasWidth * (canvasWidth/2-i))];
        }
        var y = ( canvasHeight / 2 ) - ( avg / 2 );
        var height = avg;
        var color = this.wavePlayed;
        if(i/canvasWidth >= completion) {
            color = this.waveUnplayed;
        }
        this.rect(x, y, this.lineWidth, height, color);
    }
};

visualization.prototype.drawScrubber = function(){
    var completion = 0; // 0-1, percentage

    if(this.audioManager.songBuffer) {
        completion = this.audioManager.currentTime / this.audioManager.duration;
    }

    if(completion >= 1) {
        this.audioManager.currentTime = 0;
        this.audioManager.pause();
        completion = 0;
        this.audioManager.nextPlay();
    }

    var canvasWidth = this.audioManager.canvas.width/1.03;
    var canvasHeight = this.audioManager.canvas.height;
    // scrubber
    this.ctx.fillStyle = this.wavePlayed;
    this.ctx.fillRect( 0, canvasHeight/2-this.timelineHeight, canvasWidth, this.timelineHeight );

    this.ctx.fillStyle = this.timeline;
    this.ctx.fillRect( 0, canvasHeight/2-this.timelineHeight, canvasWidth*completion, this.timelineHeight );

    var left = completion * canvasWidth - this.pbBox.width/2;

    this.audioManager.playButton.style.left = left + 'px';
    this.audioManager.timeField.value = this.audioManager.formatTime(this.audioManager.currentTime);
};

visualization.prototype.drawFooterPlayer = function(){
    var completion = 0; // 0-1, percentage

    if(this.audioManager.songBuffer) {
        completion = this.audioManager.currentTime / this.audioManager.duration;
    }

    if(completion >= 1) {
        completion = 0;
    }

    var canvasWidth = $("#beat_play-controller canvas").width();
    var canvasHeight = $("#beat_play-controller canvas").height();
    var play_btn = $("#beat_play-controller button");
    // scrubber
    var footerPlayer_ctx = $("#beat_play-controller canvas")[0].getContext( '2d' );
    footerPlayer_ctx.fillStyle = "#DBDBDB";
    footerPlayer_ctx.fillRect( 0, canvasHeight/2-this.timelineHeight, canvasWidth, this.timelineHeight );

    footerPlayer_ctx.fillStyle = "#2bb673";
    footerPlayer_ctx.fillRect( 0, canvasHeight/2-this.timelineHeight, canvasWidth*completion, this.timelineHeight );
    var left = 60 + completion * canvasWidth - play_btn.outerWidth()/2;
    play_btn.css("left", left + 'px');
    $("#beat_play-controller .player__time--duration").html(this.audioManager.durationField.value);
    $("#beat_play-controller .player__time--current").html(this.audioManager.timeField.value);
};

visualization.prototype.drawBackground =function () {
    var canvasWidth = this.audioManager.canvas.width;
    var canvasHeight = this.audioManager.canvas.height;
    // clear the current state
    this.ctx.fillStyle = this.background;
    this.ctx.fillRect( 0, 0, canvasWidth, canvasHeight );

    for (var i = 0; i<canvasWidth; i+=2*this.lineWidth) {
        // background lines
        var x = i;
        this.rect(x, 0, this.lineWidth, canvasHeight, this.emptyBar);
    }
};

visualization.prototype.drawWaveform =function(){
    var precomputedPeaks = this.audioManager.precomputedPeaks;
    var completion  = 0; // 0-1, percentage
    if(this.audioManager.songBuffer) {
        completion    = this.audioManager.currentTime / this.audioManager.duration;
    }
    var canvasWidth   = this.audioManager.canvas.width;
    var canvasHeight  = this.audioManager.canvas.height;
    var peaks   = precomputedPeaks && precomputedPeaks.length ?
        precomputedPeaks : this.getPeaks(precomputedPeaks);
    this.ctx.beginPath();
    this.ctx.strokeStyle = this.wavePlayed;
    this.ctx.lineWidth = 2;
    this.ctx.moveTo(0, canvasHeight/2);
    var hasStruck = false;
    for(var i = 0; i<canvasWidth; i++) {
        var peak = peaks[Math.floor(peaks.length/canvasWidth * i)];
        this.ctx.lineTo(i, peak*canvasHeight/2 + canvasHeight/2);
        if(!hasStruck && i/canvasWidth >= completion) {
            this.ctx.stroke(); // close up previous stroke
            this.ctx.beginPath();
            this.ctx.lineWidth = 2;
            this.ctx.moveTo(i, peak*canvasHeight/2 + canvasHeight/2);
            this.ctx.strokeStyle = this.waveUnplayed;
        }
    }
    this.ctx.stroke();
    this.framesToCollapse -= 1;
    if(this.framesToCollapse <= 0) {
        this.collapsed = true;
    }
};

visualization.prototype.rect = function(x, y, width, height, color){
    this.ctx.save();
    this.ctx.beginPath();
    this.ctx.rect( x, y, width, height );
    this.ctx.clip();

    this.ctx.fillStyle = color;
    this.ctx.fillRect( 0, 0, this.audioManager.canvas.width,this.audioManager.canvas.height );
    this.ctx.restore();
};

visualization.prototype.getAverageVolume = function(array) {
    var values = 0;
    var average;

    var length = array.length;

    // get all the frequency amplitudes
    for ( var i = 0; i < length; i++ ) {
        values += array[ i ];
    }

    average = values / length;
    return average;
};