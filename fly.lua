-- LocalScript
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local flying = false
local speed = 60
local velocity

local gui = Instance.new("ScreenGui")
gui.Name = "MobileFlyGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.fromOffset(130, 55)
button.Position = UDim2.new(1, -150, 1, -100)
button.BackgroundTransparency = 0.15
button.Text = "FLY"
button.TextScaled = true
button.Parent = gui

local function setFly(state)
    flying = state

    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")

    if flying then
        velocity = Instance.new("BodyVelocity")
        velocity.Name = "MobileFlyVelocity"
        velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        velocity.Velocity = Vector3.zero
        velocity.Parent = root

        button.Text = "UNFLY"
    else
        if velocity then
            velocity:Destroy()
            velocity = nil
        end

        button.Text = "FLY"
    end
end

button.Activated:Connect(function()
    setFly(not flying)
end)

RunService.RenderStepped:Connect(function()
    if not flying or not velocity then return end

    local camera = workspace.CurrentCamera
    local humanoid = player.Character
        and player.Character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        local direction = humanoid.MoveDirection

        if direction.Magnitude > 0 then
            velocity.Velocity = direction.Unit * speed
        else
            velocity.Velocity = Vector3.zero
        end
    end
end)

player.CharacterAdded:Connect(function()
    flying = false
    velocity = nil
    button.Text = "FLY"
end)
