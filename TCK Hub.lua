--[[
    ============================================================
    TCK HUB V6 — LIQUID GLASS PREMIUM UI LIBRARY
    ============================================================
    Style   : Liquid Glass · Apple VisionOS · Glassmorphism
    Engine  : Direct Visibility Page Registry (zero UIPageLayout)
    Compat  : Roblox PC + Mobile Executors
    API     : 100% backward compatible
    Debug   : Full print trace enabled
    ============================================================
]]

-- ============================================================
-- SERVICES
-- ============================================================
local CoreGui         = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local TextService     = game:GetService("TextService")
local HttpService     = game:GetService("HttpService")
local RunService      = game:GetService("RunService")

print("[TCK] UI INIT")

-- ============================================================
-- CLEANUP: destroy any prior instances
-- ============================================================
for _, name in ipairs({"TckHub", "TckHubLogo", "TckHubNotif", "ScreenGui"}) do
    local old = CoreGui:FindFirstChild(name)
    if old then pcall(function() old:Destroy() end) end
end

-- ============================================================
-- GLOBAL ACCENT COLORS  (can be overridden before loading)
-- ============================================================
_G.V6_Primary = _G.V6_Primary or Color3.fromRGB(100, 140, 255)   -- ice blue
_G.V6_Accent  = _G.V6_Accent  or Color3.fromRGB(130, 80,  255)   -- violet
_G.V6_Danger  = _G.V6_Danger  or Color3.fromRGB(255, 75,  100)   -- red/pink
_G.V6_Dark    = _G.V6_Dark    or Color3.fromRGB(8,   8,   12)    -- near-black

-- keep old _G.Primary/_G.Third names alive for any scripts that read them
_G.Primary = _G.V6_Primary
_G.Third   = _G.V6_Danger

-- ============================================================
-- UTILITY HELPERS
-- ============================================================
local function corner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = parent
    return c
end

