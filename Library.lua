--[[
    Library.lua — Custom UI Framework
    Kloso Hub - Blox Fruits
]]

local Library = {}
Library.__index = Library

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

-- Color Palette
local Colors = {
    bg = Color3.fromRGB(15, 15, 25),
    sidebar = Color3.fromRGB(20, 20, 35),
    card = Color3.fromRGB(25, 25, 42),
    accent = Color3.fromRGB(130, 90, 255),
    accentDark = Color3.fromRGB(90, 60, 200),
    text = Color3.fromRGB(220, 220, 235),
    textDim = Color3.fromRGB(140, 140, 165),
    toggle_on = Color3.fromRGB(100, 220, 130),
    toggle_off = Color3.fromRGB(60, 60, 80),
    border = Color3.fromRGB(45, 45, 70),
    red = Color3.fromRGB(255, 80, 80),
    green = Color3.fromRGB(80, 255, 130),
    yellow = Color3.fromRGB(255, 200, 60),
}

local function tween(obj, props, dur)
    dur = dur or 0.25
    TweenService:Create(obj, TweenInfo.new(dur, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function addCorner(obj, radius)
    create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = obj})
end

local function addStroke(obj, color, thickness)
    create("UIStroke", {Color = color or Colors.border, Thickness = thickness or 1, Parent = obj})
end

