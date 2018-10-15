$.lazybox("<%= j(render 'form') %>")
$('#password_reset').parsley({successClass: "has-success", errorClass: "has-error"});
$(document).on 'click', '#password_reset .next-form', -> $('span.error').remove()
