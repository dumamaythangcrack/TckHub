--[[========================================================================⚡ TCK HUB PREMIUM UI LIBRARY - REDESIGNED VERSION 2026 ⚡========================================================================* High-Performance Rendering & Modern Dark-Glow Aesthetics* Smooth Tween Animations & Responsive Physics Bypass Elements* Fully Compatible with previous TckHub API standard.]]-- Dọn dẹp các UI cũ nếu có tránh bị trùng lặp hiển thịif (game:GetService("CoreGui")):FindFirstChild("TckHub") then(game:GetService("CoreGui")).TckHub:Destroy()endif (game:GetService("CoreGui")):FindFirstChild("ScreenGui") then-- Tránh destroy nhầm ScreenGui hệ thống, chỉ dọn ScreenGui tạo bởi loader cũ nếu khớp tênlocal oldScreen = (game:GetService("CoreGui")):FindFirstChild("ScreenGui")if oldScreen:FindFirstChild("OutlineButton") thenoldScreen:Destroy()endend-- ==================== ĐỊNH NGHĨA TÔNG MÀU PREMIUM ====================_G.Primary = Color3.fromRGB(160, 160, 165)   -- Màu phụ xám nhạt hiện đại_G.Dark = Color3.fromRGB(15, 15, 18)         -- Nền siêu tối sang trọng_G.Third = Color3.fromRGB(255, 30, 60)       -- Neon Đỏ rực rỡ làm điểm nhấn chínhlocal AccentGlow = Color3.fromRGB(255, 60, 90)local SecondaryDark = Color3.fromRGB(25, 25, 30)local TextWhite = Color3.fromRGB(245, 245, 250)local TextMuted = Color3.fromRGB(140, 140, 145)-- Hàm phụ trợ bo góc nhanhfunction CreateRounded(Parent, Size)local Rounded = Instance.new("UICorner")Rounded.Name = "Rounded"Rounded.Parent = ParentRounded.CornerRadius = UDim.new(0, Size)return Roundedend-- Hàm tạo đường viền mỏng cao cấp (UIStroke)local function CreateStroke(Parent, Color, Thickness, Transparency)local Stroke = Instance.new("UIStroke")Stroke.Parent = ParentStroke.Color = Color or Color3.fromRGB(45, 45, 50)Stroke.Thickness = Thickness or 1Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.BorderStroke.Transparency = Transparency or 0return Strokeendlocal UserInputService = game:GetService("UserInputService")local TweenService = game:GetService("TweenService")-- HÀM KÉO THẢ UI MƯỢT MÀ (Tương thích cả PC và Touch di động)function MakeDraggable(topbarobject, object)local Dragging = nillocal DragInput = nillocal DragStart = nillocal StartPosition = nillocal function Update(input)local Delta = input.Position - DragStartlocal pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)local Tween = TweenService:Create(object, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = pos})Tween:Play()endtopbarobject.InputBegan:Connect(function(input)if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch thenDragging = trueDragStart = input.PositionStartPosition = object.Positioninput.Changed:Connect(function()if input.UserInputState == Enum.UserInputState.End thenDragging = falseendend)endend)topbarobject.InputChanged:Connect(function(input)if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch thenDragInput = inputendend)UserInputService.InputChanged:Connect(function(input)if input == DragInput and Dragging thenUpdate(input)endend)end-- ==================== KHỞI TẠO NÚT MỞ NHANH (MINI BUTTON) ====================local ScreenGui = Instance.new("ScreenGui")ScreenGui.Name = "TckHub_QuickOpen"ScreenGui.Parent = game.CoreGuiScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Siblinglocal OutlineButton = Instance.new("Frame")OutlineButton.Name = "OutlineButton"OutlineButton.Parent = ScreenGuiOutlineButton.ClipsDescendants = trueOutlineButton.BackgroundColor3 = _G.DarkOutlineButton.Position = UDim2.new(0, 15, 0, 15)OutlineButton.Size = UDim2.new(0, 52, 0, 52)CreateRounded(OutlineButton, 14)local btnStroke = CreateStroke(OutlineButton, _G.Third, 1.5, 0.3)local ImageButton = Instance.new("ImageButton")ImageButton.Parent = OutlineButtonImageButton.Position = UDim2.new(0.5, 0, 0.5, 0)ImageButton.Size = UDim2.new(0, 38, 0, 38)ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)ImageButton.BackgroundColor3 = _G.DarkImageButton.ImageColor3 = TextWhiteImageButton.Image = "rbxassetid://13940080072"ImageButton.AutoButtonColor = falseCreateRounded(ImageButton, 10)MakeDraggable(ImageButton, OutlineButton)-- Hiệu ứng Hover nút mở nhanhImageButton.MouseEnter:Connect(function()TweenService:Create(OutlineButton, TweenInfo.new(0.2), {BackgroundColor3 = SecondaryDark}):Play()TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = AccentGlow, Thickness = 2}):Play()end)ImageButton.MouseLeave:Connect(function()TweenService:Create(OutlineButton, TweenInfo.new(0.2), {BackgroundColor3 = _G.Dark}):Play()TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = _G.Third, Thickness = 1.5}):Play()end)ImageButton.MouseButton1Click:Connect(function()local hub = game.CoreGui:FindFirstChild("TckHub")if hub thenhub.Enabled = not hub.Enabled-- Hiệu ứng nảy nhẹ khi bấmOutlineButton:TweenSize(UDim2.new(0, 46, 0, 46), "Out", "Back", 0.1, true, function()OutlineButton:TweenSize(UDim2.new(0, 52, 0, 52), "Out", "Back", 0.15, true)end)endend)-- ==================== HỆ THỐNG THÔNG BÁO SIÊU ĐẸP ====================local NotificationFrame = Instance.new("ScreenGui")NotificationFrame.Name = "NotificationFrame"NotificationFrame.Parent = game.CoreGuiNotificationFrame.ZIndexBehavior = Enum.ZIndexBehavior.Globallocal NotificationList = {}local function RemoveOldestNotification()if #NotificationList > 0 thenlocal removed = table.remove(NotificationList, 1)TweenService:Create(removed[1], TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, -0.2, 0),BackgroundTransparency = 1}):Play()task.delay(0.4, function()removed[1]:Destroy()end)endendtask.spawn(function()while true dotask.wait(3.5)if #NotificationList > 0 thenRemoveOldestNotification()endendend)local Update = {}function Update:Notify(desc)local OutlineFrame = Instance.new("Frame")OutlineFrame.Name = "OutlineFrame"OutlineFrame.Parent = NotificationFrameOutlineFrame.ClipsDescendants = trueOutlineFrame.BackgroundColor3 = _G.DarkOutlineFrame.AnchorPoint = Vector2.new(0.5, 0)OutlineFrame.Position = UDim2.new(0.5, 0, -0.2, 0)OutlineFrame.Size = UDim2.new(0, 360, 0, 65)CreateRounded(OutlineFrame, 12)local notifStroke = CreateStroke(OutlineFrame, _G.Third, 1.5, 0.2)local GlowBar = Instance.new("Frame")
GlowBar.Name = "GlowBar"
GlowBar.Parent = OutlineFrame
GlowBar.BackgroundColor3 = _G.Third
GlowBar.Size = UDim2.new(0, 4, 1, 0)
GlowBar.Position = UDim2.new(0, 0, 0, 0)
CreateRounded(GlowBar, 2)

local Image = Instance.new("ImageLabel")
Image.Name = "Icon"
Image.Parent = OutlineFrame
Image.BackgroundTransparency = 1
Image.Position = UDim2.new(0, 14, 0.5, 0)
Image.AnchorPoint = Vector2.new(0, 0.5)
Image.Size = UDim2.new(0, 35, 0, 35)
Image.Image = "rbxassetid://13940080072"

