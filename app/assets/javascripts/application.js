//= require jquery3
//= require turbolinks
//= require thredded
//= require jquery.turbolinks.compatibility.coffee
//= require jquery-ui
//= require jquery_ujs
//= require hammer
//= require jquery.hammer
//= require dataTables/jquery.dataTables
//= require jquery_ufujs
//= require jquery.atwho
//= require application_vendor
//= require paloma
//= require bootstrap-slider
//= require bootstrap/bootstrap-rails-tooltip
//= require bootstrap/bootstrap-rails-popover
//= require logs
//= require_tree ./components
//= require_tree ./behaviors
//= require_tree ./mobile
//= require_tree ./partials
//= require_tree ./pages


'use strict';



$(document).on('turbolinks:load', function () {
    window.currentSong = window.currentSong || null;
    window.BEAT_VOLUME = 1;
    wait_and_run = (function () {
        var timer = 0;

        return function (callback, ms) {
            clearTimeout(timer);
            timer = setTimeout(callback, ms);
        }
    })();

    initPlayers = function () {
        wait_and_run(window.waves.waveform_proc(), 500);
        $(document).on('turbolinks:load', function () {
            wait_and_run(window.waves.waveform_proc(), 500);
        });
    };

    toggleCritiqueBox = function (toggle) {
        var id = window.critiques_id;
        if(toggle == 'show') {
            window.CANDIDATE_BEAT.waveforms[id].canvas = document.querySelector('#critiques #' + id);

        } else {
            $('#lazy_body').empty();
            window.CANDIDATE_BEAT.waveforms[id].canvas = document.querySelector('#' + id);
            window.critiques_id = null;
        }

        var me = window.CANDIDATE_BEAT.waveforms[id];
        me.initUIStyle();

        // Only show line graph on desktop
        if (!AudioManage.prototype.isMobileDevice()) {

            if (me.audio_visulization) {
                me.audio_visulization.audioManager = me;
                me.audio_visulization.ctx= me.canvas.getContext( '2d' );
                me.ready();
            }
            else {
                me.initWaveform();
            }
        }
    };


    moveCanToCur = function() {
        console.log('moveCanToCur');

        for (var waveform in window.BEAT.waveforms){
         if(!window.CANDIDATE_BEAT.waveforms[waveform]){
             window.BEAT.waveforms[waveform] = {};
             delete window.BEAT.waveforms[waveform];
         }
        }
        for(var waveform in window.CANDIDATE_BEAT.waveforms){
            if(!window.BEAT.waveforms[waveform]){
                window.BEAT.waveforms[waveform] = window.CANDIDATE_BEAT.waveforms[waveform]; //need clone object?
            }
            else {
                window.BEAT.waveforms[waveform].no = window.CANDIDATE_BEAT.waveforms[waveform].no;
            }
        }
    };

    $(document).on('click', '#lazy_close', function(){
        if(window.critiques_id != null) {
            toggleCritiqueBox("hide");
        }
    });

    console.log('onmount');
    $.onmount();

    $('img').unveil(100);

    window.BEAT =  window.BEAT || {};
    window.waves = window.waves || {};
    window.BEAT.waveforms = window.BEAT.waveforms || {};
    window.CANDIDATE_BEAT = {};

    window.waves.waveform_proc = function () {
        console.log('waveform_proc');
        delete window.CANDIDATE_BEAT.waveforms;
        window.CANDIDATE_BEAT.waveforms = {};
        var unloadedPlayers = $(document).find('div#beat');


        $.each(unloadedPlayers, function (i, k) {
            try {
                var $self = $(this);

                    if ($self.is(':visible')) {
                        $self.attr('data-done', true);

                        var waveformProcData    = $self.find('div#waveform-proc');
                        if(!window.BEAT.waveforms[waveformProcData.data('id')]) {
                            var $beatsContent = $self.find('div.beats-show');
                            var $beatBackground = $beatsContent.find('img');
                            var url = waveformProcData.data('url');
                            var audio = new AudioManage($self.data('id'), waveformProcData.data('id'), waveformProcData.data('waveform'), url);
                            window.CANDIDATE_BEAT.waveforms[waveformProcData.data('id')] = audio;
                            audio.initUIStyle();

                            // Only show line graph on desktop
                            if (!AudioManage.prototype.isMobileDevice()) {
                                audio.initWaveform();
                            }

                            audio.playButton.addEventListener('click', function (e) {
                                //TO-DO: replace current playlist with showing songs
                                if(!window.BEAT.waveforms[audio.selector]) {
                                    if (window.BEAT.waveforms[window.currentSong] && window.BEAT.waveforms[window.currentSong].playing) {
                                        window.BEAT.waveforms[window.currentSong].pause();
                                    }
                                    moveCanToCur();
                                    showFooterPlayer();
                                }

                                audio.preparePlay();

                                if (AudioManage.prototype.isMobileDevice()) {
                                    audio.initWaveform();
                                    $beatBackground.hide();
                                    var current_track_element = $(this).parent()[0];
                                    var req_url = '/update_player/' + $(current_track_element).data('id');
                                    $.ajax({
                                        type: 'GET',
                                        url: req_url
                                    });
                                }

                            });
                        }
                        else {
                            var me = window.BEAT.waveforms[waveformProcData.data('id')];
                            me.canvas = document.querySelector('#' + waveformProcData.data('id'));
                            window.CANDIDATE_BEAT.waveforms[waveformProcData.data('id')] = me; //need clone object?
                            me = window.CANDIDATE_BEAT.waveforms[waveformProcData.data('id')];
                            me.initUIStyle();

                            // Only show line graph on desktop
                            if (!AudioManage.prototype.isMobileDevice()) {

                                if (me.audio_visulization) {
                                    me.audio_visulization.audioManager = me;
                                    me.audio_visulization.ctx= me.canvas.getContext( '2d' );
                                    me.ready();
                                }
                                else {
                                    me.initWaveform();
                                }
                            }
                        }
                        window.CANDIDATE_BEAT.waveforms[waveformProcData.data('id')].no = Object.keys(window.CANDIDATE_BEAT.waveforms).length-1;
                    }
            } catch (e) {
                console.log(e);
            }
        });
        showFooterPlayer();
    };


    // components

    $('#data-admin').dataTable({
        processing: true,
        serverSide: true,
        ajax: $(this).data('source')
    });

    $(document).on('click', '#play-btn-1', function () {
        var my_id = (this.id);
        $('#beat_' + my_id).toggle();
    });


    $(document).on('change', ':file', function () {
        if (this.files && this.files[0]) {
            var reader = new FileReader();
            var $spinner = $('#spinner_2');

            $spinner.show();
            reader.onload = function (e) {
                $('#existedImage').attr('src', e.target.result);
                $spinner.hide();
            };

            reader.readAsDataURL(this.files[0]);
        }
    });

    $(document).on('click', '#existedImage', function () {
        $('#profilePicture').trigger('click');
    });

    Paloma.start();
});

// runs google analytics on page load
document.addEventListener('turbolinks:load', function(event) {
  if (typeof ga === 'function') {
    console.log('google analytics loading' + ga)
    ga('set', 'location', event.data.url);
    ga('send', 'pageview');
  }
});
