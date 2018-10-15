$(document).on('turbolinks:load', function() {
    $.map(['.beats-critique-tab', '.beats-rating-tab'], function(tab, i) {
        $(tab).on('click touchstart touch', function() {
            var trackId = $(this).data('id');
            $(this).siblings().removeClass("is-active");
            $(this).toggleClass("is-active");
            $(tab + '-view[data-id=' + trackId + ']').siblings().removeClass("is-active");
            $(tab + '-view[data-id=' + trackId + ']').toggleClass("is-active");
        });
    });

    $.map(['.critique-tab', '.contact-tab', '.info-tab'], function(tab, i) {
        $(tab).on('click touchstart touch', function() {
            var trackId = $(this).data('id');
            $(this).siblings().removeClass("is-active");
            $(this).addClass("is-active");
            $(tab + '-view[data-id=' + trackId + ']').siblings().removeClass("is-active");
            $(tab + '-view[data-id=' + trackId + ']').addClass("is-active");
        });
    });

});
$(document).on('click touchstart touch', '.mobile-waveform-play', function() {
    var trackId    = $(this).data('id');
    var trackPlayer = $('.mobile-track-player[data-id=' + trackId + ']');
    trackPlayer.css('z-index', 100);
    trackPlayer.children('button.waveform-play:first').trigger('click');
    $(this).hide();
});

$(document).on('click touchstart touch', '#btn-expand-player', function() {
    $('#fixed-player-mobile-wrapper, #btn-expand-player').toggleClass('is-active');
});
