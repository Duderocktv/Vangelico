 
vangelico = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)

vangelico.Version = '1.0'

Citizen.CreateThread(function(...)
  while not ESX do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj; end)
    Citizen.Wait(0)
  end
end)

-- Make sure you change these.
vangelico.InteractDist = 2.0 -- dist for drawtext to appear
vangelico.RefreshTimer = 3600 --1 hour
vangelico.MinPoliceOnline = 0 -- if count >= policecount, then canrob = true;
vangelico.PoliceJobName = "police" -- change this to your police job name.
vangelico.SecurePosition = vector3(-631.0558,-230.6056,37.97163 )  -- Position for Police to Secure the building (Computer in the Office)
vangelico.VangelicoPosition = vector3(-623.94, -232.37, 38.06) -- Store Marker position
vangelico.MoveToWhenClosedPosition = vector3(-634.36, -240.00, 38.08)
vangelico.MoveToWhenClosedHeading = 130.47

-- Hacking Settings 
vangelico.HackingDeviceDBName = "rasperry" -- change this to your hacking device name.
vangelico.ChanceToTriggerAlarmWhileHacking = 25  -- Percentage chance to notify the police that a hack is in progress
vangelico.HackPosition = vector3(-610.73,-240.17, 50.24) -- Position for Hacking to unlock the front Doors


-- Probably don't change these.
vangelico.LoadZoneDist = 50.0 
vangelico.SeatHash = 1630899471

-- Front Doors for Locking and freezing
vangelico.FrontDoorRight = {
          Hash = 9467943,
          EntityName = 'p_jewel_door_r1',
          Position = vector3(-630.4265,-238.4376,38.20653),
          Heading = 306.26763916016
}
vangelico.FrontDoorLeft = {
          Hash = 1425919976,
          EntityName = 'p_jewel_door_l',
          Position = vector3(-631.9554,-236.3333,38.20653),
          Heading = 305.76663208008
}
vangelico.FrontDoorLockPickPosition = vector3(-631.7,-237.72,38.07)

-- Safe Position 
vangelico.SafePos = vector3(-625.55, -223.78, 38.20)
vangelico.SafePosition = vector3(-625.243, -223.44, 37.78)
-- Rewards for the safe.
-- Rewards for the safe.
vangelico.SafeRewards = { 
  CashAmount    = math.random(7500,25000), 
  Items = { 
        ["Loot_01"] ={
            name = "Loot_01",
            type = 'diamond',
            dropchance = 100,
            minamount = 1,
            maxamount = 5,
          }, 
        ["Loot_03"] ={
            name = "Loot_03",
            type = 'gold',
            dropchance = 100,
            minamount = 1,
            maxamount = 5,
          },  
        ["Loot_05"] ={
            name = "Loot_05",
            type = 'rolex',
            dropchance = 100,
            minamount = 1,
            maxamount = 5,
          },  
  }, -- New Safe Loot Table Changed to add ease of configuring to the loot droped
}

vangelico.BobSpawnPos = vector3(-630.05,-228.54,38.06)

 -- Reworked Case positions.  Added the 4 Corner Cases to the Robbable cases
