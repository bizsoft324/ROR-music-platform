window.showFlash = function() {
    $.each($('#toastr_messages').data(), function(type, message) {
        var method = (function() {
            switch (type) {
                case 'notice':
                    return 'info';
                case 'danger':
                    return 'error';
                case 'alert':
                    return 'error';
            }
        })();
        toastr[method](message);
        $('#toastr_messages').removeData(type);
    });
};

$(document).on('turbolinks:load', function() {
    showFlash();
});
