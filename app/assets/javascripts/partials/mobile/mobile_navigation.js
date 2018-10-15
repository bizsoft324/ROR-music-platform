$(document).on('turbolinks:load', function (e) {
    $('#toggle-nav-menu').hammer().bind('tap',function (e) {
        e.preventDefault();

        $('#nav-menu').toggleClass('hide');
        $(this).toggleClass('is-active');
    });

    $('#toggle-user-menu').hammer().bind('tap',function (e) {
        e.preventDefault();

        $('#user-menu').fadeToggle(200);
        $(this).find('#user_thumbnail').toggleClass('is-active');
    });
});