var hideOptions = function() {
    $('select#select_choose_subgenre option').show();
    $('select#select_choose_subgenre').each(function(index, select) {
        if (select.value) {
            return $('select#select_choose_subgenre option[value=\'' + select.value + '\']').hide();
        }
    });
    window.initSlider = function() {
        $('#new_upload_track [data-edit-slider]').slider({
            min: 0,
            max: 1,
            animate: 'slow',
            create: function(event, ui) {
                var streamable;
                streamable = $('input[id=\'track_streamable\']').prop('checked');
                if (streamable) {
                    event.target.lastChild.style.left = '100%';
                }
                console.log(streamable);
                if (streamable) {
                    return $('[data-edit-right] span').addClass('bold-text');
                } else {
                    return $('[data-edit-left] span').addClass('bold-text');
                }
            },
            slide: function(event, ui) {
                if (ui.value > 0) {
                    return $('input[id=\'track_streamable\']').prop('checked', true);
                } else {
                    return $('input[id=\'track_streamable\']').prop('checked', false);
                }
            }
        });
    };
};

Paloma.controller('Tracks', {
  // this code never runs
    edit: function() {
        $('span.select#first-subgenre').on('change', function() {
            $('span.select#second-subgenre').toggle();
        });

        $('form#new_upload_track').on('submit', function() {
            var $input = $('#inputFile');
            $input.removeAttr('required');
            $input.prop('required', $('img#image_upload_preview').attr('src') === '');
        });
        $('.form-track').parsley({
            successClass: 'has-success',
            errorClass: 'has-error'
        });
        $('select#select_choose_subgenre').on('change', function() {
            hideOptions();
        });
        initSlider();

        $('[data-edit-slider]').on('slidechange', function(e, ui) {
            if (ui.value === 0) {
                $('[data-edit-left] span').addClass('bold-text');
                $('[data-edit-right] span').removeClass('bold-text');
            } else {
                $('[data-edit-right] span').addClass('bold-text');
                $('[data-edit-left] span').removeClass('bold-text');
            }
        });
    }
});