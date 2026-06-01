--[[
    ==========================================================================
    TCK HUB PREMIUM MODERN UI LIBRARY
    ==========================================================================
    * Style: Ultra-Premium Glassmorphism & Dark Theme
    * Optimized for High FPS & Smooth Micro-Animations
    * 100% Backward Compatible with original API
]]

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

-- Clean up any existing instances to prevent overlays
if CoreGui:FindFirstChild("TckHub") then
    pcall(function() CoreGui.TckHub:Destroy() end)
end
if CoreGui:FindFirstChild("ScreenGui") then
    pcall(function() CoreGui.ScreenGui:Destroy() end)
end

-- Premium Color Palette
_G.Primary = Color3.fromRGB(120, 110, 255)  -- Glowing Violet Accent
_G.Dark = Color3.fromRGB(13, 13, 16)        -- Rich Dark Glass Base
_G.Third = Color3.fromRGB(255, 60, 100)     -- Vibrant Neon Red/Pink

-- File level global reference to main GUI to bypass restricted indexing on executors
local MainGuiInstance = nil

-- Modern Utility Helpers
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.Name = "Corner"
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Name = "Stroke"
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.85
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function makeDraggable(topbar, object)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        TweenService:Create(object, TweenInfo.new(0.12, Enum.EasingStyle.OutQuad), {
            Position = targetPos
        }):Play()
    end
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScreenGui"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local OutlineButton = Instance.new("Frame")
OutlineButton.Name = "OutlineButton"
OutlineButton.Parent = ScreenGui
OutlineButton.ClipsDescendants = false
OutlineButton.BackgroundColor3 = _G.Dark
OutlineButton.BackgroundTransparency = 0.15
OutlineButton.Position = UDim2.new(0, 15, 0, 15)
OutlineButton.Size = UDim2.new(0, 50, 0, 50)
createCorner(OutlineButton, 25)
createStroke(OutlineButton, _G.Primary, 1.5, 0.6)

local ImageButton = Instance.new("ImageButton")
ImageButton.Parent = OutlineButton
ImageButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageButton.Size = UDim2.new(0, 36, 0, 36)
ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
ImageButton.BackgroundTransparency = 1
ImageButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
ImageButton.Image = "rbxassetid://13940080072"
ImageButton.AutoButtonColor = false
createCorner(ImageButton, 18)
makeDraggable(ImageButton, OutlineButton)

local function toggleMainUI()
    print("[TCK] Logo Clicked")
    if MainGuiInstance then
        MainGuiInstance.Enabled = not MainGuiInstance.Enabled
        print("[TCK] Main UI Opened: " .. tostring(MainGuiInstance.Enabled))
    else
        local mainGui = CoreGui:FindFirstChild("TckHub")
        if mainGui then
            mainGui.Enabled = not mainGui.Enabled
            print("[TCK] Main UI Opened (via fallback): " .. tostring(mainGui.Enabled))
        else
            warn("[TCK] Main UI Instance not found!")
        end
    end
end

ImageButton.MouseButton1Click:Connect(toggleMainUI)
ImageButton.TouchTap:Connect(toggleMainUI) -- Dedicated Mobile touch support

