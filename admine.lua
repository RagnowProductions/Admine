local ChatService = game:GetService("Chat")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

ChatService:RegisterChatCallback(Enum.ChatCallbackType.OnCreatingChatWindow, function()
    return false -- Disables the default chat window
end)

-- Start of /give function
ChatService:RegisterProcessCommandsFunction("GiveItem", function(speaker, message)
    local command, args = message:match("^/give%s+(%w+)%s+(.+)$")
    
    if command and args then
        local targetPlayer = nil
        local itemName = args
        
        if args:match("@") then
            local targetSpecifier, itemSpecifier = args:match("@(%w+)%s+(.+)")
            
            if targetSpecifier == "s" then
                targetPlayer = speaker
            else
                targetPlayer = Players:FindFirstChild(targetSpecifier)
            end
            
            itemName = itemSpecifier
        end
        
        if targetPlayer then
            -- Find the item in the workspace
            local itemFolder = Workspace:FindFirstChild("items")
            
            if itemFolder then
                local item = itemFolder:FindFirstChild(itemName)
                
                if item then
                    -- Clone the item and put it in the player's backpack
                    local backpack = targetPlayer:FindFirstChildOfClass("Backpack")
                    
                    if backpack then
                        local itemClone = item:Clone()
                        itemClone.Parent = backpack
                        
                        -- Print a message to the player
                        targetPlayer:Chat("You received " .. itemName)
                    end
                end
            end
        end
    end
end)
-- End of /give function

-- Start of /kill function
ChatService:RegisterProcessCommandsFunction("KillPlayer", function(speaker, message)
    local command, targetSpecifier = message:match("^/kill%s+(.+)$")
    
    if command and targetSpecifier then
        local targetPlayer = nil
        
        if targetSpecifier == "@a" then
            -- Kill all players
            for _, player in ipairs(Players:GetPlayers()) do
                player.Character:BreakJoints()
            end
        elseif targetSpecifier == "@s" then
            -- Kill the speaker
            speaker.Character:BreakJoints()
        elseif targetSpecifier == "@r" then
            -- Kill a random player
            local randomPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
            
            if randomPlayer then
                randomPlayer.Character:BreakJoints()
            end
        elseif targetSpecifier == "@p" then
            -- Kill the nearest player
            local nearestPlayer = nil
            local nearestDistance = math.huge
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= speaker then
                    local distance = (player.Character.HumanoidRootPart.Position - speaker.Character.HumanoidRootPart.Position).Magnitude
                    
                    if distance < nearestDistance then
                        nearestPlayer = player
                        nearestDistance = distance
                    end
                end
            end
            
            if nearestPlayer then
                nearestPlayer.Character:BreakJoints()
            end
        else
            -- Kill the specified player by username
            targetPlayer = Players:FindFirstChild(targetSpecifier)
            
            if targetPlayer then
                targetPlayer.Character:BreakJoints()
            end
        end
    end
end)
-- End of /kill function

-- Start of /clear function
ChatService:RegisterProcessCommandsFunction("ClearInventory", function(speaker, message)
    local command, targetSpecifier = message:match("^/clear%s+(.+)$")
    
    if command and targetSpecifier then
        local targetPlayer = nil
        
        if targetSpecifier == "@a" then
            -- Clear inventory for all players
            for _, player in ipairs(Players:GetPlayers()) do
                clearPlayerInventory(player)
            end
        elseif targetSpecifier == "@s" then
            -- Clear inventory for the speaker
            clearPlayerInventory(speaker)
        elseif targetSpecifier == "@r" then
            -- Clear inventory for a random player
            local randomPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
            
            if randomPlayer then
                clearPlayerInventory(randomPlayer)
            end
        elseif targetSpecifier == "@p" then
            -- Clear inventory for the nearest player
            local nearestPlayer = nil
            local nearestDistance = math.huge
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= speaker then
                    local distance = (player.Character.HumanoidRootPart.Position - speaker.Character.HumanoidRootPart.Position).Magnitude
                    
                    if distance < nearestDistance then
                        nearestPlayer = player
                        nearestDistance = distance
                    end
                end
            end
            
            if nearestPlayer then
                clearPlayerInventory(nearestPlayer)
            end
        else
            -- Clear inventory for the specified player by username
            targetPlayer = Players:FindFirstChild(targetSpecifier)
            
            if targetPlayer then
                clearPlayerInventory(targetPlayer)
            end
        end
    end
end)

function clearPlayerInventory(player)
    local backpack = player:FindFirstChildOfClass("Backpack")
    
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            item:Destroy()
        end
    end
end
-- End of /clear function
