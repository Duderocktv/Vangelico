ESX = nil
local ServerSideJewelryCase = nil 
local robberyStart = 0
local closeJewelry = false 
local isClosed = false 
local ServerSideFrontDoorsLocked = true 
local ServerSideFrontDoorsHacked = false 
local ServerSideSafeBeingUsed = false 
local ServerSideSafeUnlocked = false
local ServerSideVangelicoOnCooldown = false
local PoliceNotified = false 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getnumberofcops()
    local cops = 0
    local OnlinePolice = {}
    OnlinePolice =  GetPoliceForce() 
    for k, PoliceOfficer in pairs(OnlinePolice) do
        cops = cops + 1
    end  
    return cops
end 

function UpdateClientSide()  
	TriggerClientEvent('vangelico:SetJewelryCaseState', -1, ServerSideJewelryCase, ServerSideFrontDoorsLocked, ServerSideFrontDoorsHacked, ServerSideSafeBeingUsed, ServerSideSafeUnlocked, ServerSideVangelicoOnCooldown)  
end

function setJewelryCasestate()  
	local JewelryCases = nil
	local canrob = false 
	if JewelryCases == nil then
		JewelryCases = vangelico.CasePositions
	end 
	local cops = getnumberofcops()
	
	--if(cops >= vangelico.MinPoliceOnline)then  
		canrob = true  
	--end   

	for k,v in pairs(JewelryCases) do
		if canrob == true then 
			v.isOpen = false
		else
			v.isOpen = true 
		end
	end 

	ServerSideJewelryCase = JewelryCases
end  

function NotifyPolice()
	if PoliceNotified == false then 
		TriggerEvent('police:jewlerystore', _source)
		PoliceNotified = true
	end 
end 

RegisterServerEvent('vangelico:GetCaseState')
AddEventHandler('vangelico:GetCaseState', function()   
	if ServerSideJewelryCase == nil then 
		setJewelryCasestate()  
	end 
	UpdateClientSide()
end)

--Server Side Front Doors Unlocked
RegisterServerEvent('vangelico:UnlockFrontDoors')
AddEventHandler('vangelico:UnlockFrontDoors', function()   
	ServerSideFrontDoorsLocked = false
	robberyStart = os.time()
	UpdateClientSide()
end)

RegisterServerEvent('vangelico:NotifyPolice')
AddEventHandler('vangelico:NotifyPolice', function()   
	NotifyPolice()
end)

ESX.RegisterServerCallback('vangelico:CheckCase', function(source, cb, index) 
	local CaseIsOpen

	for k,v in pairs(ServerSideJewelryCase) do
		if k == index then  
			CaseIsOpen = v.isOpen 
			break
		end 
	end 

 	cb(CaseIsOpen )

end) 

-- Server Side Case Breaking Function
RegisterServerEvent('vangelico:CaseSmashed')
AddEventHandler('vangelico:CaseSmashed', function(index)
	local _source = source 
	xPlayer = ESX.GetPlayerFromId(_source)
	local rewarded = 0

	while rewarded < 1 do 
		for k, reward in pairs(vangelico.LootTable) do
			local chance = math.random(1, 100)
			if chance < reward.dropchance then 
				local lootamount = math.random(reward.minamount, reward.maxamount)
				xPlayer.addInventoryItem(reward.type, lootamount)
				rewarded = rewarded + 1
			end 
		end 
	end 
  
	for k,v in pairs(ServerSideJewelryCase) do
		if k == index then  
			v.isOpen = true 
			v.lastrobbed = os.time()
			robberyStart = os.time()
			break
		end 
	end 
	local ped = GetPlayerPed(_source)
	local coords = GetEntityCoords(ped)  
	UpdateClientSide()
end)

-- Server Side Safe Functions
ESX.RegisterServerCallback('vangelico:GetSafeState', function(source,cb) 
	  
	cb({
		SafeUnlocked = ServerSideSafeUnlocked, 
		SafeInuse = ServerSideSafeBeingUsed
	})

end) 

RegisterServerEvent('vangelico:SetSafeInuse')
AddEventHandler('vangelico:SetSafeInuse', function( ) 
	ServerSideSafeBeingUsed = true 
	ServerSideSafeUnlocked = true 
	robberyStart = os.time()
	UpdateClientSide() 
end) 