local Title = Instance.new("TextLabel")
Title.Parent = OutlineFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 60, 0, 12)
Title.Size = UDim2.new(1, -70, 0, 20)
Title.Font = Enum.Font.GothamBold
Title.Text = "TckHub Notification"
Title.TextColor3 = TextWhite
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local Desc = Instance.new("TextLabel")
Desc.Parent = OutlineFrame
Desc.BackgroundTransparency = 1
Desc.Position = UDim2.new(0, 60, 0, 32)
Desc.Size = UDim2.new(1, -70, 0, 20)
Desc.Font = Enum.Font.GothamMedium
Desc.Text = desc
Desc.TextColor3 = TextMuted
Desc.TextSize = 11
Desc.TextXAlignment = Enum.TextXAlignment.Left

-- Tween bay xuống mượt mà
local targetY = 0.05 + (#NotificationList * 0.09)
OutlineFrame:TweenPosition(UDim2.new(0.5, 0, targetY, 0), "Out", "Back", 0.45, true)

table.insert(NotificationList, {OutlineFrame})
end-- ==================== HỆ THỐNG LOADER BAN ĐẦU ====================function Update:StartLoad()local Loader = Instance.new("ScreenGui")Loader.Parent = game.CoreGuiLoader.ZIndexBehavior = Enum.ZIndexBehavior.GlobalLoader.DisplayOrder = 1000local LoaderFrame = Instance.new("Frame")
LoaderFrame.Name = "LoaderFrame"
LoaderFrame.Parent = Loader
LoaderFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
LoaderFrame.Size = UDim2.new(1, 0, 1, 0)
LoaderFrame.BorderSizePixel = 0

local MainLoaderFrame = Instance.new("Frame")
MainLoaderFrame.Name = "MainLoaderFrame"
MainLoaderFrame.Parent = LoaderFrame
MainLoaderFrame.BackgroundColor3 = _G.Dark
MainLoaderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainLoaderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainLoaderFrame.Size = UDim2.new(0, 380, 0, 220)
CreateRounded(MainLoaderFrame, 16)
CreateStroke(MainLoaderFrame, _G.Third, 1.5, 0.3)

local TitleLoader = Instance.new("TextLabel")
TitleLoader.Parent = MainLoaderFrame
TitleLoader.Text = "TckHub"
TitleLoader.Font = Enum.Font.FredokaOne
TitleLoader.TextSize = 42
TitleLoader.TextColor3 = TextWhite
TitleLoader.BackgroundTransparency = 1
TitleLoader.Position = UDim2.new(0, 0, 0.2, 0)
TitleLoader.Size = UDim2.new(1, 0, 0, 50)

local DescriptionLoader = Instance.new("TextLabel")
DescriptionLoader.Parent = MainLoaderFrame
DescriptionLoader.Text = "Verifying Environment.."
DescriptionLoader.Font = Enum.Font.GothamMedium
DescriptionLoader.TextSize = 13
DescriptionLoader.TextColor3 = TextMuted
DescriptionLoader.BackgroundTransparency = 1
DescriptionLoader.Position = UDim2.new(0, 0, 0.48, 0)
DescriptionLoader.Size = UDim2.new(1, 0, 0, 25)

local LoadingBarBackground = Instance.new("Frame")
LoadingBarBackground.Parent = MainLoaderFrame
LoadingBarBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
LoadingBarBackground.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingBarBackground.Position = UDim2.new(0.5, 0, 0.7, 0)
LoadingBarBackground.Size = UDim2.new(0.75, 0, 0, 6)
LoadingBarBackground.ClipsDescendants = true
CreateRounded(LoadingBarBackground, 3)

local LoadingBar = Instance.new("Frame")
LoadingBar.Parent = LoadingBarBackground
LoadingBar.BackgroundColor3 = _G.Third
LoadingBar.Size = UDim2.new(0, 0, 1, 0)
CreateRounded(LoadingBar, 3)

-- Glow hiệu ứng cho thanh loading
local barGlow = Instance.new("UIStroke")
barGlow.Parent = LoadingBar
barGlow.Color = AccentGlow
barGlow.Thickness = 1.5

local dotCount = 0
local running = true

local barTween1 = TweenService:Create(LoadingBar, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = UDim2.new(0.35, 0, 1, 0)
})
local barTween2 = TweenService:Create(LoadingBar, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = UDim2.new(1, 0, 1, 0)
})

barTween1:Play()

function Update:Loaded()
	barTween2:Play()
end

barTween1.Completed:Connect(function()
	running = true
	barTween2.Completed:Connect(function()
		task.wait(0.5)
		running = false
		DescriptionLoader.Text = "Execution Ready!"
		task.wait(0.4)
		-- Hiệu ứng đóng nhẹ nhàng
		TweenService:Create(LoaderFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1
		}):Play()
		TweenService:Create(MainLoaderFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1
		}):Play()
		task.delay(0.3, function()
			Loader:Destroy()
		end)
	end)
end)

task.spawn(function()
	while running do
		dotCount = (dotCount + 1) % 4
		local dots = string.rep(".", dotCount)
		DescriptionLoader.Text = "Please wait" .. dots
		task.wait(0.4)
	end
end)
end-- ==================== CẤU HÌNH CONFIGURATIONS ====================local SettingsLib = {SaveSettings = true,LoadAnimation = true};(getgenv()).LoadConfig = function()if readfile and writefile and isfile and isfolder thenif not isfolder("TckHub") thenmakefolder("TckHub")endif not isfolder("TckHub/Library/") thenmakefolder("TckHub/Library/")endlocal path = "TckHub/Library/" .. game.Players.LocalPlayer.Name .. ".json"if not isfile(path) thenwritefile(path, (game:GetService("HttpService")):JSONEncode(SettingsLib))elselocal success, Decode = pcall(function()return (game:GetService("HttpService")):JSONDecode(readfile(path))end)if success and type(Decode) == "table" thenfor i, v in pairs(Decode) doSettingsLib[i] = vendendendprint("[TckHub] Config loaded successfully.")elsereturn warn("[TckHub] Executor không hỗ trợ đọc/ghi file.")endend;(getgenv()).SaveConfig = function()if readfile and writefile and isfile and isfolder thenlocal path = "TckHub/Library/" .. game.Players.LocalPlayer.Name .. ".json"if not isfile(path) then(getgenv()).LoadConfig()elselocal Array = {}for i, v in pairs(SettingsLib) doArray[i] = vendwritefile(path, (game:GetService("HttpService")):JSONEncode(Array))endelsereturn warn("[TckHub] Executor không hỗ trợ lưu cấu hình.")endend;(getgenv()).LoadConfig()function Update:SaveSettings()return SettingsLib.SaveSettingsendfunction Update:LoadAnimation()return SettingsLib.LoadAnimationend-- ==================== CỬA SỔ CHÍNH (MAIN WINDOW) ====================function Update:Window(Config)assert(Config.SubTitle, "Yêu cầu SubTitle!")local WindowConfig = {
	Size = Config.Size or UDim2.new(0, 560, 0, 360),
	TabWidth = Config.TabWidth or 140
}

local currentpage = ""
local abc = false

local TckHub = Instance.new("ScreenGui")
TckHub.Name = "TckHub"
TckHub.Parent = game.CoreGui
TckHub.DisplayOrder = 999

local OutlineMain = Instance.new("Frame")
OutlineMain.Name = "OutlineMain"
OutlineMain.Parent = TckHub
OutlineMain.ClipsDescendants = true
OutlineMain.AnchorPoint = Vector2.new(0.5, 0.5)
OutlineMain.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
OutlineMain.BackgroundTransparency = 0.2
OutlineMain.Position = UDim2.new(0.5, 0, 0.45, 0)
OutlineMain.Size = UDim2.new(0, 0, 0, 0)
CreateRounded(OutlineMain, 16)
local windowStroke = CreateStroke(OutlineMain, _G.Third, 1.5, 0.2)

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = OutlineMain
Main.ClipsDescendants = true
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = _G.Dark
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = WindowConfig.Size
CreateRounded(Main, 14)

