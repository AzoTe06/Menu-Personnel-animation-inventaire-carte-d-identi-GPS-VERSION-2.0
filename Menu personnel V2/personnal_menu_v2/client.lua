--
-- Created by IntelliJ IDEA.
-- User: Djyss
-- Date: 09/05/2017
-- Time: 09:55
-- To change this template use File | Settings | File Templates.
--




local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Menu personnel",
    menu_subtitle = "Categories",
    color_r = 255,
    color_g = 51,
    color_b = 102,
}


------------------------------------------------------------------------------------------------------------------------

-- Base du menu
function PersonnalMenu()
    ped = GetPlayerPed(-1);
    ClearMenu()
    Menu.addButton("Animations", "animsMenu", nil)
    Menu.addButton("Inventaire", "inventoryMenu", nil)
    Menu.addButton("GPS", "gps", nil)    
    Menu.addButton("Ma carte d'identité", "identite", nil)
	--Menu.addButton("Montrer ma carte d'identité", "showcard", nil)
    --Menu.addButton("[WIP]Telephone", "phoneMenu", nil)
    --Menu.addButton("[WIP]Gestion des accessoires", "accessoriesMenu", nil)
    --Menu.addButton("Donner de l'argent", "giveMoney", nil)
end

------------------------------------------------------------------------------------------------------------------------

function identite()
    options.menu_subtitle = "Carte d identite"
    ClearMenu()
    Menu.addButton("Voir ma carte", "openGuiIdentity", nil )
    Menu.addButton("[SOON] Montrer ma carte", "openGuiIdentity", nil )    
    Menu.addButton("Retour", "PersonnalMenu", nil )
end

function gps()
	options.menu_subtitle = "GPS"
    ClearMenu()
    Menu.addButton("Pole emploi", "poleemploi", nil )
    Menu.addButton("Concessionnaire", "concepoint", nil )
    Menu.addButton("Comissariat", "comico", nil )    
    Menu.addButton("Retour", "PersonnalMenu", nil )    
end	

function poleemploi()
	x, y, z = -266.775268554688, -959.946960449219, 31.2197742462158
	SetNewWaypoint(x, y, z)
end

function concepoint()
	x, y, z = -34.2844390869141, -1101.75170898438, 26.4223537445068
	SetNewWaypoint(x, y, z)
end

function comico()
	x, y, z = 462.319854736328, -989.413513183594, 24.9148712158203
	SetNewWaypoint(x, y, z)
end

function medic()
	BLIP_EMERGENCY = AddBlipForCoord(x, y, z)

	SetBlipSprite(BLIP_EMERGENCY, 2)
	SetNewWaypoint(x, y)

	SendNotification(txt[lang]['gps'])

	Citizen.CreateThread(
		function()
			local isRes = false
			local ped = GetPlayerPed(-1);
			while not isRes do
				Citizen.Wait(0)

				if (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), x,y,z, true)<3.0) then
						DisplayHelpText(txt[lang]['res'])
						if (IsControlJustReleased(1, Keys['E'])) then
							TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
							Citizen.Wait(8000)
							ClearPedTasks(ped);
	            TriggerServerEvent('es_em:sv_resurectPlayer', sourcePlayerInComa)
	            isRes = true
	          end
				end
			end
	end)
end

------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedUsingAnyScenario(GetPlayerPed(-1)) then
            if IsControlJustPressed(1, 34) or IsControlJustPressed(1, 32) or IsControlJustPressed(1, 8) or IsControlJustPressed(1, 9) then
                ClearPedTasks(GetPlayerPed(-1))
            end
        end

    end
end)

