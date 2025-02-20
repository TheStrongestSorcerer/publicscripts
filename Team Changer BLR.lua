local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FancyTeamSelector"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 600, 0, 400)
Frame.Position = UDim2.new(0.5, -300, 0.5, -200)
Frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
Frame.BorderSizePixel = 0

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Gradient = Instance.new("UIGradient", Frame)
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(0.2, 0.2, 0.4)),
    ColorSequenceKeypoint.new(1, Color3.new(0.1, 0.1, 0.2))
}

local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 100, 0, 50)
ToggleButton.Position = UDim2.new(1, -120, 0, 20)
ToggleButton.Text = "Toggle"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
ToggleButton.BorderSizePixel = 0

Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)

local ToggleGradient = Instance.new("UIGradient", ToggleButton)
ToggleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(0.4, 0.4, 0.8)),
    ColorSequenceKeypoint.new(1, Color3.new(0.2, 0.2, 0.6))
}

local isFrameVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    isFrameVisible = not isFrameVisible
    Frame.Visible = isFrameVisible
end)

local PositionOffsets = {
    CF = {0, 0},
    CM = {0, 70},
    GK = {0, 140},
    RW = {100, 0},
    LW = {-100, 0}
}

local function createButton(team, position, xOffset, yOffset)
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0, 100, 0, 50)
    Button.Position = UDim2.new(0.5, xOffset + (team == "Home" and -150 or 150), 0.5, yOffset)
    Button.Text = team .. " " .. position
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.Font = Enum.Font.Arcade
    Button.TextScaled = true
    Button.BackgroundColor3 = team == "Home" and Color3.new(0, 1, 1) or Color3.new(1, 0, 0)
    
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

    Button.MouseButton1Click:Connect(function()
        ReplicatedStorage.Packages.Knit.Services.TeamService.RE.Select:FireServer(team, position)
    end)
end

for _, team in ipairs({"Home", "Away"}) do
    for position, offsets in pairs(PositionOffsets) do
        createButton(team, position, offsets[1], offsets[2])
    end
end
