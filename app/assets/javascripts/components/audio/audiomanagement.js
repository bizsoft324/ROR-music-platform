/**
 * Created by adamlucas on 12/5/16.
 */
'use strict';
var AudioManage = function (id, selector, precomputedPeaks, url) {
    this.wavePlayed = '#2BB673';
    var timeFieldBackground = '#FFF'; // in pixels
    var timeFieldColor = '#000'; // in pixels
    var buttonFill = this.wavePlayed;
    var buttonInner = '#FFF';
    var buttonPadding = 15; // in pixels
    var buttonFontSize = 20; // in pixels
    var playButtonFontSize = 20;
    var timeFieldWidth = 25; // in pixels
    var me = this;
    if (this.isIosDevice()) {
        playButtonFontSize = 13;
    }
    this.id = id;
    this.selector = selector;
    this.no = -1;
    this.url = url;
    this.timeFieldHeight = 20; // in pixels
    this.startOffset = 0;
    this.startTime = 0;
    this.precomputedPeaks = precomputedPeaks;

    this.playButton = document.createElement('button');
    this.timeField = document.createElement('input');
    this.durationField = document.createElement('input');
    this.iosPlaySymbol = document.createElement('i');

    this.canvas = document.querySelector("#" + this.selector);
    this.context = this.getIosSafeContext();
    this.analyzer = this.context.createAnalyser();
    this.analyzer.fftSize = 1024;
    this.analyzer.smoothingTimeConstant = 0.3;
    this.audio_visulization = null;

    this.playing = false;
    this.hasStarted = false;
    this.songBuffer = null;
    this.playButton_style = {
        borderRadius: '50px',
        border: 'none',
        paddingTop: buttonPadding + 'px',
        paddingBottom: buttonPadding + 'px',
        width: buttonPadding * 2 + buttonFontSize + 'px',
        lineHeight: buttonFontSize + 'px',
        fontSize: playButtonFontSize + 'px',
        color: buttonInner,
        background: buttonFill,
        fontWeight: 'bold',
        cursor: 'pointer',
        position: 'absolute',
        outline: 'none',
        visibility: 'hidden'
    };
    this.field_style = {
        zIndex: '0',
        backgroundColor: timeFieldBackground,
        position: 'absolute',
        border: 'none',
        color: timeFieldColor,
        width: timeFieldWidth + 'px',
        height: this.timeFieldHeight + 'px',
        lineHeight: this.timeFieldHeight + 'px',
        fontSize: '10px'
    };
    this.iosPlaySymbol.className = "uk-icon-play";
    this.gainNode = null;
    this.ready = function () {
        this.canvas.removeEventListener('click', this.setCurrentTime);
        this.canvas.addEventListener('click', this.setCurrentTime);
        this.playButton.style.visibility = 'visible';
        this.timeField.style.visibility = 'visible';
        this.durationField.style.visibility = 'visible';
        this.durationField.value = this.formatTime(me.duration);
        this.resize();
    };
    this.setCurrentTime = function (e) {
        if (!me.songBuffer) {
            me.playButton.click();
        } else {
            var time = e.offsetX / me.canvas.width * me.duration;
            console.log(time);
            me.currentTime = time;

        }
    };
    this.resize = function () {
        var pbBox = me.playButton.getBoundingClientRect();
        var width = me.canvas.parentElement.offsetWidth;
        var height = me.canvas.parentElement.offsetHeight;
        if ((me.selector == window.currentSong) && ($("#beat_play-controller canvas").length > 0)) {
            if ($("#beat_play-controller .player__play").is(":visible")) {
                $("#beat_play-controller canvas")[0].width = $("#beat_play-controller .player__play").width() - 120;
            } else {
                $("#beat_play-controller canvas")[0].width = $("#beat_play-controller .player__artist.mobile").width() - 120;
            }
        }
        me.canvas.height = height;
        me.canvas.width = width;
        var canvasHeight = me.canvas.height;
        me.timeField.style.left = '0px';
        me.durationField.style.right = '0px';
        if (AudioManage.prototype.isMobileDevice()) {
            me.playButton.style.left = '0px';
        } else {
            me.playButton.style.left = '-20px';
        }
        me.playButton.style.top = (canvasHeight - (buttonPadding * 2 + buttonFontSize)) / 2 + 'px';
        me.timeField.style.top = (canvasHeight - this.timeFieldHeight) / 2 + 'px';
        me.durationField.style.top = (canvasHeight - this.timeFieldHeight) / 2 + 'px';
        if (me.audio_visulization != null) {
            me.audio_visulization.draw();
        }
    };

    this.preparePlay = function () {
        if (!this.songBuffer) {
            $(this.playButton).html('<div class="spinner-loader"></div>');   // loader
            if ($("#beat_play-controller").length > 0) {
                $("#beat_play-controller button").html('<div class="spinner-loader"></div>');
            }
            var cur = this;
            this.loadSong(this.url, function () {
                $(cur.playButton).html('▶');
                if ($("#beat_play-controller").length > 0) {
                    $("#beat_play-controller button").html('▶');
                }
                cur.playCallBack();
            });

        } else {
            this.playCallBack();
        }
    };

    this.playCallBack = function () {
        debugger;
        if (me.playing) {
            me.pause();
        } else {
            if (this.context.state === 'suspended' &&
                typeof this.context.resume === 'function') {
                this.context.resume();
            }

            me.play();
        }
    };

    Object.defineProperty(this, 'duration', {
        get: function () {
            if (this.songBuffer) {
                return this.songBuffer.duration
            } else {
                return 0;
            }
        }
    });

    Object.defineProperty(this, 'currentTime', {
        get: function () {
            return this.getCurrentTime() || 0;
        },
        set: function (t) {
            this.pause();
            this.startOffset = t;
            this.play();
        }
    });
    window.addEventListener('resize', this.resize);
};

