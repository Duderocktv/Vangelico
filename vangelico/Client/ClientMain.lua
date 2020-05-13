local ClientSideJewelryCases = nil
local smashingcase = false 
local ClientSideFrontDoorsLocked = true 
local ClientSideFrontDoorsHacked = false 
local ClientSideSafeBeingUsed = false 
local ClientSideSafeUnlocked = false
local ClientSideVangelicoOnCooldown = false 
local secondsRemaining = 0
local PlayerIsPolice = false  
ESX = nil

local frontDoorpos = vangelico.FrontDoorLockPickPosition 
local DisplayFrontDoorSecurity = false 

local DisplayClosestCase = false 
local ClosestCase = 0
local LastCaseOpened = 0
local ClosestCasePosition 
local ClosestCaseHeading 

Citizen.CreateThread(function()
	while ESX == nil do 
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end 
	setplayerPoliceJobStatus()
	SetupBlip()
	DeleteSeats()
end)
   
-- Job change function to set Jobs
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	TriggerServerEvent('zoo_PoliceCount:PlayerJobChange', source)
	setplayerPoliceJobStatus()
end)

-- Sets up the map Icon
function  SetupBlip() 
	local blip = AddBlipForCoord(vangelico.VangelicoPosition.x, vangelico.VangelicoPosition.y, vangelico.VangelicoPosition.z)
	SetBlipSprite               (blip, 439)
	SetBlipDisplay              (blip, 3)
	SetBlipScale                (blip, 0.5)
	SetBlipColour               (blip, 71)
	SetBlipAsShortRange         (blip, false)
	SetBlipHighDetail           (blip, true)
	BeginTextCommandSetBlipName ("STRING")
	AddTextComponentString      ("Vangelico")
	EndTextCommandSetBlipName   (blip)
end
 
function setplayerPoliceJobStatus()

	PlayerData = ESX.GetPlayerData()
	if PlayerData and PlayerData.job then 
		if PlayerData.job.name == "police" then
			PlayerIsPolice = true 
		end 
	end 
end 

 -- Function to Set the CLient Side state of the Jewelry Store
RegisterNetEvent('vangelico:SetJewelryCaseState')
AddEventHandler('vangelico:SetJewelryCaseState', function(JewelryCases, FrontDoorState, Hackedstate, SafeBeingUsed, SafeUnlocked, VangelicoOnCooldown )  
	ClientSideJewelryCases = JewelryCases 
	ClientSideFrontDoorsLocked = FrontDoorState
	ClientSideFrontDoorsHacked = Hackedstate
	ClientSideSafeBeingUsed = SafeBeingUsed 
	ClientSideSafeUnlocked = SafeUnlocked
	ClientSideVangelicoOnCooldown = VangelicoOnCooldown   
	setDoorState(ClientSideFrontDoorsLocked)
end)

-- Hacking Function 
RegisterNetEvent('vangelico:currentlyhacking')
AddEventHandler('vangelico:currentlyhacking', function( )  
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",3,30, opendoors) 
	secondsRemaining = 30
end)

function opendoors(success, timeremaining)
	if success then
		TriggerEvent('mhacking:hide') 
		ESX.ShowNotification('~r~ Hacked completed.') -- Hack successful message
		TriggerServerEvent('vangelico:DoorHacked')  
		secondsRemaining = 0 
	else 
		ESX.ShowNotification('Hack has failed') -- Hack Failed Message
		TriggerEvent('mhacking:hide')
		secondsRemaining = 0 
	end
end 
  
--Lock Picking Doors
function LockpickComplete(result)
	if result then 
		TriggerServerEvent('vangelico:UnlockFrontDoors')  
	else
		TriggerServerEvent('vangelico:NotifyPolice')
	end
end 

function getPlayerDistance(Coords)
	local playerCoords =  GetEntityCoords(GetPlayerPed(-1), true) 
	return Vdist(playerCoords.x, playerCoords.y, playerCoords.z, Coords.x, Coords.y, Coords.z)
end 

