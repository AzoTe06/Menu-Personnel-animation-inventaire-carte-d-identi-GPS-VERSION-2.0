--
-- Created by IntelliJ IDEA.
-- User: Djyss
-- Date: 09/05/2017
-- Time: 09:55
-- To change this template use File | Settings | File Templates.
--

require "resources/essentialmode/lib/MySQL"
MySQL:open(database.host, database.name, database.username, database.password)

RegisterServerEvent("item:getItems")
RegisterServerEvent("item:updateQuantity")
RegisterServerEvent("item:setItem")
RegisterServerEvent("item:reset")
RegisterServerEvent("item:sell")
RegisterServerEvent("player:giveItem")
RegisterServerEvent("pm:wearHat")
RegisterServerEvent("pm:wearPercing")
RegisterServerEvent("pm:wearGlasses")
RegisterServerEvent("pm:wearMask")
RegisterServerEvent("player:swapMoney")

local items = {}

AddEventHandler("item:getItems", function()
    items = {}
    local player = getPlayerID(source)
    local executed_query = MySQL:executeQuery("SELECT * FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE user_id = '@username'", { ['@username'] = player })
    local result = MySQL:getResults(executed_query, { 'quantity', 'libelle', 'item_id' }, "item_id")
    if (result) then
        for _, v in ipairs(result) do
            t = { ["quantity"] = v.quantity, ["libelle"] = v.libelle }
            table.insert(items, tonumber(v.item_id), t)
        end
    end
    TriggerClientEvent("gui:getItems", source, items)
end)

AddEventHandler("item:setItem", function(item, quantity)
    local player = getPlayerID(source)
    MySQL:executeQuery("INSERT INTO user_inventory (`user_id`, `item_id`, `quantity`) VALUES ('@player', @item, @qty)",
        { ['@player'] = player, ['@item'] = item, ['@qty'] = quantity })
end)

AddEventHandler("item:updateQuantity", function(qty, id)
    local player = getPlayerID(source)
    MySQL:executeQuery("UPDATE user_inventory SET `quantity` = @qty WHERE `user_id` = '@username' AND `item_id` = @id", { ['@username'] = player, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id) })
end)

AddEventHandler("item:reset", function()
    local player = getPlayerID(source)
    MySQL:executeQuery("UPDATE user_inventory SET `quantity` = @qty WHERE `user_id` = '@username'", { ['@username'] = player, ['@qty'] = 0 })
end)

AddEventHandler("item:sell", function(id, qty, price)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        MySQL:executeQuery("UPDATE user_inventory SET `quantity` = @qty WHERE `user_id` = '@username' AND `item_id` = @id", { ['@username'] = player, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id) })
        user:addMoney(tonumber(price))
    end)
end)

AddEventHandler("player:giveItem", function(item, name, qty, target)
    local player = getPlayerID(source)
    local executed_query = MySQL:executeQuery("SELECT SUM(quantity) as total FROM user_inventory WHERE user_id = '@username'", { ['@username'] = player })
    local result = MySQL:getResults(executed_query, { 'total' })
    local total = result[1].total
    if (total + qty <= 64) then
        TriggerClientEvent("player:looseItem", source, item, qty)
        TriggerClientEvent("player:receiveItem", target, item, qty)
        TriggerClientEvent("es_freeroam:notify", target, "CHAR_MP_STRIPCLUB_PR", 1, "Mairie", false, "Vous venez de recevoir " .. qty .. " " .. name)
    end
end)

------------------------------------------------------------------------------------------------------------------------
AddEventHandler("pm:wearHat", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local playerSkin_query = MySQL:executeQuery("SELECT * FROM skin WHERE identifier = '@username'", {['@username'] = user.identifier})
        local skin = MySQL:getResults(playerSkin_query, {'identifier','helmet', 'helmet_txt'}, "identifier")
        if(skin)then
            for k,v in ipairs(skin)do
                if v.helmet ~= nil then
                    TriggerClientEvent("pm:accessoriesWearHat", source, v)
                end
            end
        end
    end)
end)

AddEventHandler("pm:wearGlasses", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local playerSkin_query = MySQL:executeQuery("SELECT * FROM skin WHERE identifier = '@username'", {['@username'] = user.identifier})
        local skin = MySQL:getResults(playerSkin_query, {'identifier','glasses', 'glasses_txt'}, "identifier")
        if(skin)then
            for k,v in ipairs(skin)do
                if v.glasses ~= nil then
                    TriggerClientEvent("pm:accessoriesWearGlasses", source, v)
                end
            end
        end
    end)
end)

AddEventHandler("pm:wearPercing", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local playerSkin_query = MySQL:executeQuery("SELECT * FROM skin WHERE identifier = '@username'", {['@username'] = user.identifier})
        local skin = MySQL:getResults(playerSkin_query, {'identifier','percing', 'Percing_txt'}, "identifier")
        if(skin)then
            for k,v in ipairs(skin)do
                if v.percing ~= nil then
                    TriggerClientEvent("pm:accessoriesWearPercing", source, v)
                end
            end
        end
    end)
end)

AddEventHandler("pm:wearMask", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local playerSkin_query = MySQL:executeQuery("SELECT * FROM skin WHERE identifier = '@username'", {['@username'] = user.identifier})
        local skin = MySQL:getResults(playerSkin_query, {'identifier','mask', 'mask_txt'}, "identifier")
        if(skin)then
            for k,v in ipairs(skin)do
                if v.mask ~= nil then
                    TriggerClientEvent("pm:accessoriesWearMask", source, v)
                end
            end
        end
    end)
end)
------------------------------------------------------------------------------------------------------------------------