AudioManage.prototype.pause = function () {
    this.playing = false;
    if (this.isIosDevice()) {
        this.playButton.textContent = '';
        this.iosPlaySymbol.style.visibility = 'visible';
        this.playButton.appendChild(this.iosPlaySymbol);
    } else {
        this.playButton.textContent = '▶';

    }
    if ($("#beat_play-controller").length > 0) {
        $("#beat_play-controller button").html('▶');
        $("#beat_play-controller .player__artist .status").html("PAUSED");
    }
    if (this.songSource) {
        this.songSource.stop(0);
    }
    this.startOffset += this.context.currentTime - this.startTime;
};

AudioManage.prototype.nextPlay = function () {
    if (this.no < Object.keys(window.BEAT.waveforms).length - 1) {
        for (var waveform in window.BEAT.waveforms) {
            if (window.BEAT.waveforms[waveform].playing) {
                window.BEAT.waveforms[waveform].pause();
            }
        }
        for (var waveform in window.BEAT.waveforms) {
            if (window.BEAT.waveforms[waveform].no == (this.no + 1)) {
                window.BEAT.waveforms[waveform].preparePlay();
            }
        }
    }
};

AudioManage.prototype.prevPlay = function () {
    if (this.no > 0) {
        for (var waveform in window.BEAT.waveforms) {
            if (window.BEAT.waveforms[waveform].playing) {
                window.BEAT.waveforms[waveform].pause();
            }
            if (window.BEAT.waveforms[waveform].no == (this.no - 1)) {
                window.BEAT.waveforms[waveform].preparePlay();
            }
        }
    }
};

AudioManage.prototype.changeVolume = function () {
    this.gainNode.gain.value = -1 + 2 * window.BEAT_VOLUME;
}

AudioManage.prototype.play = function() {
    for(var waveform in window.BEAT.waveforms)
    {
        console.log(window.BEAT.waveforms[waveform].playing);
        if(window.BEAT.waveforms[waveform].playing)
        {
            window.BEAT.waveforms[waveform].pause();
        }
    }

    this.playing = true;
    this.hasStarted = true;
    this.iosPlaySymbol.style.visibility = 'hidden';
    this.playButton.textContent = '||';
    if ($("#beat_play-controller").length > 0) {
        $("#beat_play-controller button").html('||');
        $("#beat_play-controller .player__artist .status").html("PLAYING");
    }
    this.startTime = this.context.currentTime;
    this.gainNode = this.context.createGain();
    this.songSource = this.context.createBufferSource();
    this.songSource.connect(this.gainNode);
    this.gainNode.connect(this.context.destination);
    this.gainNode.gain.value = -1 + 2 * window.BEAT_VOLUME * window.BEAT_VOLUME;
    this.songSource.connect(this.analyzer);
    this.songSource.buffer = this.songBuffer;
    this.songSource.connect(this.context.destination);
    this.songSource.start(0, this.startOffset % this.duration);

    window.currentSong = this.selector;
};

