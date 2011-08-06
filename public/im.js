var myId = '';
var chatroom = getParameterByName('chatroom');
var username = getParameterByName('username');

var PHONO_OPTIONS = {
    apiKey: "6e442b984dfa26cd102423b7bc5aaebd",
    onReady: function() {
    $("#message")[0].disabled = false;
    $("#message").focus();
	myId = this.sessionId;
	
	// send hello message to register jid on tropo
	var sendmsg = myId + ':' + username + ':' + chatroom + ':joined';
	phono.messaging.send('github@tropo.im', sendmsg);
    addInteraction('Me', 'joined', 'client');

    },
    messaging: {
    onMessage: function(event) {
		var themsg = event.message.body;
		// message is colon delimited username:the message
		var thenewmsg = new Array();
		thenewmsg = themsg.split(':');
		if(thenewmsg[0] != username){
        	addInteraction(thenewmsg[0], thenewmsg[1], 'server');
		}
    }
    }
};
 
var phono = $.phono(PHONO_OPTIONS);

function processKey(event) {
  if (event.keyCode == 13) {
      sendMessage();
      return false;
  } else {
      return true;
  }
}
 
function sendMessage() {
    var msg = $('#message').val();
    if (msg == '') return;
 
	var sendmsg = myId + ':' + username + ':' + chatroom + ':' + msg;

    $('#message').val("");
    phono.messaging.send('github@tropo.im', sendmsg);
    addInteraction('Me', msg, 'client');
}

function addInteraction(who, msg, cls) {
    var dialogDiv = $('#dialog');
    dialogDiv.append($("<div class='msg_" + cls + "'><b>"
                       + who + ":</b> " + msg + "</div>"));
    dialogDiv[0].scrollTop = dialogDiv[0].scrollHeight;
}

function getParameterByName(name) {

    var match = RegExp('[?&]' + name + '=([^&]*)')
                    .exec(window.location.search);

    return match && decodeURIComponent(match[1].replace(/\+/g, ' '));

}