function getClosestCase(JewelryCases)  
	for k,v in pairs(JewelryCases) do   
		if v.isOpen == false then 
			local pos2 = v.position 
			allcasesopened = false 
			if(getPlayerDistance(pos2) < 1.0)then  
				ClosestCasePosition = pos2
				ClosestCase = k
				print(k)
				ClosestCaseHeading = v.heading 
				DisplayClosestCase = true 
				break 
			end
		else  
			DisplayClosestCase = false 
			ClosestCase = 0
		end 
	end 
end 
 

--Display Text   Police Close
Citizen.CreateThread(function() 
	while true do	
		Citizen.Wait(0)
		-- Police Secure Location
		local securepos = vangelico.SecurePosition  
		if PlayerIsPolice == true then 
			if( getPlayerDistance(securepos) < 1.0)then 
				Draw3DText(securepos.x, securepos.y, securepos.z, '~w~[~g~E~w~] ' .. 'to secure the building') 
				if IsControlJustReleased(1, 51) then  
					TriggerServerEvent("vangelico:SecureBuilding")
				end 
			end  
		end  
	end
end)

--Display Text   
Citizen.CreateThread(function() 
	while true do	
		Citizen.Wait(0)   
		local storepos = vangelico.VangelicoPosition
		local allcasesopened = true 

		local JewelryCases = ClientSideJewelryCases 
		local FrontDoorsLocked = ClientSideFrontDoorsLocked 
		local FrontDoorsHacked = ClientSideFrontDoorsHacked 
		local SafeBeingUsed = ClientSideSafeBeingUsed 
		local SafeUnlocked = ClientSideSafeUnlocked
		local VangelicoOnCooldown = ClientSideVangelicoOnCooldown 


		-- Kick people out if Jewelry store is on Cooldown
		if( getPlayerDistance(storepos) < 20.0)then
			if VangelicoOnCooldown == true then  
				if( getPlayerDistance(storepos) < 8.75)then
					local plyPed = GetPlayerPed(-1) 
					SetEntityCoords(plyPed, vangelico.MoveToWhenClosedPosition.x, vangelico.MoveToWhenClosedPosition.y, vangelico.MoveToWhenClosedPosition.z) 
					ESX.ShowNotification("Vangelico is currently closed.")
				end 
			else 
				-- Jewelry Case 3d Text & Unlock press
					if JewelryCases == nil then  
						TriggerServerEvent('vangelico:GetCaseState', -1)  
						JewelryCases = ClientSideJewelryCases
					end   
					if  JewelryCases then  
						if(getPlayerDistance(storepos) < 9.0)then
							if ClosestCase ~= 0 then 
								if(getPlayerDistance(ClosestCasePosition) > 1.0)then  
									getClosestCase(JewelryCases)
								end 
							else
								getClosestCase(JewelryCases)
							end  
						end 
					else  
						ClosestCase = 0
						allcasesopened = false 
					end 
					if ClosestCase ~= 0 then 
						Draw3DText(ClosestCasePosition.x, ClosestCasePosition.y, ClosestCasePosition.z, '~w~[~g~E~w~] ' .. 'to smash case') 
						if IsControlJustReleased(1, 51) and smashingcase == false then 
							if(getPlayerDistance(ClosestCasePosition) < 1.0)then 
								smashingcase = true 
								robCase(ClosestCasePosition, ClosestCaseHeading, ClosestCase) 
							end 
						end  
					end 
	
					-- Safe 3d Text and Unlock Press 
					if allcasesopened == true and SafeUnlocked == false then 
						local safepos = vangelico.SafePos  
						if(getPlayerDistance(safepos) < 1.0)then 
							Draw3DText(safepos.x, safepos.y, safepos.z, '~w~[~g~E~w~] ' .. 'to try and open safe') 
							if IsControlJustReleased(1, 51) then 
								robSafe() 
							end 
						end 
					end 
			
					-- Display Message for Hacking Security Box 
					if FrontDoorsHacked == false then 
						local hackpos = vangelico.HackPosition  
						if(getPlayerDistance(hackpos) < 1.0)then 
							Draw3DText(hackpos.x, hackpos.y, hackpos.z, '~w~[~g~E~w~] ' .. 'to hack security box') 
							if IsControlJustReleased(1, 51) then 
								TriggerServerEvent('vangelico:hackFrontDoors', k)  
							end 
						end 
			  
						local frontDoorpos = vangelico.FrontDoorLockPickPosition  
						if (getPlayerDistance(frontDoorpos) < 1.0)then 
							Draw3DText(frontDoorpos.x, frontDoorpos.y, frontDoorpos.z, 'Extra security measures are in place')  
						end

					else
						-- Display Message for Unlocking the Front Door
						if FrontDoorsLocked == true  then 
							local frontDoorpos = vangelico.FrontDoorLockPickPosition  
							if(getPlayerDistance(frontDoorpos) < 1.0)then 
								Draw3DText(frontDoorpos.x, frontDoorpos.y, frontDoorpos.z, '~w~[~g~E~w~] ' .. 'to pick the doorlocks') 
								if IsControlJustReleased(1, 51) then 
									TriggerEvent('lockpicking:StartMinigame',5, LockpickComplete)
								end 
							end 
						end
					end
			 
			end  
		end  
    end
end)
 
