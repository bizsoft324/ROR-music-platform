$(document).on('turbolinks:load', function() {
    $('#profile-link').click();

    $('#slider-container').sliderUi({
        speed: 400,
        cssEasing: 'cubic-bezier(0.285, 1.015, 0.165, 1.000)'
    });

    $('#caption-slide').sliderUi({
        caption: true
    });

    $('#flexslider').flexslider({
        animation: 'fade',
        controlsContainer: '.flexslider'
    });
});
