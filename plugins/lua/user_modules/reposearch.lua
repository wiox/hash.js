local function encodeuri(s) -- http://www.lua.org/pil/20.3.html
	s = string.gsub(s, "([&=+%c])", function (c)
		return string.format("%%%02X", string.byte(c))
	end)
	s = string.gsub(s, " ", "+")
	return s
end

hook.Add("Message", "gmodrepo", function(name, sid, msg)
	if string.find(msg, "^?") and #string.gsub(msg, "?", "") > 0 then
		print("https://github.com/garrynewman/garrysmod/search?utf8=✓&q="..encodeuri(string.sub(msg, 2)))
	end
end)