function Draw3DText(x, y, z, text) 
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.35)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
  
function robCase(val, heading, index)  
	local plyPed = GetPlayerPed(-1) 
	local plySkin
	local plyWeapon = GetCurrentPedWeapon(plyPed) 
	local weapHash = GetSelectedPedWeapon(plyPed) % 0x100000000

	local matching = false
	for k,v in pairs(vangelico.MeleeWeapons) do if v == weapHash then matching = true; end; end
	TriggerEvent('skinchanger:getSkin', function(skin) plySkin = skin; end)
	if not matching and plyWeapon and (plySkin["bags_1"] ~= 0 or plySkin["bags_2"] ~= 0) then
		SetEntityCoords(plyPed, val.x, val.y, val.z-0.95)
		SetEntityHeading(plyPed, heading) 
		PlaySoundFromCoord(-1, "Glass_Smash", val.x, val.y, val.z, "", 0, 0, 0)
		Wait(1500)

		
		ESX.Streaming.RequestAnimDict('missheist_jewel', function(...)
			TaskPlayAnim( plyPed, "missheist_jewel", "smash_case_tray_a", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )     
		end)
		TriggerServerEvent('vangelico:CaseSmashed', index)  
		DisplayClosestCase = false 
		LastCaseOpened = ClosestCase
		ClosestCase = 0

		Wait(500)
		
		if not HasNamedPtfxAssetLoaded("scr_jewelheist") then RequestNamedPtfxAsset("scr_jewelheist"); end
		while not HasNamedPtfxAssetLoaded("scr_jewelheist") do Citizen.Wait(0); end    


		SetPtfxAssetNextCall("scr_jewelheist")
		StartParticleFxLoopedAtCoord("scr_jewel_cab_smash", val.x, val.y, val.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)                
		PlaySoundFromCoord(-1, "Glass_Smash", val.x, val.y, val.z, 0, 0, 0, 0)
		Wait(2400)

		ClearPedTasksImmediately(plyPed)
		Wait(1000)

		TriggerServerEvent('vangelico:NotifyPolice')
	elseif not plyWeapon then
		ESX.ShowNotification("You need something to break the glass with.")
	elseif plySkin["bags_2"] == 0 and plySkin["bags_1"] == 0 then
		ESX.ShowNotification("You need a bag to carry the goods with.")
	elseif matching then
		ESX.ShowNotification("You can't break the glass with this.")  
	end   
	smashingcase = false 
end 

