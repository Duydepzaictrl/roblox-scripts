getfenv().death = false -- Toggle false to not die after getting bonds
loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/refs/heads/ok/dead%20rails"))()

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- 🚀 NoClip - Đi xuyên tường
local noclipEnabled = false

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipEnabled
            end
        end
    end
end

RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 📌 Tạo UI Bảng điều khiển NoClip + Timer
local screenGui = Instance.new("ScreenGui", player.PlayerGui)

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 150)
mainFrame.Position = UDim2.new(0, 20, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 85, 85)

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Text = "NoClip & Timer"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.BackgroundTransparency = 1

-- ⏳ Bảng Đếm Thời Gian
local timerLabel = Instance.new("TextLabel", mainFrame)
timerLabel.Size = UDim2.new(1, 0, 0, 40)
timerLabel.Position = UDim2.new(0, 0, 0, 35)
timerLabel.Text = "10:00"
timerLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
timerLabel.Font = Enum.Font.GothamBlack
timerLabel.TextSize = 32
timerLabel.BackgroundTransparency = 1

local function startTimer(duration)
    local endTime = tick() + duration
    while tick() < endTime do
        local remaining = endTime - tick()
        timerLabel.Text = string.format("%02d:%02d", math.floor(remaining / 60), math.floor(remaining % 60))
        wait(0.1)
    end
    timerLabel.Text = "00:00"
end

spawn(function()
    startTimer(600) -- Đếm ngược 10 phút (600 giây)
end)

-- 🔘 Nút Bật/Tắt NoClip
local toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.Size = UDim2.new(1, 0, 0, 40)
toggleButton.Position = UDim2.new(0, 0, 0, 80)
toggleButton.Text = "Toggle NoClip"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.BorderSizePixel = 1
toggleButton.BorderColor3 = Color3.fromRGB(255, 85, 85)

toggleButton.MouseButton1Click:Connect(function()
    toggleNoclip()
    toggleButton.Text = "NoClip: " .. (noclipEnabled and "ON" or "OFF")
    toggleButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
end)