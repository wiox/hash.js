local function random(len) -- credit to swad I guess
	local out = ""
	for i = 1, len or 11 do
		local r = math.random(1, 3)
		if r == 1 then
			out = out .. string.char(math.random(97, 122))
		elseif r == 2 then
			out = out .. string.char(math.random(65, 90))
		else
			out = out .. string.char(math.random(48, 57))
		end
	end
	return out
end

local function urlencode(str)
	return (string.gsub(str, "([^%w%-%_%.%~])", function(c)
		return string.format("%%%02X", string.byte(c))
	end))
end

local apikey = "AIzaSyBdNHtSytlHao_L5l_dPe-FByVapmKzd0U" -- idgaf; registered as GLua Chat YouTube or something

yt = {}

local vidbase = "http://youtube.com/watch?v="

function yt.RandomVideo(str, retry, isretry)
	retry = retry or (not str)
	isretry = isretry or false
	math.randomseed(os.time())
	local randomstr = str or random(math.random(3, 24))
	local url = "https://www.googleapis.com/youtube/v3/search?key=" .. apikey .. "&part=snippet&type=video&maxResults=50&q=" .. urlencode(randomstr)
	http.Fetch(url, function(c, b)
		if (c ~= "200" and c ~= 200) then print("HTTP Error: " .. c) return end
		local data = json.decode(b)
		if not (data.items and #data.items > 0) then if not isretry then print("Result error or no items (not data.items)", retry and "retrying until we find one..." or nil) end if retry then yt.RandomVideo(str, retry, true) end return end
		local vid = data.items[math.random(1, #data.items)]
		print(vidbase .. vid.id.videoId .. " (str=" .. randomstr .. "\n" .. vid.snippet.title)
	end)
end
