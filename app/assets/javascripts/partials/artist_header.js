$(document).on('turbolinks:load', function() {
    $(document).on('scroll', function(e) {
        var $header = $('#artist_header_2');
        if (($header.length)) {
            if ($(window).scrollTop() > 300) {
                $header.addClass('fixed-header');
            } else {
                $header.removeClass('fixed-header');
            }
            var getHeightHeader = $header.height();

            var $beatsContainer = $('#artist_beats_public');
            if ($(window).scrollTop() > 400) {
                $beatsContainer.addClass('filter-row-fixed');
                $beatsContainer.find('#is_clearfix').addClass('container');
                $beatsContainer.find('#filter_row').css('top', getHeightHeader);
            } else {
                $beatsContainer.removeClass('filter-row-fixed');
                $beatsContainer.find('#is_clearfix').removeClass('container');
            }
        }
    });
});
