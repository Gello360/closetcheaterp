-- Créer un GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Aim Assist Menu
local AimAssistMenu = Instance.new("Frame")
AimAssistMenu.Size = UDim2.new(0, 300, 0, 350)  -- Increased size for the slider
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

-- Boutons
local AimAssistToggleButton = Instance.new("TextButton")
AimAssistToggleButton.Size = UDim2.new(0, 250, 0, 30)
AimAssistToggleButton.Position = UDim2.new(0.5, -125, 0.3, 0)
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

-- Smoothness Slider
local SmoothnessSlider = Instance.new("TextButton")
SmoothnessSlider.Size = UDim2.new(0, 250, 0, 30)
SmoothnessSlider.Position = UDim2.new(0.5, -125, 0.55, 0)
SmoothnessSlider.Text = "Smoothness: 0.5"
SmoothnessSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SmoothnessSlider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SmoothnessSlider.Parent = AimAssistMenu

-- Variables pour Aim Assist
local AimAssistEnabled = false
local toggleKey = Enum.KeyCode.R
local AimAssistSmoothness = 0.5
local MaxDistance = 20  -- Maximum distance to target players (in studs)

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

-- Fonction pour ajuster la smoothness
local function adjustSmoothness()
    AimAssistSmoothness = AimAssistSmoothness + 0.1
    if AimAssistSmoothness > 1 then
        AimAssistSmoothness = 0.1
    end
    SmoothnessSlider.Text = "Smoothness: " .. string.format("%.1f", AimAssistSmoothness)
end

-- Fonction pour ouvrir/fermer le menu
local function toggleMenu()
    AimAssistMenu.Visible = not AimAssistMenu.Visible
end

-- Connecter les boutons
AimAssistToggleButton.MouseButton1Click:Connect(toggleAimAssist)
CloseButton.MouseButton1Click:Connect(toggleMenu)
SmoothnessSlider.MouseButton1Click:Connect(adjustSmoothness)

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
                    local targetPart = player.Character.HumanoidRootPart
                    local screenPoint = camera:WorldToViewportPoint(targetPart.Position)

                    -- Vérifier si la cible est dans l'écran de la caméra
                    if screenPoint.Z > 0 then
                        local distance = (camera.CFrame.Position - targetPart.Position).Magnitude
                        
                        -- Vérifier si la cible est à une distance acceptable
                        if distance < closestDistance and distance <= MaxDistance then
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
