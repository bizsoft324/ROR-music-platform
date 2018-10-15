// for critiques to send
function send_comment(id, isFromFixedForm) {
  $('#err_'+id).html(''); // .hide()?
  $('#send_'+id).html('Sending');
  if(isFromFixedForm) {
    send_from_fixed_player(id);
  }
  else {
    send_from_tab(id);
  }
}

function send_from_tab(id) {
  var data = $('#form_'+id).serialize();
  $.ajax({
    url: '/comments' ,
    method: 'POST',
    data: data,
    dataType: 'JSON',
    success: function(data) {
      critique_success(data,id);
    },
    error: function(data) {
      console.log(data);
      critique_error(data,id);
    }
  });
}

function send_from_fixed_player(id) {
  var data = $('#form_'+id+'_fixed').serialize();
  $.ajax({
    url: '/comments' ,
    method: 'POST',
    data: data,
    dataType: 'JSON',
    success: function(data) {
      update_comments_section(id);
    },
    error: function(data) {
      fixed_form_critique_error(data,id);
    }
  });
}

function update_comments_section(id) {
  $("#form_"+id+"_fixed").trigger("reset");
}

function fixed_form_critique_error(data, id) {
  fixedTextarea = $("[data-fixed-textarea='"+id+"']");
  fixedTextarea.toggleClass('textarea-error');
  fixedTextarea.attr('placeholder', 'Gotta write something..');
  fixedTextarea.one('keypress',function(){
    $(this).toggleClass('textarea-error');
  });
}

function critique_success(data, id) {
  $('#form_'+id).addClass('hide');
  $('#send_'+id).remove();
  $('#detail_'+id).removeClass('hide').prepend("<p>Critique Sent!</p>");
  return false;
}

function critique_error(data, id) {
  $('#send_'+id).html('Send');
  var error = JSON.parse(data.responseText).errors.body;
  $('#err_'+id).prepend(error);
  return false;
}
// for critiques to send
