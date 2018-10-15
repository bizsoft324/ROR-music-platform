$(document).on('turbolinks:load', function() {
    $(document).on('click', '#social-share-close', function(e) {
        $.lazybox.close();
    });

    $(document).on('click', '[data-share-button]', function(e) {
        e.preventDefault();
        window.open(this.href, '', "height=100% width=600  resizable=yes scrollbars=yes");
    });
});