-- Trượt mở màn hình chính cực đẹp
OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 12, 0, WindowConfig.Size.Y.Offset + 12), "Out", "Back", 0.45, true)

-- Kéo dãn kích thước góc (Resize Button)
local DragButton = Instance.new("Frame")
DragButton.Name = "DragButton"
DragButton.Parent = Main
DragButton.Position = UDim2.new(1, -2, 1, -2)
DragButton.AnchorPoint = Vector2.new(1, 1)
DragButton.Size = UDim2.new(0, 14, 0, 14)
DragButton.BackgroundColor3 = _G.Third
DragButton.BackgroundTransparency = 0.6
DragButton.ZIndex = 11
CreateRounded(DragButton, 99)

local Top = Instance.new("Frame")
Top.Name = "Top"
Top.Parent = Main
Top.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Top.Size = UDim2.new(1, 0, 0, 44)
Top.BackgroundTransparency = 0.5
CreateRounded(Top, 5)

local NameHub = Instance.new("TextLabel")
NameHub.Name = "NameHub"
NameHub.Parent = Top
NameHub.BackgroundTransparency = 1
NameHub.RichText = true
NameHub.Position = UDim2.new(0, 15, 0.5, 0)
NameHub.AnchorPoint = Vector2.new(0, 0.5)
NameHub.Font = Enum.Font.GothamBold
NameHub.Text = "TckHub"
NameHub.TextSize = 21
NameHub.TextColor3 = TextWhite
NameHub.TextXAlignment = Enum.TextXAlignment.Left
local nameHubSize = (game:GetService("TextService")):GetTextSize(NameHub.Text, NameHub.TextSize, NameHub.Font, Vector2.new(math.huge, math.huge))
NameHub.Size = UDim2.new(0, nameHubSize.X, 0, 25)

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Parent = NameHub
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, nameHubSize.X + 8, 0.5, 0)
SubTitle.Font = Enum.Font.GothamSemibold
SubTitle.AnchorPoint = Vector2.new(0, 0.5)
SubTitle.Text = Config.SubTitle
SubTitle.TextSize = 13
SubTitle.TextColor3 = _G.Third
local SubTitleSize = (game:GetService("TextService")):GetTextSize(SubTitle.Text, SubTitle.TextSize, SubTitle.Font, Vector2.new(math.huge, math.huge))
SubTitle.Size = UDim2.new(0, SubTitleSize.X, 0, 25)

-- Nút điều hướng góc phải
local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = Top
CloseButton.BackgroundTransparency = 1
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.Position = UDim2.new(1, -15, 0.5, 0)
CloseButton.Size = UDim2.new(0, 22, 0, 22)
CloseButton.Image = "rbxassetid://7743878857"
CloseButton.ImageColor3 = TextWhite
CreateRounded(CloseButton, 4)

CloseButton.MouseEnter:Connect(function()
	TweenService:Create(CloseButton, TweenInfo.new(0.2), {ImageColor3 = _G.Third}):Play()
end)
CloseButton.MouseLeave:Connect(function()
	TweenService:Create(CloseButton, TweenInfo.new(0.2), {ImageColor3 = TextWhite}):Play()
end)
CloseButton.MouseButton1Click:Connect(function()
	TckHub.Enabled = false
end)

local ResizeButton = Instance.new("ImageButton")
ResizeButton.Name = "ResizeButton"
ResizeButton.Parent = Top
ResizeButton.BackgroundTransparency = 1
ResizeButton.AnchorPoint = Vector2.new(1, 0.5)
ResizeButton.Position = UDim2.new(1, -50, 0.5, 0)
ResizeButton.Size = UDim2.new(0, 20, 0, 20)
ResizeButton.Image = "rbxassetid://10734886735"
ResizeButton.ImageColor3 = TextMuted
CreateRounded(ResizeButton, 4)

local SettingsButton = Instance.new("ImageButton")
SettingsButton.Name = "SettingsButton"
SettingsButton.Parent = Top
SettingsButton.BackgroundTransparency = 1
SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
SettingsButton.Position = UDim2.new(1, -85, 0.5, 0)
SettingsButton.Size = UDim2.new(0, 20, 0, 20)
SettingsButton.Image = "rbxassetid://10734950020"
SettingsButton.ImageColor3 = TextMuted
CreateRounded(SettingsButton, 4)

-- ==================== PHẦN MENU CÀI ĐẶT (SETTINGS OVERLAY) ====================
local BackgroundSettings = Instance.new("Frame")
BackgroundSettings.Name = "BackgroundSettings"
BackgroundSettings.Parent = OutlineMain
BackgroundSettings.ClipsDescendants = true
BackgroundSettings.Active = true
BackgroundSettings.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
BackgroundSettings.BackgroundTransparency = 0.3
BackgroundSettings.Size = UDim2.new(1, 0, 1, 0)
BackgroundSettings.Visible = false
CreateRounded(BackgroundSettings, 15)

local SettingsFrame = Instance.new("Frame")
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Parent = BackgroundSettings
SettingsFrame.ClipsDescendants = true
SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsFrame.BackgroundColor3 = _G.Dark
SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
SettingsFrame.Size = UDim2.new(0.75, 0, 0.75, 0)
SettingsFrame.ClipsDescendants = true
CreateRounded(SettingsFrame, 14)
CreateStroke(SettingsFrame, _G.Third, 1.2, 0.2)

local CloseSettings = Instance.new("ImageButton")
CloseSettings.Name = "CloseSettings"
CloseSettings.Parent = SettingsFrame
CloseSettings.BackgroundTransparency = 1
CloseSettings.AnchorPoint = Vector2.new(1, 0)
CloseSettings.Position = UDim2.new(1, -15, 0, 15)
CloseSettings.Size = UDim2.new(0, 22, 0, 22)
CloseSettings.Image = "rbxassetid://10747384394"
CloseSettings.ImageColor3 = TextWhite
CreateRounded(CloseSettings, 4)

CloseSettings.MouseButton1Click:Connect(function()
	BackgroundSettings.Visible = false
end)

local TitleSettings = Instance.new("TextLabel")
TitleSettings.Name = "TitleSettings"
TitleSettings.Parent = SettingsFrame
TitleSettings.BackgroundTransparency = 1
TitleSettings.Position = UDim2.new(0, 20, 0, 15)
TitleSettings.Size = UDim2.new(0.6, 0, 0, 25)
TitleSettings.Font = Enum.Font.GothamBold
TitleSettings.Text = "Settings Hub"
TitleSettings.TextSize = 18
TitleSettings.TextColor3 = TextWhite
TitleSettings.TextXAlignment = Enum.TextXAlignment.Left

local SettingsMenuList = Instance.new("Frame")
SettingsMenuList.Name = "SettingsMenuList"
SettingsMenuList.Parent = SettingsFrame
SettingsMenuList.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
SettingsMenuList.Position = UDim2.new(0, 15, 0, 50)
SettingsMenuList.Size = UDim2.new(1, -30, 1, -65)
CreateRounded(SettingsMenuList, 10)
CreateStroke(SettingsMenuList, Color3.fromRGB(35, 35, 40), 1)

local ScrollSettings = Instance.new("ScrollingFrame")
ScrollSettings.Name = "ScrollSettings"
ScrollSettings.Parent = SettingsMenuList
ScrollSettings.Active = true
ScrollSettings.BackgroundTransparency = 1
ScrollSettings.Size = UDim2.new(1, 0, 1, 0)
ScrollSettings.ScrollBarThickness = 2
ScrollSettings.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollSettings.ScrollBarImageColor3 = _G.Third

