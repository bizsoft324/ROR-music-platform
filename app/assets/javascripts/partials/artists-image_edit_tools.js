$(document).on('turbolinks:load', function() {
    $(document).on('click', '#open_edit_tool', function(e) {
        e.preventDefault();

        $('#open_edit_tool').hide();
        $('#background_edit').show();
    });

    $(document).on('click', '#btn_cancel', function(e) {
        e.preventDefault();

        $('#background_edit').hide();
        $('#open_edit_tool').show();
    });
});
