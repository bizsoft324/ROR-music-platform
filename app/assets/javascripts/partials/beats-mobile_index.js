$(document).on('turbolinks:load', function() {
    $('#toggle-filter').click(function() {
        $(this).toggleClass('is-active');
        $('#filter-menu').toggleClass('is-active');
        $('html, body').toggleClass('has-overflow-hidden');
    });
});
