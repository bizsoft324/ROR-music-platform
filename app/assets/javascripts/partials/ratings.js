$(document).on('click', '[data-rating]', function(e) {
    e.preventDefault();
    e.stopImmediatePropagation();
    var current_target = $(this);

    var id          = $(this).attr('id');
    var type        = $(this).data('rating');
    var href        = $(this).attr('href');
    var disabled    = $(this).hasClass('disabled');

    var $target = $('a.image_' + id + '.disabled');

    $target.toggleClass('disabled', disabled);

    $('a[data-image="' + id + '"][data-rating="' + type + '"]').toggleClass('disabled', !disabled);

    $.ajax({
        url: href,
        method: 'GET',
        success: function(data) {

            if(data.error) {
                $('a.image_' + id + '.disabled').toggleClass('disabled');
                current_target.popover({
                    html: true,
                    content: '<div class="popup popup__rating"><div class="popup__body"><p class="popup__alert"><i class="uk-icon-exclamation-triangle"></i>You must be logged in to do that.</p><div class="popup__create-btn"><a data-remote="true" href="/signup">create account</a></div><div class="popup__log-in"><a data-remote="true" href="/signin">log in</a></div></div></div>',
                    placement: "auto top",
                    trigger: "focus",
                    delay: {show: 0, hide: 300}
                }).popover('toggle');

            } else {
                change_emojis(id);
                total_likes(data, id);
            }

        },
        error: function(data) {
            console.log(data);
        }
    });

});
var change_emojis = function(id) {
    $('[data-image="' + id + '"]').each(function() {
        var svg = $(this).find('svg');
        var emoji = $(this).data('rating');
        var disabled = $(this).hasClass('disabled');
        svg.toggleClass(emoji, !disabled);
    });
};

var total_likes = function(data, id) {
    $('*[id=like_' + id + ']').text(data.likes);
    $('*[id=indifferent_' + id + ']').text(data.indifference);
    $('*[id=dislike_' + id + ']').text(data.dislikes);
};