vangelico.CasePositions =  { 
  ["Case_01"] = {
      name = "Case_01",
      lastrobbed = 0,
      position = vector3(-628.05, -233.83, 38.057),
      isOpen = false, 
      heading = 213.76
    },
  ["Case_02"] = {
      name = "Case_02",
      lastrobbed = 0,
      position = vector3( -627.00, -233.16, 38.057),
      isOpen = false, 
      heading = 214.68
    },
  ["Case_03"] = {
      name = "Case_03",
      lastrobbed = 0,
      position =vector3( -625.85, -234.64, 38.057),
      isOpen = false, 
      heading = 31.27
    },
  ["Case_04"] = {
      name = "Case_04",
      lastrobbed = 0,
      position = vector3(-626.79, -235.31, 38.057),
      isOpen = false, 
      heading = 33.572
    },
  ["Case_05"] = {
      name = "Case_05",
      lastrobbed = 0,
      position = vector3(-626.72, -238.62, 38.057),
      isOpen = false, 
      heading = 220.72
    },
  ["Case_06"] = {
      name = "Case_06",
      lastrobbed = 0,
      position = vector3(-625.72, -237.82, 38.057),
      isOpen = false, 
      heading = 214.63
    },
  ["Case_07"] = {
      name = "Case_07",
      lastrobbed = 0,
      position = vector3( -623.21, -232.88, 38.057),
      isOpen = false, 
      heading = 299.81
    },
  ["Case_08"] = {
      name = "Case_08",
      lastrobbed = 0,
      position = vector3(-621.76, -233.87, 38.057),
      isOpen = false, 
      heading = 344.15
    },
  ["Case_09"] = {
      name = "Case_09",
      lastrobbed = 0,
      position = vector3(-620.13, -233.32, 38.057),
      isOpen = false, 
      heading = 44.14
    },
  ["Case_10"] = {
      name = "Case_10",
      lastrobbed = 0,
      position = vector3( -619.2, -231.92, 38.057),
      isOpen = false, 
      heading = 82.85
    },
  ["Case_11"] = {
      name = "Case_11",
      lastrobbed = 0,
      position = vector3( -619.75, -230.36, 38.057),
      isOpen = false, 
      heading = 126.92
    },
  ["Case_12"] = {
      name = "Case_12",
      lastrobbed = 0,
      position = vector3(-621.09, -228.54, 38.057),
      isOpen = false, 
      heading = 127.92
    },
  ["Case_13"] = {
      name = "Case_13",
      lastrobbed = 0,
      position =vector3(-622.41, -227.43, 38.057),
      isOpen = false, 
      heading = 163.53
    },
  ["Case_14"] = {
      name = "Case_14",
      lastrobbed = 0,
      position = vector3(-624.01, -228.14, 38.057),
      isOpen = false, 
      heading = 215.31
    },
  ["Case_15"] = {
      name = "Case_15",
      lastrobbed = 0,
      position = vector3(-624.94, -229.49, 38.057),
      isOpen = false, 
      heading = 254.46
    },
  ["Case_16"] = {
      name = "Case_16",
      lastrobbed = 0,
      position = vector3(-624.47, -231.11, 38.057),
      isOpen = false, 
      heading = 302.27
    },
  ["Case_17"] = {
      name = "Case_17",
      lastrobbed = 0,
      position = vector3(-624.94, -227.8, 38.057),
      isOpen = false, 
      heading = 43.68
    },
  ["Case_18"] = {
      name = "Case_18",
      lastrobbed = 0,
      position = vector3(-623.9, -227.09, 38.057),
      isOpen = false, 
      heading = 30.54
    },
  ["Case_19"] = {
      name = "Case_19",
      lastrobbed = 0,
      position = vector3(-620.39, -226.65, 38.057),
      isOpen = false, 
      heading = 319.14
    },
  ["Case_20"] = {
      name = "Case_20",
      lastrobbed = 0,
      position = vector3(-619.28, -227.69, 38.057),
      isOpen = false, 
      heading = 303.72
    },
  ["Case_21"] = {
      name = "Case_21",
      lastrobbed = 0,
      position = vector3(-618.37, -229.53, 38.057),
      isOpen = false, 
      heading = 313.93
    }, 
  ["Case_22"] = {
      name = "Case_22",
      lastrobbed = 0,
      position = vector3(-617.5, -230.63, 38.057),
      isOpen = false, 
      heading = 306.32
    },
  ["Case_23"] = {
      name = "Case_23",
      lastrobbed = 0,
      position = vector3(-619.18, -233.64, 38.057),
      isOpen = false, 
      heading = 215.15
    },
  ["Case_24"] = {
      name = "Case_24",
      lastrobbed = 0,
      position = vector3(-620.31, -234.51, 38.057),
      isOpen = false, 
      heading = 221.2
    },
} 
-- New Jewelry Case loot table, changed to make editing and adding items easier, Added Drop chances, and min/max amounts for items when dropped
vangelico.LootTable= { 
          ["Loot_01"] ={
              name = "Loot_01",
              type = 'diamond',
              dropchance = 15,
              minamount = 1,
              maxamount = 1,
            }, 
          ["Loot_03"] ={
              name = "Loot_03",
              type = 'gold',
              dropchance = 90,
              minamount = 1,
              maxamount = 3,
            },  
          ["Loot_05"] ={
              name = "Loot_05",
              type = 'rolex',
              dropchance = 50,
              minamount = 1,
              maxamount = 2,
            },  
} 
 
vangelico.SmashAnimations = {
  [1] = "smash_case",
  [2] = "smash_case_b",
  [3] = "smash_case_c",
  [4] = "smash_case_d",
  [5] = "smash_case_e",
  [6] = "smash_case_f",
  [7] = "smash_case_tray_a",
}

vangelico.MeleeWeapons = {
  ["WEAPON_BAT"]                           =  0x958A4A8F,
  ["WEAPON_BALL"]                          =  0x23C9F95C,
  ["WEAPON_BOTTLE"]                        =  0xF9E6AA4B,
  ["WEAPON_CROWBAR"]                       =  0x84BD7BFD,
  ["WEAPON_DAGGER"]                        =  0x92A27487,
  ["WEAPON_FIREEXTINGUISHER"]              =  0x060EC506,
  ["WEAPON_FLAREGUN"]                      =  0x47757124, 
  ["WEAPON_KNIFE"]                         =  0x99B507EA,
  ["WEAPON_HAMMER"]                        =  0x4E875F73,
  ["WEAPON_HATCHET"]                       =  0xF9DCBF2D,
  ["WEAPON_MOLOTOV"]                       =  0x24B17070,
  ["WEAPON_PETROLCAN"]                     =  0x34A67B97, 
  ["WEAPON_MACHETE"]                       =  0xDD5DF8D9,
  ["WEAPON_WRENCH"]                        =  0x19044EE0,
}