local SettingsListLayout = Instance.new("UIListLayout")
SettingsListLayout.Parent = ScrollSettings
SettingsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsListLayout.Padding = UDim.new(0, 10)

local PaddingScroll = Instance.new("UIPadding")
PaddingScroll.Parent = ScrollSettings
PaddingScroll.PaddingTop = UDim.new(0, 10)
PaddingScroll.PaddingBottom = UDim.new(0, 10)
PaddingScroll.PaddingLeft = UDim.new(0, 15)
PaddingScroll.PaddingRight = UDim.new(0, 15)

SettingsButton.MouseButton1Click:Connect(function()
	BackgroundSettings.Visible = true
end)

-- ==================== CÁC PHẦN TỬ TRONG SETTINGS MENU ====================
function CreateCheckbox(title, state, callback)
	local checked = state or false
	local Background = Instance.new("Frame")
	Background.Name = "CheckboxRow"
	Background.Parent = ScrollSettings
	Background.BackgroundTransparency = 1
	Background.Size = UDim2.new(1, 0, 0, 30)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Parent = Background
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 40, 0.5, 0)
	TitleLabel.Size = UDim2.new(1, -50, 0, 20)
	TitleLabel.Font = Enum.Font.GothamSemibold
	TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
	TitleLabel.Text = title or ""
	TitleLabel.TextSize = 13
	TitleLabel.TextColor3 = TextWhite
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	local Checkbox = Instance.new("ImageButton")
	Checkbox.Name = "Checkbox"
	Checkbox.Parent = Background
	Checkbox.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	Checkbox.AnchorPoint = Vector2.new(0, 0.5)
	Checkbox.Position = UDim2.new(0, 5, 0.5, 0)
	Checkbox.Size = UDim2.new(0, 22, 0, 22)
	Checkbox.Image = "rbxassetid://10709790644"
	CreateRounded(Checkbox, 6)
	local checkStroke = CreateStroke(Checkbox, Color3.fromRGB(60, 60, 65), 1)

	local function updateState()
		if checked then
			TweenService:Create(Checkbox, TweenInfo.new(0.2), {BackgroundColor3 = _G.Third}):Play()
			TweenService:Create(checkStroke, TweenInfo.new(0.2), {Color = AccentGlow}):Play()
			Checkbox.ImageTransparency = 0
		else
			TweenService:Create(Checkbox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
			TweenService:Create(checkStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 65)}):Play()
			Checkbox.ImageTransparency = 1
		end
	end

	Checkbox.MouseButton1Click:Connect(function()
		checked = not checked
		updateState()
		pcall(callback, checked)
	end)

	updateState()
end

function CreateButton(title, callback)
	local Background = Instance.new("Frame")
	Background.Parent = ScrollSettings
	Background.BackgroundTransparency = 1
	Background.Size = UDim2.new(1, 0, 0, 35)

	local Button = Instance.new("TextButton")
	Button.Parent = Background
	Button.BackgroundColor3 = _G.Third
	Button.Size = UDim2.new(0.9, 0, 0, 32)
	Button.Font = Enum.Font.GothamBold
	Button.Text = title or "Button"
	Button.AnchorPoint = Vector2.new(0.5, 0)
	Button.Position = UDim2.new(0.5, 0, 0, 0)
	Button.TextColor3 = TextWhite
	Button.TextSize = 13
	Button.AutoButtonColor = false
	CreateRounded(Button, 6)
	local btnStr = CreateStroke(Button, AccentGlow, 1)

	Button.MouseEnter:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = AccentGlow}):Play()
	end)
	Button.MouseLeave:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = _G.Third}):Play()
	end)

	Button.MouseButton1Click:Connect(function()
		-- Nảy nhẹ khi bấm nút
		Button:TweenSize(UDim2.new(0.85, 0, 0, 28), "Out", "Quad", 0.1, true, function()
			Button:TweenSize(UDim2.new(0.9, 0, 0, 32), "Out", "Quad", 0.1, true)
		end)
		pcall(callback)
	end)
end

CreateCheckbox("Save Settings", SettingsLib.SaveSettings, function(state)
	SettingsLib.SaveSettings = state
	(getgenv()).SaveConfig()
end)
CreateCheckbox("Loading Animation", SettingsLib.LoadAnimation, function(state)
	SettingsLib.LoadAnimation = state
	(getgenv()).SaveConfig()
end)
CreateButton("Reset Config", function()
	if isfolder("TckHub") then
		delfolder("TckHub")
	end
	Update:Notify("Config đã được làm sạch!")
end)

-- ==================== CẤU TRÚC PHÂN CHIA TABS ====================
local Tab = Instance.new("Frame")
Tab.Name = "Tab"
Tab.Parent = Main
Tab.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
Tab.Position = UDim2.new(0, 8, 0, Top.Size.Y.Offset + 4)
Tab.BackgroundTransparency = 0.4
Tab.Size = UDim2.new(0, WindowConfig.TabWidth, 1, -(Top.Size.Y.Offset + 12))
CreateRounded(Tab, 10)
CreateStroke(Tab, Color3.fromRGB(30, 30, 35), 1)

local ScrollTab = Instance.new("ScrollingFrame")
ScrollTab.Name = "ScrollTab"
ScrollTab.Parent = Tab
ScrollTab.Active = true
ScrollTab.BackgroundTransparency = 1
ScrollTab.Size = UDim2.new(1, 0, 1, 0)
ScrollTab.ScrollBarThickness = 0
ScrollTab.ScrollingDirection = Enum.ScrollingDirection.Y

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = ScrollTab
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

local PPD = Instance.new("UIPadding")
PPD.Parent = ScrollTab
PPD.PaddingTop = UDim.new(0, 8)
PPD.PaddingLeft = UDim.new(0, 6)
PPD.PaddingRight = UDim.new(0, 6)

local Page = Instance.new("Frame")
Page.Name = "Page"
Page.Parent = Main
Page.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
Page.Position = UDim2.new(0, Tab.Size.X.Offset + 16, 0, Top.Size.Y.Offset + 4)
Page.Size = UDim2.new(1, -(Tab.Size.X.Offset + 24), 1, -(Top.Size.Y.Offset + 12))
CreateRounded(Page, 10)
CreateStroke(Page, Color3.fromRGB(30, 30, 35), 1)

local MainPage = Instance.new("Frame")
MainPage.Name = "MainPage"
MainPage.Parent = Page
MainPage.ClipsDescendants = true
MainPage.BackgroundTransparency = 1
MainPage.Size = UDim2.new(1, 0, 1, 0)

local PageList = Instance.new("Folder")
PageList.Name = "PageList"
PageList.Parent = MainPage

local UIPageLayout = Instance.new("UIPageLayout")
UIPageLayout.Parent = PageList
UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIPageLayout.EasingDirection = Enum.EasingDirection.Out
UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
UIPageLayout.FillDirection = Enum.FillDirection.Vertical
UIPageLayout.TweenTime = 0.25
UIPageLayout.GamepadInputEnabled = false
UIPageLayout.ScrollWheelInputEnabled = false
UIPageLayout.TouchInputEnabled = false

MakeDraggable(Top, OutlineMain)

-- Trình nghe phím tắt Insert ẩn/hiện menu chính nhanh
UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Insert then
		TckHub.Enabled = not TckHub.Enabled
	end
end)

local Dragging = false
DragButton.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		Dragging = true
	end
end)
UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		Dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(Input)
	if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
		local newX = math.clamp(Input.Position.X - Main.AbsolutePosition.X, 450, 1000)
		local newY = math.clamp(Input.Position.Y - Main.AbsolutePosition.Y, 280, 700)
		
		OutlineMain.Size = UDim2.new(0, newX + 12, 0, newY + 12)
		Main.Size = UDim2.new(0, newX, 0, newY)
		Page.Size = UDim2.new(1, -(Tab.Size.X.Offset + 24), 1, -(Top.Size.Y.Offset + 12))
		Tab.Size = UDim2.new(0, WindowConfig.TabWidth, 1, -(Top.Size.Y.Offset + 12))
	end