function setDoorState(DoorState)

	if DoorState == true  then   
		-- Lock the front doors
		local RightDoorObj =  GetClosestObjectOfType(vangelico.FrontDoorRight.Position, 0.8, vangelico.FrontDoorRight.Hash, false, false, false)
		if DoesEntityExist(RightDoorObj) then 
			FreezeEntityPosition(RightDoorObj, true)
			SetEntityHeading(RightDoorObj, vangelico.FrontDoorLeft.Heading)
		end 
		local LeftDoorObj =  GetClosestObjectOfType(vangelico.FrontDoorLeft.Position, 0.8, vangelico.FrontDoorLeft.Hash, false, false, false)
		if DoesEntityExist(LeftDoorObj) then 
			FreezeEntityPosition(LeftDoorObj, true)
			SetEntityHeading(LeftDoorObj, vangelico.FrontDoorLeft.Heading)
		end 
	else 
		-- Make Sure front doors are unlocked
		local RightDoorObj =  GetClosestObjectOfType(vangelico.FrontDoorRight.Position, 0.8, vangelico.FrontDoorRight.Hash, false, false, false)
		if DoesEntityExist(RightDoorObj) then 
			FreezeEntityPosition(RightDoorObj, false) 
		end 
		local LeftDoorObj =  GetClosestObjectOfType(vangelico.FrontDoorLeft.Position, 0.8, vangelico.FrontDoorLeft.Hash, false, false, false)
		if DoesEntityExist(LeftDoorObj) then 
			FreezeEntityPosition(LeftDoorObj, false) 
		end 
	end  
end

-- Safe Robery Functions
-- Creates the Safe
function DeleteSeats()
	local newPos = vector3(-625.243, -223.44, 37.78)
	TriggerEvent('safecracker:SpawnSafe', false, newPos, 0.0)
	vangelico.DeletedSeats = true
	local objects = ESX.Game.GetObjects()
	for k,v in pairs(objects) do
	  local model = GetEntityModel(v) % 0x100000000
	  if model == vangelico.SeatHash then 
		SetEntityAsMissionEntity(v,false)
		DeleteObject(v)
	  end
	end
end

-- Spawns the Guards when the safe is cracked
function SpawnGuardNPC() 
	--TriggerEvent('police:jeweleryrobbery', source) 
	local nearby = ESX.Game.GetPlayersInArea(vangelico.VangelicoPosition, 20.0) 
  
	local hk = GetHashKey('s_m_m_security_01') 
	if not HasModelLoaded(hk) then RequestModel(hk); end 
	while not HasModelLoaded(hk) do RequestModel(hk); Citizen.Wait(0); end 
  
	for k,v in pairs(nearby) do  
	  Citizen.CreateThread(function()
		local plyPed = GetPlayerPed(v)
		local plyPos = GetEntityCoords(plyPed)
		local newPed = CreatePed(4, hk, vangelico.BobSpawnPos, 0.0, true, true)
  
		SetPedRelationshipGroupHash(newPed, GetHashKey("AMBIENT_GANG_MEXICAN"))
		SetPedRelationshipGroupDefaultHash(newPed, GetHashKey("AMBIENT_GANG_MEXICAN"))
  
		GiveWeaponToPed(newPed, GetHashKey('weapon_stungun'), 1000, false, true)
		SetPedDropsWeaponsWhenDead(newPed,false)
  
		--TaskGo
		TaskGotoEntityAiming(newPed, plyPed, 3.0, 5.0)
		Wait(5000)
  
		local timer = GetGameTimer() 
		local dist = Utils:GetVecDist(plyPos,GetEntityCoords(newPed))
		while dist > 10.0 do
		  Citizen.Wait(100)
		  plyPos = GetEntityCoords(GetPlayerPed(v))
		  dist = Utils:GetVecDist(plyPos,GetEntityCoords(newPed))       
		end
		ClearPedTasksImmediately(newPed)
		Citizen.Wait(1000)
		TaskCombatPed(newPed,GetPlayerPed(v), 0, 16)
		TaskShootAtEntity(newPed, GetPlayerPed(v), -1, GetHashKey("FIRING_PATTERN_FULL_AUTO"))
	  end)
	end 
end

function robSafe() 
    ESX.TriggerServerCallback('vangelico:GetSafeState', function(canUse)
      if canUse.SafeUnlocked == false and  canUse.SafeInuse == false  then
        --SpawnGuardNPC()
        TriggerServerEvent("vangelico:SetSafeInuse")
        TriggerEvent('safecracker:StartMinigame', vangelico.SafeRewards)
	  elseif canUse.SafeUnlocked == false then 
		ESX.ShowNotification("Somebody has already cracked this safe.")
	  elseif  canUse.SafeInuse == true then 
		ESX.ShowNotification("Somebody is already cracking this safe.")
      end
    end)

end
  