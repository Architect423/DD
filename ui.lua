-- ui.lua
local ui = {}
local world = require('world')
function ui:drawMenu()
    love.graphics.printf("Press Enter to Start Game or Esc to Exit", love.graphics.getWidth() / 2 - 50, love.graphics.getHeight() / 2, 100, 'center')
end

function ui:drawClassSelection(classes, selectedClassIndex)
    love.graphics.print('Select your class:', 10, 10)
    for i, class in ipairs(classes) do
        love.graphics.setColor(class.color)
        love.graphics.print(class.name, 10, 30 * i + 10)
        if i == selectedClassIndex then
            love.graphics.print('<<', 200, 30 * i + 10)
        end
    end
end

function ui:drawGameOver()
    love.graphics.printf("Game Over! Press Enter to Restart or Esc to go to Main Menu", love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2, 200, 'center')
end

function ui:drawInGameUI(player, roundTimer)
    love.graphics.print("Time: " .. math.floor(roundTimer), love.graphics.getWidth() - 100, 10)
    if player.class == "Wizard" then
        love.graphics.print("Left-click to cast Chain Lightning", 10, 30)
    elseif player.class == "Barbarian" then
        love.graphics.print("Left-click to perform Axe Swing", 10, 30)
    elseif player.class == "Ranger" then
        love.graphics.print("Left-click to shoot Arrow", 10, 30)
    end
	 ui:drawLootCount(player)
end

function ui:drawHealthBar(player)
    love.graphics.setColor(1, 1, 1)  -- Reset color to default (white)
    love.graphics.rectangle('fill', 10, 10, player.health, 10)  -- Health bar
end

function ui:drawLootCount(player)
    love.graphics.print("Loot count:", 10, 60)
    local i = 1
    for name, count in pairs(player.inventory.lootCount) do
        love.graphics.print(name .. ": " .. count, 10, 60 + 20 * i)
        i = i + 1
    end
end

function ui:drawShop(npc, shopItems)
    -- Calculate the shop's position to be next to the NPC
    local shopX = npc.x + npc.size
    local shopY = npc.y

    -- Calculate the height of the shop background based on the number of shop items
    local shopHeight = 50 * #shopItems

    -- Draw the shop background
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8) -- Set the background color
    love.graphics.rectangle('fill', shopX, shopY, 250, shopHeight)

    -- Reset color for text and buttons
    love.graphics.setColor(1, 1, 1)

    -- List shop items
    for i, item in ipairs(shopItems) do
        local y = shopY + 50 * i
        love.graphics.print(item.name .. " - " .. item.price .. " gold", shopX, y)
        -- Draw a "Buy" button for each item
        love.graphics.rectangle('line', shopX + 200, y, 50, 20) -- Draw button outline
        love.graphics.printf("Buy", shopX + 200, y, 50, 'center')

        -- Check if the player clicks the "Buy" button
        if love.mouse.isDown(1) then
            local mouseX, mouseY = love.mouse.getPosition()
            if mouseX >= shopX + 200 and mouseX <= shopX + 250 and mouseY >= y and mouseY <= y + 20 then
                -- Buy the item if the player has enough gold
                if player.gold >= item.price then
                    player.gold = player.gold - item.price
                    table.insert(player.inventory, item)
                    print("You bought " .. item.name)
                else
                    print("Not enough gold")
                end
            end
        end
    end
end



return ui
