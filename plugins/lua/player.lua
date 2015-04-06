util = util or {}

function util.SteamIDFrom64(id)
	if not id or not tonumber(id) then return end
	local steam64 = tonumber(string.sub(id, 2))
	local a = steam64 % 2 == 0 and 0 or 1
	local b = math.floor(math.abs(6561197960265728 - steam64 - a) / 2)
	return "STEAM_0:" .. a .. ":" .. (a == 1 and b -1 or b)
end

local allplayers = {}

local function GetAll()
	return allplayers
end

local function GetBySteamID(sid)
	for k,v in pairs(allplayers) do
		if v:SteamID() == sid then
			return v
		end
	end
end

local function GetBySteamID64(sid)
	for k,v in pairs(allplayers) do
		if v:SteamID64() == sid then
			return v
		end
	end
end

local function GetByIndex(i)
	return allplayers[i]
end

local REALPLAYER = {}

function REALPLAYER:Nick()
	return self.vars.name
end

function REALPLAYER:SteamID64()
	return self.vars.sid64
end

function REALPLAYER:SteamID()
	return self.vars.sid
end

function REALPLAYER:SetPData(key, val)
	local typ = type(val)
	if typ == "string" or typ == "boolean" or typ == "number" then
		cookie["PData_" .. self:SteamID() .. "_" .. key] = tostring(val)
	end
end

function REALPLAYER:GetPData(key, default)
	return cookie["PData_" .. self:SteamID() .. "_" .. key] or default
end

function REALPLAYER:RemovePData(key)
	cookie["PData_" .. self:SteamID() .. "_" .. key] = nil
end

local botsids = {
	[76561198004992117] = true,
	[76561198146767516] = true,
	[76561198096703994] = true,
}

function REALPLAYER:IsBot()
	return self.vars.isbot
end

REALPLAYER.__index = REALPLAYER
REALPLAYER.__metatable = FAKE_META

local PLAYER = {}
setmetatable(PLAYER, REALPLAYER)

function PLAYER:__index(k)
	return rawget(self, k) or PLAYER[k] or REALPLAYER[k] or nil
end

function PLAYER:__tostring() -- insecure
	return "Player " .. self:SteamID() .. " (" .. self:Nick() .. ")"
end

local function NewPlayer(name, sid)
	local self = {}
	local index = #allplayers + 1
	self.vars = {
		name = name or "",
		sid64 = sid or 0,
		sid = util.SteamIDFrom64(sid) or "",
		isbot = botsids[tonumber(sid)] or false,
		index = index,
	}
	setmetatable(self, PLAYER)
	allplayers[index] = self
	return self
end

local function DestroyPlayer(sid)
	local ply = GetBySteamID64(sid)
	if not ply then return end
	table.remove(allplayers, ply.index)
end

NewPlayer("#", 76561198004992117)

local registeredplayers = {}

hook.Add("Connected", "RegisterPlayers", function(name, sid)
	if GetBySteamID64(sid) then return end
	NewPlayer(name, sid)
	registeredplayers[sid] = true
end)

hook.Add("Message", "RegisterPlayers", function(name, sid, msg)
	if GetBySteamID64(sid) then return end
	NewPlayer(name, sid)
	registeredplayers[sid] = true
end)

hook.Add("Disconnected", "DeregisterPlayers", function(name, sid)
	if not GetBySteamID64(sid) then return end
	DestroyPlayer(sid)
	registeredplayers[sid] = nil
end)

return {
	GetAll = GetAll,
	GetBySteamID = GetBySteamID,
	GetBySteamID64 = GetBySteamID64,
	GetByIndex = GetByIndex
}