-- Serverside Hacking Functions
RegisterServerEvent('vangelico:DoorHacked')
AddEventHandler('vangelico:DoorHacked', function()  
	ServerSideFrontDoorsHacked = true 
	robberyStart = os.time()
	UpdateClientSide()
end)

RegisterServerEvent('vangelico:hackFrontDoors')
AddEventHandler('vangelico:hackFrontDoors', function() 
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)  
	if getnumberofcops() >= vangelico.MinPoliceOnline then 
		if xPlayer.getInventoryItem(vangelico.HackingDeviceDBName).count >= 1 then 
			
			TriggerClientEvent('esx:showNotification', _source, 'Hacking in progress, do not move.')

			local HackingAlarm = math.random(1,100) 

			if HackingAlarm <= vangelico.ChanceToTriggerAlarmWhileHacking then
				NotifyPolice()
			end
			TriggerClientEvent('vangelico:currentlyhacking', _source)  
			xPlayer.removeInventoryItem(vangelico.HackingDeviceDBName, 1)
		else
			TriggerClientEvent('esx:showNotification', _source, 'You need a hacking device to hack this panel.')
		end
	else
		TriggerClientEvent('esx:showNotification', _source, 'There are not enough police in the city.')
	end 
end) 
  
-- Police Count
RegisterServerEvent('vangelico:checkCops' ,  function(source, cb)   
	local _source = source 
	local retvalue = 0   
 
	local cops = getnumberofcops()
	
	if(cops >= vangelico.MinPoliceOnline)then  
		retvalue = 1  
	end   
  	cb(retvalue) 
end)

-- Police Actions
RegisterServerEvent('vangelico:SecureBuilding')
AddEventHandler('vangelico:SecureBuilding', function()  
	ServerSideVangelicoOnCooldown = true 
	robberyStart = os.time()
	UpdateClientSide() 
end)
  
--Loop for Jewelry Robbery 
Citizen.CreateThread(function() 
	while true do	  
		local TenMinutes = 600 
		local ElevenMinutes = 660 
		local FiveMinutes = 300 
		local SixMinutes = 360 
		local ThirtySeconds = 30 
		
		Citizen.Wait(ThirtySeconds)
		if (os.time() - robberyStart) > vangelico.RefreshTimer or robberyStart == 0 then   
			closeJewelry = false 
			isClosed = false  
			ServerSideFrontDoorsLocked = true 
			ServerSideFrontDoorsHacked = false 
			ServerSideSafeBeingUsed = false 
			ServerSideSafeUnlocked = false
			ServerSideVangelicoOnCooldown = false
			PoliceNotified = false

			if ServerSideJewelryCase == nil then 
				setJewelryCasestate()  
			end 

			local canrob = false 
			if JewelryCases == nil then
				JewelryCases = vangelico.CasePositions
			end 
			local cops = getnumberofcops()
			
			--if(cops >= vangelico.MinPoliceOnline)then 
				canrob = true 
			--end   

			if ServerSideJewelryCase then 
				for k,v in pairs(ServerSideJewelryCase) do
					if canrob == true then 
						if (os.time() - v.lastrobbed) < vangelico.RefreshTimer and v.lastrobbed ~= 0 then  
							v.isOpen = true 
						else 
							v.isOpen = false 
						end
					else 
						v.isOpen = true 
					end
				end 
				UpdateClientSide()  
			end 
		end

		if closeJewelry == true then  
			local closedtime = os.time()
			robberyStart = os.time()
			if ServerSideJewelryCase then 
				for k,v in pairs(ServerSideJewelryCase) do 
					v.isOpen = true  
					v.lastrobbed = closedtime
				end 
				ServerSideSafeBeingUsed = true  
				ServerSideSafeUnlocked = true 
				UpdateClientSide() 
			end  
			closeJewelry = false 
		end 

		if (os.time() - robberyStart) > TenMinutes and (os.time() - robberyStart) < ElevenMinutes and isClosed == false then    
			closeJewelry = true 
			isClosed = true 
		end

	end 
end)