--[[
    Dead Rails External
        notify("Script execution failed: " .. tostring(execResult), 5)
        return false
    end
    
    log("Script loaded successfully!")
    notify("Dead Rails script loaded successfully!", 3)
    scriptLoaded = true
    return true
end

local function updateCommandsList()
    -- Clear existing entries
    for _, child in pairs(CommandsFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Add command entries
    local yPos = 5
    for cmd, info in pairs(commands) do
        local cmdLabel = Instance.new("TextLabel")
        cmdLabel.Name = cmd .. "Command"
        cmdLabel.Size = UDim2.new(1, -10, 0, 40)
        cmdLabel.Position = UDim2.new(0, 5, 0, yPos)
        cmdLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        cmdLabel.BorderSizePixel = 0
        cmdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        cmdLabel.TextSize = 14
        cmdLabel.Text = CONFIG.PREFIX .. cmd .. " - " .. info.description
        cmdLabel.TextWrapped = true
        cmdLabel.TextXAlignment = Enum.TextXAlignment.Left
        cmdLabel.TextYAlignment = Enum.TextYAlignment.Center
        
        -- Add some padding
        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 5)
        padding.Parent = cmdLabel
        
        -- Add corner
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = cmdLabel
        
        cmdLabel.Parent = CommandsFrame
        yPos = yPos + 45
    end
    
    -- Update scrolling frame size
    CommandsFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

local function processCommand(message)
    if message:sub(1, 1) ~= CONFIG.PREFIX then
        return false
    end
    
    local parts = message:split(" ")
    local command = parts[1]:sub(2) -- Remove prefix
    
    if commands[command] then
        -- Create arguments table without the command
        local args = {}
        for i = 2, #parts do
            table.insert(args, parts[i])
        end
        
        -- Execute command
        commands[command].callback(args)
        return true
    end
    
    return false
end

-- Setup UI
local function setupUI()
    ScreenGui.Name = "DeadRailsScriptGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Protect GUI from being detected
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    elseif gethui then
        ScreenGui.Parent = gethui()
    else
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 350, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainFrame
    
    -- Title Bar
    Title.Name = "Title"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Title.BorderSizePixel = 0
    Title.Text = "Dead Rails Script"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = MainFrame
    
    -- Corner for title
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = Title
    
    -- Status Text
    StatusText.Name = "StatusText"
    StatusText.Size = UDim2.new(1, -20, 0, 30)
    StatusText.Position = UDim2.new(0, 10, 0, 50)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "Initializing..."
    StatusText.TextColor3 = Color3.fromRGB(200, 200, 200)
    StatusText.TextSize = 14
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Font = Enum.Font.SourceSans
    StatusText.Parent = MainFrame
    
    -- Execute Button
    ExecuteButton.Name = "ExecuteButton"
    ExecuteButton.Size = UDim2.new(0, 150, 0, 35)
    ExecuteButton.Position = UDim2.new(0, 10, 0, 90)
    ExecuteButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    ExecuteButton.BorderSizePixel = 0
    ExecuteButton.Text = "Execute Script"
    ExecuteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecuteButton.TextSize = 16
    ExecuteButton.Font = Enum.Font.SourceSansBold
    ExecuteButton.Parent = MainFrame
    
    -- UICorner for Execute Button
    local execCorner = Instance.new("UICorner")
    execCorner.CornerRadius = UDim.new(0, 6)
    execCorner.Parent = ExecuteButton
    
    -- Reload Button
    ReloadButton.Name = "ReloadButton"
    ReloadButton.Size = UDim2.new(0, 150, 0, 35)
    ReloadButton.Position = UDim2.new(0, 170, 0, 90)
    ReloadButton.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
    ReloadButton.BorderSizePixel = 0
    ReloadButton.Text = "Reload Script"
    ReloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ReloadButton.TextSize = 16
    ReloadButton.Font = Enum.Font.SourceSansBold
    ReloadButton.Parent = MainFrame
    
    -- UICorner for Reload Button
    local reloadCorner = Instance.new("UICorner")
    reloadCorner.CornerRadius = UDim.new(0, 6)
    reloadCorner.Parent = ReloadButton
    
    -- Close Button
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Parent = MainFrame
    
    -- UICorner for Close Button
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = CloseButton
    
    -- Commands Header
    local CommandsHeader = Instance.new("TextLabel")
    CommandsHeader.Name = "CommandsHeader"
    CommandsHeader.Size = UDim2.new(1, -20, 0, 30)
    CommandsHeader.Position = UDim2.new(0, 10, 0, 135)
    CommandsHeader.BackgroundTransparency = 1
    CommandsHeader.Text = "Available Commands:"
    CommandsHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
    CommandsHeader.TextSize = 16
    CommandsHeader.TextXAlignment = Enum.TextXAlignment.Left
    CommandsHeader.Font = Enum.Font.SourceSansBold
    CommandsHeader.Parent = MainFrame
    
    -- Commands Frame
    CommandsFrame.Name = "CommandsFrame"
    CommandsFrame.Size = UDim2.new(1, -20, 0, 225)
    CommandsFrame.Position = UDim2.new(0, 10, 0, 165)
    CommandsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CommandsFrame.BorderSizePixel = 0
    CommandsFrame.ScrollBarThickness = 6
    CommandsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    CommandsFrame.Parent = MainFrame
    
    -- UICorner for Commands Frame
    local cmdFrameCorner = Instance.new("UICorner")
    cmdFrameCorner.CornerRadius = UDim.new(0, 6)
    cmdFrameCorner.Parent = CommandsFrame
    
    -- Add event handlers
    ExecuteButton.MouseButton1Click:Connect(function()
        loadMainScript()
        updateCommandsList()
    end)
    
    ReloadButton.MouseButton1Click:Connect(function()
        if scriptLoaded then
            scriptLoaded = false
            commands = {}
            loadMainScript()
            updateCommandsList()
        else
            notify("Script hasn't been loaded yet. Please execute first.", 3)
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        guiVisible = false
        ScreenGui.Enabled = false
    end)
end

-- Event Handlers
local function onChatted(message)
    if scriptLoaded then
        processCommand(message)
    end
end

local function setupEventHandlers()
    LocalPlayer.Chatted:Connect(onChatted)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == CONFIG.TOGGLE_KEY then
            guiVisible = not guiVisible
            ScreenGui.Enabled = guiVisible
        end
    end)
end

-- Initialization
local function initialize()
    if initialized then return end
    
    -- Check if the game is supported
    if not isGameSupported() then
        notify("This script is intended for Dead Rails only.", 5)
        warn("[Dead Rails Script] This script is intended for Dead Rails only.")
        return
    end
    
    setupUI()
    setupEventHandlers()
    
    -- Register basic commands
    commands["help"] = {
        description = "Shows available commands",
        callback = function()
            notify("Check the GUI for a list of commands.", 3)
        end
    }
    
    commands["reload"] = {
        description = "Reloads the script",
        callback = function()
            notify("Reloading script...", 2)
            scriptLoaded = false
            commands = {}
            loadMainScript()
            updateCommandsList()
        end
    }
    
    commands["toggle"] = {
        description = "Toggles the GUI visibility",
        callback = function()
            guiVisible = not guiVisible
            ScreenGui.Enabled = guiVisible
            notify(guiVisible and "GUI shown" or "GUI hidden", 2)
        end
    }
    
    updateCommandsList()
    initialized = true
    
    -- Auto-execute on start
    loadMainScript()
}

-- Start the script
initialize()