-- ═══════════════════════════════════════
-- MAIN WINDOW
-- ═══════════════════════════════════════
function Library:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Kloso Hub"
    local size = config.Size or UDim2.new(0, 680, 0, 460)

    -- Cleanup old
    local pg = plr:FindFirstChild("PlayerGui")
    if pg then
        local old = pg:FindFirstChild("KlosoHub")
        if old then old:Destroy() end
    end

    local gui = create("ScreenGui", {Name = "KlosoHub", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = pg})

    -- Main Frame
    local main = create("Frame", {Name = "Main", Size = size, Position = UDim2.new(0.5, -340, 0.5, -230), BackgroundColor3 = Colors.bg, Parent = gui})
    addCorner(main, 12)
    addStroke(main, Colors.border, 1)

    -- Shadow
    create("ImageLabel", {Name = "Shadow", Size = UDim2.new(1, 30, 1, 30), Position = UDim2.new(0, -15, 0, -15), BackgroundTransparency = 1, Image = "rbxassetid://6014261993", ImageColor3 = Color3.new(0,0,0), ImageTransparency = 0.5, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49,49,450,450), ZIndex = -1, Parent = main})

    -- Dragging
    local dragging, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Title Bar
    local titleBar = create("Frame", {Name = "TitleBar", Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Colors.sidebar, Parent = main})
    addCorner(titleBar, 12)
    -- Fix bottom corners
    create("Frame", {Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12), BackgroundColor3 = Colors.sidebar, BorderSizePixel = 0, Parent = titleBar})

    create("TextLabel", {Text = "⚡ " .. title, Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 15, 0, 0), BackgroundTransparency = 1, TextColor3 = Colors.accent, Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = titleBar})

    -- Close / Minimize
    local closeBtn = create("TextButton", {Text = "✕", Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -38, 0, 5), BackgroundTransparency = 1, TextColor3 = Colors.textDim, Font = Enum.Font.GothamBold, TextSize = 16, Parent = titleBar})
    local minBtn = create("TextButton", {Text = "─", Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -68, 0, 5), BackgroundTransparency = 1, TextColor3 = Colors.textDim, Font = Enum.Font.GothamBold, TextSize = 16, Parent = titleBar})

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(main, {Size = UDim2.new(0, size.X.Offset, 0, 40)}, 0.3)
        else
            tween(main, {Size = size}, 0.3)
        end
    end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(main, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        task.wait(0.35)
        gui:Destroy()
    end)

    -- Sidebar
    local sidebar = create("Frame", {Name = "Sidebar", Size = UDim2.new(0, 150, 1, -40), Position = UDim2.new(0, 0, 0, 40), BackgroundColor3 = Colors.sidebar, BorderSizePixel = 0, Parent = main})
    create("Frame", {Size = UDim2.new(0, 12, 1, 0), Position = UDim2.new(1, -12, 0, 0), BackgroundColor3 = Colors.sidebar, BorderSizePixel = 0, Parent = sidebar})

    local tabList = create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = sidebar})
    create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = sidebar})

    -- Content area
    local content = create("Frame", {Name = "Content", Size = UDim2.new(1, -150, 1, -40), Position = UDim2.new(0, 150, 0, 40), BackgroundColor3 = Colors.bg, BorderSizePixel = 0, ClipsDescendants = true, Parent = main})

    -- Mobile toggle
    local mobileBtn = create("TextButton", {Name = "MobileToggle", Text = "⚡", Size = UDim2.new(0, 50, 0, 50), Position = UDim2.new(0, 10, 0.5, -25), BackgroundColor3 = Colors.accent, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 22, Visible = false, Parent = gui})
    addCorner(mobileBtn, 25)

    local window = {gui = gui, main = main, sidebar = sidebar, content = content, tabs = {}, activeTab = nil, Colors = Colors}

    -- Tab methods
    function window:AddTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or ""

        local tabBtn = create("TextButton", {
            Name = tabName, Text = tabIcon .. " " .. tabName,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Colors.card, BackgroundTransparency = 0.5,
            TextColor3 = Colors.textDim, Font = Enum.Font.GothamSemibold,
            TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false, Parent = sidebar
        })
        addCorner(tabBtn, 8)
        create("UIPadding", {PaddingLeft = UDim.new(0, 12), Parent = tabBtn})

        local tabContent = create("ScrollingFrame", {
            Name = tabName .. "Content", Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, ScrollBarThickness = 3,
            ScrollBarImageColor3 = Colors.accent, BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0), Visible = false,
            AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = content
        })
        create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = tabContent})
        create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), Parent = tabContent})

        local tab = {btn = tabBtn, content = tabContent, name = tabName}
        table.insert(self.tabs, tab)

        tabBtn.MouseButton1Click:Connect(function()
            self:SelectTab(tab)
        end)

        tabBtn.MouseEnter:Connect(function()
            if self.activeTab ~= tab then
                tween(tabBtn, {BackgroundTransparency = 0.2})
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if self.activeTab ~= tab then
                tween(tabBtn, {BackgroundTransparency = 0.5})
            end
        end)

        -- Auto-select first tab
        if #self.tabs == 1 then
            self:SelectTab(tab)
        end

        -- Element builders
        function tab:AddSection(name)
            local section = create("TextLabel", {
                Text = "  " .. (name or "Section"), Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1, TextColor3 = Colors.accent,
                Font = Enum.Font.GothamBold, TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left, Parent = tabContent
            })
            return section
        end

        function tab:AddDivider()
            local div = create("Frame", {Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Colors.border, BorderSizePixel = 0, Parent = tabContent})
            return div
        end

        function tab:AddToggle(config)
            config = config or {}
            local togName = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end

            local holder = create("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Colors.card, Parent = tabContent})
            addCorner(holder, 8)

            create("TextLabel", {Text = togName, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, TextColor3 = Colors.text, Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = holder})

            local togBg = create("Frame", {Size = UDim2.new(0, 40, 0, 22), Position = UDim2.new(1, -52, 0.5, -11), BackgroundColor3 = default and Colors.toggle_on or Colors.toggle_off, Parent = holder})
            addCorner(togBg, 11)

            local togCircle = create("Frame", {Size = UDim2.new(0, 16, 0, 16), Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.new(1,1,1), Parent = togBg})
            addCorner(togCircle, 8)

            local state = default
            local togBtn = create("TextButton", {Text = "", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = holder})

            togBtn.MouseButton1Click:Connect(function()
                state = not state
                tween(togBg, {BackgroundColor3 = state and Colors.toggle_on or Colors.toggle_off})
                tween(togCircle, {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
                pcall(callback, state)
            end)

            return {
                Set = function(_, val)
                    state = val
                    tween(togBg, {BackgroundColor3 = state and Colors.toggle_on or Colors.toggle_off})
                    tween(togCircle, {Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)})
                end,
                Get = function() return state end
            }
        end

        function tab:AddSlider(config)
            config = config or {}
            local slName = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local callback = config.Callback or function() end

            local holder = create("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Colors.card, Parent = tabContent})
            addCorner(holder, 8)

            local valLabel = create("TextLabel", {Text = slName .. ": " .. default, Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 12, 0, 4), BackgroundTransparency = 1, TextColor3 = Colors.text, Font = Enum.Font.GothamSemibold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = holder})

            local sliderBg = create("Frame", {Size = UDim2.new(1, -24, 0, 8), Position = UDim2.new(0, 12, 0, 32), BackgroundColor3 = Colors.toggle_off, Parent = holder})
            addCorner(sliderBg, 4)

            local fill = create("Frame", {Size = UDim2.new((default - min) / (max - min), 0, 1, 0), BackgroundColor3 = Colors.accent, Parent = sliderBg})
            addCorner(fill, 4)

            local sliderBtn = create("TextButton", {Text = "", Size = UDim2.new(1, 0, 1, 10), Position = UDim2.new(0, 0, 0, -5), BackgroundTransparency = 1, Parent = sliderBg})

            local sliding = false
            sliderBtn.MouseButton1Down:Connect(function() sliding = true end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * rel)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    valLabel.Text = slName .. ": " .. val
                    pcall(callback, val)
                end
            end)

            return {Set = function(_, val)
                local rel = (val - min) / (max - min)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                valLabel.Text = slName .. ": " .. val
            end}
        end

        function tab:AddDropdown(config)
            config = config or {}
            local ddName = config.Name or "Dropdown"
            local options = config.Options or {}
            local default = config.Default or (options[1] or "")
            local callback = config.Callback or function() end

            local holder = create("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Colors.card, ClipsDescendants = true, Parent = tabContent})
            addCorner(holder, 8)

            create("TextLabel", {Text = ddName, Size = UDim2.new(0.5, -10, 0, 38), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, TextColor3 = Colors.text, Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = holder})

            local selected = create("TextButton", {Text = tostring(default) .. " ▾", Size = UDim2.new(0.45, 0, 0, 28), Position = UDim2.new(0.52, 0, 0, 5), BackgroundColor3 = Colors.toggle_off, TextColor3 = Colors.text, Font = Enum.Font.Gotham, TextSize = 12, AutoButtonColor = false, Parent = holder})
            addCorner(selected, 6)

            local opened = false
            local currentVal = default

            selected.MouseButton1Click:Connect(function()
                opened = not opened
                local targetH = opened and (38 + #options * 28) or 38
                tween(holder, {Size = UDim2.new(1, 0, 0, targetH)}, 0.2)
            end)

            for i, opt in ipairs(options) do
                local optBtn = create("TextButton", {Text = tostring(opt), Size = UDim2.new(0.45, 0, 0, 24), Position = UDim2.new(0.52, 0, 0, 34 + (i-1) * 28), BackgroundColor3 = Colors.sidebar, TextColor3 = Colors.textDim, Font = Enum.Font.Gotham, TextSize = 11, AutoButtonColor = false, Parent = holder})
                addCorner(optBtn, 4)

                optBtn.MouseButton1Click:Connect(function()
                    currentVal = opt
                    selected.Text = tostring(opt) .. " ▾"
                    opened = false
                    tween(holder, {Size = UDim2.new(1, 0, 0, 38)}, 0.2)
                    pcall(callback, opt)
                end)
            end

            return {Get = function() return currentVal end, Set = function(_, val) currentVal = val; selected.Text = tostring(val) .. " ▾" end}
        end

        function tab:AddButton(config)
            config = config or {}
            local btnName = config.Name or "Button"
            local callback = config.Callback or function() end

            local btn = create("TextButton", {Text = btnName, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Colors.accent, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false, Parent = tabContent})
            addCorner(btn, 8)

            btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = Colors.accentDark}) end)
            btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = Colors.accent}) end)
            btn.MouseButton1Click:Connect(function() pcall(callback) end)
            return btn
        end

        function tab:AddLabel(text)
            local lbl = create("TextLabel", {Text = text or "", Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, TextColor3 = Colors.textDim, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = tabContent})
            return lbl
        end

        return tab
    end

    function window:SelectTab(tab)
        for _, t in ipairs(self.tabs) do
            t.content.Visible = false
            tween(t.btn, {BackgroundTransparency = 0.5, TextColor3 = Colors.textDim})
        end
        tab.content.Visible = true
        tween(tab.btn, {BackgroundTransparency = 0, TextColor3 = Colors.accent})
        self.activeTab = tab
    end

    function window:Destroy()
        gui:Destroy()
    end

    return window
end

return Library
