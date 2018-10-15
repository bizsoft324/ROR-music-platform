Paloma.controller('Artists', {
    track_list: function() {
        var $trackOrder = $('#tracks_order');

        $trackOrder.on('change', function() {
            $.ajax({
                url: window.location.pathname,
                type: 'GET',
                dataType: 'script',
                data: { order: $trackOrder.find('option:selected').val() }
            });
        });

        initPlayers();

        window.initSlider = function() {
            $('[data-edit-share] [data-edit-slider]').slider({
                min: 0,
                max: 1,
                animate: 'slow',
                create: function(event, ui) {
                    var value;
                    value = event.target.parentElement.getAttribute('data-slider');
                    if (value === '1') {
                        event.target.firstChild.style.left = '100%';
                    }
                    if (value === '0') {
                        return $(this).parent().prev().find('span').addClass('bold-text');
                    } else {
                        return $(this).parent().next().find('span').addClass('bold-text');
                    }
                },
                slide: function(event, ui) {
                    if ($(ui.handle).hasClass('ui-state-hover')) return;

                    var streamable  = ui.value > 0;
                    var id          = event.target.parentElement.getAttribute('data-id');
                    $.ajax({
                        url: '/tracks/' + id,
                        dataType: 'json',
                        type: 'PUT',
                        data: { track: { streamable: streamable } }
                    });
                }
            });
        };

        initSlider();

        $('[data-edit-slider]').on('slidechange', function(e, ui) {
            if (ui.value === 0) {
                $(this).parent().prev().find('span').addClass('bold-text');
                return $(this).parent().next().find('span').removeClass('bold-text');
            } else {
                $(this).parent().next().find('span').addClass('bold-text');
                return $(this).parent().prev().find('span').removeClass('bold-text');
            }
        });
    }

});
