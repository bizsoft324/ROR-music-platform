$(document).on('turbolinks:load', function () {
  $.onmount('[data-validate-create-account]', function() {

    var emailRegExp = /([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/;
    var passwordRegExp = /\S{8,}$/;
    var usernameRegExp = /^[a-zA-Z][-a-zA-Z0-9_.]{4,}$/;

    function validateInput(element, event, regexp) {
      $(document).on(event, element, function() {
        var test = regexp.test($(this).val());
        $(this).toggleClass('invalid', !test);
      })
    }

    validateInput('input#user_email', 'keyup', emailRegExp);
    validateInput('input#user_password', 'keyup', passwordRegExp);
    validateInput('input#user_username', 'keyup', usernameRegExp);

    $(document).on('keyup', 'input#user_password_confirmation', function(){
      var equal = $('input#user_password').val() == $(this).val();
      $(this).toggleClass('invalid', !equal);
    })

  });
});