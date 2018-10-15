$(document).on('turbolinks:load', function () {
  $(document).on('click', '#envelope_button', function () {
    $('#form_create_account').removeClass('hide');
    $('#logins').addClass('hide');
  });

  $(document).on('click', '#twitter_sign_up_form a', function () {
    $('#twitter_sign_up_form [data-active="true"] input').each(function (index) {
      $(this).parsley().validate();
    });

    var errors = $('#twitter_sign_up_form .parsley-errors-list li');

    if (!errors.length) {
      var currentForm = $(this).parent('.profile-form');
      var nextForm    = currentForm.next('.profile-form');

      currentForm.attr('data-active', 'false');
      nextForm.attr('data-active', 'true');

      currentForm.addClass('hide');
      nextForm.removeClass('hide');
    }

  });

  $(document).on('click', '#form_create_account .next-form', function () {
    $('#form_create_account [data-active="true"] input').each(function (index) {
      $(this).parsley().validate();
    });

    var errors = $('[data-active="true"] li');


    if (!errors.length) {
      currentForm = $(this).not('button.next-form').parent('[data-active]');
      nextForm    = currentForm.next('[data-active]');

      currentForm.addClass('hide').attr('data-active', 'false');
      nextForm.removeClass('hide').attr('data-active', 'true');
      $('#sign-up-form').parsley().reset();
    }
  });
});