end)

local uitab = {}

-- ==================== TẠO TAB NÚT BẤM VÀ TRANG CHỨA CHỨC NĂNG ====================
function uitab:Tab(text, img)
	local TabButton = Instance.new("TextButton")
	TabButton.Parent = ScrollTab
	TabButton.Name = text .. "Unique"
	TabButton.Text = ""
	TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	TabButton.BackgroundTransparency = 1
	TabButton.Size = UDim2.new(1, 0, 0, 38)
	CreateRounded(TabButton, 8)

	local SelectedTab = Instance.new("Frame")
	SelectedTab.Name = "SelectedTab"
	SelectedTab.Parent = TabButton
	SelectedTab.BackgroundColor3 = _G.Third
	SelectedTab.Size = UDim2.new(0, 3, 0, 0)
	SelectedTab.Position = UDim2.new(0, 0, 0.5, 0)
	SelectedTab.AnchorPoint = Vector2.new(0, 0.5)
	CreateRounded(SelectedTab, 99)

	local Title = Instance.new("TextLabel")
	Title.Parent = TabButton
	Title.Name = "Title"
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0, 32, 0.5, 0)
	Title.Size = UDim2.new(1, -38, 0, 20)
	Title.Font = Enum.Font.GothamBold
	Title.Text = text
	Title.AnchorPoint = Vector2.new(0, 0.5)
	Title.TextColor3 = TextWhite
	Title.TextTransparency = 0.4
	Title.TextSize = 13
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local IDK = Instance.new("ImageLabel")
	IDK.Name = "IDK"
	IDK.Parent = TabButton
	IDK.BackgroundTransparency = 1
	IDK.ImageTransparency = 0.4
	IDK.Position = UDim2.new(0, 8, 0.5, 0)
	IDK.Size = UDim2.new(0, 16, 0, 16)
	IDK.AnchorPoint = Vector2.new(0, 0.5)
	IDK.Image = img or "rbxassetid://10709790948"
	IDK.ImageColor3 = TextWhite

	local MainFramePage = Instance.new("ScrollingFrame")
	MainFramePage.Name = text .. "_Page"
	MainFramePage.Parent = PageList
	MainFramePage.Active = true
	MainFramePage.BackgroundTransparency = 1
	MainFramePage.Size = UDim2.new(1, 0, 1, 0)
	MainFramePage.ScrollBarThickness = 2
	MainFramePage.ScrollingDirection = Enum.ScrollingDirection.Y
	MainFramePage.ScrollBarImageColor3 = _G.Third

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = MainFramePage
	UIPadding.PaddingTop = UDim.new(0, 10)
	UIPadding.PaddingBottom = UDim.new(0, 10)
	UIPadding.PaddingLeft = UDim.new(0, 12)
	UIPadding.PaddingRight = UDim.new(0, 12)

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = MainFramePage
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 6)

	-- Hiệu ứng kích hoạt Tab
	local function selectThisTab()
		for _, v in next, ScrollTab:GetChildren() do
			if v:IsA("TextButton") then
				TweenService:Create(v, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
				TweenService:Create(v.SelectedTab, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
				TweenService:Create(v.IDK, TweenInfo.new(0.25), {ImageTransparency = 0.4, ImageColor3 = TextWhite}):Play()
				TweenService:Create(v.Title, TweenInfo.new(0.25), {TextTransparency = 0.4}):Play()
			end
		end
		TweenService:Create(TabButton, TweenInfo.new(0.25), {BackgroundTransparency = 0.8, BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
		TweenService:Create(SelectedTab, TweenInfo.new(0.25), {Size = UDim2.new(0, 3, 0, 16)}):Play()
		TweenService:Create(IDK, TweenInfo.new(0.25), {ImageTransparency = 0, ImageColor3 = _G.Third}):Play()
		TweenService:Create(Title, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
	end

	TabButton.MouseButton1Click:Connect(function()
		selectThisTab()
		currentpage = text .. "_Page"
		local targetPage = PageList:FindFirstChild(currentpage)
		if targetPage then
			UIPageLayout:JumpTo(targetPage)
		end
	end)

	-- Thiết lập Tab mặc định đầu tiên
	if abc == false then
		task.spawn(function()
			task.wait(0.1)
			selectThisTab()
			UIPageLayout:JumpToIndex(1)
		end)
		abc = true
	end

	-- Tự động cập nhật kích thước Canvas bên trong ScrollingFrame
	game:GetService("RunService").Stepped:Connect(function()
		pcall(function()
			MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 25)
			ScrollTab.CanvasSize = UDim2.new(0, 0, 0, TabListLayout.AbsoluteContentSize.Y)
			ScrollSettings.CanvasSize = UDim2.new(0, 0, 0, SettingsListLayout.AbsoluteContentSize.Y)
		end)
	end)

	-- Xử lý nút Resize Screen
	local defaultSize = true
	ResizeButton.MouseButton1Click:Connect(function()
		if defaultSize then
			defaultSize = false
			OutlineMain:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", 0.25, true)
			Main:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.35, true)
			OutlineMain:TweenSize(UDim2.new(1, -15, 1, -15), "Out", "Quad", 0.35, true)
			ResizeButton.Image = "rbxassetid://10734895698"
		else
			defaultSize = true
			Main:TweenSize(WindowConfig.Size, "Out", "Quad", 0.35, true)
			OutlineMain:TweenSize(UDim2.new(0, WindowConfig.Size.X.Offset + 12, 0, WindowConfig.Size.Y.Offset + 12), "Out", "Quad", 0.35, true)
			ResizeButton.Image = "rbxassetid://10734886735"
		end
	end)

	local main = {}
	
	-- ==================== PHẦN TỬ: BUTTON ====================
	function main:Button(text, callback)
		local Button = Instance.new("Frame")
		Button.Name = "ButtonRow"
		Button.Parent = MainFramePage
		Button.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		Button.Size = UDim2.new(1, 0, 0, 42)
		CreateRounded(Button, 8)
		local rowStroke = CreateStroke(Button, Color3.fromRGB(35, 35, 40), 1)

		local TextLabel = Instance.new("TextLabel")
		TextLabel.Name = "TextLabel"
		TextLabel.Parent = Button
		TextLabel.BackgroundTransparency = 1
		TextLabel.AnchorPoint = Vector2.new(0, 0.5)
		TextLabel.Position = UDim2.new(0, 15, 0.5, 0)
		TextLabel.Size = UDim2.new(1, -65, 1, 0)
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.Text = text
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.TextColor3 = TextWhite
		TextLabel.TextSize = 13

		local TextButton = Instance.new("TextButton")
		TextButton.Name = "TextButton"
		TextButton.Parent = Button
		TextButton.BackgroundColor3 = _G.Third
		TextButton.AnchorPoint = Vector2.new(1, 0.5)
		TextButton.Position = UDim2.new(1, -8, 0.5, 0)
		TextButton.Size = UDim2.new(0, 30, 0, 30)
		TextButton.Text = ""
		CreateRounded(TextButton, 6)
		local btnStr = CreateStroke(TextButton, AccentGlow, 1)

		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.Name = "ImageLabel"
		ImageLabel.Parent = TextButton
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ImageLabel.Size = UDim2.new(0, 16, 0, 16)
		ImageLabel.Image = "rbxassetid://10734898355"
		ImageLabel.ImageColor3 = TextWhite

		-- Hover effects
		Button.MouseEnter:Connect(function()
			TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 33)}):Play()
			TweenService:Create(rowStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 55)}):Play()
			TweenService:Create(TextButton, TweenInfo.new(0.2), {BackgroundColor3 = AccentGlow}):Play()
		end)
		Button.MouseLeave:Connect(function()
			TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 26)}):Play()
			TweenService:Create(rowStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 40)}):Play()
			TweenService:Create(TextButton, TweenInfo.new(0.2), {BackgroundColor3 = _G.Third}):Play()
		end)

		TextButton.MouseButton1Click:Connect(function()
			-- Hiệu ứng bóp nhẹ nút
			TextButton:TweenSize(UDim2.new(0, 26, 0, 26), "Out", "Quad", 0.1, true, function()
				TextButton:TweenSize(UDim2.new(0, 30, 0, 30), "Out", "Quad", 0.1, true)
			end)
			pcall(callback)
		end)
	end

	-- ==================== PHẦN TỬ: TOGGLE ====================
	function main:Toggle(text, config, desc, callback)
		config = config or false
		local toggled = config

		local Button = Instance.new("Frame")
		Button.Name = "ToggleRow"
		Button.Parent = MainFramePage
		Button.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		CreateRounded(Button, 8)
		local tglStroke = CreateStroke(Button, Color3.fromRGB(35, 35, 40), 1)

		local Title2 = Instance.new("TextLabel")
		Title2.Parent = Button
		Title2.BackgroundTransparency = 1
		Title2.Font = Enum.Font.GothamBold
		Title2.Text = text
		Title2.TextColor3 = TextWhite
		Title2.TextSize = 13
		Title2.TextXAlignment = Enum.TextXAlignment.Left

		local Desc = Instance.new("TextLabel")
		Desc.Parent = Button
		Desc.BackgroundTransparency = 1
		Desc.Font = Enum.Font.GothamMedium
		Desc.TextColor3 = TextMuted
		Desc.TextSize = 10
		Desc.TextXAlignment = Enum.TextXAlignment.Left

		if desc and desc ~= "" then
			Desc.Text = desc
			Title2.Position = UDim2.new(0, 15, 0, 8)
			Title2.Size = UDim2.new(1, -70, 0, 18)
			Desc.Position = UDim2.new(0, 15, 0, 26)
			Desc.Size = UDim2.new(1, -70, 0, 14)
			Button.Size = UDim2.new(1, 0, 0, 48)
			Desc.Visible = true
		else
			Title2.Position = UDim2.new(0, 15, 0.5, 0)
			Title2.AnchorPoint = Vector2.new(0, 0.5)
			Title2.Size = UDim2.new(1, -70, 0, 20)
			Desc.Visible = false
			Button.Size = UDim2.new(1, 0, 0, 40)
		end

		local ToggleFrame = Instance.new("Frame")
		ToggleFrame.Name = "ToggleFrame"
		ToggleFrame.Parent = Button
		ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
		ToggleFrame.Position = UDim2.new(1, -12, 0.5, 0)
		ToggleFrame.Size = UDim2.new(0, 40, 0, 20)
		ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
		CreateRounded(ToggleFrame, 10)
		local frameStroke = CreateStroke(ToggleFrame, Color3.fromRGB(55, 55, 60), 1)

		local ToggleImage = Instance.new("TextButton")
		ToggleImage.Name = "ToggleImage"
		ToggleImage.Parent = ToggleFrame
		ToggleImage.BackgroundTransparency = 1
		ToggleImage.Size = UDim2.new(1, 0, 1, 0)
		ToggleImage.Text = ""

		local Circle = Instance.new("Frame")
		Circle.Name = "Circle"
		Circle.Parent = ToggleFrame
		Circle.BackgroundColor3 = TextWhite
		Circle.Position = UDim2.new(0, 2, 0.5, 0)
		Circle.Size = UDim2.new(0, 16, 0, 16)
		Circle.AnchorPoint = Vector2.new(0, 0.5)
		CreateRounded(Circle, 99)

		local function updateToggle(animate)
			local duration = animate and 0.22 or 0
			local info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			
			if toggled then
				TweenService:Create(Circle, info, {Position = UDim2.new(1, -18, 0.5, 0)}):Play()
				TweenService:Create(ToggleFrame, info, {BackgroundColor3 = _G.Third}):Play()
				TweenService:Create(frameStroke, info, {Color = AccentGlow}):Play()
			else
				TweenService:Create(Circle, info, {Position = UDim2.new(0, 2, 0.5, 0)}):Play()
				TweenService:Create(ToggleFrame, info, {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
				TweenService:Create(frameStroke, info, {Color = Color3.fromRGB(55, 55, 60)}):Play()
			end
		end

		ToggleImage.MouseButton1Click:Connect(function()
			toggled = not toggled
			updateToggle(true)
			pcall(callback, toggled)
		end)

		-- Hover Row
		Button.MouseEnter:Connect(function()
			TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 33)}):Play()
			TweenService:Create(tglStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 55)}):Play()
		end)
		Button.MouseLeave:Connect(function()
			TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 26)}):Play()
			TweenService:Create(tglStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 40)}):Play()
		end)

		updateToggle(false)
		if config == true then
			pcall(callback, toggled)
		end
	end

	-- ==================== PHẦN TỬ: DROPDOWN ====================
	function main:Dropdown(text, option, var, callback)
		local isdropping = false
		local activeItem = var and tostring(var) or ""

		local Dropdown = Instance.new("Frame")
		Dropdown.Name = "Dropdown"
		Dropdown.Parent = MainFramePage
		Dropdown.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		Dropdown.ClipsDescendants = true
		Dropdown.Size = UDim2.new(1, 0, 0, 42)
		CreateRounded(Dropdown, 8)
		local dropStroke = CreateStroke(Dropdown, Color3.fromRGB(35, 35, 40), 1)

		local DropTitle = Instance.new("TextLabel")
		DropTitle.Name = "DropTitle"
		DropTitle.Parent = Dropdown
		DropTitle.BackgroundTransparency = 1
		DropTitle.Size = UDim2.new(1, -160, 0, 42)
		DropTitle.Font = Enum.Font.GothamBold
		DropTitle.Text = text
		DropTitle.TextColor3 = TextWhite
		DropTitle.TextSize = 13
		DropTitle.TextXAlignment = Enum.TextXAlignment.Left
		DropTitle.Position = UDim2.new(0, 15, 0, 0)

		local SelectItems = Instance.new("TextButton")
		SelectItems.Name = "SelectItems"
		SelectItems.Parent = Dropdown
		SelectItems.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		SelectItems.TextColor3 = TextWhite
		SelectItems.Position = UDim2.new(1, -12, 0, 6)
		SelectItems.Size = UDim2.new(0, 120, 0, 30)
		SelectItems.AnchorPoint = Vector2.new(1, 0)
		SelectItems.Font = Enum.Font.GothamSemibold
		SelectItems.TextSize = 11
		SelectItems.AutoButtonColor = false
		SelectItems.Text = "  Select Items"
		SelectItems.TextXAlignment = Enum.TextXAlignment.Left
		CreateRounded(SelectItems, 6)
		local selStroke = CreateStroke(SelectItems, Color3.fromRGB(45, 45, 50), 1)

		local ArrowDown = Instance.new("ImageLabel")
		ArrowDown.Name = "ArrowDown"
		ArrowDown.Parent = SelectItems
		ArrowDown.BackgroundTransparency = 1
		ArrowDown.AnchorPoint = Vector2.new(1, 0.5)
		ArrowDown.Position = UDim2.new(1, -8, 0.5, 0)
		ArrowDown.Size = UDim2.new(0, 16, 0, 16)
		ArrowDown.Image = "rbxassetid://10709790948"
		ArrowDown.ImageColor3 = TextMuted

		local DropdownFrameScroll = Instance.new("Frame")
		DropdownFrameScroll.Name = "DropdownFrameScroll"
		DropdownFrameScroll.Parent = Dropdown
		DropdownFrameScroll.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
		DropdownFrameScroll.Position = UDim2.new(0, 10, 0, 46)
		DropdownFrameScroll.Size = UDim2.new(1, -20, 0, 100)
		DropdownFrameScroll.Visible = false
		CreateRounded(DropdownFrameScroll, 8)
		CreateStroke(DropdownFrameScroll, Color3.fromRGB(35, 35, 40), 1)

		local DropScroll = Instance.new("ScrollingFrame")
		DropScroll.Name = "DropScroll"
		DropScroll.Parent = DropdownFrameScroll
		DropScroll.BackgroundTransparency = 1
		DropScroll.Size = UDim2.new(1, 0, 1, -10)
		DropScroll.Position = UDim2.new(0, 0, 0, 5)
		DropScroll.ScrollBarThickness = 2
		DropScroll.ScrollBarImageColor3 = _G.Third

		local DropListLayout = Instance.new("UIListLayout")
		DropListLayout.Parent = DropScroll
		DropListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		DropListLayout.Padding = UDim.new(0, 2)

		local PaddingDrop = Instance.new("UIPadding")
		PaddingDrop.Parent = DropScroll
		PaddingDrop.PaddingLeft = UDim.new(0, 8)
		PaddingDrop.PaddingRight = UDim.new(0, 8)

		local function renderItems(itemsArray)
			-- Clear old item objects
			for _, child in pairs(DropScroll:GetChildren()) do
				if child:IsA("TextButton") then child:Destroy() end
			end

			for _, val in next, itemsArray do
				local itemStr = tostring(val)
				local Item = Instance.new("TextButton")
				Item.Name = "Item"
				Item.Parent = DropScroll
				Item.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
				Item.BackgroundTransparency = 1
				Item.Size = UDim2.new(1, 0, 0, 28)
				Item.Font = Enum.Font.GothamMedium
				Item.Text = itemStr
				Item.TextColor3 = TextWhite
				Item.TextSize = 12
				Item.TextTransparency = 0.5
				Item.TextXAlignment = Enum.TextXAlignment.Left
				CreateRounded(Item, 5)

				local itemPad = Instance.new("UIPadding")
				itemPad.Parent = Item
				itemPad.PaddingLeft = UDim.new(0, 10)

				local SelectedIndicator = Instance.new("Frame")
				SelectedIndicator.Name = "SelectedItems"
				SelectedIndicator.Parent = Item
				SelectedIndicator.BackgroundColor3 = _G.Third
				SelectedIndicator.Size = UDim2.new(0, 3, 0.5, 0)
				SelectedIndicator.Position = UDim2.new(0, -6, 0.5, 0)
				SelectedIndicator.AnchorPoint = Vector2.new(0, 0.5)
				SelectedIndicator.BackgroundTransparency = 1
				CreateRounded(SelectedIndicator, 2)

				local function markActive()
					if activeItem == itemStr then
						TweenService:Create(Item, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, TextTransparency = 0}):Play()
						TweenService:Create(SelectedIndicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
					else
						TweenService:Create(Item, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 0.5}):Play()
						TweenService:Create(SelectedIndicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
					end
				end

				Item.MouseButton1Click:Connect(function()
					activeItem = itemStr
					SelectItems.Text = "  " .. itemStr
					pcall(callback, itemStr)
					
					-- Refresh trạng thái cho tất cả nút trong dropdown
					for _, btn in pairs(DropScroll:GetChildren()) do
						if btn:IsA("TextButton") then
							local ind = btn:FindFirstChild("SelectedItems")
							if btn.Text == activeItem then
								TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.8, TextTransparency = 0}):Play()
								if ind then TweenService:Create(ind, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play() end
							else
								TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextTransparency = 0.5}):Play()
								if ind then TweenService:Create(ind, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play() end
							end
						end
					end
				end)

				-- Auto-select nếu trùng khớp 'var'
				if itemStr == activeItem then
					SelectItems.Text = "  " .. itemStr
					markActive()
				end
			end
			DropScroll.CanvasSize = UDim2.new(0, 0, 0, DropListLayout.AbsoluteContentSize.Y + 10)
		end

		renderItems(option)

		local function toggleDropdown()
			if isdropping == false then
				isdropping = true
				DropdownFrameScroll.Visible = true
				TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 110)}):Play()
				TweenService:Create(Dropdown, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 165)}):Play()
				TweenService:Create(ArrowDown, TweenInfo.new(0.25), {Rotation = 180, ImageColor3 = _G.Third}):Play()
			else
				isdropping = false
				TweenService:Create(DropdownFrameScroll, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, 0)}):Play()
				TweenService:Create(Dropdown, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 42)}):Play()
				TweenService:Create(ArrowDown, TweenInfo.new(0.25), {Rotation = 0, ImageColor3 = TextMuted}):Play()
				task.delay(0.25, function()
					if not isdropping then DropdownFrameScroll.Visible = false end
				end)
			end
		end

		SelectItems.MouseButton1Click:Connect(toggleDropdown)

		-- Row Hover
		Dropdown.MouseEnter:Connect(function()
			TweenService:Create(Dropdown, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 33)}):Play()
			TweenService:Create(dropStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 55)}):Play()
		end)
		Dropdown.MouseLeave:Connect(function()
			TweenService:Create(Dropdown, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 26)}):Play()
			TweenService:Create(dropStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 40)}):Play()
		end)

		local dropfunc = {}
		function dropfunc:Add(t)
			table.insert(option, t)
			renderItems(option)
		end
		function dropfunc:Clear()
			SelectItems.Text = "  Select Items"
			option = {}
			renderItems(option)
			if isdropping then toggleDropdown() end
		end
		return dropfunc
	end

	-- ==================== PHẦN TỬ: SLIDER ====================
	function main:Slider(text, min, max, set, callback)
		local Slider = Instance.new("Frame")
		Slider.Name = "SliderRow"
		Slider.Parent = MainFramePage
		Slider.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		Slider.Size = UDim2.new(1, 0, 0, 42)
		CreateRounded(Slider, 8)
		local sldStroke = CreateStroke(Slider, Color3.fromRGB(35, 35, 40), 1)

		local Title = Instance.new("TextLabel")
		Title.Parent = Slider
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.new(0, 15, 0.5, 0)
		Title.Size = UDim2.new(0.45, 0, 0, 30)
		Title.Font = Enum.Font.GothamBold
		Title.Text = text
		Title.AnchorPoint = Vector2.new(0, 0.5)
		Title.TextColor3 = TextWhite
		Title.TextSize = 13
		Title.TextXAlignment = Enum.TextXAlignment.Left

		-- Khung chứa thanh kéo slider
		local bar = Instance.new("Frame")
		bar.Name = "bar"
		bar.Parent = Slider
		bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		bar.Size = UDim2.new(0, 120, 0, 5)
		bar.Position = UDim2.new(1, -15, 0.5, 0)
		bar.AnchorPoint = Vector2.new(1, 0.5)
		CreateRounded(bar, 99)

		local bar1 = Instance.new("Frame")
		bar1.Name = "bar1"
		bar1.Parent = bar
		bar1.BackgroundColor3 = _G.Third
		bar1.Size = UDim2.new((set - min) / (max - min), 0, 1, 0)
		CreateRounded(bar1, 99)

		local circlebar = Instance.new("Frame")
		circlebar.Name = "circlebar"
		circlebar.Parent = bar1
		circlebar.BackgroundColor3 = TextWhite
		circlebar.Position = UDim2.new(1, 0, 0.5, 0)
		circlebar.AnchorPoint = Vector2.new(0.5, 0.5)
		circlebar.Size = UDim2.new(0, 14, 0, 14)
		CreateRounded(circlebar, 99)
		CreateStroke(circlebar, AccentGlow, 1.5)

		local ValueText = Instance.new("TextLabel")
		ValueText.Parent = Slider
		ValueText.BackgroundTransparency = 1
		ValueText.Position = UDim2.new(1, -145, 0.5, 0)
		ValueText.Size = UDim2.new(0, 40, 0, 20)
		ValueText.Font = Enum.Font.GothamBold
		ValueText.Text = tostring(set)
		ValueText.AnchorPoint = Vector2.new(1, 0.5)
		ValueText.TextColor3 = _G.Third
		ValueText.TextSize = 13
		ValueText.TextXAlignment = Enum.TextXAlignment.Right

		-- Drag Logic cho Slider
		local currentValue = set
		local isDraggingSlider = false

		local function updateSlider(inputPosition)
			local percentage = math.clamp((inputPosition.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			local rawVal = min + (max - min) * percentage
			currentValue = math.floor(rawVal)
			
			bar1.Size = UDim2.new(percentage, 0, 1, 0)
			ValueText.Text = tostring(currentValue)
			pcall(callback, currentValue)
		end

		circlebar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				isDraggingSlider = true
			end
		end)

		bar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				isDraggingSlider = true
				updateSlider(input.Position)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				isDraggingSlider = false
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				updateSlider(input.Position)
			end
		end)

		-- Row Hover
		Slider.MouseEnter:Connect(function()
			TweenService:Create(Slider, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 33)}):Play()
			TweenService:Create(sldStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 55)}):Play()
		end)
		Slider.MouseLeave:Connect(function()
			TweenService:Create(Slider, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 26)}):Play()
			TweenService:Create(sldStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 40)}):Play()
		end)

		-- Trả về giá trị mặc định lúc khởi chạy
		pcall(callback, currentValue)
	end

	-- ==================== PHẦN TỬ: TEXTBOX ====================
	function main:Textbox(text, disappear, callback)
		local Textbox = Instance.new("Frame")
		Textbox.Name = "TextboxRow"
		Textbox.Parent = MainFramePage
		Textbox.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		Textbox.Size = UDim2.new(1, 0, 0, 42)
		CreateRounded(Textbox, 8)
		local boxStroke = CreateStroke(Textbox, Color3.fromRGB(35, 35, 40), 1)

		local TextboxLabel = Instance.new("TextLabel")
		TextboxLabel.Name = "TextboxLabel"
		TextboxLabel.Parent = Textbox
		TextboxLabel.BackgroundTransparency = 1
		TextboxLabel.Position = UDim2.new(0, 15, 0.5, 0)
		TextboxLabel.Text = text
		TextboxLabel.Size = UDim2.new(1, -120, 1, 0)
		TextboxLabel.Font = Enum.Font.GothamBold
		TextboxLabel.AnchorPoint = Vector2.new(0, 0.5)
		TextboxLabel.TextColor3 = TextWhite
		TextboxLabel.TextSize = 13
		TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left

		local RealTextbox = Instance.new("TextBox")
		RealTextbox.Name = "RealTextbox"
		RealTextbox.Parent = Textbox
		RealTextbox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
		RealTextbox.Position = UDim2.new(1, -12, 0.5, 0)
		RealTextbox.AnchorPoint = Vector2.new(1, 0.5)
		RealTextbox.Size = UDim2.new(0, 100, 0, 28)
		RealTextbox.Font = Enum.Font.GothamSemibold
		RealTextbox.Text = ""
		RealTextbox.TextColor3 = TextWhite
		RealTextbox.TextSize = 12
		RealTextbox.PlaceholderText = "Type here..."
		RealTextbox.PlaceholderColor3 = TextMuted
		CreateRounded(RealTextbox, 6)
		local inputStroke = CreateStroke(RealTextbox, Color3.fromRGB(45, 45, 50), 1)

		-- Tập trung nhập liệu đổi viền thành đỏ neon
		RealTextbox.Focused:Connect(function()
			TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = _G.Third}):Play()
		end)
		RealTextbox.FocusLost:Connect(function(enterPressed)
			TweenService:Create(inputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 50)}):Play()
			pcall(callback, RealTextbox.Text)
			if disappear then
				RealTextbox.Text = ""
			end
		end)

		-- Row Hover
		Textbox.MouseEnter:Connect(function()
			TweenService:Create(Textbox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 33)}):Play()
			TweenService:Create(boxStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(50, 50, 55)}):Play()
		end)
		Textbox.MouseLeave:Connect(function()
			TweenService:Create(Textbox, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 26)}):Play()
			TweenService:Create(boxStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 40)}):Play()
		end)
	end

	-- ==================== PHẦN TỬ: LABEL ====================
	function main:Label(text)
		local Frame = Instance.new("Frame")
		Frame.Name = "LabelRow"
		Frame.Parent = MainFramePage
		Frame.BackgroundTransparency = 1
		Frame.Size = UDim2.new(1, 0, 0, 30)

		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.Name = "ImageLabel"
		ImageLabel.Parent = Frame
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Position = UDim2.new(0, 10, 0.5, 0)
		ImageLabel.Size = UDim2.new(0, 16, 0, 16)
		ImageLabel.AnchorPoint = Vector2.new(0, 0.5)
		ImageLabel.Image = "rbxassetid://10723415903"
		ImageLabel.ImageColor3 = _G.Third

		local Label = Instance.new("TextLabel")
		Label.Name = "Label"
		Label.Parent = Frame
		Label.BackgroundTransparency = 1
		Label.Size = UDim2.new(1, -40, 1, 0)
		Label.Font = Enum.Font.GothamBold
		Label.Position = UDim2.new(0, 35, 0.5, 0)
		Label.AnchorPoint = Vector2.new(0, 0.5)
		Label.TextColor3 = TextWhite
		Label.TextSize = 13
		Label.Text = text
		Label.TextXAlignment = Enum.TextXAlignment.Left

		local labelfunc = {}
		function labelfunc:Set(newtext)
			Label.Text = newtext
		end
		return labelfunc
	end

	-- ==================== PHẦN TỬ: SEPARATOR ====================
	function main:Seperator(text)
		local Seperator = Instance.new("Frame")
		Seperator.Name = "Seperator"
		Seperator.Parent = MainFramePage
		Seperator.BackgroundTransparency = 1
		Seperator.Size = UDim2.new(1, 0, 0, 36)

		local Sep2 = Instance.new("TextLabel")
		Sep2.Name = "Sep2"
		Sep2.Parent = Seperator
		Sep2.BackgroundTransparency = 1
		Sep2.AnchorPoint = Vector2.new(0.5, 0.5)
		Sep2.Position = UDim2.new(0.5, 0, 0.5, 0)
		Sep2.Size = UDim2.new(1, 0, 1, 0)
		Sep2.Font = Enum.Font.GothamBold
		Sep2.Text = "──  " .. text .. "  ──"
		Sep2.TextColor3 = _G.Third
		Sep2.TextSize = 13
	end

	-- ==================== PHẦN TỬ: LINE ====================
	function main:Line()
		local Linee = Instance.new("Frame")
		Linee.Name = "LineContainer"
		Linee.Parent = MainFramePage
		Linee.BackgroundTransparency = 1
		Linee.Size = UDim2.new(1, 0, 0, 15)

		local Line = Instance.new("Frame")
		Line.Name = "Line"
		Line.Parent = Linee
		Line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, 0, 0.5, 0)
		Line.Size = UDim2.new(1, 0, 0, 1)

		local UIGradient = Instance.new("UIGradient")
		UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, _G.Dark),
			ColorSequenceKeypoint.new(0.15, Color3.fromRGB(50, 50, 55)),
			ColorSequenceKeypoint.new(0.5, _G.Third),
			ColorSequenceKeypoint.new(0.85, Color3.fromRGB(50, 50, 55)),
			-- Gần về cuối mờ nhạt dần
			ColorSequenceKeypoint.new(1, _G.Dark)
		})
		UIGradient.Parent = Line
	end

	return main
end
return uitab
endreturn Update
