var request     = require('request');
var key = "AIzaSyA8OmKcw2DMNkJicyCJ0vqvf90xgeH52zE";

var String_Prototype_Repeat_Is_NonStandard = [
	"✩✩✩✩✩",
	"★✩✩✩✩",
	"★★✩✩✩",
	"★★★✩✩",
	"★★★★✩",
	"★★★★★"
];

bot.on( "Message", function( name, steamID, msg, group ) {

	var match = msg.match( /(youtube\.com\/watch\?v=|youtu\.be\/)([A-Z0-9-_]+)/i );

	if ( !match )
		return;

	request( "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&prettyPrint=false&maxResults=1&key=" + key + "&id=" + match[2], function( error, response, body ) {

		if ( error )
			return; // Fuck Node

		var data = JSON.parse( body );

		var likeCount = parseInt(data.items[0].statistics.likeCount);
		var dislikeCount = parseInt(data.items[0].statistics.dislikeCount);

        if ( !data.items || !data.items[0] || !data.items[0].snippet || !data.items[0].statistics || !likeCount || !dislikeCount || !data.items[0].snippet.title )
			return; // Fuck YouTube

		var starCount = Math.round(5 * (likeCount / (likeCount + dislikeCount)));
		starCount = Math.min(Math.max(starCount, 0), 5);

		bot.sendMessage( "YouTube: " + data.items[0].snippet.title + " [" + String_Prototype_Repeat_Is_NonStandard[ starCount ] + "]", group );

	} );
} );
