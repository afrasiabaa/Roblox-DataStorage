--[[
Programmer: WheatwithPineapple, (discord: owlwheatwithpineapple)
Date: 5/15/2025
Description: Module that handles the data of the player, this includes: saving, loading, and serializing the data.

Last Modified: 5/15/2025
]]

local DataHandler = {}

-- Services
local DataStoreService = game:GetService("DataStoreService")

-- Variables
local PlayerDataStore = DataStoreService:GetDataStore("PlayerDataStore")


-- Helper Functions
function GetPlayerData(player: Player) --> Returns the table of the players data
	assert(player:IsA("Player"), "Argument[1]: player, is not of type Player")

	local playerID = tostring(player.UserId)
	local playerData = nil

	local success, error = pcall(function()
		playerData = PlayerDataStore:GetAsync(tostring(playerID))
	end)

	return playerData

end

-- Functions
function DataHandler.SavePlayerData(player: Player)
	assert(player:IsA("Player"), "Argument[1]: player, is not of type Player")
	
	local playerID = tostring(player.UserId) -- We will save the data using the players UserID as the key.
	
	-- Data Tables
	local playerDataTable = {} -- Table that holds all data
	local playerInventory = {} -- Table that holds players inventory
	local playerLeaderStats = {} -- Table that holds players leaderstats
	
	for _, stat in pairs(player:WaitForChild("leaderstats"):GetChildren()) do -- Iterate through the players leaderstat folder and save it in a dictionary/hashmap
		playerLeaderStats[stat.Name] = stat.Value
	end
	
	playerDataTable["leaderstats"] = playerLeaderStats
	
	-- Implement the inventory serialization here.... --
	
	
	--------------------------------------------------
	
	local success, error = pcall(function()
		PlayerDataStore:SetAsync(playerID, playerDataTable)
	end)
	
end

function DataHandler.LoadPlayerData(player: Player) 
	assert(player:IsA("Player"), "Argument[1]: player, is not of type Player")
	
	-- Handle Player data logic here... --
	local playerData = GetPlayerData(player)
	
	if playerData then
		for statName, statValue in pairs(playerData["leaderstats"]) do
			local leaderStat = player:WaitForChild("leaderstats"):FindFirstChild(statName)
			if leaderStat then
				leaderStat.Value = statValue
			end
		end
		
	else
		-- Can add any sort of necessary code for new players.
		
	end
	
end

function DataHandler.PlayerHasData(player: Player) --> Returns true if player does have previous data, otherwise false.
	assert(player:IsA("Player"), "Argument[1]: player, is not of type Player")
	
	local isTrue = false -- Holds the value of the return
	local playerID = tostring(player.UserId)
	
	local success, error = pcall(function()
		if PlayerDataStore:GetAsync(playerID) then
			isTrue = true
		else
			isTrue = false
		end
	end)
	
	print(isTrue)
	return isTrue
	
end

return DataHandler
