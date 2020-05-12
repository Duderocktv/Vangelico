local PoliceForce = {}
ESX = nil

function checkESX()
    if ESX == nil then 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
    end 
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end  
    rebuildPolice() 
  end)

AddEventHandler('vangelico:GetPoliceForce', function(cb) 
	cb(PoliceForce)
end)

function GetPoliceForce() 
    return PoliceForce
end 

AddEventHandler('playerDropped', function(reason)
    local _source = source  
	local _player = ESX.GetPlayerFromId(_source)
    if _player and _player.job then 
        if (_player.job.name == 'police') then
            removePolice(_source)
        end 
    else
        rebuildPolice()
    end 
end) 

AddEventHandler('esx:playerLoaded', function(source)
    local _source = source 
    checkESX()  
	local _player = ESX.GetPlayerFromId(_source)
    if _player and _player.job then 
        if (_player.job.name == 'police') then
            addPolice(_source)
        end 
    else
        rebuildPolice()
    end  
end)
   
RegisterServerEvent('vangelico:PlayerJobChange')
AddEventHandler('vangelico:PlayerJobChange', function() 
    local _source = source  
    local _player = ESX.GetPlayerFromId(_source)
    if _player and _player.job then 
        if _player.job.name == 'police' then
            addPolice(_source)
        else
            removePolice(_source)
        end 
    else
        rebuildPolice()
    end
end)

function addPolice(sourceval)
    local _source = sourceval 
    local NotInList = true 

    for k, police in pairs(PoliceForce) do
        if police.PoliceSource == _source then
            NotInList = false 
            break
        end
    end 
    if NotInList then  
        table.insert(PoliceForce, {PoliceSource = _source} )
    end 
end

function removePolice(sourceval)
    local _source = sourceval
    local temppolice = {}

    for k, police in pairs(PoliceForce) do
        if police.PoliceSource ~= _source then
            table.insert(temppolice, police )
        end
    end 
    PoliceForce = temppolice 
end

function rebuildPolice()
    checkESX()
    local temppolice = {} 
    local xPlayers = ESX.GetPlayers() 
    for i=1, #xPlayers, 1 do 
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])  
        if xPlayer.job.name == 'police' then
            table.insert(temppolice,  {PoliceSource = xPlayers[i]} )
        end  
    end 
    PoliceForce = temppolice 
end