-- Hover effect on OutlineButton
ImageButton.MouseEnter:Connect(function()
    TweenService:Create(OutlineButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(ImageButton, TweenInfo.new(0.3), {Size = UDim2.new(0, 40, 0, 40)}):Play()
end)
ImageButton.MouseLeave:Connect(function()
    TweenService:Create(OutlineButton, TweenInfo.new(0.3), {BackgroundTransparency = 0.15}):Play()
    TweenService:Create(ImageButton, TweenInfo.new(0.3), {Size = UDim2.new(0, 36, 0, 36)}):Play()
end)

-- Notification Frame
local NotificationFrame = Instance.new("ScreenGui")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Parent = CoreGui
NotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Global

local NotificationList = {}

local function removeNotification(index)
    local removed = table.remove(NotificationList, index)
    if removed then
        TweenService:Create(removed.Frame, TweenInfo.new(0.4, Enum.EasingStyle.InBack), {
            Position = UDim2.new(0.5, 0, -0.2, 0),
            BackgroundTransparency = 1
        }):Play()
        task.delay(0.4, function()
            removed.Frame:Destroy()
        end)
        -- Realign remaining notifications
        for i = 1, #NotificationList do
            TweenService:Create(NotificationList[i].Frame, TweenInfo.new(0.3, Enum.EasingStyle.OutQuad), {
                Position = UDim2.new(0.5, 0, 0.05 + (i - 1) * 0.1, 0)
            }):Play()
        end
    end
end

task.spawn(function()
    while true do
        task.wait(4)
        if #NotificationList > 0 then
            removeNotification(1)
        end
    end
end)

local Update = {}

function Update:Notify(desc)
    local OutlineFrame = Instance.new("Frame")
    OutlineFrame.Name = "NotificationOutline"
    OutlineFrame.Parent = NotificationFrame
    OutlineFrame.ClipsDescendants = false
    OutlineFrame.BackgroundColor3 = _G.Dark
    OutlineFrame.BackgroundTransparency = 0.1
    OutlineFrame.AnchorPoint = Vector2.new(0.5, 0)
    OutlineFrame.Position = UDim2.new(0.5, 0, -0.2, 0)
    OutlineFrame.Size = UDim2.new(0, 360, 0, 64)
    createCorner(OutlineFrame, 10)
    createStroke(OutlineFrame, _G.Primary, 1.2, 0.5)

    local Frame = Instance.new("Frame")
    Frame.Name = "MainContent"
    Frame.Parent = OutlineFrame
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(1, 0, 1, 0)

    local Image = Instance.new("ImageLabel")
    Image.Name = "Icon"
    Image.Parent = Frame
    Image.BackgroundTransparency = 1
    Image.Position = UDim2.new(0, 12, 0.5, 0)
    Image.AnchorPoint = Vector2.new(0, 0.5)
    Image.Size = UDim2.new(0, 40, 0, 40)
    Image.Image = "rbxassetid://13940080072"
    createCorner(Image, 8)

    local Title = Instance.new("TextLabel")
    Title.Parent = Frame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 64, 0, 12)
    Title.Size = UDim2.new(1, -76, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "TckHub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Desc = Instance.new("TextLabel")
    Desc.Parent = Frame
    Desc.BackgroundTransparency = 1
    Desc.Position = UDim2.new(0, 64, 0, 32)
    Desc.Size = UDim2.new(1, -76, 0, 20)
    Desc.Font = Enum.Font.GothamMedium
    Desc.Text = desc or ""
    Desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left

    -- Add closing button
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Parent = Frame
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -12, 0, 12)
    CloseBtn.AnchorPoint = Vector2.new(1, 0)
    CloseBtn.Size = UDim2.new(0, 16, 0, 16)
    CloseBtn.Image = "rbxassetid://10747384394"
    CloseBtn.ImageColor3 = Color3.fromRGB(200, 200, 200)
    
    local targetPos = UDim2.new(0.5, 0, 0.05 + (#NotificationList) * 0.1, 0)
    TweenService:Create(OutlineFrame, TweenInfo.new(0.4, Enum.EasingStyle.OutBack), {
        Position = targetPos
    }):Play()

    local entry = {Frame = OutlineFrame}
    table.insert(NotificationList, entry)

    CloseBtn.MouseButton1Click:Connect(function()
        for idx, item in ipairs(NotificationList) do
            if item.Frame == OutlineFrame then
                removeNotification(idx)
                break
            end
        end
    end)
end

function Update:StartLoad()
    print("[TCK] StartLoad bypassed")
end

function Update:Loaded()
    print("[TCK] Loaded bypassed")
end

-- Configuration Configuration File System
local SettingsLib = {
    SaveSettings = true,
    LoadAnimation = true
}

getgenv().LoadConfig = function()
    pcall(function()
        if readfile and writefile and isfile and isfolder then
            if not isfolder("TckHub") then makefolder("TckHub") end
            if not isfolder("TckHub/Library/") then makefolder("TckHub/Library/") end
            local filePath = "TckHub/Library/" .. game.Players.LocalPlayer.Name .. ".json"
            if not isfile(filePath) then
                writefile(filePath, HttpService:JSONEncode(SettingsLib))
            else
                local decoded = HttpService:JSONDecode(readfile(filePath))
                for i, v in pairs(decoded) do
                    SettingsLib[i] = v
                end
            end
        end
    end)
end

getgenv().SaveConfig = function()
    pcall(function()
        if readfile and writefile and isfile and isfolder then
            local filePath = "TckHub/Library/" .. game.Players.LocalPlayer.Name .. ".json"
            writefile(filePath, HttpService:JSONEncode(SettingsLib))
        end
    end)
end

getgenv().LoadConfig()

function Update:SaveSettings()
    return SettingsLib.SaveSettings == true
end

function Update:LoadAnimation()
    return false
end

-- WINDOW SYSTEM
function Update:Window(Config)
    print("[TCK] UI Created")
    local WindowConfig = {
        Size = Config.Size or UDim2.new(0, 480, 0, 340),
        TabWidth = Config.TabWidth or 140
    }
    
    local keybind = Config.Keybind or Enum.KeyCode.RightControl
    local currentpage = ""
    local uiActive = true
    
    local TckHub = Instance.new("ScreenGui")
    TckHub.Name = "TckHub"
    TckHub.Parent = CoreGui
    TckHub.DisplayOrder = 999
    
    -- Assign main GUI globally to bypass index blocks
    MainGuiInstance = TckHub

    local OutlineMain = Instance.new("Frame")
    OutlineMain.Name = "OutlineMain"
    OutlineMain.Parent = TckHub
    OutlineMain.ClipsDescendants = false
    OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5)
    OutlineMain.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    OutlineMain.BackgroundTransparency = 0.2
    OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0)
    OutlineMain.Size = UDim2.new(0, 0, 0, 0)
    createCorner(OutlineMain, 14)
    createStroke(OutlineMain, _G.Primary, 1.5, 0.6)

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = OutlineMain
    Main.ClipsDescendants = true
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Main.BackgroundTransparency = 0.05
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = WindowConfig.Size
    createCorner(Main, 12)
    createStroke(Main, Color3.fromRGB(255, 255, 255), 1, 0.92)

    OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 12, 0, WindowConfig.Size.Y.Offset + 12), "Out", "Quad", 0.4, true)

    local DragButton = Instance.new("Frame")
    DragButton.Name = "DragButton"
    DragButton.Parent = Main
    DragButton.Position = UDim2.new(1, -2, 1, -2)
    DragButton.AnchorPoint = Vector2.new(1, 1)
    DragButton.Size = UDim2.new(0, 16, 0, 16)
    DragButton.BackgroundColor3 = _G.Primary
    DragButton.BackgroundTransparency = 0.7
    DragButton.ZIndex = 10
    createCorner(DragButton, 8)

    local Top = Instance.new("Frame")
    Top.Name = "Top"
    Top.Parent = Main
    Top.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    Top.BackgroundTransparency = 0.5
    Top.Size = UDim2.new(1, 0, 0, 42)
    createCorner(Top, 12)
    createStroke(Top, Color3.fromRGB(255, 255, 255), 1, 0.95)

    local NameHub = Instance.new("TextLabel")
    NameHub.Name = "NameHub"
    NameHub.Parent = Top
    NameHub.BackgroundTransparency = 1
    NameHub.RichText = true
    NameHub.Position = UDim2.new(0, 16, 0.5, 0)
    NameHub.AnchorPoint = Vector2.new(0, 0.5)
    NameHub.Font = Enum.Font.GothamBold
    NameHub.Text = "TckHub"
    NameHub.TextSize = 18
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    local nameSize = TextService:GetTextSize(NameHub.Text, NameHub.TextSize, NameHub.Font, Vector2.new(math.huge, math.huge))
    NameHub.Size = UDim2.new(0, nameSize.X + 5, 0, 25)

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = NameHub
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.new(1, 8, 0.5, 0)
    SubTitle.AnchorPoint = Vector2.new(0, 0.5)
    SubTitle.Font = Enum.Font.GothamMedium
    SubTitle.Text = Config.SubTitle or "v5"
    SubTitle.TextSize = 12
    SubTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
    
    local subSize = TextService:GetTextSize(SubTitle.Text, SubTitle.TextSize, SubTitle.Font, Vector2.new(math.huge, math.huge))
    SubTitle.Size = UDim2.new(0, subSize.X, 0, 25)

    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Top
    CloseButton.BackgroundTransparency = 1
    CloseButton.AnchorPoint = Vector2.new(1, 0.5)
    CloseButton.Position = UDim2.new(1, -16, 0.5, 0)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Image = "rbxassetid://10747384394"
    CloseButton.ImageColor3 = Color3.fromRGB(230, 230, 230)

    CloseButton.MouseButton1Click:Connect(function()
        TckHub.Enabled = false
    end)

    local ResizeButton = Instance.new("ImageButton")
    ResizeButton.Name = "ResizeButton"
    ResizeButton.Parent = Top
    ResizeButton.BackgroundTransparency = 1
    ResizeButton.AnchorPoint = Vector2.new(1, 0.5)
    ResizeButton.Position = UDim2.new(1, -48, 0.5, 0)
    ResizeButton.Size = UDim2.new(0, 20, 0, 20)
    ResizeButton.Image = "rbxassetid://10734886735"
    ResizeButton.ImageColor3 = Color3.fromRGB(230, 230, 230)

    local BackgroundSettings = Instance.new("Frame")
    BackgroundSettings.Name = "BackgroundSettings"
    BackgroundSettings.Parent = OutlineMain
    BackgroundSettings.ClipsDescendants = true
    BackgroundSettings.Active = true
    BackgroundSettings.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    BackgroundSettings.BackgroundTransparency = 0.3
    BackgroundSettings.Size = UDim2.new(1, 0, 1, 0)
    BackgroundSettings.Visible = false
    createCorner(BackgroundSettings, 14)

    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Parent = BackgroundSettings
    SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    SettingsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    SettingsFrame.Size = UDim2.new(0.75, 0, 0.75, 0)
    createCorner(SettingsFrame, 12)
    createStroke(SettingsFrame, _G.Primary, 1, 0.6)

    local CloseSettings = Instance.new("ImageButton")
    CloseSettings.Name = "CloseSettings"
    CloseSettings.Parent = SettingsFrame
    CloseSettings.BackgroundTransparency = 1
    CloseSettings.AnchorPoint = Vector2.new(1, 0)
    CloseSettings.Position = UDim2.new(1, -16, 0, 16)
    CloseSettings.Size = UDim2.new(0, 18, 0, 18)
    CloseSettings.Image = "rbxassetid://10747384394"
    CloseSettings.ImageColor3 = Color3.fromRGB(240, 240, 240)

    CloseSettings.MouseButton1Click:Connect(function()
        BackgroundSettings.Visible = false
    end)

    local SettingsButton = Instance.new("ImageButton")
    SettingsButton.Name = "SettingsButton"
    SettingsButton.Parent = Top
    SettingsButton.BackgroundTransparency = 1
    SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
    SettingsButton.Position = UDim2.new(1, -80, 0.5, 0)
    SettingsButton.Size = UDim2.new(0, 20, 0, 20)
    SettingsButton.Image = "rbxassetid://10734950020"
    SettingsButton.ImageColor3 = Color3.fromRGB(230, 230, 230)

    SettingsButton.MouseButton1Click:Connect(function()
        BackgroundSettings.Visible = true
    end)

    local TitleSettings = Instance.new("TextLabel")
    TitleSettings.Name = "TitleSettings"
    TitleSettings.Parent = SettingsFrame
    TitleSettings.BackgroundTransparency = 1
    TitleSettings.Position = UDim2.new(0, 18, 0, 16)
    TitleSettings.Size = UDim2.new(0.8, 0, 0, 20)
    TitleSettings.Font = Enum.Font.GothamBold
    TitleSettings.Text = "Settings"
    TitleSettings.TextSize = 16
    TitleSettings.TextColor3 = Color3.fromRGB(245, 245, 245)
    TitleSettings.TextXAlignment = Enum.TextXAlignment.Left

    local SettingsMenuList = Instance.new("Frame")
    SettingsMenuList.Name = "SettingsMenuList"
    SettingsMenuList.Parent = SettingsFrame
    SettingsMenuList.BackgroundTransparency = 1
    SettingsMenuList.Position = UDim2.new(0, 10, 0, 48)
    SettingsMenuList.Size = UDim2.new(1, -20, 1, -64)

    local ScrollSettings = Instance.new("ScrollingFrame")
    ScrollSettings.Name = "ScrollSettings"
    ScrollSettings.Parent = SettingsMenuList
    ScrollSettings.Active = true
    ScrollSettings.BackgroundTransparency = 1
    ScrollSettings.Size = UDim2.new(1, 0, 1, 0)
    ScrollSettings.ScrollBarThickness = 2
    ScrollSettings.ScrollingDirection = Enum.ScrollingDirection.Y
    ScrollSettings.ScrollBarImageColor3 = _G.Primary

    local SettingsListLayout = Instance.new("UIListLayout")
    SettingsListLayout.Name = "SettingsListLayout"
    SettingsListLayout.Parent = ScrollSettings
    SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsListLayout.Padding = UDim.new(0, 8)

    local SettingsPadding = Instance.new("UIPadding")
    SettingsPadding.PaddingTop = UDim.new(0, 4)
    SettingsPadding.PaddingBottom = UDim.new(0, 4)
    SettingsPadding.PaddingLeft = UDim.new(0, 8)
    SettingsPadding.PaddingRight = UDim.new(0, 8)
    SettingsPadding.Parent = ScrollSettings

    -- Handle Settings List Resize
    SettingsListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollSettings.CanvasSize = UDim2.new(0, 0, 0, SettingsListLayout.AbsoluteContentSize.Y + 12)
    end)

    local function CreateCheckbox(title, state, callback)
        local checked = state or false
        local Background = Instance.new("Frame")
        Background.Name = "Background"
        Background.Parent = ScrollSettings
        Background.BackgroundTransparency = 1
        Background.Size = UDim2.new(1, 0, 0, 26)

        local Checkbox = Instance.new("ImageButton")
        Checkbox.Name = "Checkbox"
        Checkbox.Parent = Background
        Checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Checkbox.AnchorPoint = Vector2.new(0, 0.5)
        Checkbox.Position = UDim2.new(0, 6, 0.5, 0)
        Checkbox.Size = UDim2.new(0, 18, 0, 18)
        Checkbox.Image = "rbxassetid://10709790644"
        Checkbox.ImageColor3 = Color3.fromRGB(255, 255, 255)
        createCorner(Checkbox, 4)
        createStroke(Checkbox, Color3.fromRGB(255, 255, 255), 1, 0.8)

        local TitleText = Instance.new("TextLabel")
        TitleText.Name = "TitleText"
        TitleText.Parent = Background
        TitleText.BackgroundTransparency = 1
        TitleText.Position = UDim2.new(0, 34, 0.5, 0)
        TitleText.Size = UDim2.new(1, -38, 0, 20)
        TitleText.Font = Enum.Font.GothamMedium
        TitleText.AnchorPoint = Vector2.new(0, 0.5)
        TitleText.Text = title or ""
        TitleText.TextSize = 12
        TitleText.TextColor3 = Color3.fromRGB(200, 200, 200)
        TitleText.TextXAlignment = Enum.TextXAlignment.Left

        local function updateCheckVisual()
            if checked then
                Checkbox.ImageTransparency = 0
                TweenService:Create(Checkbox, TweenInfo.new(0.2), {
                    BackgroundColor3 = _G.Third
                }):Play()
            else
                Checkbox.ImageTransparency = 1
                TweenService:Create(Checkbox, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                }):Play()
            end
        end

        Checkbox.MouseButton1Click:Connect(function()
            checked = not checked
            updateCheckVisual()
            pcall(callback, checked)
        end)

        updateCheckVisual()
    end

    local function CreateButton(title, callback)
        local Background = Instance.new("Frame")
        Background.Name = "Background"
        Background.Parent = ScrollSettings
        Background.BackgroundTransparency = 1
        Background.Size = UDim2.new(1, 0, 0, 36)

        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Parent = Background
        Button.BackgroundColor3 = _G.Third
        Button.Size = UDim2.new(1, -12, 1, -4)
        Button.Font = Enum.Font.GothamBold
        Button.Text = title or "Button"
        Button.AnchorPoint = Vector2.new(0.5, 0.5)
        Button.Position = UDim2.new(0.5, 0, 0.5, 0)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 12
        Button.AutoButtonColor = false
        createCorner(Button, 6)
        createStroke(Button, Color3.fromRGB(255, 255, 255), 1, 0.8)

        Button.MouseButton1Click:Connect(function()
            pcall(callback)
        end)

        -- Micro interaction for standard button
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = _G.Third:Lerp(Color3.fromRGB(255, 255, 255), 0.15)
            }):Play()
        end)
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = _G.Third
            }):Play()
        end)
    end

    CreateCheckbox("Save Configs", SettingsLib.SaveSettings, function(state)
        SettingsLib.SaveSettings = state
        pcall(function() getgenv().SaveConfig() end)
    end)

    CreateCheckbox("Animations Effect", SettingsLib.LoadAnimation, function(state)
        SettingsLib.LoadAnimation = state
        pcall(function() getgenv().SaveConfig() end)
    end)

    CreateButton("Reset Library Settings", function()
        pcall(function()
            if delfolder then
                delfolder("TckHub")
            end
        end)
        Update:Notify("Config layout reset completed!")
    end)

    -- MAIN TAB LIST LAYOUT & WRAPPER
    local Tab = Instance.new("Frame")
    Tab.Name = "Tab"
    Tab.Parent = Main
    Tab.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    Tab.BackgroundTransparency = 0.6
    Tab.Position = UDim2.new(0, 8, 0, 48)
    Tab.Size = UDim2.new(0, WindowConfig.TabWidth, 1, -56)
    createCorner(Tab, 8)
    createStroke(Tab, Color3.fromRGB(255, 255, 255), 1, 0.94)

    local ScrollTab = Instance.new("ScrollingFrame")
    ScrollTab.Name = "ScrollTab"
    ScrollTab.Parent = Tab
    ScrollTab.Active = true
    ScrollTab.BackgroundTransparency = 1
    ScrollTab.Size = UDim2.new(1, 0, 1, 0)
    ScrollTab.ScrollBarThickness = 0
    ScrollTab.ScrollingDirection = Enum.ScrollingDirection.Y

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Name = "TabListLayout"
    TabListLayout.Parent = ScrollTab
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 4)

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 6)
    TabPadding.PaddingBottom = UDim.new(0, 6)
    TabPadding.PaddingLeft = UDim.new(0, 6)
    TabPadding.PaddingRight = UDim.new(0, 6)
    TabPadding.Parent = ScrollTab

    TabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollTab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y + 12)
    end)

    -- PAGE VIEWER SYSTEM
    local Page = Instance.new("Frame")
    Page.Name = "Page"
    Page.Parent = Main
    Page.BackgroundTransparency = 1
    Page.Position = UDim2.new(0, WindowConfig.TabWidth + 16, 0, 48)
    Page.Size = UDim2.new(1, -WindowConfig.TabWidth - 24, 1, -56)

    local MainPage = Instance.new("Frame")
    MainPage.Name = "MainPage"
    MainPage.Parent = Page
    MainPage.ClipsDescendants = true
    MainPage.BackgroundTransparency = 1
    MainPage.Size = UDim2.new(1, 0, 1, 0)
    createCorner(MainPage, 8)

    local PageList = Instance.new("Folder")
    PageList.Name = "PageList"
    PageList.Parent = MainPage

    local UIPageLayout = Instance.new("UIPageLayout")
    UIPageLayout.Parent = PageList
    UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIPageLayout.EasingDirection = Enum.EasingDirection.Out
    UIPageLayout.EasingStyle = Enum.EasingStyle.Quart
    UIPageLayout.FillDirection = Enum.FillDirection.Horizontal
    UIPageLayout.Padding = UDim.new(0, 16)
    UIPageLayout.TweenTime = 0.35
    UIPageLayout.GamepadInputEnabled = false
    UIPageLayout.ScrollWheelInputEnabled = false
    UIPageLayout.TouchInputEnabled = false

    makeDraggable(Top, OutlineMain)

    -- Close window keybind listener
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == keybind then
            TckHub.Enabled = not TckHub.Enabled
        elseif not processed and input.KeyCode == Enum.KeyCode.Insert then
            TckHub.Enabled = not TckHub.Enabled
        end
    end)

    -- Real-time UI Resize Engine
    local resizing = false
    DragButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local offsetPos = input.Position
            local deltaX = math.clamp(offsetPos.X - Main.AbsolutePosition.X, 360, 960)
            local deltaY = math.clamp(offsetPos.Y - Main.AbsolutePosition.Y, 240, 680)

            OutlineMain.Size = UDim2.new(0, deltaX + 12, 0, deltaY + 12)
            Main.Size = UDim2.new(0, deltaX, 0, deltaY)
            Page.Size = UDim2.new(0, deltaX - Tab.Size.X.Offset - 24, 0, deltaY - 56)
            Tab.Size = UDim2.new(0, WindowConfig.TabWidth, 0, deltaY - 56)
        end
    end)

    local abc = false
    local uitab = {}

    function uitab:Tab(text, img)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = ScrollTab
        TabButton.Name = text .. "Unique"
        TabButton.Text = ""
        TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        TabButton.BackgroundTransparency = 0.95
        TabButton.Size = UDim2.new(1, 0, 0, 34)
        createCorner(TabButton, 6)
        createStroke(TabButton, Color3.fromRGB(255, 255, 255), 1, 0.92)

        local SelectedTab = Instance.new("Frame")
        SelectedTab.Name = "SelectedTab"
        SelectedTab.Parent = TabButton
        SelectedTab.BackgroundColor3 = _G.Third
        SelectedTab.BackgroundTransparency = 1
        SelectedTab.Size = UDim2.new(0, 3, 0, 0)
        SelectedTab.Position = UDim2.new(0, 3, 0.5, 0)
        SelectedTab.AnchorPoint = Vector2.new(0, 0.5)
        createCorner(SelectedTab, 2)

        local Title = Instance.new("TextLabel")
        Title.Parent = TabButton
        Title.Name = "Title"
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 32, 0.5, 0)
        Title.Size = UDim2.new(1, -38, 0, 20)
        Title.Font = Enum.Font.GothamMedium
        Title.Text = text
        Title.AnchorPoint = Vector2.new(0, 0.5)
        Title.TextColor3 = Color3.fromRGB(180, 180, 190)
        Title.TextSize = 13
        Title.TextXAlignment = Enum.TextXAlignment.Left

        local Icon = Instance.new("ImageLabel")
        Icon.Name = "IDK"
        Icon.Parent = TabButton
        Icon.BackgroundTransparency = 1
        Icon.ImageTransparency = 0.4
        Icon.Position = UDim2.new(0, 8, 0.5, 0)
        Icon.Size = UDim2.new(0, 16, 0, 16)
        Icon.AnchorPoint = Vector2.new(0, 0.5)
        Icon.Image = img or "rbxassetid://10723407389"

        local MainFramePage = Instance.new("ScrollingFrame")
        MainFramePage.Name = text .. "_Page"
        MainFramePage.Parent = PageList
        MainFramePage.Active = true
        MainFramePage.BackgroundTransparency = 1
        MainFramePage.Size = UDim2.new(1, 0, 1, 0)
        MainFramePage.ScrollBarThickness = 2
        MainFramePage.ScrollingDirection = Enum.ScrollingDirection.Y
        MainFramePage.ScrollBarImageColor3 = _G.Primary

        local UIPadding = Instance.new("UIPadding")
        UIPadding.PaddingTop = UDim.new(0, 4)
        UIPadding.PaddingBottom = UDim.new(0, 4)
        UIPadding.PaddingLeft = UDim.new(0, 8)
        UIPadding.PaddingRight = UDim.new(0, 8)
        UIPadding.Parent = MainFramePage

        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Padding = UDim.new(0, 6)
        UIListLayout.Parent = MainFramePage
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 12)
        end)

        local function activateTab()
            for _, btn in ipairs(ScrollTab:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundTransparency = 0.95}):Play()
                    TweenService:Create(btn.SelectedTab, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0), BackgroundTransparency = 1}):Play()
                    TweenService:Create(btn.IDK, TweenInfo.new(0.25), {ImageTransparency = 0.4}):Play()
                    TweenService:Create(btn.Title, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(180, 180, 190)}):Play()
                end
            end
            TweenService:Create(TabButton, TweenInfo.new(0.25), {BackgroundTransparency = 0.8}):Play()
            TweenService:Create(SelectedTab, TweenInfo.new(0.25), {Size = UDim2.new(0, 3, 0, 18), BackgroundTransparency = 0}):Play()
            TweenService:Create(Icon, TweenInfo.new(0.25), {ImageTransparency = 0}):Play()
            TweenService:Create(Title, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            
            UIPageLayout:JumpTo(MainFramePage)
        end

        TabButton.MouseButton1Click:Connect(activateTab)

        if not abc then
            activateTab()
            abc = true
        end

        local defaultSize = true
        ResizeButton.MouseButton1Click:Connect(function()
            if defaultSize then
                defaultSize = false
                OutlineMain:TweenPosition(UDim2.new(0.5, 0, 0.45, 0), "Out", "Quad", 0.2, true)
                Main:TweenSize(UDim2.new(1, -20, 1, -20), "Out", "Quad", 0.4, true, function()
                    Page:TweenSize(UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 24, 0, Main.AbsoluteSize.Y - 56), "Out", "Quad", 0.4, true)
                    Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - 56), "Out", "Quad", 0.4, true)
                end)
                OutlineMain:TweenSize(UDim2.new(1, -10, 1, -10), "Out", "Quad", 0.4, true)
                ResizeButton.Image = "rbxassetid://10734895698"
            else
                defaultSize = true
                Main:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset, 0, WindowConfig.Size.Y.Offset), "Out", "Quad", 0.4, true, function()
                    Page:TweenSize(UDim2.new(0, Main.AbsoluteSize.X - Tab.AbsoluteSize.X - 24, 0, Main.AbsoluteSize.Y - 56), "Out", "Quad", 0.4, true)
                    Tab:TweenSize(UDim2.new(0, WindowConfig.TabWidth, 0, Main.AbsoluteSize.Y - 56), "Out", "Quad", 0.4, true)
                end)
                OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 12, 0, WindowConfig.Size.Y.Offset + 12), "Out", "Quad", 0.4, true)
                ResizeButton.Image = "rbxassetid://10734886735"
            end
        end)

        -- INTERACTION COMPONENTS GENERATOR
        local main = {}

        function main:Button(text, callback)
            local Button = Instance.new("Frame")
            Button.Name = "Button"
            Button.Parent = MainFramePage
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            Button.BackgroundTransparency = 0.75
            Button.Size = UDim2.new(1, 0, 0, 36)
            createCorner(Button, 6)
            createStroke(Button, Color3.fromRGB(255, 255, 255), 1, 0.94)

            local TextButton = Instance.new("TextButton")
            TextButton.Name = "TextButton"
            TextButton.Parent = Button
            TextButton.BackgroundTransparency = 1
            TextButton.Size = UDim2.new(1, 0, 1, 0)
            TextButton.Text = ""

            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "TextLabel"
            TextLabel.Parent = Button
            TextLabel.BackgroundTransparency = 1
            TextLabel.AnchorPoint = Vector2.new(0, 0.5)
            TextLabel.Position = UDim2.new(0, 34, 0.5, 0)
            TextLabel.Size = UDim2.new(1, -70, 1, 0)
            TextLabel.Font = Enum.Font.GothamMedium
            TextLabel.RichText = true
            TextLabel.Text = text
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.TextColor3 = Color3.fromRGB(235, 235, 245)
            TextLabel.TextSize = 13

            local Icon = Instance.new("ImageLabel")
            Icon.Name = "Icon"
            Icon.Parent = Button
            Icon.BackgroundTransparency = 1
            Icon.AnchorPoint = Vector2.new(0, 0.5)
            Icon.Position = UDim2.new(0, 10, 0.5, 0)
            Icon.Size = UDim2.new(0, 16, 0, 16)
            Icon.Image = "rbxassetid://10709768347"
            Icon.ImageColor3 = Color3.fromRGB(200, 200, 200)

            local ArrowRight = Instance.new("ImageLabel")
            ArrowRight.Name = "ArrowRight"
            ArrowRight.Parent = Button
            ArrowRight.BackgroundTransparency = 1
            ArrowRight.AnchorPoint = Vector2.new(1, 0.5)
            ArrowRight.Position = UDim2.new(1, -10, 0.5, 0)
            ArrowRight.Size = UDim2.new(0, 14, 0, 14)
            ArrowRight.Image = "rbxassetid://10734898355"
            ArrowRight.ImageColor3 = Color3.fromRGB(200, 200, 200)

            -- Ripple & Hover Effect
            TextButton.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.25), {BackgroundTransparency = 0.55, BackgroundColor3 = Color3.fromRGB(40, 40, 50)}):Play()
                TweenService:Create(ArrowRight, TweenInfo.new(0.2), {ImageColor3 = _G.Primary}):Play()
            end)
            TextButton.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.25), {BackgroundTransparency = 0.75, BackgroundColor3 = Color3.fromRGB(30, 30, 38)}):Play()
                TweenService:Create(ArrowRight, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end)

            TextButton.MouseButton1Click:Connect(function()
                -- Dynamic push animation
                local push = TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0.98, 0, 0, 34)
                })
                push:Play()
                push.Completed:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.15), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                end)
                pcall(callback)
            end)
        end

        function main:Toggle(text, config, desc, callback)
            config = config or false
            local toggled = config
            
            local Button = Instance.new("Frame")
            Button.Name = "Button"
            Button.Parent = MainFramePage
            Button.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            Button.BackgroundTransparency = 0.75
            createCorner(Button, 6)
            createStroke(Button, Color3.fromRGB(255, 255, 255), 1, 0.94)

            local ToggleClick = Instance.new("TextButton")
            ToggleClick.Name = "ToggleClick"
            ToggleClick.Parent = Button
            ToggleClick.BackgroundTransparency = 1
            ToggleClick.Size = UDim2.new(1, 0, 1, 0)
            ToggleClick.Text = ""

            local Title = Instance.new("TextLabel")
            Title.Parent = Button
            Title.BackgroundTransparency = 1
            Title.Font = Enum.Font.GothamMedium
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(235, 235, 245)
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local Desc = Instance.new("TextLabel")
            Desc.Parent = Button
            Desc.BackgroundTransparency = 1
            Desc.Font = Enum.Font.Gotham
            Desc.TextColor3 = Color3.fromRGB(150, 150, 160)
            Desc.TextSize = 11
            Desc.TextXAlignment = Enum.TextXAlignment.Left
            Desc.TextWrapped = true

            if desc then
                Desc.Text = desc
                Title.Position = UDim2.new(0, 14, 0, 6)
                Title.Size = UDim2.new(1, -64, 0, 18)
                Desc.Position = UDim2.new(0, 14, 0, 24)
                Desc.Size = UDim2.new(1, -64, 0, 16)
                Button.Size = UDim2.new(1, 0, 0, 46)
            else
                Desc.Visible = false
                Title.Position = UDim2.new(0, 14, 0.5, 0)
                Title.AnchorPoint = Vector2.new(0, 0.5)
                Title.Size = UDim2.new(1, -64, 0, 20)
                Button.Size = UDim2.new(1, 0, 0, 36)
            end

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = Button
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            ToggleFrame.Position = UDim2.new(1, -12, 0.5, 0)
            ToggleFrame.Size = UDim2.new(0, 34, 0, 18)
            ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
            createCorner(ToggleFrame, 9)
            createStroke(ToggleFrame, Color3.fromRGB(255, 255, 255), 1, 0.9)

            local Circle = Instance.new("Frame")
            Circle.Name = "Circle"
            Circle.Parent = ToggleFrame
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Position = UDim2.new(0, 2, 0.5, 0)
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.AnchorPoint = Vector2.new(0, 0.5)
            createCorner(Circle, 7)

            local function updateToggleVisual(animate)
                local duration = animate and 0.25 or 0
                if toggled then
                    TweenService:Create(Circle, TweenInfo.new(duration, Enum.EasingStyle.OutQuad), {
                        Position = UDim2.new(1, -16, 0.5, 0)
                    }):Play()
                    TweenService:Create(ToggleFrame, TweenInfo.new(duration), {
                        BackgroundColor3 = _G.Third
                    }):Play()
                else
                    Circle:TweenPosition(UDim2.new(0, 2, 0.5, 0), "Out", "Sine", duration, true)
                    TweenService:Create(ToggleFrame, TweenInfo.new(duration), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 60)
                    }):Play()
                end
            end

            local function performToggle()
                toggled = not toggled
                updateToggleVisual(true)
                pcall(callback, toggled)
            end

            ToggleClick.MouseButton1Click:Connect(performToggle)
            
            ToggleClick.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.25), {BackgroundTransparency = 0.55}):Play()
            end)
            ToggleClick.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.25), {BackgroundTransparency = 0.75}):Play()
            end)

            updateToggleVisual(false)
            if config == true then
                pcall(callback, toggled)
            end
        end

        function main:Dropdown(text, option, var, callback)
            local isdropping = false
            local activeItem = tostring(var or "")
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = "Dropdown"
            Dropdown.Parent = MainFramePage
            Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            Dropdown.BackgroundTransparency = 0.75
            Dropdown.ClipsDescendants = true
            Dropdown.Size = UDim2.new(1, 0, 0, 38)
            createCorner(Dropdown, 6)
            createStroke(Dropdown, Color3.fromRGB(255, 255, 255), 1, 0.94)

            local DropTitle = Instance.new("TextLabel")
            DropTitle.Name = "DropTitle"
            DropTitle.Parent = Dropdown
            DropTitle.BackgroundTransparency = 1
            DropTitle.Size = UDim2.new(1, -160, 0, 38)
            DropTitle.Font = Enum.Font.GothamMedium
            DropTitle.Text = text
            DropTitle.TextColor3 = Color3.fromRGB(235, 235, 245)
            DropTitle.TextSize = 13
            DropTitle.TextXAlignment = Enum.TextXAlignment.Left
            DropTitle.Position = UDim2.new(0, 14, 0, 0)

            local SelectItems = Instance.new("TextButton")
            SelectItems.Name = "SelectItems"
            SelectItems.Parent = Dropdown
            SelectItems.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            SelectItems.TextColor3 = Color3.fromRGB(200, 200, 210)
            SelectItems.Position = UDim2.new(1, -12, 0, 5)
            SelectItems.Size = UDim2.new(0, 120, 0, 28)
            SelectItems.AnchorPoint = Vector2.new(1, 0)
            SelectItems.Font = Enum.Font.GothamMedium
            SelectItems.AutoButtonColor = false
            SelectItems.TextSize = 11
            SelectItems.Text = var and ("  " .. tostring(var)) or "  Select Items"
            SelectItems.TextXAlignment = Enum.TextXAlignment.Left
            createCorner(SelectItems, 4)
            createStroke(SelectItems, Color3.fromRGB(255, 255, 255), 1, 0.92)

            local ArrowDown = Instance.new("ImageLabel")
            ArrowDown.Name = "ArrowDown"
            ArrowDown.Parent = SelectItems
            ArrowDown.BackgroundTransparency = 1
            ArrowDown.AnchorPoint = Vector2.new(1, 0.5)
            ArrowDown.Position = UDim2.new(1, -8, 0.5, 0)
            ArrowDown.Size = UDim2.new(0, 12, 0, 12)
            ArrowDown.Image = "rbxassetid://10709790948"
            ArrowDown.ImageColor3 = Color3.fromRGB(200, 200, 200)

            local DropdownFrameScroll = Instance.new("Frame")
            DropdownFrameScroll.Name = "DropdownFrameScroll"
            DropdownFrameScroll.Parent = Dropdown
            DropdownFrameScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            DropdownFrameScroll.Position = UDim2.new(0, 6, 0, 42)
            DropdownFrameScroll.Size = UDim2.new(1, -12, 0, 100)
            DropdownFrameScroll.Visible = false
            createCorner(DropdownFrameScroll, 6)
            createStroke(DropdownFrameScroll, _G.Primary, 1, 0.8)

            local DropScroll = Instance.new("ScrollingFrame")
            DropScroll.Name = "DropScroll"
            DropScroll.Parent = DropdownFrameScroll
            DropScroll.ScrollingDirection = Enum.ScrollingDirection.Y
            DropScroll.Active = true
            DropScroll.BackgroundTransparency = 1
            DropScroll.Size = UDim2.new(1, 0, 1, -8)
            DropScroll.Position = UDim2.new(0, 0, 0, 4)
            DropScroll.ScrollBarThickness = 2
            DropScroll.ScrollBarImageColor3 = _G.Primary

            local UIListLayout = Instance.new("UIListLayout")
            UIListLayout.Parent = DropScroll
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.Padding = UDim.new(0, 2)

            local PaddingDrop = Instance.new("UIPadding")
            PaddingDrop.PaddingLeft = UDim.new(0, 6)
            PaddingDrop.PaddingRight = UDim.new(0, 6)
            PaddingDrop.Parent = DropScroll

            UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 8)
            end)

            local function alignActiveItem()
                for _, child in ipairs(DropScroll:GetChildren()) do
                    if child:IsA("TextButton") then
                        local activeIndicator = child:FindFirstChild("SelectedItems")
                        if child.Text == activeItem then
                            TweenService:Create(child, 0.2, {BackgroundTransparency = 0.8, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                            if activeIndicator then activeIndicator.BackgroundTransparency = 0 end
                        else
                            TweenService:Create(child, 0.2, {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 180, 190)}):Play()
                            if activeIndicator then activeIndicator.BackgroundTransparency = 1 end
                        end
                    end
                end
            end

            local function constructItems(list)
                for _, optionVal in ipairs(list) do
                    local itemText = tostring(optionVal)
                    local Item = Instance.new("TextButton")
                    Item.Name = "Item"
                    Item.Parent = DropScroll
                    Item.BackgroundColor3 = _G.Primary
                    Item.BackgroundTransparency = 1
                    Item.Size = UDim2.new(1, 0, 0, 28)
                    Item.Font = Enum.Font.GothamMedium
                    Item.Text = itemText
                    Item.TextColor3 = Color3.fromRGB(180, 180, 190)
                    Item.TextSize = 12
                    Item.TextXAlignment = Enum.TextXAlignment.Left
                    createCorner(Item, 4)

                    local SelectedItemsIndicator = Instance.new("Frame")
                    SelectedItemsIndicator.Name = "SelectedItems"
                    SelectedItemsIndicator.Parent = Item
                    SelectedItemsIndicator.BackgroundColor3 = _G.Third
                    SelectedItemsIndicator.BackgroundTransparency = 1
                    SelectedItemsIndicator.Size = UDim2.new(0, 3, 0, 14)
                    SelectedItemsIndicator.Position = UDim2.new(0, 6, 0.5, 0)
                    SelectedItemsIndicator.AnchorPoint = Vector2.new(0, 0.5)
                    createCorner(SelectedItemsIndicator, 1)

                    -- Offset label slightly to avoid overlap with selected accent line
                    local ItemPadding = Instance.new("UIPadding")
                    ItemPadding.PaddingLeft = UDim.new(0, 16)
                    ItemPadding.Parent = Item

                    Item.MouseButton1Click:Connect(function()
                        activeItem = itemText
                        SelectItems.Text = "  " .. itemText
                        alignActiveItem()
                        pcall(callback, itemText)
                        
                        -- Auto close dropdown
                        isdropping = false
                        TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -12, 0, 0), Visible = false}):Play()
                        TweenService:Create(Dropdown, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 38)}):Play()
                        TweenService:Create(ArrowDown, TweenInfo.new(0.25), {Rotation = 0}):Play()
                    end)
                end
                alignActiveItem()
            end

            constructItems(option)

            SelectItems.MouseButton1Click:Connect(function()
                isdropping = not isdropping
                if isdropping then
                    DropdownFrameScroll.Visible = true
                    TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.3, Enum.EasingStyle.OutQuart), {Size = UDim2.new(1, -12, 0, 110)}):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.OutQuart), {Size = UDim2.new(1, 0, 0, 158)}):Play()
                    TweenService:Create(ArrowDown, TweenInfo.new(0.25), {Rotation = 180}):Play()
                else
                    TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.3, Enum.EasingStyle.OutQuart), {Size = UDim2.new(1, -12, 0, 0)}):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3, Enum.EasingStyle.OutQuart), {Size = UDim2.new(1, 0, 0, 38)}):Play()
                    TweenService:Create(ArrowDown, TweenInfo.new(0.25), {Rotation = 0}):Play()
                    task.delay(0.3, function()
                        if not isdropping then DropdownFrameScroll.Visible = false end
                    end)
                end
            end)

            if var then
                pcall(callback, var)
            end

            local dropfunc = {}
            function dropfunc:Add(t)
                constructItems({t})
            end
            function dropfunc:Clear()
                SelectItems.Text = "  Select Items"
                activeItem = ""
                for _, child in ipairs(DropScroll:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
            end
            return dropfunc
        end

        function main:Slider(text, min, max, set, callback)
            local Value = set or min
            
            local Slider = Instance.new("Frame")
            Slider.Name = "Slider"
            Slider.Parent = MainFramePage
            Slider.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            Slider.BackgroundTransparency = 0.75
            Slider.Size = UDim2.new(1, 0, 0, 42)
            createCorner(Slider, 6)
            createStroke(Slider, Color3.fromRGB(255, 255, 255), 1, 0.94)

            local Title = Instance.new("TextLabel")
            Title.Parent = Slider
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 14, 0, 4)
            Title.Size = UDim2.new(1, -140, 0, 18)
            Title.Font = Enum.Font.GothamMedium
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(235, 235, 245)
            Title.TextSize = 13
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local ValueText = Instance.new("TextLabel")
            ValueText.Parent = Slider
            ValueText.BackgroundTransparency = 1
            ValueText.Position = UDim2.new(1, -120, 0, 4)
            ValueText.Size = UDim2.new(0, 40, 0, 18)
            ValueText.Font = Enum.Font.GothamBold
            ValueText.Text = tostring(Value)
            ValueText.TextColor3 = _G.Primary
            ValueText.TextSize = 12
            ValueText.TextXAlignment = Enum.TextXAlignment.Right

            local bar = Instance.new("Frame")
            bar.Name = "bar"
            bar.Parent = Slider
            bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            bar.Size = UDim2.new(1, -28, 0, 6)
            bar.Position = UDim2.new(0, 14, 0, 28)
            bar.BorderSizePixel = 0
            createCorner(bar, 3)

            local bar1 = Instance.new("Frame")
            bar1.Name = "bar1"
            bar1.Parent = bar
            bar1.BackgroundColor3 = _G.Third
            bar1.Size = UDim2.new((Value - min) / (max - min), 0, 1, 0)
            bar1.BorderSizePixel = 0
            createCorner(bar1, 3)

            local circlebar = Instance.new("ImageButton")
            circlebar.Name = "circlebar"
            circlebar.Parent = bar1
            circlebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            circlebar.Position = UDim2.new(1, 0, 0.5, 0)
            circlebar.AnchorPoint = Vector2.new(0.5, 0.5)
            circlebar.Size = UDim2.new(0, 14, 0, 14)
            createCorner(circlebar, 7)
            createStroke(circlebar, _G.Primary, 1, 0.4)

            local dragging = false
            
            local function updateSlider(input)
                local absSize = bar.AbsoluteSize.X
                local percentage = math.clamp((input.Position.X - bar.AbsolutePosition.X) / absSize, 0, 1)
                Value = math.floor(min + (max - min) * percentage)
                
                bar1.Size = UDim2.new(percentage, 0, 1, 0)
                ValueText.Text = tostring(Value)
                pcall(callback, Value)
            end

            circlebar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            -- Allow clicking bar directly
            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    updateSlider(input)
                end
            end)

            pcall(callback, Value)
        end

        function main:Textbox(text, disappear, callback)
            local Textbox = Instance.new("Frame")
            Textbox.Name = "Textbox"
            Textbox.Parent = MainFramePage
            Textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            Textbox.BackgroundTransparency = 0.75
            Textbox.Size = UDim2.new(1, 0, 0, 38)
            createCorner(Textbox, 6)
            createStroke(Textbox, Color3.fromRGB(255, 255, 255), 1, 0.94)

            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Name = "TextboxLabel"
            TextboxLabel.Parent = Textbox
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Position = UDim2.new(0, 14, 0.5, 0)
            TextboxLabel.Size = UDim2.new(1, -120, 0, 20)
            TextboxLabel.Font = Enum.Font.GothamMedium
            TextboxLabel.Text = text
            TextboxLabel.AnchorPoint = Vector2.new(0, 0.5)
            TextboxLabel.TextColor3 = Color3.fromRGB(235, 235, 245)
            TextboxLabel.TextSize = 13
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left

            local RealTextbox = Instance.new("TextBox")
            RealTextbox.Name = "RealTextbox"
            RealTextbox.Parent = Textbox
            RealTextbox.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
            RealTextbox.Position = UDim2.new(1, -12, 0.5, 0)
            RealTextbox.AnchorPoint = Vector2.new(1, 0.5)
            RealTextbox.Size = UDim2.new(0, 90, 0, 26)
            RealTextbox.Font = Enum.Font.Gotham
            RealTextbox.Text = ""
            RealTextbox.PlaceholderText = "Type.."
            RealTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            RealTextbox.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
            RealTextbox.TextSize = 12
            createCorner(RealTextbox, 4)
            createStroke(RealTextbox, Color3.fromRGB(255, 255, 255), 1, 0.92)

            RealTextbox.FocusLost:Connect(function(enterPressed)
                pcall(callback, RealTextbox.Text)
                if disappear then
                    RealTextbox.Text = ""
                end
            end)

            -- Animate stroke on focus
            local textBoxStroke = RealTextbox:FindFirstChild("Stroke")
            RealTextbox.Focused:Connect(function()
                if textBoxStroke then
                    TweenService:Create(textBoxStroke, TweenInfo.new(0.2), {Color = _G.Primary, Transparency = 0.4}):Play()
                end
            end)
            RealTextbox.FocusLost:Connect(function()
                if textBoxStroke then
                    TweenService:Create(textBoxStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255), Transparency = 0.92}):Play()
                end
            end)
        end

        function main:Label(text)
            local Frame = Instance.new("Frame")
            Frame.Name = "LabelFrame"
            Frame.Parent = MainFramePage
            Frame.BackgroundTransparency = 1
            Frame.Size = UDim2.new(1, 0, 0, 26)

            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Parent = Frame
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -30, 1, 0)
            Label.Font = Enum.Font.GothamMedium
            Label.Position = UDim2.new(0, 32, 0.5, 0)
            Label.AnchorPoint = Vector2.new(0, 0.5)
            Label.TextColor3 = Color3.fromRGB(200, 200, 210)
            Label.TextSize = 13
            Label.Text = text
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local Icon = Instance.new("ImageLabel")
            Icon.Name = "Icon"
            Icon.Parent = Frame
            Icon.BackgroundTransparency = 1
            Icon.Position = UDim2.new(0, 10, 0.5, 0)
            Icon.Size = UDim2.new(0, 14, 0, 14)
            Icon.AnchorPoint = Vector2.new(0, 0.5)
            Icon.Image = "rbxassetid://10723415903"
            Icon.ImageColor3 = _G.Primary

            local labelfunc = {}
            function labelfunc:Set(newtext)
                Label.Text = newtext
            end
            return labelfunc
        end

        function main:Seperator(text)
            local Seperator = Instance.new("Frame")
            Seperator.Name = "Seperator"
            Seperator.Parent = MainFramePage
            Seperator.BackgroundTransparency = 1
            Seperator.Size = UDim2.new(1, 0, 0, 36)

            local Sep1 = Instance.new("TextLabel")
            Sep1.Name = "Sep1"
            Sep1.Parent = Seperator
            Sep1.BackgroundTransparency = 1
            Sep1.AnchorPoint = Vector2.new(0, 0.5)
            Sep1.Position = UDim2.new(0, 0, 0.5, 0)
            Sep1.Size = UDim2.new(0, 20, 0, 36)
            Sep1.Font = Enum.Font.GothamBold
            Sep1.RichText = true
            Sep1.Text = "〈<font color=\"rgb(255, 60, 100)\">〈</font>"
            Sep1.TextColor3 = Color3.fromRGB(255, 255, 255)
            Sep1.TextSize = 12

            local Sep2 = Instance.new("TextLabel")
            Sep2.Name = "Sep2"
            Sep2.Parent = Seperator
            Sep2.BackgroundTransparency = 1
            Sep2.AnchorPoint = Vector2.new(0.5, 0.5)
            Sep2.Position = UDim2.new(0.5, 0, 0.5, 0)
            Sep2.Size = UDim2.new(1, -50, 0, 36)
            Sep2.Font = Enum.Font.GothamBold
            Sep2.Text = text or ""
            Sep2.TextColor3 = Color3.fromRGB(230, 230, 240)
            Sep2.TextSize = 12

            local Sep3 = Instance.new("TextLabel")
            Sep3.Name = "Sep3"
            Sep3.Parent = Seperator
            Sep3.BackgroundTransparency = 1
            Sep3.AnchorPoint = Vector2.new(1, 0.5)
            Sep3.Position = UDim2.new(1, 0, 0.5, 0)
            Sep3.Size = UDim2.new(0, 20, 0, 36)
            Sep3.Font = Enum.Font.GothamBold
            Sep3.RichText = true
            Sep3.Text = "<font color=\"rgb(255, 60, 100)\">〉</font>〉"
            Sep3.TextColor3 = Color3.fromRGB(255, 255, 255)
            Sep3.TextSize = 12
        end

        function main:Line()
            local Linee = Instance.new("Frame")
            Linee.Name = "Linee"
            Linee.Parent = MainFramePage
            Linee.BackgroundTransparency = 1
            Linee.Size = UDim2.new(1, 0, 0, 12)

            local Line = Instance.new("Frame")
            Line.Name = "Line"
            Line.Parent = Linee
            Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Line.BorderSizePixel = 0
            Line.Position = UDim2.new(0, 0, 0.5, 0)
            Line.Size = UDim2.new(1, 0, 0, 1.2)

            local UIGradient = Instance.new("UIGradient")
            UIGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, _G.Dark),
                ColorSequenceKeypoint.new(0.4, _G.Primary),
                ColorSequenceKeypoint.new(0.5, _G.Primary),
                ColorSequenceKeypoint.new(0.6, _G.Primary),
                ColorSequenceKeypoint.new(1, _G.Dark)
            })
            UIGradient.Parent = Line
        end

        return main
    end

    return uitab
end

return Update
