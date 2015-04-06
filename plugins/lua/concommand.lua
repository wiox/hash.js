local commands = {}

local function GetTable()
	return commands
end

local function Add(name, func)
	commands[name] = func
end

hook.Add("Message", "Concommand", function(name, sid, msg)
	if string.sub(msg, 1, 1) ~= "!" then return end

	local cmd = string.sub(msg, 2)
	local space = string.find(cmd, " ")

	local argsstr
	if space then
		argsstr = string.sub(cmd, space + 1)
		cmd = string.sub(cmd, 1, space - 1)
	end

	if commands[cmd] then
		commands[cmd](player.GetBySteamID64(sid), argsstr)
	else
		print("Unknown concommand '"..cmd.."'")
	end
end)

local function Remove(name)
	commands[name] = nil
end

return {
	GetTable	= GetTable,
	Add			= Add,
	Remove		= Remove
}