local function stroke(parent, col, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(255,255,255)
    s.Thickness = thick or 1
    s.Transparency = trans or 0.85
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function gradient(parent, c0, c1, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c0, c1)
    g.Rotation = rot or 90
    g.Parent = parent
    return g
end

local function tween(obj, t, props, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir   = dir   or Enum.EasingDirection.Out
    return TweenService:Create(obj, TweenInfo.new(t, style, dir), props)
end

local function makeDraggable(handle, target)
    local dragging = false
    local dragStart, startPos

    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = target.Position
        end
    end

    handle.InputBegan:Connect(beginDrag)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ============================================================
-- GLOBAL MAIN-UI REFERENCE  (used by logo toggle)
-- ============================================================
local _MainGuiRef = nil

-- ============================================================
-- NOTIFICATION SYSTEM  (standalone ScreenGui)
-- ============================================================
local NotifGui = Instance.new("ScreenGui")
NotifGui.Name = "TckHubNotif"
NotifGui.DisplayOrder = 9999
NotifGui.ResetOnSpawn = false
NotifGui.Parent = CoreGui

local notifList = {}

local function removeNotif(idx)
    local entry = table.remove(notifList, idx)
    if not entry then return end
    tween(entry.frame, 0.35, {Position = UDim2.new(1.2, 0, entry.frame.Position.Y.Scale, 0)}, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
    task.delay(0.4, function()
        pcall(function() entry.frame:Destroy() end)
    end)
    for i, e in ipairs(notifList) do
        tween(e.frame, 0.3, {Position = UDim2.new(1, -20, 0, 20 + (i-1)*80)}, Enum.EasingStyle.Quad):Play()
    end
end

task.spawn(function()
    while true do
        task.wait(5)
        if #notifList > 0 then removeNotif(1) end
    end
end)

-- ============================================================
-- LOGO / FLOATING TOGGLE BUTTON
-- ============================================================
print("[TCK] LOGO CREATED")

local LogoGui = Instance.new("ScreenGui")
LogoGui.Name = "TckHubLogo"
LogoGui.DisplayOrder = 9998
LogoGui.ResetOnSpawn = false
LogoGui.Parent = CoreGui

local LogoOuter = Instance.new("Frame")
LogoOuter.Name = "LogoOuter"
LogoOuter.Parent = LogoGui
LogoOuter.Size = UDim2.new(0, 54, 0, 54)
LogoOuter.Position = UDim2.new(0, 16, 0, 16)
LogoOuter.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
LogoOuter.BackgroundTransparency = 0.1
LogoOuter.ClipsDescendants = false
corner(LogoOuter, 27)
stroke(LogoOuter, _G.V6_Primary, 1.5, 0.4)
gradient(LogoOuter, Color3.fromRGB(30,30,50), Color3.fromRGB(10,10,20), 135)

local LogoBtn = Instance.new("ImageButton")
LogoBtn.Name = "LogoBtn"
LogoBtn.Parent = LogoOuter
LogoBtn.Size = UDim2.new(0, 36, 0, 36)
LogoBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
LogoBtn.AnchorPoint = Vector2.new(0.5, 0.5)
LogoBtn.BackgroundTransparency = 1
LogoBtn.Image = "rbxassetid://13940080072"
LogoBtn.ImageColor3 = Color3.fromRGB(220, 230, 255)
LogoBtn.AutoButtonColor = false
corner(LogoBtn, 18)

-- Pulse ring
local PulseRing = Instance.new("Frame")
PulseRing.Name = "PulseRing"
PulseRing.Parent = LogoOuter
PulseRing.Size = UDim2.new(1, 8, 1, 8)
PulseRing.Position = UDim2.new(0, -4, 0, -4)
PulseRing.BackgroundTransparency = 1
PulseRing.ZIndex = 0
corner(PulseRing, 31)
stroke(PulseRing, _G.V6_Primary, 1, 0.6)

-- Drag the logo
makeDraggable(LogoOuter, LogoOuter)

-- Hover effects
LogoBtn.MouseEnter:Connect(function()
    tween(LogoOuter, 0.3, {BackgroundTransparency = 0.02}):Play()
    tween(LogoBtn, 0.3, {Size = UDim2.new(0, 40, 0, 40)}):Play()
end)
LogoBtn.MouseLeave:Connect(function()
    tween(LogoOuter, 0.3, {BackgroundTransparency = 0.1}):Play()
    tween(LogoBtn, 0.3, {Size = UDim2.new(0, 36, 0, 36)}):Play()
end)

local function toggleMainUI()
    print("[TCK] LOGO CLICKED")
    if _MainGuiRef then
        _MainGuiRef.Enabled = not _MainGuiRef.Enabled
        print("[TCK] MAIN UI TOGGLED:", tostring(_MainGuiRef.Enabled))
    else
        -- Fallback: search CoreGui
        local found = CoreGui:FindFirstChild("TckHub")
        if found then
            found.Enabled = not found.Enabled
            print("[TCK] MAIN UI TOGGLED (fallback):", tostring(found.Enabled))
        else
            warn("[TCK] WARNING: Main UI not found in CoreGui")
        end
    end
end

LogoBtn.MouseButton1Click:Connect(toggleMainUI)
LogoBtn.Activated:Connect(toggleMainUI)

-- ============================================================
-- LIBRARY TABLE
-- ============================================================
local Library = {}

-- ============================================================
-- NOTIFY
-- ============================================================
function Library:Notify(desc, duration)
    duration = duration or 4
    local yPos = 20 + #notifList * 80

    local frame = Instance.new("Frame")
    frame.Name = "Notif"
    frame.Parent = NotifGui
    frame.Size = UDim2.new(0, 300, 0, 68)
    frame.Position = UDim2.new(1, 20, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
    frame.BackgroundTransparency = 0.08
    frame.ClipsDescendants = false
    corner(frame, 12)
    stroke(frame, _G.V6_Primary, 1, 0.5)
    gradient(frame, Color3.fromRGB(20,24,40), Color3.fromRGB(10,10,18), 120)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, -16)
    accentBar.Position = UDim2.new(0, 8, 0, 8)
    accentBar.BackgroundColor3 = _G.V6_Primary
    accentBar.Parent = frame
    corner(accentBar, 2)

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 32, 0, 32)
    icon.Position = UDim2.new(0, 20, 0.5, 0)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://13940080072"
    icon.Parent = frame
    corner(icon, 8)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 0, 20)
    title.Position = UDim2.new(0, 62, 0, 12)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "TckHub"
    title.TextColor3 = Color3.fromRGB(220, 230, 255)
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -80, 0, 22)
    body.Position = UDim2.new(0, 62, 0, 34)
    body.BackgroundTransparency = 1
    body.Font = Enum.Font.GothamMedium
    body.Text = desc or ""
    body.TextColor3 = Color3.fromRGB(160, 170, 200)
    body.TextSize = 11
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextWrapped = true
    body.Parent = frame

    local closeBtn = Instance.new("ImageButton")
    closeBtn.Size = UDim2.new(0, 14, 0, 14)
    closeBtn.Position = UDim2.new(1, -14, 0, 10)
    closeBtn.AnchorPoint = Vector2.new(1, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = "rbxassetid://10747384394"
    closeBtn.ImageColor3 = Color3.fromRGB(160, 170, 200)
    closeBtn.Parent = frame

    local entry = {frame = frame}
    table.insert(notifList, entry)
    closeBtn.MouseButton1Click:Connect(function()
        for i, e in ipairs(notifList) do
            if e == entry then removeNotif(i) break end
        end
    end)

    -- slide in
    tween(frame, 0.4, {Position = UDim2.new(1, -320, 0, yPos)}, Enum.EasingStyle.Back):Play()
    task.delay(duration, function()
        for i, e in ipairs(notifList) do
            if e == entry then removeNotif(i) break end
        end
    end)
end

function Library:StartLoad() end
function Library:Loaded() end
function Library:LoadAnimation() return false end
function Library:SaveSettings() return true end

-- ============================================================
-- SETTINGS CONFIG SYSTEM
-- ============================================================
local SettingsLib = { SaveSettings = true, LoadAnimation = false }
local HttpSrv = game:GetService("HttpService")

getgenv().LoadConfig = getgenv().LoadConfig or function()
    pcall(function()
        if readfile and writefile and isfile and isfolder then
            if not isfolder("TckHub") then makefolder("TckHub") end
            if not isfolder("TckHub/Library/") then makefolder("TckHub/Library/") end
            local fp = "TckHub/Library/" .. game.Players.LocalPlayer.Name .. ".json"
            if not isfile(fp) then
                writefile(fp, HttpSrv:JSONEncode(SettingsLib))
            else
                local ok, decoded = pcall(function() return HttpSrv:JSONDecode(readfile(fp)) end)
                if ok and decoded then
                    for k, v in pairs(decoded) do SettingsLib[k] = v end
                end
            end
        end
    end)
end

getgenv().SaveConfig = getgenv().SaveConfig or function()
    pcall(function()
        if writefile and isfolder then
            local fp = "TckHub/Library/" .. game.Players.LocalPlayer.Name .. ".json"
            writefile(fp, HttpSrv:JSONEncode(SettingsLib))
        end
    end)
end

pcall(function() getgenv().LoadConfig() end)

-- ============================================================
-- WINDOW
-- ============================================================
function Library:Window(Config)
    print("[TCK] WINDOW CREATED")
    Config = Config or {}

    local WinW = 480
    local WinH = 320
    if Config.Size then
        WinW = Config.Size.X.Offset > 0 and Config.Size.X.Offset or WinW
        WinH = Config.Size.Y.Offset > 0 and Config.Size.Y.Offset or WinH
    end
    local TabW  = Config.TabWidth or 140
    local keybind = Config.Keybind or Enum.KeyCode.RightControl

    -- --------------------------------------------------------
    -- PAGE REGISTRY
    -- --------------------------------------------------------
    local Pages   = {}   -- [tabName] = ScrollingFrame
    local TabAPIs = {}   -- [tabName] = component API table
    local TabBtns = {}   -- [tabName] = {button, selector, icon, title}
    local activeTab = nil

    -- --------------------------------------------------------
    -- ROOT SCREENGUI
    -- --------------------------------------------------------
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "TckHub"
    Gui.DisplayOrder = 1000
    Gui.ResetOnSpawn = false
    Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Gui.Parent = CoreGui

    _MainGuiRef = Gui   -- expose for logo toggle

    -- --------------------------------------------------------
    -- GLASS WINDOW FRAME
    -- --------------------------------------------------------
    local Outline = Instance.new("Frame")
    Outline.Name = "Outline"
    Outline.Parent = Gui
    Outline.AnchorPoint = Vector2.new(0.5, 0.5)
    Outline.Position = UDim2.new(0.5, 0, 0.5, 0)
    Outline.Size = UDim2.new(0, WinW + 4, 0, WinH + 4)
    Outline.BackgroundColor3 = Color3.fromRGB(30, 34, 58)
    Outline.BackgroundTransparency = 0.5
    Outline.ClipsDescendants = false
    corner(Outline, 18)
    stroke(Outline, _G.V6_Primary, 1.5, 0.45)

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = Outline
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(1, -4, 1, -4)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
    Main.BackgroundTransparency = 0.08
    Main.ClipsDescendants = true
    corner(Main, 16)

    -- Subtle glass sheen
    local sheen = Instance.new("Frame")
    sheen.Name = "Sheen"
    sheen.Parent = Main
    sheen.Size = UDim2.new(1, 0, 0.5, 0)
    sheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sheen.BackgroundTransparency = 0.97
    sheen.BorderSizePixel = 0
    sheen.ZIndex = 2
    corner(sheen, 16)

    -- --------------------------------------------------------
    -- TOPBAR
    -- --------------------------------------------------------
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.Size = UDim2.new(1, 0, 0, 44)
    TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    TopBar.BackgroundTransparency = 0.4
    TopBar.BorderSizePixel = 0
    TopBar.ZIndex = 3
    corner(TopBar, 16)
    stroke(TopBar, Color3.fromRGB(255,255,255), 1, 0.93)

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TopBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 16, 0.5, 0)
    TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = "TckHub"
    TitleLabel.TextSize = 17
    TitleLabel.TextColor3 = Color3.fromRGB(220, 230, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 4
    local ts = TextService:GetTextSize(TitleLabel.Text, 17, Enum.Font.GothamBold, Vector2.new(9999,9999))
    TitleLabel.Size = UDim2.new(0, ts.X + 4, 0, 24)

    local SubLabel = Instance.new("TextLabel")
    SubLabel.Name = "Sub"
    SubLabel.Parent = TitleLabel
    SubLabel.BackgroundTransparency = 1
    SubLabel.Position = UDim2.new(1, 8, 0.5, 0)
    SubLabel.AnchorPoint = Vector2.new(0, 0.5)
    SubLabel.Font = Enum.Font.GothamMedium
    SubLabel.Text = Config.SubTitle or "v6"
    SubLabel.TextSize = 11
    SubLabel.TextColor3 = Color3.fromRGB(100, 120, 180)
    local ss = TextService:GetTextSize(SubLabel.Text, 11, Enum.Font.GothamMedium, Vector2.new(9999,9999))
    SubLabel.Size = UDim2.new(0, ss.X, 0, 18)
    SubLabel.ZIndex = 4

    -- Close
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Name = "Close"
    CloseBtn.Parent = TopBar
    CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
    CloseBtn.Position = UDim2.new(1, -14, 0.5, 0)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Image = "rbxassetid://10747384394"
    CloseBtn.ImageColor3 = Color3.fromRGB(200, 210, 240)
    CloseBtn.ZIndex = 4
    CloseBtn.MouseButton1Click:Connect(function() Gui.Enabled = false end)

    -- Minimize / Resize
    local ResizeBtn = Instance.new("ImageButton")
    ResizeBtn.Name = "Resize"
    ResizeBtn.Parent = TopBar
    ResizeBtn.AnchorPoint = Vector2.new(1, 0.5)
    ResizeBtn.Position = UDim2.new(1, -44, 0.5, 0)
    ResizeBtn.Size = UDim2.new(0, 20, 0, 20)
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Image = "rbxassetid://10734886735"
    ResizeBtn.ImageColor3 = Color3.fromRGB(200, 210, 240)
    ResizeBtn.ZIndex = 4

    local isFullscreen = false
    ResizeBtn.MouseButton1Click:Connect(function()
        isFullscreen = not isFullscreen
        if isFullscreen then
            tween(Outline, 0.35, {Size = UDim2.new(0.9, 0, 0.85, 0)}, Enum.EasingStyle.Quad):Play()
            ResizeBtn.Image = "rbxassetid://10734895698"
        else
            tween(Outline, 0.35, {Size = UDim2.new(0, WinW+4, 0, WinH+4)}, Enum.EasingStyle.Quad):Play()
            ResizeBtn.Image = "rbxassetid://10734886735"
        end
    end)

    -- Drag main window by topbar
    makeDraggable(TopBar, Outline)

    -- Keybind toggle
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == keybind or input.KeyCode == Enum.KeyCode.Insert then
            Gui.Enabled = not Gui.Enabled
        end
    end)

    -- --------------------------------------------------------
    -- TAB SIDEBAR
    -- --------------------------------------------------------
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Parent = Main
    SideBar.Position = UDim2.new(0, 6, 0, 50)
    SideBar.Size = UDim2.new(0, TabW, 1, -56)
    SideBar.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
    SideBar.BackgroundTransparency = 0.5
    SideBar.ClipsDescendants = false
    corner(SideBar, 12)
    stroke(SideBar, Color3.fromRGB(255,255,255), 1, 0.93)

    local SideScroll = Instance.new("ScrollingFrame")
    SideScroll.Name = "SideScroll"
    SideScroll.Parent = SideBar
    SideScroll.Size = UDim2.new(1, 0, 1, 0)
    SideScroll.BackgroundTransparency = 1
    SideScroll.ScrollBarThickness = 0
    SideScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    SideScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    SideScroll.Active = true

    local SideLayout = Instance.new("UIListLayout")
    SideLayout.Parent = SideScroll
    SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SideLayout.Padding = UDim.new(0, 4)

    local SidePad = Instance.new("UIPadding")
    SidePad.Parent = SideScroll
    SidePad.PaddingTop = UDim.new(0, 6)
    SidePad.PaddingBottom = UDim.new(0, 6)
    SidePad.PaddingLeft = UDim.new(0, 6)
    SidePad.PaddingRight = UDim.new(0, 6)

    SideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SideScroll.CanvasSize = UDim2.new(0, 0, 0, SideLayout.AbsoluteContentSize.Y + 12)
    end)

    -- --------------------------------------------------------
    -- PAGE CONTAINER
    -- --------------------------------------------------------
    local PageContainer = Instance.new("Frame")
    PageContainer.Name = "PageContainer"
    PageContainer.Parent = Main
    PageContainer.Position = UDim2.new(0, TabW + 12, 0, 50)
    PageContainer.Size = UDim2.new(1, -(TabW + 18), 1, -56)
    PageContainer.BackgroundTransparency = 1
    PageContainer.ClipsDescendants = true

    -- --------------------------------------------------------
    -- PAGE SWITCH FUNCTION
    -- --------------------------------------------------------
    local function switchPage(tabName)
        print("[TCK] TAB CLICKED:", tabName)
        -- hide all pages
        for name, page in pairs(Pages) do
            page.Visible = (name == tabName)
            if name == tabName then
                print("[TCK] PAGE SHOWN:", tabName)
            end
        end
        -- update tab button visuals
        for name, entry in pairs(TabBtns) do
            local active = (name == tabName)
            local btn = entry.button
            tween(btn, 0.22, {
                BackgroundTransparency = active and 0.75 or 0.96,
                BackgroundColor3 = active and _G.V6_Primary or Color3.fromRGB(30,30,45)
            }):Play()
            if entry.selector then
                tween(entry.selector, 0.2, {
                    Size = active and UDim2.new(0,3,0,20) or UDim2.new(0,3,0,0),
                    BackgroundTransparency = active and 0 or 1
                }):Play()
            end
            if entry.title then
                tween(entry.title, 0.2, {
                    TextColor3 = active and Color3.fromRGB(220,230,255) or Color3.fromRGB(130,140,170)
                }):Play()
            end
            if entry.icon then
                tween(entry.icon, 0.2, {
                    ImageTransparency = active and 0 or 0.5
                }):Play()
            end
        end
        activeTab = tabName
    end

    -- --------------------------------------------------------
    -- WINDOW OBJECT  (returned to caller)
    -- --------------------------------------------------------
    local Window = {}

    -- --------------------------------------------------------
    -- TAB CREATION
    -- --------------------------------------------------------
    function Window:Tab(tabName, iconId)
        print("[TCK] TAB CREATED:", tabName)

        -- Guard: don't create duplicate tabs
        if Pages[tabName] then
            warn("[TCK] Tab already exists:", tabName)
            return TabAPIs[tabName]
        end

        -- --- Tab Button ---
        local btn = Instance.new("TextButton")
        btn.Name = tabName .. "_Btn"
        btn.Parent = SideScroll
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.Text = ""
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        btn.BackgroundTransparency = 0.96
        btn.AutoButtonColor = false
        corner(btn, 8)
        stroke(btn, Color3.fromRGB(255,255,255), 1, 0.94)

        local selector = Instance.new("Frame")
        selector.Name = "Selector"
        selector.Parent = btn
        selector.BackgroundColor3 = _G.V6_Primary
        selector.BackgroundTransparency = 1
        selector.Size = UDim2.new(0, 3, 0, 0)
        selector.Position = UDim2.new(0, 4, 0.5, 0)
        selector.AnchorPoint = Vector2.new(0, 0.5)
        corner(selector, 2)

        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Parent = btn
        tabIcon.BackgroundTransparency = 1
        tabIcon.Size = UDim2.new(0, 16, 0, 16)
        tabIcon.Position = UDim2.new(0, 12, 0.5, 0)
        tabIcon.AnchorPoint = Vector2.new(0, 0.5)
        tabIcon.Image = iconId or "rbxassetid://10723407389"
        tabIcon.ImageTransparency = 0.5
        tabIcon.ImageColor3 = Color3.fromRGB(200, 210, 255)

        local tabTitle = Instance.new("TextLabel")
        tabTitle.Name = "Title"
        tabTitle.Parent = btn
        tabTitle.BackgroundTransparency = 1
        tabTitle.Position = UDim2.new(0, 34, 0.5, 0)
        tabTitle.AnchorPoint = Vector2.new(0, 0.5)
        tabTitle.Size = UDim2.new(1, -40, 0, 18)
        tabTitle.Font = Enum.Font.GothamMedium
        tabTitle.Text = tabName
        tabTitle.TextSize = 12
        tabTitle.TextColor3 = Color3.fromRGB(130, 140, 170)
        tabTitle.TextXAlignment = Enum.TextXAlignment.Left

        TabBtns[tabName] = {
            button   = btn,
            selector = selector,
            icon     = tabIcon,
            title    = tabTitle
        }

        -- --- Page ScrollingFrame ---
        print("[TCK] PAGE CREATED:", tabName)
        local page = Instance.new("ScrollingFrame")
        page.Name = tabName .. "_Page"
        page.Parent = PageContainer
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = _G.V6_Primary
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Active = true
        page.Visible = false     -- hidden until activated

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Parent = page
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pageLayout.Padding = UDim.new(0, 6)

        local pagePad = Instance.new("UIPadding")
        pagePad.Parent = page
        pagePad.PaddingTop = UDim.new(0, 6)
        pagePad.PaddingBottom = UDim.new(0, 8)
        pagePad.PaddingLeft = UDim.new(0, 6)
        pagePad.PaddingRight = UDim.new(0, 6)

        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 14)
        end)

        Pages[tabName] = page

        -- Click handler
        btn.MouseButton1Click:Connect(function()
            switchPage(tabName)
        end)

        -- Hover
        btn.MouseEnter:Connect(function()
            if activeTab ~= tabName then
                tween(btn, 0.2, {BackgroundTransparency = 0.88}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if activeTab ~= tabName then
                tween(btn, 0.2, {BackgroundTransparency = 0.96}):Play()
            end
        end)

        -- Auto-select the first tab created
        if activeTab == nil then
            switchPage(tabName)
        end

        -- --------------------------------------------------------
        -- COMPONENT API for this tab's page
        -- --------------------------------------------------------
        local TabAPI = {}

        local function makeCard(h)
            local card = Instance.new("Frame")
            card.Name = "Card"
            card.Parent = page
            card.Size = UDim2.new(1, 0, 0, h or 38)
            card.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
            card.BackgroundTransparency = 0.65
            corner(card, 8)
            stroke(card, Color3.fromRGB(255,255,255), 1, 0.93)
            return card
        end

        -- ----- BUTTON -----
        function TabAPI:Button(text, callback)
            local card = makeCard(38)

            local btn2 = Instance.new("TextButton")
            btn2.Parent = card
            btn2.Size = UDim2.new(1, 0, 1, 0)
            btn2.BackgroundTransparency = 1
            btn2.Text = ""
            btn2.ZIndex = 2

            local icon = Instance.new("ImageLabel")
            icon.Parent = card
            icon.BackgroundTransparency = 1
            icon.Size = UDim2.new(0, 15, 0, 15)
            icon.Position = UDim2.new(0, 12, 0.5, 0)
            icon.AnchorPoint = Vector2.new(0, 0.5)
            icon.Image = "rbxassetid://10709768347"
            icon.ImageColor3 = Color3.fromRGB(150, 160, 200)

            local label = Instance.new("TextLabel")
            label.Parent = card
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 34, 0.5, 0)
            label.AnchorPoint = Vector2.new(0, 0.5)
            label.Size = UDim2.new(1, -60, 0, 20)
            label.Font = Enum.Font.GothamMedium
            label.Text = text
            label.TextSize = 13
            label.TextColor3 = Color3.fromRGB(220, 225, 245)
            label.TextXAlignment = Enum.TextXAlignment.Left

            local arrow = Instance.new("ImageLabel")
            arrow.Parent = card
            arrow.BackgroundTransparency = 1
            arrow.Size = UDim2.new(0, 12, 0, 12)
            arrow.Position = UDim2.new(1, -12, 0.5, 0)
            arrow.AnchorPoint = Vector2.new(1, 0.5)
            arrow.Image = "rbxassetid://10734898355"
            arrow.ImageColor3 = Color3.fromRGB(120, 130, 180)

            btn2.MouseEnter:Connect(function()
                tween(card, 0.2, {BackgroundTransparency = 0.45, BackgroundColor3 = Color3.fromRGB(30,34,52)}):Play()
                tween(arrow, 0.2, {ImageColor3 = _G.V6_Primary}):Play()
            end)
            btn2.MouseLeave:Connect(function()
                tween(card, 0.2, {BackgroundTransparency = 0.65, BackgroundColor3 = Color3.fromRGB(20,20,32)}):Play()
                tween(arrow, 0.2, {ImageColor3 = Color3.fromRGB(120,130,180)}):Play()
            end)
            btn2.MouseButton1Click:Connect(function()
                tween(card, 0.08, {Size = UDim2.new(0.97, 0, 0, 36)}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
                task.delay(0.1, function()
                    tween(card, 0.12, {Size = UDim2.new(1, 0, 0, 38)}):Play()
                end)
                pcall(callback)
            end)
        end

        -- ----- TOGGLE -----
        function TabAPI:Toggle(text, default, desc, callback)
            if type(desc) == "function" then
                callback = desc
                desc = nil
            end
            default = default or false
            local toggled = default

            local h = desc and 48 or 38
            local card = makeCard(h)

            local clickArea = Instance.new("TextButton")
            clickArea.Parent = card
            clickArea.Size = UDim2.new(1, 0, 1, 0)
            clickArea.BackgroundTransparency = 1
            clickArea.Text = ""
            clickArea.ZIndex = 2

            local titleLbl = Instance.new("TextLabel")
            titleLbl.Parent = card
            titleLbl.BackgroundTransparency = 1
            titleLbl.Font = Enum.Font.GothamMedium
            titleLbl.Text = text
            titleLbl.TextSize = 13
            titleLbl.TextColor3 = Color3.fromRGB(220, 225, 245)
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            if desc then
                titleLbl.Position = UDim2.new(0, 12, 0, 7)
                titleLbl.Size = UDim2.new(1, -62, 0, 18)
            else
                titleLbl.Position = UDim2.new(0, 12, 0.5, 0)
                titleLbl.AnchorPoint = Vector2.new(0, 0.5)
                titleLbl.Size = UDim2.new(1, -62, 0, 20)
            end

            if desc then
                local descLbl = Instance.new("TextLabel")
                descLbl.Parent = card
                descLbl.BackgroundTransparency = 1
                descLbl.Font = Enum.Font.Gotham
                descLbl.Text = desc
                descLbl.TextSize = 11
                descLbl.TextColor3 = Color3.fromRGB(110, 120, 160)
                descLbl.TextXAlignment = Enum.TextXAlignment.Left
                descLbl.TextWrapped = true
                descLbl.Position = UDim2.new(0, 12, 0, 26)
                descLbl.Size = UDim2.new(1, -62, 0, 16)
            end

            -- iOS-style pill toggle
            local pillOuter = Instance.new("Frame")
            pillOuter.Parent = card
            pillOuter.Size = UDim2.new(0, 38, 0, 22)
            pillOuter.Position = UDim2.new(1, -12, 0.5, 0)
            pillOuter.AnchorPoint = Vector2.new(1, 0.5)
            pillOuter.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            corner(pillOuter, 11)
            stroke(pillOuter, Color3.fromRGB(255,255,255), 1, 0.9)

            local knob = Instance.new("Frame")
            knob.Parent = pillOuter
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = UDim2.new(0, 3, 0.5, 0)
            knob.AnchorPoint = Vector2.new(0, 0.5)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            corner(knob, 8)

            local function updateVisual(anim)
                local dur = anim and 0.2 or 0
                if toggled then
                    tween(knob, dur, {Position = UDim2.new(1, -19, 0.5, 0)}):Play()
                    tween(pillOuter, dur, {BackgroundColor3 = _G.V6_Primary}):Play()
                else
                    tween(knob, dur, {Position = UDim2.new(0, 3, 0.5, 0)}):Play()
                    tween(pillOuter, dur, {BackgroundColor3 = Color3.fromRGB(50,50,70)}):Play()
                end
            end

            updateVisual(false)
            if default then pcall(callback, true) end

            clickArea.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateVisual(true)
                pcall(callback, toggled)
            end)
            clickArea.MouseEnter:Connect(function()
                tween(card, 0.2, {BackgroundTransparency = 0.45}):Play()
            end)
            clickArea.MouseLeave:Connect(function()
                tween(card, 0.2, {BackgroundTransparency = 0.65}):Play()
            end)

            local api = {}
            function api:Set(val)
                toggled = val
                updateVisual(true)
                pcall(callback, toggled)
            end
            function api:Get() return toggled end
            return api
        end

        -- ----- SLIDER -----
        function TabAPI:Slider(text, min, max, set, callback)
            min = min or 0
            max = max or 100
            local val = math.clamp(set or min, min, max)

            local card = makeCard(48)

            local titleLbl = Instance.new("TextLabel")
            titleLbl.Parent = card
            titleLbl.BackgroundTransparency = 1
            titleLbl.Position = UDim2.new(0, 12, 0, 6)
            titleLbl.Size = UDim2.new(1, -80, 0, 18)
            titleLbl.Font = Enum.Font.GothamMedium
            titleLbl.Text = text
            titleLbl.TextSize = 13
            titleLbl.TextColor3 = Color3.fromRGB(220, 225, 245)
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left

            local valLbl = Instance.new("TextLabel")
            valLbl.Parent = card
            valLbl.BackgroundTransparency = 1
            valLbl.Position = UDim2.new(1, -14, 0, 6)
            valLbl.AnchorPoint = Vector2.new(1, 0)
            valLbl.Size = UDim2.new(0, 60, 0, 18)
            valLbl.Font = Enum.Font.GothamBold
            valLbl.Text = tostring(val)
            valLbl.TextSize = 12
            valLbl.TextColor3 = _G.V6_Primary
            valLbl.TextXAlignment = Enum.TextXAlignment.Right

            local track = Instance.new("Frame")
            track.Parent = card
            track.Position = UDim2.new(0, 12, 0, 30)
            track.Size = UDim2.new(1, -24, 0, 6)
            track.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            track.BorderSizePixel = 0
            corner(track, 3)

            local fill = Instance.new("Frame")
            fill.Parent = track
            fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = _G.V6_Primary
            fill.BorderSizePixel = 0
            corner(fill, 3)
            gradient(fill, _G.V6_Primary, _G.V6_Accent, 0)

            local thumb = Instance.new("ImageButton")
            thumb.Parent = fill
            thumb.Size = UDim2.new(0, 16, 0, 16)
            thumb.Position = UDim2.new(1, 0, 0.5, 0)
            thumb.AnchorPoint = Vector2.new(0.5, 0.5)
            thumb.BackgroundColor3 = Color3.fromRGB(240, 245, 255)
            thumb.AutoButtonColor = false
            corner(thumb, 8)
            stroke(thumb, _G.V6_Primary, 1.5, 0.3)

            local dragging = false

            local function setVal(input)
                local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * pct + 0.5)
                fill.Size = UDim2.new(pct, 0, 1, 0)
                valLbl.Text = tostring(val)
                pcall(callback, val)
            end

            thumb.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            track.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    setVal(i)
                end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                    setVal(i)
                end
            end)

            pcall(callback, val)
        end

        -- ----- DROPDOWN -----
        function TabAPI:Dropdown(text, options, default, callback)
            options = options or {}
            local selected = tostring(default or "Select")
            local open = false
            local ITEM_H = 26
            local BASE_H = 38
            local MAX_SHOW = 4

            local wrapper = Instance.new("Frame")
            wrapper.Name = "Dropdown"
            wrapper.Parent = page
            wrapper.Size = UDim2.new(1, 0, 0, BASE_H)
            wrapper.BackgroundTransparency = 1
            wrapper.ClipsDescendants = false

            local card = Instance.new("Frame")
            card.Parent = wrapper
            card.Size = UDim2.new(1, 0, 0, BASE_H)
            card.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
            card.BackgroundTransparency = 0.65
            card.ClipsDescendants = true
            corner(card, 8)
            stroke(card, Color3.fromRGB(255,255,255), 1, 0.93)

            local clickHeader = Instance.new("TextButton")
            clickHeader.Parent = card
            clickHeader.Size = UDim2.new(1, 0, 0, BASE_H)
            clickHeader.BackgroundTransparency = 1
            clickHeader.Text = ""
            clickHeader.ZIndex = 2

            local titleLbl = Instance.new("TextLabel")
            titleLbl.Parent = card
            titleLbl.BackgroundTransparency = 1
            titleLbl.Position = UDim2.new(0, 12, 0, 0)
            titleLbl.Size = UDim2.new(0.5, 0, 0, BASE_H)
            titleLbl.Font = Enum.Font.GothamMedium
            titleLbl.Text = text
            titleLbl.TextSize = 13
            titleLbl.TextColor3 = Color3.fromRGB(220, 225, 245)
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left

            local selLbl = Instance.new("TextLabel")
            selLbl.Parent = card
            selLbl.BackgroundTransparency = 1
            selLbl.Position = UDim2.new(0.5, 0, 0, 0)
            selLbl.Size = UDim2.new(0.5, -28, 0, BASE_H)
            selLbl.Font = Enum.Font.GothamMedium
            selLbl.Text = selected
            selLbl.TextSize = 11
            selLbl.TextColor3 = Color3.fromRGB(130, 145, 200)
            selLbl.TextXAlignment = Enum.TextXAlignment.Right

            local chevron = Instance.new("ImageLabel")
            chevron.Parent = card
            chevron.BackgroundTransparency = 1
            chevron.Size = UDim2.new(0, 12, 0, 12)
            chevron.Position = UDim2.new(1, -12, 0.5, 0)
            chevron.AnchorPoint = Vector2.new(1, 0.5)
            chevron.Image = "rbxassetid://10709790948"
            chevron.ImageColor3 = Color3.fromRGB(130, 145, 200)

            -- dropdown list
            local listFrame = Instance.new("ScrollingFrame")
            listFrame.Parent = card
            listFrame.Position = UDim2.new(0, 0, 0, BASE_H)
            listFrame.Size = UDim2.new(1, 0, 0, 0)
            listFrame.BackgroundTransparency = 1
            listFrame.ScrollBarThickness = 2
            listFrame.ScrollBarImageColor3 = _G.V6_Primary
            listFrame.ScrollingDirection = Enum.ScrollingDirection.Y
            listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
            listFrame.Active = true

            local listLayout = Instance.new("UIListLayout")
            listLayout.Parent = listFrame
            listLayout.Padding = UDim.new(0, 2)

            local listPad = Instance.new("UIPadding")
            listPad.PaddingLeft = UDim.new(0, 4)
            listPad.PaddingRight = UDim.new(0, 4)
            listPad.PaddingTop = UDim.new(0, 4)
            listPad.PaddingBottom = UDim.new(0, 4)
            listPad.Parent = listFrame

            listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                listFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
            end)

            local function buildItem(opt)
                local item = Instance.new("TextButton")
                item.Parent = listFrame
                item.Size = UDim2.new(1, 0, 0, ITEM_H)
                item.BackgroundColor3 = Color3.fromRGB(30, 34, 52)
                item.BackgroundTransparency = opt == selected and 0.6 or 1
                item.Font = Enum.Font.GothamMedium
                item.Text = tostring(opt)
                item.TextSize = 12
                item.TextColor3 = opt == selected and Color3.fromRGB(200,215,255) or Color3.fromRGB(140,150,190)
                item.TextXAlignment = Enum.TextXAlignment.Left
                item.AutoButtonColor = false
                corner(item, 4)

                local itPad = Instance.new("UIPadding")
                itPad.PaddingLeft = UDim.new(0, 8)
                itPad.Parent = item

                item.MouseEnter:Connect(function()
                    tween(item, 0.15, {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(210,220,255)}):Play()
                end)
                item.MouseLeave:Connect(function()
                    local isSel = item.Text == selected
                    tween(item, 0.15, {BackgroundTransparency = isSel and 0.6 or 1, TextColor3 = isSel and Color3.fromRGB(200,215,255) or Color3.fromRGB(140,150,190)}):Play()
                end)
                item.MouseButton1Click:Connect(function()
                    selected = tostring(opt)
                    selLbl.Text = selected
                    pcall(callback, selected)
                    -- close
                    open = false
                    local sh = math.min(#options, MAX_SHOW) * ITEM_H + 10
                    tween(card, 0.22, {Size = UDim2.new(1, 0, 0, BASE_H), ClipsDescendants = true}):Play()
                    tween(listFrame, 0.22, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    tween(wrapper, 0.22, {Size = UDim2.new(1, 0, 0, BASE_H)}):Play()
                    tween(chevron, 0.2, {Rotation = 0}):Play()
                    -- refresh colours
                    for _, ch in ipairs(listFrame:GetChildren()) do
                        if ch:IsA("TextButton") then
                            local isSel = ch.Text == selected
                            ch.BackgroundTransparency = isSel and 0.6 or 1
                            ch.TextColor3 = isSel and Color3.fromRGB(200,215,255) or Color3.fromRGB(140,150,190)
                        end
                    end
                end)
            end

            for _, opt in ipairs(options) do buildItem(opt) end

            clickHeader.MouseButton1Click:Connect(function()
                open = not open
                local sh = math.min(#options, MAX_SHOW) * (ITEM_H + 2) + 10
                if open then
                    card.ClipsDescendants = false
                    tween(listFrame, 0.25, {Size = UDim2.new(1, 0, 0, sh)}, Enum.EasingStyle.Quart):Play()
                    tween(card, 0.25, {Size = UDim2.new(1, 0, 0, BASE_H + sh)}, Enum.EasingStyle.Quart):Play()
                    tween(wrapper, 0.25, {Size = UDim2.new(1, 0, 0, BASE_H + sh)}, Enum.EasingStyle.Quart):Play()
                    tween(chevron, 0.2, {Rotation = 180}):Play()
                else
                    tween(listFrame, 0.22, {Size = UDim2.new(1, 0, 0, 0)}):Play()
                    tween(card, 0.22, {Size = UDim2.new(1, 0, 0, BASE_H)}):Play()
                    tween(wrapper, 0.22, {Size = UDim2.new(1, 0, 0, BASE_H)}):Play()
                    tween(chevron, 0.2, {Rotation = 0}):Play()
                    task.delay(0.23, function() if not open then card.ClipsDescendants = true end end)
                end
            end)

            if default then pcall(callback, tostring(default)) end

            local api = {}
            function api:Add(opt)
                table.insert(options, opt)
                buildItem(opt)
            end
            function api:Clear()
                selected = "Select"
                selLbl.Text = selected
                for _, ch in ipairs(listFrame:GetChildren()) do
                    if ch:IsA("TextButton") then ch:Destroy() end
                end
                options = {}
            end
            function api:Set(val)
                selected = tostring(val)
                selLbl.Text = selected
                pcall(callback, selected)
            end
            return api
        end

        -- ----- TEXTBOX -----
        function TabAPI:Textbox(text, placeholder, disappear, callback)
            if type(placeholder) == "boolean" then
                callback = disappear
                disappear = placeholder
                placeholder = "Type..."
            end
            placeholder = placeholder or "Type..."

            local card = makeCard(38)

            local lbl = Instance.new("TextLabel")
            lbl.Parent = card
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 12, 0.5, 0)
            lbl.AnchorPoint = Vector2.new(0, 0.5)
            lbl.Size = UDim2.new(0.5, 0, 0, 20)
            lbl.Font = Enum.Font.GothamMedium
            lbl.Text = text
            lbl.TextSize = 13
            lbl.TextColor3 = Color3.fromRGB(220, 225, 245)
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local box = Instance.new("TextBox")
            box.Parent = card
            box.Position = UDim2.new(1, -12, 0.5, 0)
            box.AnchorPoint = Vector2.new(1, 0.5)
            box.Size = UDim2.new(0, 100, 0, 26)
            box.BackgroundColor3 = Color3.fromRGB(14, 14, 22)
            box.BackgroundTransparency = 0.3
            box.Font = Enum.Font.Gotham
            box.Text = ""
            box.PlaceholderText = placeholder
            box.TextColor3 = Color3.fromRGB(220, 230, 255)
            box.PlaceholderColor3 = Color3.fromRGB(80, 90, 130)
            box.TextSize = 12
            box.ClearTextOnFocus = false
            corner(box, 6)
            local bStroke = stroke(box, Color3.fromRGB(255,255,255), 1, 0.9)

            box.Focused:Connect(function()
                tween(bStroke, 0.2, {Color = _G.V6_Primary, Transparency = 0.3}):Play()
            end)
            box.FocusLost:Connect(function(enter)
                tween(bStroke, 0.2, {Color = Color3.fromRGB(255,255,255), Transparency = 0.9}):Play()
                pcall(callback, box.Text)
                if disappear then box.Text = "" end
            end)
        end

        -- ----- LABEL -----
        function TabAPI:Label(text)
            local card = makeCard(30)
            card.BackgroundTransparency = 1

            local dot = Instance.new("Frame")
            dot.Parent = card
            dot.Size = UDim2.new(0, 6, 0, 6)
            dot.Position = UDim2.new(0, 10, 0.5, 0)
            dot.AnchorPoint = Vector2.new(0, 0.5)
            dot.BackgroundColor3 = _G.V6_Primary
            corner(dot, 3)

            local lbl = Instance.new("TextLabel")
            lbl.Parent = card
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 24, 0.5, 0)
            lbl.AnchorPoint = Vector2.new(0, 0.5)
            lbl.Size = UDim2.new(1, -30, 0, 20)
            lbl.Font = Enum.Font.GothamMedium
            lbl.Text = text
            lbl.TextSize = 13
            lbl.TextColor3 = Color3.fromRGB(190, 200, 230)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.RichText = true

            local api = {}
            function api:Set(t) lbl.Text = t end
            function api:Get() return lbl.Text end
            return api
        end

        -- ----- PARAGRAPH -----
        function TabAPI:Paragraph(title, body)
            local wrapper = Instance.new("Frame")
            wrapper.Name = "Paragraph"
            wrapper.Parent = page
            wrapper.Size = UDim2.new(1, 0, 0, 60)
            wrapper.BackgroundColor3 = Color3.fromRGB(18, 18, 30)
            wrapper.BackgroundTransparency = 0.65
            corner(wrapper, 8)
            stroke(wrapper, Color3.fromRGB(255,255,255), 1, 0.93)

            local tLbl = Instance.new("TextLabel")
            tLbl.Parent = wrapper
            tLbl.BackgroundTransparency = 1
            tLbl.Position = UDim2.new(0, 12, 0, 8)
            tLbl.Size = UDim2.new(1, -20, 0, 18)
            tLbl.Font = Enum.Font.GothamBold
            tLbl.Text = title or ""
            tLbl.TextSize = 13
            tLbl.TextColor3 = Color3.fromRGB(210, 220, 255)
            tLbl.TextXAlignment = Enum.TextXAlignment.Left

            local bLbl = Instance.new("TextLabel")
            bLbl.Parent = wrapper
            bLbl.BackgroundTransparency = 1
            bLbl.Position = UDim2.new(0, 12, 0, 26)
            bLbl.Size = UDim2.new(1, -20, 0, 28)
            bLbl.Font = Enum.Font.Gotham
            bLbl.Text = body or ""
            bLbl.TextSize = 11
            bLbl.TextColor3 = Color3.fromRGB(120, 135, 175)
            bLbl.TextXAlignment = Enum.TextXAlignment.Left
            bLbl.TextWrapped = true
            bLbl.RichText = true
        end

        -- ----- SEPARATOR -----
        function TabAPI:Seperator(text)
            local sep = Instance.new("Frame")
            sep.Name = "Separator"
            sep.Parent = page
            sep.Size = UDim2.new(1, 0, 0, 28)
            sep.BackgroundTransparency = 1

            local line = Instance.new("Frame")
            line.Parent = sep
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0.5, 0)
            line.BackgroundColor3 = Color3.fromRGB(255,255,255)
            line.BorderSizePixel = 0
            gradient(line, Color3.fromRGB(10,10,16), _G.V6_Primary, 0)

            if text and text ~= "" then
                local bg = Instance.new("Frame")
                bg.Parent = sep
                bg.AnchorPoint = Vector2.new(0.5, 0.5)
                bg.Position = UDim2.new(0.5, 0, 0.5, 0)
                bg.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
                bg.BackgroundTransparency = 0
                bg.Size = UDim2.new(0, 0, 1, 0)
                bg.AutomaticSize = Enum.AutomaticSize.X
                bg.BorderSizePixel = 0

                local tl = Instance.new("TextLabel")
                tl.Parent = bg
                tl.BackgroundTransparency = 1
                tl.Size = UDim2.new(0, 0, 1, 0)
                tl.AutomaticSize = Enum.AutomaticSize.X
                tl.Font = Enum.Font.GothamBold
                tl.Text = "  " .. text .. "  "
                tl.TextSize = 11
                tl.TextColor3 = Color3.fromRGB(100, 120, 180)
                tl.TextXAlignment = Enum.TextXAlignment.Center
            end
        end

        -- alias
        TabAPI.Separator = TabAPI.Seperator

        -- ----- LINE -----
        function TabAPI:Line()
            local f = Instance.new("Frame")
            f.Name = "Line"
            f.Parent = page
            f.Size = UDim2.new(1, 0, 0, 8)
            f.BackgroundTransparency = 1

            local l = Instance.new("Frame")
            l.Parent = f
            l.Size = UDim2.new(1, 0, 0, 1)
            l.Position = UDim2.new(0, 0, 0.5, 0)
            l.BackgroundColor3 = _G.V6_Primary
            l.BackgroundTransparency = 0.7
            l.BorderSizePixel = 0
            corner(l, 1)
        end

        -- ----- KEYBIND -----
        function TabAPI:Keybind(text, default, callback)
            local currentKey = default or Enum.KeyCode.Unknown
            local listening = false

            local card = makeCard(38)

            local lbl = Instance.new("TextLabel")
            lbl.Parent = card
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 12, 0.5, 0)
            lbl.AnchorPoint = Vector2.new(0, 0.5)
            lbl.Size = UDim2.new(0.6, 0, 0, 20)
            lbl.Font = Enum.Font.GothamMedium
            lbl.Text = text
            lbl.TextSize = 13
            lbl.TextColor3 = Color3.fromRGB(220, 225, 245)
            lbl.TextXAlignment = Enum.TextXAlignment.Left

            local keyBtn = Instance.new("TextButton")
            keyBtn.Parent = card
            keyBtn.Position = UDim2.new(1, -12, 0.5, 0)
            keyBtn.AnchorPoint = Vector2.new(1, 0.5)
            keyBtn.Size = UDim2.new(0, 80, 0, 24)
            keyBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 45)
            keyBtn.BackgroundTransparency = 0.3
            keyBtn.Font = Enum.Font.GothamMedium
            keyBtn.Text = tostring(currentKey.Name)
            keyBtn.TextSize = 11
            keyBtn.TextColor3 = Color3.fromRGB(170, 185, 230)
            keyBtn.AutoButtonColor = false
            corner(keyBtn, 6)
            stroke(keyBtn, _G.V6_Primary, 1, 0.6)

            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
                keyBtn.TextColor3 = _G.V6_Danger
            end)

            UserInputService.InputBegan:Connect(function(input, gp)
                if not listening then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    listening = false
                    keyBtn.Text = tostring(currentKey.Name)
                    keyBtn.TextColor3 = Color3.fromRGB(170, 185, 230)
                    pcall(callback, currentKey)
                end
            end)
        end

        TabAPIs[tabName] = TabAPI
        return TabAPI
    end

    print("[TCK] LOADING COMPLETE")
    return Window
end

return Library
