-- Créer un GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Aim Assist Menu
local AimAssistMenu = Instance.new("Frame")
AimAssistMenu.Size = UDim2.new(0, 300, 0, 300)
AimAssistMenu.Position = UDim2.new(0.5, -150, 0.3, 0)
AimAssistMenu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AimAssistMenu.BackgroundTransparency = 0.5
AimAssistMenu.Visible = false
AimAssistMenu.Parent = ScreenGui

-- Label for the Aim Assist Status
local AimAssistLabel = Instance.new("TextLabel")
AimAssistLabel.Size = UDim2.new(0, 250, 0, 30)
AimAssistLabel.Position = UDim2.new(0.5, -125, 0.1, 0)
AimAssistLabel.Text = "Aim Assist: Disabled"
AimAssistLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
AimAssistLabel.BackgroundTransparency = 1
AimAssistLabel.Parent = AimAssistMenu

-- Smoothness Label and Slider
local SmoothnessLabel = Instance.new("TextLabel")
SmoothnessLabel.Size = UDim2.new(0, 250, 0, 30)
SmoothnessLabel.Position = UDim2.new(0.5, -125, 0.2, 0)
SmoothnessLabel.Text = "Smoothness: 0.5"
SmoothnessLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SmoothnessLabel.BackgroundTransparency = 1
SmoothnessLabel.Parent = AimAssistMenu

local SmoothnessSlider = Instance.new("Slider")
SmoothnessSlider.Size = UDim2.new(0, 250, 0, 30)
SmoothnessSlider.Position = UDim2.new(0.5, -125, 0.3, 0)
SmoothnessSlider.Min = 0
SmoothnessSlider.Max = 1
SmoothnessSlider.Value = 0.5
SmoothnessSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SmoothnessSlider.Parent = AimAssistMenu

-- Keybind Label and TextBox
local KeybindLabel = Instance.new("TextLabel")
KeybindLabel.Size = UDim2.new(0, 250, 0, 30)
KeybindLabel.Position = UDim2.new(0.5, -125, 0.4, 0)
KeybindLabel.Text = "Keybind: R"
KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
KeybindLabel.BackgroundTransparency = 1
KeybindLabel.Parent = AimAssistMenu

local KeybindTextBox = Instance.new("TextBox")
KeybindTextBox.Size = UDim2.new(0, 250, 0, 30)
KeybindTextBox.Position = UDim2.new(0.5, -125, 0.5, 0)
KeybindTextBox.Text = "R"
KeybindTextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
KeybindTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeybindTextBox.Parent = AimAssistMenu

-- Boutons
local AimAssistToggleButton = Instance.new("TextButton")
AimAssistToggleButton.Size = UDim2.new(0, 250, 0, 30)
AimAssistToggleButton.Position = UDim2.new(0.5, -125, 0.6, 0)
AimAssistToggleButton.Text = "Toggle Aim Assist"
AimAssistToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimAssistToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AimAssistToggleButton.Parent = AimAssistMenu

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 250, 0, 30)
CloseButton.Position = UDim2.new(0.5, -125, 0.85, 0)
CloseButton.Text = "Close Menu"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.Parent = AimAssistMenu

-- Variables pour Aim Assist
local AimAssistEnabled = false
local toggleKey = Enum.KeyCode.R  -- Default key is R
local AimAssistSmoothness = 0.5

-- Fonction pour activer/désactiver Aim Assist
local function toggleAimAssist()
    AimAssistEnabled = not AimAssistEnabled
    if AimAssistEnabled then
        AimAssistLabel.Text = "Aim Assist: Enabled"
        AimAssistLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        AimAssistLabel.Text = "Aim Assist: Disabled"
        AimAssistLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

-- Fonction pour ouvrir/fermer le menu
local function toggleMenu()
    AimAssistMenu.Visible = not AimAssistMenu.Visible
end

-- Logique pour la mise à jour de la smoothness
SmoothnessSlider.Changed:Connect(function()
    AimAssistSmoothness = SmoothnessSlider.Value
    SmoothnessLabel.Text = "Smoothness: " .. tostring(math.round(AimAssistSmoothness, 2))
end)

-- Fonction pour mettre à jour la touche du keybind
KeybindTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local newKey = KeybindTextBox.Text:upper()
        local keyEnum = Enum.KeyCode[newKey]
        if keyEnum then
            toggleKey = keyEnum
            KeybindLabel.Text = "Keybind: " .. newKey
        else
            KeybindLabel.Text = "Invalid Key"
        end
    end
end)

-- Connecter les boutons
AimAssistToggleButton.MouseButton1Click:Connect(toggleAimAssist)
CloseButton.MouseButton1Click:Connect(toggleMenu)

-- Logique d'Aim Assist
game:GetService("RunService").RenderStepped:Connect(function()
    if AimAssistEnabled then
        local character = game.Players.LocalPlayer.Character
        local camera = workspace.CurrentCamera

        if character and character:FindFirstChild("HumanoidRootPart") then
            local closestTarget = nil
            local closestTargetPart = nil
            local closestDistance = math.huge

            -- Vérifier si une cible est dans la vue de la caméra
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    -- Ne pas viser les joueurs de la même équipe
                    if player.Team == game.Players.LocalPlayer.Team then
                        continue  -- Ignore this player if they are on the same team
                    end
                    
                    local targetPart = player.Character.HumanoidRootPart
                    local screenPoint = camera:WorldToViewportPoint(targetPart.Position)

                    -- Vérifier si la cible est dans l'écran de la caméra
                    if screenPoint.Z > 0 then
                        local distance = (camera.CFrame.Position - targetPart.Position).Magnitude
                        -- Cibler la personne la plus proche dans l'écran
                        if distance < closestDistance then
                            closestDistance = distance
                            closestTarget = player
                            closestTargetPart = targetPart
                        end
                    end
                end
            end

            -- Appliquer l'Aim Assist sur la cible sélectionnée
            if closestTargetPart then
                local direction = (closestTargetPart.Position - camera.CFrame.Position).Unit
                camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction), AimAssistSmoothness)
            end
        end
    end
end)

-- Gérer les entrées clavier
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    elseif input.KeyCode == toggleKey then
        toggleAimAssist()
    end
end)
