var SlackBotServer = {};

$(document).ready(function() {

  SlackBotServer.message = function(text) {
    $('#messages').fadeOut('slow', function() {
      $('#messages').fadeIn('slow').html(text)
    });
  };

  SlackBotServer.error = function(xhr) {
    try {
      var message;
      if (xhr.responseText) {
        var rc = JSON.parse(xhr.responseText);
        if (rc && rc.message) {
          message = rc.message;
          if (message == 'invalid_code') {
            message = 'The code returned from the OAuth workflow was invalid.'
          } else if (message == 'code_already_used') {
            message = 'The code returned from the OAuth workflow has already been used.'
          }
        }
      }

      SlackBotServer.message(message || xhr.statusText || xhr.responseText || 'Unexpected Error');

    } catch(err) {
      SlackBotServer.message(err.message);
    }
  };

  // Slack OAuth
  var code = $.url('?code')
  if (code) {
    SlackBotServer.message('Working, please wait ...');
    $('#register-top').hide();
    $('#register-bottom').hide();
    $.ajax({
      type: "POST",
      url: "/api/teams",
      data: {
        code: code
      },
      success: function(data) {
        SlackBotServer.message('Team successfully registered!<br><br>Invite <b>@missingkids</b> to a channel.');
      },
      error: SlackBotServer.error
    });
  }
});
