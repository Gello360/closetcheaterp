local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local AimAssistLabel = Instance.new("TextLabel")
AimAssistLabel.Size = UDim2.new(0, 200, 0, 50)
AimAssistLabel.Position = UDim2.new(0.5, -100, 0.1, 0)
AimAssistLabel.Text = "Aim Assist: Disabled"
AimAssistLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
AimAssistLabel.BackgroundTransparency = 1
AimAssistLabel.Parent = ScreenGui

local AimAssistToggleButton = Instance.new("TextButton")
AimAssistToggleButton.Size = UDim2.new(0, 200, 0, 50)
AimAssistToggleButton.Position = UDim2.new(0.5, -100, 0.2, 0)
AimAssistToggleButton.Text = "Toggle Aim Assist"
AimAssistToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimAssistToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AimAssistToggleButton.Parent = ScreenGui

local AimAssistEnabled = false
local AimAssistSpeed = 2
local AimAssistSmoothness = 50

local blacklist = {
    [game.Players.LocalPlayer.UserId] = true
}

local function toggleAimAssist()
    AimAssistEnabled = not AimAssistEnabled
    if AimAssistEnabled then
        AimAssistLabel.Text = "Aim Assist: Enabled"
        AimAssistLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        game:GetService("RunService").RenderStepped:Connect(function()
            if AimAssistEnabled then
                local closestPlayer = nil
                local minDistance = math.huge
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if blacklist[player.UserId] then
                            continue
                        end

                        if player == game.Players.LocalPlayer then
                            continue  -- Ignore LocalPlayer
                        end

                        local distance = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < minDistance then
                            minDistance = distance
                            closestPlayer = player
                        end
                    end
                end

                if closestPlayer then
                    local humanoidRootPart = closestPlayer.Character.HumanoidRootPart
                    local camera = game.Workspace.CurrentCamera
                    camera.CFrame = camera.CFrame:lerp(CFrame.new(camera.CFrame.Position, humanoidRootPart.Position), AimAssistSpeed / AimAssistSmoothness)
                end
            end
        end)
    else
        AimAssistLabel.Text = "Aim Assist: Disabled"
        AimAssistLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end

AimAssistToggleButton.MouseButton1Click:Connect(toggleAimAssist)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.R then
        toggleAimAssist()
    end
end)
