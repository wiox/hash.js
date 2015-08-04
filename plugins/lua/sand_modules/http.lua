
local tostring    = require "stostring"
local scall       = require "scall"
local callbacks = {}

local i = 1;

function HTTPCallback ( id, code, body, err )
    error"ayy";
    print("CALLBACK "..id);
    if ( not callbacks[id] ) then
        return;
    end
    
    local callback = callbacks[id]
    
    callbacks[id] = nil
    
    local returns = { scall ( callback ( code, body, err ) ) }
    
end


local function HTTP ( url, callback )
    
	assert( type(url) == "string", 
        "bad argument #1 to 'HTTP' (string expected, got " .. type( url ) .. ")",
         2
     )
    
    callbacks[i] = callback
    
    writepacket ( CreatePacket ( tostring(i)..":_", "H") .. tostring(url) )
    writepacket ( EOF )
    
    i = i + 1;
    
end

return {
    Fetch = HTTP,
}