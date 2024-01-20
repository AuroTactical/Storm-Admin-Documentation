

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local PlayerOwnsAsset = MarketplaceService.PlayerOwnsAsset

local AssetIds = {18824203, 1567446, 93078560, 102611803}

-- # Uptime Calculator
-- # Player Value Setup


Players.PlayerAdded:Connect(function(plr)
	local isVerified = false

	for _, assetId in ipairs(AssetIds) do
		local success, result = pcall(PlayerOwnsAsset, MarketplaceService, plr, assetId)
		if success and result then
			isVerified = true
			break
		end
	end

	local success, result = pcall(function() return Players:GetFriendsAsync(plr.UserId) end)

	local joinTime = os.time() - (plr.AccountAge * 86400)
	local joinDate = os.date("!*t", joinTime)

	if success then
		local Friends = 0

		while true do
			Friends = Friends + #result:GetCurrentPage()
			if result.IsFinished then
				break
			else
				result:AdvanceToNextPageAsync()
			end
		end

		-- Create folder and set values
		local Folder = Instance.new("Folder")
		Folder.Name = "Information"
		Folder.Parent = Players:FindFirstChild(plr.Name)

		local AccountAge = Instance.new("NumberValue")
		AccountAge.Parent = Folder
		AccountAge.Value = plr.AccountAge
		AccountAge.Name = "AccountAge"

		local FriendsValue = Instance.new("NumberValue")
		FriendsValue.Parent = Folder
		FriendsValue.Value = Friends
		FriendsValue.Name = "FriendAmount"

		local Verified = Instance.new("BoolValue")
		Verified.Parent = Folder
		Verified.Value = isVerified
		Verified.Name = "Verified"

		local JoinDate = Instance.new("StringValue")
		JoinDate.Parent = Folder
		JoinDate.Value = string.format("%02d.%02d.%04d", joinDate.day, joinDate.month, joinDate.year)
		JoinDate.Name = "JoinDate"

	else
		warn (result)
	end
end)

isHttpEnabled = pcall(function()
	game:GetService("HttpService"):RequestAsync({Url = "example.com", Method = "POST"})
end)

print(isHttpEnabled)

-- # Server Values Setup

local Folder = Instance.new("Folder")
Folder.Parent = game:GetService("ReplicatedStorage")
Folder.Name = "Error_Server"

local Info = Instance.new("BoolValue")
Info.Parent = Folder
Info.Name = "HTTP_REQUESTs"
Info.Value = isHttpEnabled

local serverStartTime = tick()
local Uptime = Instance.new("StringValue")
Uptime.Parent = Folder
Uptime.Name = "Uptime"

while true do
	local currentTime = tick()
	local uptimeInSeconds = currentTime - serverStartTime

	local minutes = math.floor(uptimeInSeconds / 60)
	local seconds = math.floor(uptimeInSeconds % 60)
	local hours = math.floor(minutes / 60)
	local days = math.floor(hours / 24)
	local weeks = math.floor(days / 7)

	Uptime.Value = string.format("Uptime: %d weeks, %d days, %d hours, %d minutes, %d seconds", weeks, days % 7, hours % 24, minutes, seconds)

	wait(1)
end

