local ChatService = game:GetService("Chat")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

ChatService:RegisterChatCallback(Enum.ChatCallbackType.OnCreatingChatWindow, function()
    return false -- Disables the default chat window
end)

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
