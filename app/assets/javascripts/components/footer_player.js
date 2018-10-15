'use strict';
var template = '<div class="player" id="beat_play-controller"><div class="columns is-gapless"><div class="column is-2-desktop player__artist mobile"></div><div class="column is-5-desktop player__play"><span class="player__time player__time--current">0:00</span>' + '<canvas height="40" class="player__canvas"></canvas><span class="player__time player__time--duration">0:00</span><button class="player__play-btn" style="left: 43px; top: 0px;">||</button></div><div class="column is-2-desktop player__artist"></div><div class="column is-5 player__controls"><ul class="player__list"><li><img class="player__prev-btn pointer" src="/images/pre-icon.png" alt="Pre icon"></li><li id="volume-popup"><label class="volume-icon"><img src="/images/volume-icon.png" alt="Volume icon"></label><div class="player__volume"><div id="slider-vertical"><div class="ui-slider-background"></div></div></div></li><li><img class="player__next-btn pointer" src="/images/next-icon.png" alt="Next icon"></li></ul><ul class="beat__ratings"></ul><h5 class="player__critique">CRITIQUES</h5></div><span class="collapse"><i class="fa fa-caret-up"></i><i class="fa fa-close"></i></span></div></div>';
function showFooterPlayer() {
    if (!jQuery.isEmptyObject(window.BEAT.waveforms)) {
        if ($('#beat_play-controller').length <= 0) {
            drawFrame();
            if (window.BEAT.waveforms[window.currentSong]) {
                console.log('newLoad');
                window.BEAT.waveforms[window.currentSong].drawTrackInfo();
            }
        }

        if (window.BEAT.waveforms[window.currentSong]) {
            if (window.BEAT.waveforms[window.currentSong].playing) {
                $("#beat_play-controller button").html('||');
            } else {
                $("#beat_play-controller button").html('▶');
            }
            window.BEAT.waveforms[window.currentSong].audio_visulization.drawFooterPlayer();

        }
    }
    else {
        if ($('#beat_play-controller').length > 0) {
            $('#beat_play-controller').remove();
        }
    }
}

function drawFrame() {
    var $body = $('body');
    if ($('#beat_play-controller').length <= 0) {
        $body.append($(template));
        var $controller = $('#beat_play-controller');

        $controller.find('#slider-vertical').slider({
            min: 0,
            max: 100,
            step: 10,
            orientation: 'vertical',
            value: window.BEAT_VOLUME * 100,
            range: 'min'
        }).on('slide', function (e, ui) {
            window.BEAT_VOLUME = ui.value / 100;
            window.BEAT.waveforms[window.currentSong] && window.BEAT.waveforms[window.currentSong].changeVolume();
        });

        var $canvas = $controller.find('canvas');
        if ($controller.find(' .player__play').is(':visible')) {
            $canvas[0].width = $controller.find('.player__play').width() - 120;
        } else {
            $canvas[0].width = $controller.find('.player__artist.mobile').width() - 120;
        }

        // Events

        $(document).on('click', 'canvas.player__canvas', function (e) {
            if (!window.BEAT.waveforms[window.currentSong].songBuffer) {
                window.BEAT.waveforms[window.currentSong].playButton.click();
            } else {
                var time = e.offsetX / e.target.width * window.BEAT.waveforms[window.currentSong].duration;
                window.BEAT.waveforms[window.currentSong].currentTime = time;
            }
        });

        $(document).on('click', 'button.player__play-btn', function(e) {
            window.BEAT.waveforms[window.currentSong].preparePlay()
        });

        $(document).on('click', 'img.player__prev-btn.pointer', function (e) {
            window.BEAT.waveforms[window.currentSong].prevPlay()
        });

        $(document).on('click', 'img.player__next-btn.pointer', function (e) {
            window.BEAT.waveforms[window.currentSong].nextPlay()
        });

        $(document).on('click', 'label.volume-icon', function (e) {
            $('div#beat_play-controller.player').find('.player__volume').toggle();
        });

        $(document).on('mousedown', function (e) {
            var container = $controller.find('#volume-popup');

            if (!container.is(e.target) && container.has(e.target).length === 0)
                $('div#beat_play-controller.player').find('.player__volume').hide();
        });

        $(document).on('click', '#beat_play-controller span.collapse', function (e) {
            $(this).toggleClass('on');
            $('div#beat_play-controller.player').find('.player__play').toggle('500');
        });

        // add padding at the bottom
        $body.addClass('padding-space');
    }
}

Object.defineProperty(window, 'currentSong', {
    get: function () {
        return this._currentSong || null;
    },
    set: function (cur) {

        if (this._currentSong != cur && cur != null) {
            console.log('newLoad' + cur);
            this._currentSong = cur;
            try {
                window.BEAT.waveforms[cur].drawTrackInfo()
            }
            catch (e) {
                console.log(cur);
                console.log(e);
            }
        }
        else {
            this._currentSong = cur;
        }

    }
});
