$(document).on('turbolinks:load', function() {

    $(document).on('DOMSubtreeModified', '[data-attr]', function(e) {
        $('[name="user[' + ($(this).data('attr')) + ']"]').val($(this).text());
    });

    $(document).on('change', '#user_country', function(e) {
        $('[data-select]').text($(this).val());
    }
    );
    $(document).on('change', '#inputFile', function(e) {
        readURL(this);
    });

    $(document).on('click', '[data-label]', function(e) {
        $('[data-attr="' + ($(this).data('label')) + '"]').focus();
    });

    $(document).on('keyup', '[data-link]', function(e) {
        var social  = $(this).val().match(/.*\:\/\/(?:www|plus.)?([^\.]+)/)[1];
        var count   = $(this).data('link');
        $('[data-social=' + count + '] [data-icon]')[0].className = 'uk-icon-' + social;
        $('[data-social=' + count + '] [data-background]')[0].className = social;
    });
    $(document).on('click', '[data-add]', function(e) {
        $('.profile__social--hidden')[0].className = 'profile__social';
    }
    );
    $(document).on('click', '[data-trash]', function(e) {
        var count = $(this).data('trash');
        $('[data-social=' + count + '] [data-link]')[0].value = '';
        $('[data-social=' + count + '] [data-label]')[0].value = '';
        $('[data-social=' + count + '] [data-icon]')[0].className = 'uk-icon';
        $('[data-social=' + count + '] [data-background]')[0].className = '';
        $('[data-social=' + count + ']').addClass('profile__social--hidden');
    });
});
