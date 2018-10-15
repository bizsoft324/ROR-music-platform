// Vertical Slider
$(document).on('turbolinks:load', function () {
    var $slider = $('#slider-vertical');
    // if ( !$slider.length ) {
    //     console.log('No slider found!');
    //     return;
    // }

    $slider.slider({
        orientation: 'vertical',
        range: 'min',
        min: 0,
        max: 100,
        value: 60,
        slide: function (event, ui) {
            $('#amount').val(ui.value);
        }
    });

    $('#amount').val($('#slider-vertical').slider('value'));
});