function animsMenu()
    options.menu_subtitle = "Animations"
    ClearMenu()
    Menu.addButton("Calme toi ", "animsAction", { lib = "gestures@m@standing@casual", anim = "gesture_easy_now" })    
    Menu.addButton("Dire bonjour", "animsAction", { lib = "gestures@m@standing@casual", anim = "gesture_hello" })
    Menu.addButton("Doigt d'honneur", "animsAction", { lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter" })      
    Menu.addButton("Faire des pompes", "animsActionScenario", { anim = "WORLD_HUMAN_PUSH_UPS" })
    Menu.addButton("Enlacer", "animsAction", { lib = "mp_ped_interaction", anim = "kisses_guy_a" })          
    Menu.addButton("Faire du yoga", "animsActionScenario", { anim = "WORLD_HUMAN_YOGA" })
    Menu.addButton("Feliciter", "animsActionScenario", {anim = "WORLD_HUMAN_CHEERING" })
    Menu.addButton("Fumer une clope", "animsActionScenario", { anim = "WORLD_HUMAN_SMOKING" })        
    Menu.addButton("Jouer de la musique", "animsActionScenario", {anim = "WORLD_HUMAN_MUSICIAN" })
    Menu.addButton("Prendre des notes", "animsActionScenario", { anim = "WORLD_HUMAN_CLIPBOARD" })    
    Menu.addButton("S'assoir", "animsActionScenario", { anim = "WORLD_HUMAN_PICNIC" })    
    Menu.addButton("Serrer la main", "animsAction", { lib = "mp_common", anim = "givetake1_a" })
    Menu.addButton("Se gratter les c**", "animsAction", { lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch" })        
    Menu.addButton("Super", "animsAction", { lib = "mp_action", anim = "thanks_male_06" })    
    Menu.addButton("Retour","PersonnalMenu",nil)
end

function animsAction(animObj)
    RequestAnimDict( animObj.lib )
    while not HasAnimDictLoaded( animObj.lib ) do
        Citizen.Wait(0)
    end
    if HasAnimDictLoaded( animObj.lib ) then
        TaskPlayAnim( GetPlayerPed(-1), animObj.lib , animObj.anim ,8.0, -8.0, -1, 0, 0, false, false, false )
    end
end

function animsActionScenario(animObj)
    local ped = GetPlayerPed(-1);

    if ped then
        local pos = GetEntityCoords(ped);
        local head = GetEntityHeading(ped);
        --TaskStartScenarioAtPosition(ped, animObj.anim, pos['x'], pos['y'], pos['z'] - 1, head, -1, false, false);
        TaskStartScenarioInPlace(ped, animObj.anim, 0, false)
        if IsControlJustPressed(1,188) then
        end

    end
end

function animsWithModelsSpawn(object)

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))

    RequestModel(object.object)
    while not HasModelLoaded(object.object) do
        Wait(1)
    end

    local object = CreateObject(object.object, x, y+2, z, true, true, true)
    -- local vX, vY, vZ = table.unpack(GetEntityCoords(object,  true))

    -- AttachEntityToEntity(object, PlayerId(), GetPedBoneIndex(PlayerId()), vX,  vY,  vZ, -90.0, 0, -90.0, true, true, true, false, 0, true)
    PlaceObjectOnGroundProperly(object) -- This function doesn't seem to work.

end

------------------------------------------------------------------------------------------------------------------------

-- register events, only needs to be done once
RegisterNetEvent("item:reset")
RegisterNetEvent("item:getItems")
RegisterNetEvent("item:updateQuantity")
RegisterNetEvent("item:setItem")
RegisterNetEvent("item:sell")
RegisterNetEvent("gui:getItems")
RegisterNetEvent("player:receiveItem")
RegisterNetEvent("player:looseItem")
RegisterNetEvent("player:sellItem")

ITEMS = {}
local playerdead = false
local maxCapacity = 80

-- handles when a player spawns either from joining or after death
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("item:getItems")
    -- reset player dead flag
    playerdead = false
end)

AddEventHandler("gui:getItems", function(THEITEMS)
    ITEMS = {}
    ITEMS = THEITEMS
end)

AddEventHandler("player:receiveItem", function(item, quantity)
    if (inventoryGetPods() + quantity <= maxCapacity) then
        item = tonumber(item)
        if (ITEMS[item] == nil) then
            inventoryNew(item, quantity)
        else
            inventoryAdd({ item, quantity })
        end
    end
end)

AddEventHandler("player:looseItem", function(item, quantity)
    item = tonumber(item)
    if (ITEMS[item].quantity >= quantity) then
        inventoryDelete({ item, quantity })
    end
end)

AddEventHandler("player:sellItem", function(item, price)
    item = tonumber(item)
    if (ITEMS[item].quantity > 0) then
        inventorySell({ item, price })
    end
end)

-- Menu de l'inventaire
function inventoryMenu()
    ped = GetPlayerPed(-1);
    options.menu_subtitle = "Items  "
    options.rightText = (inventoryGetPods() or 0) .. "/" .. maxCapacity
    ClearMenu()
    for ind, value in pairs(ITEMS) do
        if (value.quantity > 0) then
            Menu.addButton(tostring(value.quantity) .. " " ..tostring(value.libelle), "inventoryItemMenu", ind)
        end
    end
    Menu.addButton("Retour", "PersonnalMenu", ind)
end

function inventoryItemMenu(itemId)
    ClearMenu()
    options.menu_subtitle = "Details "
    Menu.addButton("Utiliser", "use", itemId)
	Menu.addButton("Supprimer 1", "delete", { itemId, 1 })
    --Menu.addButton("Donner", "give", itemId)

end

--function inventoryGive(item)
  --  local player = getNearPlayer()
    --if (player ~= nil) then
      --  DisplayOnscreenKeyboard(1, "Quantité :", "", "", "", "", "", 2)
        --while (UpdateOnscreenKeyboard() == 0) do
          --  DisableAllControlActions(0);
            --Wait(0);
        --end
        --if (GetOnscreenKeyboardResult()) then
            --local res = tonumber(GetOnscreenKeyboardResult())
            --if (ITEMS[item].quantity - res >= 0) then
                --TriggerServerEvent("player:giveItem", item, ITEMS[item].libelle, res, GetPlayerServerId(player))
            --end
        --end
    --end
--end

function use(item)
    if (ITEMS[item].quantity - 1 >= 0) then
        -- Nice var swap for nothing
        TriggerEvent("player:looseItem", item, 1)
        TriggerServerEvent("item:updateQuantity", 1, item)
        -- Calling the Hunger/Thirst
        if ITEMS[item].type == 2 then
            TriggerEvent("food:eat", ITEMS[item])
        elseif ITEMS[item].type == 1 then
            TriggerEvent("food:drink", ITEMS[item])
        else
            -- Any other type? Drugs??????
            Toxicated()
            Citizen.Wait(7000)
            ClearPedTasks(GetPlayerPed(-1))
            Reality()
        end
    end
end

function delete(arg)
	ClearMenu()
    local itemId = tonumber(arg[1])
    local qty = arg[2]
    local item = ITEMS[itemId]
    item.quantity = item.quantity - qty
    TriggerServerEvent("item:updateQuantity", item.quantity, itemId)
    InventoryMenu()
end


function inventorySell(arg)
    local itemId = tonumber(arg[1])
    local price = arg[2]
    local item = ITEMS[itemId]
    item.quantity = item.quantity - 1
    TriggerServerEvent("item:sell", itemId, item.quantity, price)
    inventoryMenu()
end

function inventoryDelete(arg)
    local itemId = tonumber(arg[1])
    local qty = arg[2]
    local item = ITEMS[itemId]
    item.quantity = item.quantity - qty
    TriggerServerEvent("item:updateQuantity", item.quantity, itemId)
    inventoryMenu()
end

function inventoryAdd(arg)
    local itemId = tonumber(arg[1])
    local qty = arg[2]
    local item = ITEMS[itemId]
    item.quantity = item.quantity + qty
    TriggerServerEvent("item:updateQuantity", item.quantity, itemId)
    InventoryMenu()
end

function inventoryNew(item, quantity)
    TriggerServerEvent("item:setItem", item, quantity)
    TriggerServerEvent("item:getItems")
end

function give(item)
    local player = getNearPlayer()
    if (player ~= nil) then
    DisplayOnscreenKeyboard(p0, windowTitle, p2, defaultText, defaultConcat1, defaultConcat2, defaultConcat3, maxInputLength)
        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0)
            Wait(0);
        end
        if (GetOnscreenKeyboardResult()) then
            local res = tonumber(GetOnscreenKeyboardResult())
            if (ITEMS[item].quantity - res >= 0) then
                TriggerServerEvent("player:giveItem", item, ITEMS[item].libelle, res, GetPlayerServerId(player))
            end
        end
    end
