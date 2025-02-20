-- Delete previous ESP GUI if it exists
if game.CoreGui:FindFirstChild("ESP_GUI") then
    game.CoreGui:FindFirstChild("ESP_GUI"):Destroy()
end

local colourTable = {
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 0, 255),
    Red = Color3.fromRGB(255, 0, 0),
    Yellow = Color3.fromRGB(255, 255, 0),
    Orange = Color3.fromRGB(255, 165, 0),
    Purple = Color3.fromRGB(128, 0, 128)
}

-- Use _G.ESPColors if set and valid; otherwise, default to Red
local validColors = {}
if type(_G.ESPColors) == "table" then
    for _, color in pairs(_G.ESPColors) do
        if colourTable[color] then
            table.insert(validColors, colourTable[color])
        end
    end
end

-- Default to Red if no valid colors are provided
if #validColors == 0 then
    table.insert(validColors, colourTable.Red)
end

_G.ESPToggle = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_GUI"
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 100)
mainFrame.Position = UDim2.new(0.5, -150, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local outerFrame = Instance.new("Frame")
outerFrame.Size = UDim2.new(0, 220, 0, 70)
outerFrame.Position = UDim2.new(0.5, -110, 0.5, -35)
outerFrame.BackgroundTransparency = 1
outerFrame.Parent = mainFrame
outerFrame.Active = true
outerFrame.Draggable = true

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0.5, -25)
toggleButton.Text = "Toggle ESP"
toggleButton.Parent = outerFrame
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 12)
buttonCorner.Parent = toggleButton

toggleButton.MouseButton1Click:Connect(function()
    _G.ESPToggle = not _G.ESPToggle
    toggleButton.Text = _G.ESPToggle and "ESP ON" or "ESP OFF"
end)

local function getCharacter(player)
    return Workspace:FindFirstChild(player.Name)
end

local function addHighlightToCharacter(player, character)
    if player == LocalPlayer then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart and not humanoidRootPart:FindFirstChild("Highlight") then
        local highlightClone = Instance.new("Highlight")
        highlightClone.Name = "Highlight"
        highlightClone.Adornee = character
        highlightClone.Parent = humanoidRootPart
        highlightClone.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlightClone.FillColor = validColors[math.random(#validColors)] -- Assign random color
        highlightClone.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlightClone.FillTransparency = 0.5
    end
end

local function removeHighlightFromCharacter(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local highlightInstance = humanoidRootPart:FindFirstChild("Highlight")
        if highlightInstance then
            highlightInstance:Destroy()
        end
    end
end

local function updateHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        local character = getCharacter(player)
        if character then
            if _G.ESPToggle then
                addHighlightToCharacter(player, character)
            else
                removeHighlightFromCharacter(character)
            end
        end
    end
end

RunService.RenderStepped:Connect(updateHighlights)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if _G.ESPToggle then
            addHighlightToCharacter(player, character)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(playerRemoved)
    local character = playerRemoved.Character
    if character then
        removeHighlightFromCharacter(character)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.H and not gameProcessed then
        mainFrame.Visible = not mainFrame.Visible
    end
end)
