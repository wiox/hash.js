bot.on( "Message", function( name, steamID, msg, group ) {
        if ( /\bxD?\b/.test( msg ) && steamID == "76561198093185405")
                bot.sendMessage( "Fuck off, " + name + "!", group );
} );