end

function inventoryGetQuantity(itemId)
    return ITEMS[tonumber(itemId)].quantity
end

function inventoryGetPods()
    local pods = 0
    for _, v in pairs(ITEMS) do
        pods = pods + v.quantity
    end
    return pods
end

function notFull()
    if (inventoryGetPods() < maxCapacity) then return true end
end

function PlayerIsDead()
    -- do not run if already ran
    if playerdead then
        return
    end
    TriggerServerEvent("item:reset")
end

function getPlayers()
    local playerList = {}
    for i = 0, 32 do
        local player = GetPlayerFromServerId(i)
        if NetworkIsPlayerActive(player) then
            table.insert(playerList, player)
        end
    end
    return playerList
end

function getNearPlayer()
    local players = getPlayers()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local pos2
    local distance
    local minDistance = 3
    local playerNear
    for _, player in pairs(players) do
        pos2 = GetEntityCoords(GetPlayerPed(player))
        distance = GetDistanceBetweenCoords(pos["x"], pos["y"], pos["z"], pos2["x"], pos2["y"], pos2["z"], true)
        if (pos ~= pos2 and distance < minDistance) then
            playerNear = player
            minDistance = distance
        end
    end
    if (minDistance < 3) then
        return playerNear
    end
end

------------------------------------------------------------------------------------------------------------------------
wearingHat = true
wearingGlasses = true
wearingPercing = true
wearingMask = true
-- Menu Accessoires
function accessoriesMenu()
    options.menu_subtitle = "Accessoires"
    ClearMenu()
    Menu.addButton("Porter ou Retirer chapeaux", "accessoriesWearHatChecker")
    Menu.addButton("Porter ou Retirer lunette", "accessoriesWearGlassesChecker")
    Menu.addButton("Porter ou Retirer percing", "accessoriesWearPercingChecker")
    Menu.addButton("Porter ou Retirer cagoule/mask", "accessoriesWearMaskChecker")
    Menu.addButton("Retour","PersonnalMenu",nil)
