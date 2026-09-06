-- // Title: JOPAPU Menu Preview | By JOPAPU
-- // Credits: By JOPAPU
-- // Roblox Studio UI controller. Controls are connected to the JOPAPU modules.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Controller = getgenv().JopapuController or {}

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("JopapuMenuPreview")
if oldGui then
    oldGui:Destroy()
end

local colors = {
    background = Color3.fromRGB(13, 16, 19),
    sidebar = Color3.fromRGB(17, 20, 23),
    panel = Color3.fromRGB(22, 25, 29),
    panelLight = Color3.fromRGB(28, 32, 37),
    line = Color3.fromRGB(43, 48, 54),
    text = Color3.fromRGB(226, 230, 234),
    muted = Color3.fromRGB(132, 140, 149),
    accent = Color3.fromRGB(239, 242, 245),
    accentText = Color3.fromRGB(19, 22, 25),
    green = Color3.fromRGB(116, 207, 157),
}

local gui = Instance.new("ScreenGui")
gui.Name = "JopapuMenuPreview"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function addCorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
end

local function addStroke(object, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency or 0
    stroke.Thickness = 1
    stroke.Parent = object
end

local function makeLabel(parent, text, size, color, font)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or colors.text
    label.TextSize = size or 13
    label.Font = font or Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(820, 500)
main.BackgroundColor3 = colors.background
main.Parent = gui
addCorner(main, 8)
addStroke(main, colors.line, 0.15)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.fromOffset(176, 500)
sidebar.BackgroundColor3 = colors.sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = main
addCorner(sidebar, 8)

local sidebarCover = Instance.new("Frame")
sidebarCover.Size = UDim2.new(0, 12, 1, 0)
sidebarCover.Position = UDim2.new(1, -12, 0, 0)
sidebarCover.BackgroundColor3 = colors.sidebar
sidebarCover.BorderSizePixel = 0
sidebarCover.Parent = sidebar

local brand = makeLabel(sidebar, "JOPAPU | By JOPAPU", 17, colors.text, Enum.Font.GothamBold)
brand.Position = UDim2.fromOffset(22, 22)
brand.Size = UDim2.fromOffset(130, 24)

local subtitle = makeLabel(sidebar, "clean control panel", 10, colors.muted)
subtitle.Position = UDim2.fromOffset(23, 47)
subtitle.Size = UDim2.fromOffset(130, 18)

local credit = makeLabel(sidebar, "By JOPAPU", 10, colors.muted)
credit.Position = UDim2.fromOffset(23, 458)
credit.Size = UDim2.fromOffset(130, 18)

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(176, 0)
content.Size = UDim2.new(1, -176, 1, 0)
content.BackgroundTransparency = 1
content.Parent = main

local tabBar = Instance.new("Frame")
tabBar.Position = UDim2.fromOffset(20, 14)
tabBar.Size = UDim2.new(1, -40, 0, 36)
tabBar.BackgroundTransparency = 1
tabBar.Parent = content

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabBar

local body = Instance.new("Frame")
body.Position = UDim2.fromOffset(20, 62)
body.Size = UDim2.new(1, -40, 1, -82)
body.BackgroundTransparency = 1
body.Parent = content

local pages = {}
local tabButtons = {}

local function setTab(tabName)
    for name, page in pairs(pages) do
        page.Visible = name == tabName
    end
    for name, button in pairs(tabButtons) do
        button.BackgroundColor3 = name == tabName and colors.accent or colors.panel
        button.TextColor3 = name == tabName and colors.accentText or colors.muted
    end
end

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = colors.line
    page.CanvasSize = UDim2.new()
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = body

    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(0.5, -7, 0, 152)
    grid.CellPadding = UDim2.fromOffset(14, 14)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = page

    pages[name] = page
    return page
end

local function createSection(parent, title, description)
    local section = Instance.new("Frame")
    section.BackgroundColor3 = colors.panel
    section.BorderSizePixel = 0
    section.Parent = parent
    addCorner(section, 6)
    addStroke(section, colors.line, 0.35)

    local heading = makeLabel(section, title, 13, colors.text, Enum.Font.GothamBold)
    heading.Position = UDim2.fromOffset(14, 12)
    heading.Size = UDim2.new(1, -28, 0, 20)

    local detail = makeLabel(section, description, 10, colors.muted)
    detail.Position = UDim2.fromOffset(14, 34)
    detail.Size = UDim2.new(1, -28, 0, 17)

    return section
end

local function createToggle(parent, text, defaultValue, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -28, 0, 29)
    row.Position = UDim2.fromOffset(14, 58 + (#parent:GetChildren() - 3) * 29)
    row.BackgroundTransparency = 1
    row.Parent = parent

    local label = makeLabel(row, text, 11, colors.text)
    label.Size = UDim2.new(1, -48, 1, 0)

    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(34, 18)
    button.Position = UDim2.new(1, -34, 0.5, -9)
    button.Text = ""
    button.AutoButtonColor = false
    button.BackgroundColor3 = defaultValue and colors.green or colors.panelLight
    button.Parent = row
    addCorner(button, 9)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = defaultValue and UDim2.new(1, -16, 0.5, -7) or UDim2.fromOffset(2, 2)
    knob.BackgroundColor3 = colors.text
    knob.Parent = button
    addCorner(knob, 7)

    local enabled = defaultValue
    button.Activated:Connect(function()
        enabled = not enabled
        button.BackgroundColor3 = enabled and colors.green or colors.panelLight
        knob.Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.fromOffset(2, 2)
        if callback then
            callback(enabled)
        end
    end)
end

local function createButton(parent, text)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -28, 0, 27)
    button.Position = UDim2.fromOffset(14, 58 + (#parent:GetChildren() - 3) * 29)
    button.Text = text
    button.TextSize = 11
    button.Font = Enum.Font.GothamMedium
    button.TextColor3 = colors.text
    button.BackgroundColor3 = colors.panelLight
    button.AutoButtonColor = true
    button.Parent = parent
    addCorner(button, 4)
end

local tabs = {
    {"Home | By JOPAPU", "Overview"},
    {"Combat | By JOPAPU", "Combat"},
    {"Visuals | By JOPAPU", "Visuals"},
    {"Auto Farm | By JOPAPU", "Auto Farm"},
    {"Objects | By JOPAPU", "Objects"},
    {"Settings | By JOPAPU", "Settings"},
}

for _, tab in ipairs(tabs) do
    local button = Instance.new("TextButton")
    button.Name = tab[1]
    button.Size = UDim2.fromOffset(88, 30)
    button.Text = tab[1]
    button.TextSize = 10
    button.Font = Enum.Font.GothamMedium
    button.BackgroundColor3 = colors.panel
    button.TextColor3 = colors.muted
    button.AutoButtonColor = false
    button.Parent = tabBar
    addCorner(button, 4)
    tabButtons[tab[1]] = button

    button.Activated:Connect(function()
        setTab(tab[2])
    end)
end

local home = createPage("Overview")
local homeSection = createSection(home, "Welcome | By JOPAPU", "Menu status | By JOPAPU")
createButton(homeSection, "Menu loaded successfully | By JOPAPU")
createButton(homeSection, "All controls are connected | By JOPAPU")

local combat = createPage("Combat")
local combatSection = createSection(combat, "Combat | By JOPAPU", "Combat controls | By JOPAPU")
createToggle(combatSection, "Aim assist | By JOPAPU", false, function(state)
    if Controller.SetAimAssist then Controller.SetAimAssist(state) end
end)
createToggle(combatSection, "Target highlight | By JOPAPU", false, function(state)
    if Controller.SetTargetHighlight then Controller.SetTargetHighlight(state) end
end)

local visuals = createPage("Visuals")
local visualsSection = createSection(visuals, "Visuals | By JOPAPU", "Presentation controls | By JOPAPU")
createToggle(visualsSection, "Aim lines | By JOPAPU", false, function(state)
    if Controller.SetAimLines then Controller.SetAimLines(state) end
end)
createToggle(visualsSection, "Player markers | By JOPAPU", false, function(state)
    if Controller.SetPlayerMarkers then Controller.SetPlayerMarkers(state) end
end)

local farm = createPage("Auto Farm")
local farmSection = createSection(farm, "Auto Farm | By JOPAPU", "Collection controls | By JOPAPU")
createToggle(farmSection, "Collect money | By JOPAPU", false, function(state)
    if Controller.SetCollectMoney then Controller.SetCollectMoney(state, true, false) end
end)
createToggle(farmSection, "Collect shoes | By JOPAPU", false, function(state)
    if Controller.SetCollectShoes then Controller.SetCollectShoes(state) end
end)
createToggle(farmSection, "Collect tools | By JOPAPU", false, function(state)
    if Controller.SetCollectTools then Controller.SetCollectTools(state) end
end)
createToggle(farmSection, "Collect cashiers | By JOPAPU", false, function(state)
    if Controller.SetCollectCashiers then Controller.SetCollectCashiers(state) end
end)

local objects = createPage("Objects")
local objectsSection = createSection(objects, "Objects | By JOPAPU", "Object controls | By JOPAPU")
createToggle(objectsSection, "Disable seats | By JOPAPU", false, function(state)
    if Controller.SetSeatsDisabled then Controller.SetSeatsDisabled(state) end
end)
createButton(objectsSection, "Refresh objects | By JOPAPU")
createButton(objectsSection, "Reset preview | By JOPAPU")

local settings = createPage("Settings")
local settingsSection = createSection(settings, "Settings | By JOPAPU", "Menu preferences | By JOPAPU")
createToggle(settingsSection, "Anti-fly bypass | By JOPAPU", false, function(state)
    if Controller.SetAntiFlyBypass then Controller.SetAntiFlyBypass(state) end
end)
createToggle(settingsSection, "Protections | By JOPAPU", false, function(state)
    if Controller.SetProtections then Controller.SetProtections(state) end
end)
createToggle(settingsSection, "System handler | By JOPAPU", true, function(state)
    if Controller.SetSystemHandler then Controller.SetSystemHandler(state) end
end)

setTab("Overview")

local dragging = false
local dragStart
local startPosition

local function updateDrag(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
end

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)
