if game:GetService("CoreGui"):FindFirstChild("CustomGUI") then
    game:GetService("CoreGui").CustomGUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "CustomGUI"
gui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local function createButton(name, text, position, parent)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 100, 0, 40)
    button.Position = position
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    button.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = button

    return button
end

local toggleButton = createButton("Toggle Bank UI", "Toggle Bank UI", UDim2.new(0.5, -50, 0.2, 0), mainFrame)
local infMoneyButton = createButton("InfMoney", "InfMoney", UDim2.new(0.5, -50, 0.6, 0), mainFrame)

local targetGui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("HUD") and game:GetService("Players").LocalPlayer.PlayerGui.HUD:FindFirstChild("Bank")
local state = false

toggleButton.MouseButton1Click:Connect(function()
    if targetGui then
        state = not state
        targetGui.Active = state
        targetGui.Visible = state
        toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end)

local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0, 200, 0, 100)
notificationFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
notificationFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
notificationFrame.Visible = false
notificationFrame.Parent = gui

local notificationCorner = Instance.new("UICorner")
notificationCorner.CornerRadius = UDim.new(0, 10)
notificationCorner.Parent = notificationFrame

local notificationText = Instance.new("TextLabel")
notificationText.Size = UDim2.new(1, 0, 0.5, 0)
notificationText.Position = UDim2.new(0, 0, 0, 0)
notificationText.Text = "Run InfMoney? If You Dont want roll anim Reset"
notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationText.BackgroundTransparency = 1
notificationText.Parent = notificationFrame

local yesButton = createButton("Yes", "Yes", UDim2.new(0.2, 0, 0.6, 0), notificationFrame)
local noButton = createButton("No", "No", UDim2.new(0.6, 0, 0.6, 0), notificationFrame)

infMoneyButton.MouseButton1Click:Connect(function()
    notificationFrame.Visible = true
end)

yesButton.MouseButton1Click:Connect(function()
    notificationFrame.Visible = false

    local function roll()
        local args = { "PremRollSkin10" }
        game:GetService("ReplicatedStorage").RemoteFunction:InvokeServer(unpack(args))
    end

    local function sell()
        local skins = {
            "Hot Pink", "Agent", "Checkered", "Grey Camo", "Rusted Red",
            "Green Camo", "Orange Crush", "Painted Yellow", "Painted Orange",
            "Damaged", "Earth", "Painted Blue", "Painted Green", "Painted Red", 
            "Painted Pink", "Painted Purple", "Green Sentry", "Pink Sentry", 
            "Red Sentry", "Royal", "Fallen Agent"
        }
        local guns = {"SMG", "LMG", "Double Barrel Shotgun", "Revolver", "AK47", "Turret", "Shotgun"}

        for _, g in ipairs(guns) do
            for _, s in ipairs(skins) do
                local evArgs = { "SellSkin", g, s }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(evArgs))
            end
        end
    end

    roll()
    sell()
    task.wait(1)
    print("lol") 
end)

noButton.MouseButton1Click:Connect(function()
    notificationFrame.Visible = false
end)

local toggleGuiButton = createButton("ToggleGUI", "Toggle GUI", UDim2.new(0.5, -50, -0.3, 0), gui)

toggleGuiButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)