end

RegisterNetEvent("pm:accessoriesWearHat")
AddEventHandler("pm:accessoriesWearHat", function(item)
    SetPedPropIndex(GetPlayerPed(-1), 0, item.helmet,item.helmet_txt, 0)
end)
function accessoriesWearHatChecker()
    if wearingHat then
        wearingHat = false
        ClearPedProp(GetPlayerPed(-1),0)
    else
        wearingHat = true
        TriggerServerEvent("pm:wearHat")
    end

end

RegisterNetEvent("pm:accessoriesWearPercing")
AddEventHandler("pm:accessoriesWearPercing", function(item)
    SetPedPropIndex(GetPlayerPed(-1), 2, item.percing,item.percing_txt, 0)
end)
function accessoriesWearPercingChecker()
    if wearingGlasses then
        wearingGlasses = false
        ClearPedProp(GetPlayerPed(-1),2)
    else
        wearingGlasses = true
        TriggerServerEvent("pm:wearPercing")
    end

end

RegisterNetEvent("pm:accessoriesWearGlasses")
AddEventHandler("pm:accessoriesWearGlasses", function(item)
    SetPedPropIndex(GetPlayerPed(-1), 1, item.glasses,item.glasses_txt, 0)
end)
function accessoriesWearGlassesChecker()
    if wearingPercing then
        wearingPercing = false
        ClearPedProp(GetPlayerPed(-1),1)
    else
        wearingPercing = true
        TriggerServerEvent("pm:wearGlasses")
    end

end

RegisterNetEvent("pm:accessoriesWearMask")
AddEventHandler("pm:accessoriesWearMask", function(item)
    SetPedComponentVariation(GetPlayerPed(-1), 1, item.mask,item.mask_txt, 0)
end)
function accessoriesWearMaskChecker()
    if wearingMask then
        wearingMask = false
        SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0)
    else
        wearingMask = true
        TriggerServerEvent("pm:wearMask")
    end

end

function openGuiIdentity(data)
  --SetNuiFocus(true)
  RegisterNetEvent("gc:openMeIdentity")
  TriggerServerEvent('gc:openMeIdentity')
  menuIsOpen = 1
end

function closeGui()
  SetNuiFocus(false)
  SendNUIMessage({method = 'closeGui'})
  menuIsOpen = 0
end

function showcard()
  RegisterNetEvent("gcl:showItentity")
  TriggerServerEvent('gc:openIdentity', GetPlayerServerId(p))
    local p , dist  = GetClosestPlayer(distMaxCheck)
  menuIsOpen = 0
end

--------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if menuIsOpen ~= 0 then
      if IsControlJustPressed(1, KeyToucheClose) then
        closeGui()
      elseif menuIsOpen == 2 then
        local ply = GetPlayerPed(-1)
        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        DisablePlayerFiring(ply, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 106, true)
        if IsDisabledControlJustReleased(0, 142) then
          SendNUIMessage({method = "clickGui"})
        end
      end
    end
  end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if(not IsPedInAnyVehicle(GetPlayerPed(-1), false))then
        if IsControlJustPressed(1, 167) then
            PersonnalMenu() -- Menu to draw
            Menu.hidden = not Menu.hidden -- Hide/Show the menu
        end
        Menu.renderGUI(options) -- Draw menu on each tick if Menu.hidden = false
        if IsEntityDead(PlayerPedId()) then
            PlayerIsDead()
            -- prevent the death check from overloading the server
            playerdead = true
			else
			end
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------
