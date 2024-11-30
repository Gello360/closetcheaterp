-- Créer un GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Aim Assist Menu
local AimAssistMenu = Instance.new("Frame")
AimAssistMenu.Size = UDim2.new(0, 300, 0, 150)
AimAssistMenu.Position = UDim2.new(0.5, -150, 0.3, 0)
AimAssistMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AimAssistMenu.BackgroundTransparency = 0.5
AimAssistMenu.Visible = false
AimAssistMenu.Parent = ScreenGui

-- Label for the Aim Assist Status
local AimAssistLabel = Instance.new("TextLabel")
AimAssistLabel.Size = UDim2.new(0, 200, 0, 50)
AimAssistLabel.Position = UDim2.new(0.5, -100, 0.1, 0)
AimAssistLabel.Text = "Aim Assist: Disabled"
AimAssistLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
AimAssistLabel.BackgroundTransparency = 1
AimAssistLabel.Parent = AimAssistMenu

-- Button to toggle Aim Assist
local AimAssistToggleButton = Instance.new("TextButton")
AimAssistToggleButton.Size = UDim2.new(0, 200, 0, 50)
AimAssistToggleButton.Position = UDim2.new(0.5, -100, 0.2, 0)
AimAssistToggleButton.Text = "Toggle Aim Assist"
AimAssistToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimAssistToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AimAssistToggleButton.Parent = AimAssistMenu

-- Button to close the menu
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 200, 0, 50)
CloseButton.Position = UDim2.new(0.5, -100, 0.7, 0)
CloseButton.Text = "Close Menu"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Parent = AimAssistMenu

-- Button to change the key for Aim Assist toggle
local ChangeKeyButton = Instance.new("TextButton")
ChangeKeyButton.Size = UDim2.new(0, 200, 0, 50)
ChangeKeyButton.Position = UDim2.new(0.5, -100, 0.4, 0)
ChangeKeyButton.Text = "Change Toggle Key"
ChangeKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ChangeKeyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ChangeKeyButton.Parent = AimAssistMenu

-- Variables for Aim Assist
local AimAssistEnabled = false
local AimAssistSpeed = 2
local AimAssistSmoothness = 50

-- Default Key for toggling Aim Assist
local toggleKey = Enum.KeyCode.R

-- Function to toggle the Aim Assist
local function toggleAimAssist()
    AimAssistEnabled = not AimAssistEnabled
    if AimAssistEnabled then
        AimAssistLabel.Text = "Aim Assist: Enabled"
        AimAssistLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        -- Start the logic for Aim Assist (Add your Aim Assist functionality here)
    else
        AimAssistLabel.Text = "Aim Assist: Disabled"
        AimAssistLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        -- Stop the logic for Aim Assist (Add your logic to disable here)
    end
end

-- Function to open or close the Aim Assist Menu
local function toggleMenu()
    AimAssistMenu.Visible = not AimAssistMenu.Visible
end

-- Function to change the toggle key
local function changeToggleKey(newKey)
    toggleKey = newKey
end

-- Connect the Toggle Aim Assist button to the function
AimAssistToggleButton.MouseButton1Click:Connect(toggleAimAssist)

-- Connect the Close Button to hide the menu
CloseButton.MouseButton1Click:Connect(toggleMenu)

-- Connect the Change Key button to allow the player to choose a new key
ChangeKeyButton.MouseButton1Click:Connect(function()
    -- Allow the player to choose a new key using InputBegan event
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        -- Update the toggleKey when a new key is pressed
        changeToggleKey(input.KeyCode)
        print("New toggle key set to: " .. input.KeyCode.Name)
    end)
end)

-- Function to open or close the menu with RightShift key
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    -- Open/Close the menu when RightShift is pressed
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
    -- Toggle Aim Assist with the configured toggle key (Default: R)
    if input.KeyCode == toggleKey then
        toggleAimAssist()
    end
end)
