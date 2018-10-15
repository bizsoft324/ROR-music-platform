$(document).on('turbolinks:load', function() {
    var $fixedWrap = $('#fixed_wrapper');

    if ($fixedWrap.length) {
        var w_height = $(window).height();
        if (w_height <= 500) {
            $fixedWrap.css('position', 'static');
            $('#cover_background').css('minHeight', w_height);
        } else {
            $fixedWrap.css('position', 'fixed');
            $('#cover_background').css('height', w_height);
        }
    }

    $(document).on('keyup', '[data-live]', function(e) {
        var $this       = $(this);
        var count       = $this.val().length;
        var trackId     = $this.data('live');
        var counter     = $('[data-count="' + trackId + '"]');
        counter.text(count);
        counter.toggleClass('beat-menu__counter--green', count >= 1);
    });
});