AudioManage.prototype.initUIStyle = function () {
    Object.assign(this.playButton.style, this.playButton_style);
    Object.assign(this.timeField.style, this.field_style);
    Object.assign(this.durationField.style, this.field_style);
    if (this.isIosDevice()) {
        this.playButton.appendChild(this.iosPlaySymbol);
    } else {
        if (this.playing)
            this.playButton.textContent = '||';
        else
            this.playButton.textContent = '▶';
    }
    this.playButton.classList.add('waveform-play');
    this.timeField.disabled = 'disabled';
    this.durationField.disabled = 'disabled';
    $(this.canvas).nextAll().remove();
    this.canvas.parentElement.appendChild(this.timeField);
    this.canvas.parentElement.appendChild(this.durationField);
    this.canvas.parentElement.appendChild(this.playButton);
};

AudioManage.prototype.initWaveform = function () {
    this.audio_visulization = new visualization(this);
    this.ready();
};

AudioManage.prototype.loadSong = function (url, songLoadedCallback) {
    songLoadedCallback = songLoadedCallback || null;

    var me = this;
    var request = new XMLHttpRequest();
    request.open('GET', url, true);
    request.responseType = 'arraybuffer';
    request.onload = function () {
        var arraybuffer = request.response;
        me.context.decodeAudioData(arraybuffer, function (buffer) {
            me.songBuffer = buffer;

            if (!me.audio_visulization) {
                me.audio_visulization = new visualization(me);
            }

            me.audio_visulization.repaint();
            me.ready();

            if (songLoadedCallback) {
                songLoadedCallback.call();
            }
        });
    };
    request.send();
};

AudioManage.prototype.getContext = function () {
    if (typeof ac !== 'undefined') {
        ac = ac;
    } else {
        ac = null;
    }
    if (!window.AudioContext && !window.webkitAudioContext) {
        console.warn('Web Audio API not supported in this browser');
    } else {
        ac = ac || new ( window.AudioContext || window.webkitAudioContext )();
    }
    return ac;
};
AudioManage.prototype.getIosSafeContext = function (desiredSampleRate) {
    if (typeof ac !== 'undefined') {
        ac = ac;
    } else {
        ac = null;
    }
    if (!window.AudioContext && !window.webkitAudioContext) {
        console.warn('Web Audio API not supported in this browser');
    } else {
        ac = ac || new ( window.AudioContext || window.webkitAudioContext )();
    }
    if (/(iPhone|iPad)/i.test(navigator.userAgent)) {
        ac.resume();
    }
    desiredSampleRate = typeof desiredSampleRate === 'number'
        ? desiredSampleRate
        : 44100

    // Check if hack is necessary. Only occurs in iOS6+ devices
    // and only when you first boot the iPhone, or play a audio/video
    // with a different sample rate
    if (/(iPhone|iPad)/i.test(navigator.userAgent) &&
        ac.sampleRate !== desiredSampleRate) {
        var buffer = ac.createBuffer(1, 1, desiredSampleRate)
        var dummy = ac.createBufferSource()
        dummy.buffer = buffer
        dummy.connect(ac.destination)
        dummy.start(0)
        dummy.disconnect()

        ac.close() // dispose old context
    }
    return ac;
};
AudioManage.prototype.formatTime = function (t) {
    var mm = Math.floor(t / 60);
    var ss = Math.floor(t % 60);
    if ((ss + '').length < 2) {
        ss = '0' + ss;
    }
    return mm + ':' + ss;
};
AudioManage.prototype.isMobileDevice = function () {
    if (/Android|webOS|iPhone|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
        return true;
    }
    return false;
};
AudioManage.prototype.isIosDevice = function () {
    if (/(iPhone|iPad)/i.test(navigator.userAgent)) {
        return true;
    }
    return false;
};
AudioManage.prototype.getCurrentTime = function () {
    var ct;

    if (!this.playing) {
        ct = this.startOffset;
    } else {
        ct = (this.context.currentTime - this.startTime + this.startOffset);
    }

    if (ct > this.duration) {
        ct = this.duration;
    }
    return ct;
};
AudioManage.prototype.drawTrackInfo = function () {
    var $artist_section = $("#beat_play-controller .player__artist");
    var $rating_section = $("#beat_play-controller .beat__ratings");
    var $critique_section = $("#beat_play-controller .player__critique");

    // Remove current info
    $artist_section.empty();
    $rating_section.empty();
    $critique_section.empty();

    $.get('/beats/' + this.id + '/track_info')
        .done(function (data) {
            $artist_section.html($(data).find(".artist-section").html());
            $rating_section.html($(data).find(".rating-section ul").html());
            $critique_section.html($(data).find(".critique-section").html());
        });
};