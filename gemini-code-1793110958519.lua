-- =================================================================
-- TOBOX TACTICAL HUB [MOBILE FIXED: AUTO-AIM, CENTER FOV & ESP]
-- Authors: Nazik & Jura
-- =================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local PlayerGui = (gethui and gethui()) or LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("ToBoxMobileHub") then PlayerGui.ToBoxMobileHub:Destroy() end
pcall(function() 
    RunService:UnbindFromRenderStep("ToBoxLoop") 
end)

local CORRECT_KEY = "ToBoxMobile2026"

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "ToBoxMobileHub"
ScreenGui.ResetOnSpawn = false

local function ApplyStyle(inst, bg, str, radius)
    inst.BackgroundColor3 = bg or Color3.fromRGB(16, 15, 23)
    inst.BorderSizePixel = 0
    local corner = inst:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", inst)
    corner.CornerRadius = UDim.new(0, radius or 10)
    local stroke = inst:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", inst)
    stroke.Color = str or Color3.fromRGB(45, 40, 65)
    stroke.Thickness = 1.2
    return stroke
end

-- ВІКНО АВТОРИЗАЦІЇ
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size, KeyFrame.Position = UDim2.new(0, 300, 0, 180), UDim2.new(0.5, -150, 0.5, -90)
KeyFrame.Active, KeyFrame.Draggable = true, true
ApplyStyle(KeyFrame, Color3.fromRGB(14, 13, 20), Color3.fromRGB(0, 255, 120), 12)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size, KeyTitle.Position, KeyTitle.BackgroundTransparency = UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 10), 1
KeyTitle.Text = "🔐 ToBox Auth Required"
KeyTitle.TextColor3, KeyTitle.Font, KeyTitle.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size, KeyBox.Position = UDim2.new(0.8, 0, 0, 40), UDim2.new(0.1, 0, 0, 60)
KeyBox.PlaceholderText = "Введіть ключ (пароль)..."
KeyBox.Text = ""
KeyBox.TextColor3, KeyBox.PlaceholderColor3, KeyBox.Font, KeyBox.TextSize = Color3.fromRGB(255, 255, 255), Color3.fromRGB(130, 130, 150), Enum.Font.SourceSans, 14
ApplyStyle(KeyBox, Color3.fromRGB(22, 20, 32), Color3.fromRGB(60, 50, 85), 8)

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size, SubmitBtn.Position = UDim2.new(0.8, 0, 0, 38), UDim2.new(0.1, 0, 0, 115)
SubmitBtn.Text = "ПІДТВЕРДИТИ КЛЮЧ"
SubmitBtn.TextColor3, SubmitBtn.Font, SubmitBtn.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 14
ApplyStyle(SubmitBtn, Color3.fromRGB(0, 180, 90), Color3.fromRGB(0, 255, 120), 8)

local function LaunchHub()
    KeyFrame:Destroy()

    local CurrentLanguage = "UA"
    local Translations = {
        UA = {
            Combat = "Бій", Visuals = "Візуали", CharTab = "Персонаж", Configs = "Конфіги", Service = "Сервіс",
            Aimbot = "Авто-Аім (Auto Lock)", TeamCheck = "Team Check", VisibleCheck = "Visible Check", FOVRadius = "Радіус FOV",
            HeadChance = "Шанс Голова (%)", BodyChance = "Шанс Тіло (%)", Nicknames = "Нікнейми", Boxes = "Бокси ESP",
            HPBar = "Смужка ХП", Skeleton = "Скелет", Lines = "Лінії (Tracers)", RGB_FOV = "RGB Колір FOV",
            RGB_Menu = "Фулл Меню RGB", RGB_ESP = "RGB ESP", SpeedHack = "SpeedHack", SpeedVal = "Швидкість",
            SuperJump = "Super Jump", JumpVal = "Висота Стрибка", Noclip = "Noclip", InfJump = "Inf Jump",
            KillSwitch = "🛑 ВИМКНУТИ"
        }
    }

    local Features = {
        Aimbot = false, TeamCheck = true, VisibleCheck = true,
        AimbotFOV = 200, HeadChance = 85, BodyChance = 15,
        RGB_Menu = false, RGB_FOV = false, RGB_ESP = false,
        ESP_Box = false, ESP_HPBar = true, ESP_Skeleton = false, ESP_Names = false, ESP_Tracers = false,
        ESP_BoxColor = Color3.fromRGB(255, 50, 80),
        SpeedHack = false, SpeedValue = 50,
        JumpHack = false, JumpValue = 120,
        Noclip = false, InfJump = false,
        UIScale = 13, UIThemeColor = Color3.fromRGB(255, 50, 80)
    }

    -- ПЛАВАЮЧА КНОПКА
    local OpenToggle = Instance.new("TextButton", ScreenGui)
    OpenToggle.Size, OpenToggle.Position = UDim2.new(0, 90, 0, 40), UDim2.new(0, 15, 0.35, 0)
    OpenToggle.Text, OpenToggle.TextColor3, OpenToggle.TextSize = "⚡ ToBox", Color3.fromRGB(255, 255, 255), 14
    OpenToggle.Font = Enum.Font.SourceSansBold
    OpenToggle.Active, OpenToggle.Draggable = true, true
    local OpenStroke = ApplyStyle(OpenToggle, Color3.fromRGB(20, 18, 28), Color3.fromRGB(0, 255, 120), 10)

    -- ГОЛОВНЕ ВІКНО
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size, Main.Position = UDim2.new(0, 520, 0, 360), UDim2.new(0.5, -260, 0.5, -180)
    Main.Active, Main.Draggable, Main.Visible = true, true, true
    local MainStroke = ApplyStyle(Main, Color3.fromRGB(14, 13, 20), Color3.fromRGB(55, 45, 75), 12)

    local HeaderBar = Instance.new("Frame", Main)
    HeaderBar.Size, HeaderBar.Position = UDim2.new(1, -16, 0, 32), UDim2.new(0, 8, 0, 6)
    ApplyStyle(HeaderBar, Color3.fromRGB(20, 18, 28), Color3.fromRGB(45, 40, 65), 8)

    local TitleHeader = Instance.new("TextLabel", HeaderBar)
    TitleHeader.Size, TitleHeader.Position, TitleHeader.BackgroundTransparency = UDim2.new(0.6, 0, 1, 0), UDim2.new(0, 10, 0, 0), 1
    TitleHeader.Text = "⚡ ToBox Mobile Hub"
    TitleHeader.TextColor3, TitleHeader.Font, TitleHeader.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 13
    TitleHeader.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton", HeaderBar)
    CloseBtn.Size, CloseBtn.Position = UDim2.new(0, 28, 1, -4), UDim2.new(1, -30, 0, 2)
    CloseBtn.Text, CloseBtn.TextColor3, CloseBtn.TextSize = "✕", Color3.fromRGB(255, 90, 90), 13
    CloseBtn.Font = Enum.Font.SourceSansBold
    ApplyStyle(CloseBtn, Color3.fromRGB(45, 20, 30), Color3.fromRGB(180, 40, 60), 6)

    CloseBtn.MouseButton1Click:Connect(function()
        pcall(function() RunService:UnbindFromRenderStep("ToBoxLoop") end)
        ScreenGui:Destroy()
    end)

    OpenToggle.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size, Sidebar.Position = UDim2.new(0, 130, 1, -50), UDim2.new(0, 8, 0, 42)
    ApplyStyle(Sidebar, Color3.fromRGB(18, 16, 26), Color3.fromRGB(40, 35, 60), 8)

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 4)
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Content = Instance.new("Frame", Main)
    Content.Size, Content.Position = UDim2.new(1, -148, 1, -50), UDim2.new(0, 142, 0, 42)
    Content.BackgroundTransparency = 1

    local Pages = {}
    local function CreatePage()
        local p = Instance.new("ScrollingFrame", Content)
        p.Size, p.Position, p.Visible, p.BackgroundTransparency = UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), false, 1
        p.ScrollBarThickness = 3
        p.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local l = Instance.new("UIListLayout", p)
        l.Padding = UDim.new(0, 5)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        return p
    end

    local pagesData = {
        Combat = CreatePage(), Visuals = CreatePage(), CharTab = CreatePage(), Configs = CreatePage(), Service = CreatePage()
    }

    local function AddNavButton(nameKey, icon)
        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.Text = " " .. icon .. " " .. Translations[CurrentLanguage][nameKey]
        btn.TextColor3, btn.Font, btn.TextSize = Color3.fromRGB(180, 175, 200), Enum.Font.SourceSansBold, 11
        btn.TextXAlignment = Enum.TextXAlignment.Left
        ApplyStyle(btn, Color3.fromRGB(24, 21, 34), Color3.fromRGB(50, 42, 70), 6)

        btn.MouseButton1Click:Connect(function()
            for _, pg in pairs(Pages) do pg.Visible = false end
            pagesData[nameKey].Visible = true
        end)
        Pages[nameKey] = pagesData[nameKey]
    end

    AddNavButton("Combat", "⚔️")
    AddNavButton("Visuals", "👁️")
    AddNavButton("CharTab", "🏃")
    AddNavButton("Configs", "📁")
    AddNavButton("Service", "⚙️")

    pagesData["Combat"].Visible = true

    local function AddToggle(page, textKey, key)
        local card = Instance.new("Frame", page)
        card.Size = UDim2.new(1, -6, 0, 38)
        ApplyStyle(card, Color3.fromRGB(22, 20, 32), Color3.fromRGB(48, 42, 68), 6)

        local lbl = Instance.new("TextLabel", card)
        lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 8, 0, 0), 1
        lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = Translations[CurrentLanguage][textKey] or textKey, Color3.fromRGB(230, 225, 245), Enum.Font.SourceSansBold, 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local tog = Instance.new("TextButton", card)
        tog.Size, tog.Position = UDim2.new(0, 36, 0, 20), UDim2.new(1, -44, 0.5, -10)
        tog.Text = ""
        ApplyStyle(tog, Features[key] and Features.UIThemeColor or Color3.fromRGB(40, 35, 55), Color3.fromRGB(75, 65, 100), 10)

        tog.MouseButton1Click:Connect(function()
            Features[key] = not Features[key]
            ApplyStyle(tog, Features[key] and Features.UIThemeColor or Color3.fromRGB(40, 35, 55), Color3.fromRGB(75, 65, 100), 10)
        end)
    end

    local function AddSlider(page, nameKey, key, minVal, maxVal)
        local card = Instance.new("Frame", page)
        card.Size = UDim2.new(1, -6, 0, 44)
        ApplyStyle(card, Color3.fromRGB(22, 20, 32), Color3.fromRGB(48, 42, 68), 6)

        local realName = Translations[CurrentLanguage][nameKey] or nameKey
        local lbl = Instance.new("TextLabel", card)
        lbl.Size, lbl.Position, lbl.BackgroundTransparency = UDim2.new(1, -8, 0, 18), UDim2.new(0, 8, 0, 2), 1
        lbl.Text, lbl.TextColor3, lbl.Font, lbl.TextSize = realName .. ": " .. tostring(Features[key]), Color3.fromRGB(230, 225, 245), Enum.Font.SourceSansBold, 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local sliderBg = Instance.new("Frame", card)
        sliderBg.Size, sliderBg.Position = UDim2.new(1, -16, 0, 8), UDim2.new(0, 8, 0, 26)
        ApplyStyle(sliderBg, Color3.fromRGB(14, 13, 20), Color3.fromRGB(40, 35, 55), 4)

        local fill = Instance.new("Frame", sliderBg)
        local pct = math.clamp((Features[key] - minVal) / (maxVal - minVal), 0, 1)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        ApplyStyle(fill, Features.UIThemeColor, Color3.fromRGB(100, 255, 150), 4)

        local dragging = false
        local function updateSlider(input)
            local posX = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
            local alpha = posX / sliderBg.AbsoluteSize.X
            local val = math.floor(minVal + (maxVal - minVal) * alpha)
            Features[key] = val
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            lbl.Text = realName .. ": " .. tostring(val)
        end

        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true updateSlider(input)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    AddToggle(pagesData["Combat"], "Aimbot", "Aimbot")
    AddSlider(pagesData["Combat"], "FOVRadius", "AimbotFOV", 30, 400)
    AddSlider(pagesData["Combat"], "HeadChance", "HeadChance", 0, 100)
    AddSlider(pagesData["Combat"], "BodyChance", "BodyChance", 0, 100)
    AddToggle(pagesData["Combat"], "TeamCheck", "TeamCheck")
    AddToggle(pagesData["Combat"], "VisibleCheck", "VisibleCheck")
    AddToggle(pagesData["Combat"], "RGB_FOV", "RGB_FOV")

    AddToggle(pagesData["Visuals"], "Nicknames", "ESP_Names")
    AddToggle(pagesData["Visuals"], "Boxes", "ESP_Box")
    AddToggle(pagesData["Visuals"], "HPBar", "ESP_HPBar")
    AddToggle(pagesData["Visuals"], "Skeleton", "ESP_Skeleton")
    AddToggle(pagesData["Visuals"], "Lines", "ESP_Tracers")
    AddToggle(pagesData["Visuals"], "RGB_ESP", "RGB_ESP")

    AddToggle(pagesData["CharTab"], "SpeedHack", "SpeedHack")
    AddSlider(pagesData["CharTab"], "SpeedVal", "SpeedValue", 16, 200)
    AddToggle(pagesData["CharTab"], "SuperJump", "JumpHack")
    AddSlider(pagesData["CharTab"], "JumpVal", "JumpValue", 50, 300)
    AddToggle(pagesData["CharTab"], "Noclip", "Noclip")
    AddToggle(pagesData["CharTab"], "InfJump", "InfJump")

    AddToggle(pagesData["Service"], "RGB_Menu", "RGB_Menu")

    local KillBtn = Instance.new("TextButton", pagesData["Service"])
    KillBtn.Size = UDim2.new(1, -6, 0, 38)
    KillBtn.Text = "🛑 ВИМКНУТИ СКРИПТ"
    KillBtn.TextColor3, KillBtn.Font, KillBtn.TextSize = Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 12
    ApplyStyle(KillBtn, Color3.fromRGB(180, 30, 50), Color3.fromRGB(255, 60, 80), 6)
    KillBtn.MouseButton1Click:Connect(function()
        pcall(function() RunService:UnbindFromRenderStep("ToBoxLoop") end)
        ScreenGui:Destroy()
    end)

    -- ЛОГІКА СКРИПТА
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness, FOVCircle.Filled, FOVCircle.Visible = 1.5, false, false
    local ESP_Store = {}

    local function CreateSkeleton()
        local lines = {}
        local joints = {
            {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
            {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
            {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"},
            {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
            {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}
        }
        for _, j in ipairs(joints) do
            local line = Drawing.new("Line")
            line.Thickness, line.Visible = 1.5, false
            table.insert(lines, {Line = line, A = j[1], B = j[2]})
        end
        return lines
    end

    local function IsVisible(targetPart)
        if not Features.VisibleCheck then return true end
        local char = LocalPlayer.Character
        local head = char and char:FindFirstChild("Head")
        if not head then return true end
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {char, targetPart.Parent}
        local result = workspace:Raycast(head.Position, targetPart.Position - head.Position, raycastParams)
        return result == nil
    end

    local function IsValidTarget(p)
        if p == LocalPlayer then return false end
        local ch = p.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        if Features.TeamCheck and LocalPlayer.Team and p.Team and LocalPlayer.Team == p.Team then return false end
        return true
    end

    local function GetClosestTarget()
        local target, minD = nil, Features.AimbotFOV
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        for _, p in pairs(Players:GetPlayers()) do
            if IsValidTarget(p) and p.Character then
                local headPart = p.Character:FindFirstChild("Head")
                local bodyPart = p.Character:FindFirstChild("HumanoidRootPart")
                local chosenTargetPart = (math.random(1, 100) <= Features.HeadChance) and (headPart or bodyPart) or (bodyPart or headPart)
                if chosenTargetPart and IsVisible(chosenTargetPart) then
                    local pos, onS = Camera:WorldToViewportPoint(chosenTargetPart.Position)
                    if onS then
                        local d = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                        if d < minD then minD = d target = chosenTargetPart end
                    end
                end
            end
        end
        return target
    end

    task.spawn(function()
        local hue = 0
        while task.wait(0.03) do
            hue = (hue + 0.01) % 1
            local rgbCol = Color3.fromHSV(hue, 1, 1)
            OpenStroke.Color = rgbCol
            if Features.RGB_Menu then
                MainStroke.Color = rgbCol
                HeaderBar.BackgroundColor3 = rgbCol
            end
            if Features.RGB_FOV then FOVCircle.Color = rgbCol end
        end
    end)

    RunService:BindToRenderStep("ToBoxLoop", Enum.RenderPriority.Camera.Value + 1, function()
        -- ФОВ СТРОГО ПО ЦЕНТРУ ЕКРАНА
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = Features.AimbotFOV
        FOVCircle.Visible = Features.Aimbot

        if not Features.RGB_FOV then FOVCircle.Color = Features.ESP_BoxColor end

        local currentEspColor = Features.RGB_ESP and Color3.fromHSV((tick() % 5) / 5, 1, 1) or Features.ESP_BoxColor

        -- АВТОМАТИЧНИЙ АІМБОТ БЕЗ КНОПОК
        if Features.Aimbot then
            local target = GetClosestTarget()
            if target then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.8)
            end
        end

        for p, e in pairs(ESP_Store) do
            if not p or not p.Parent then
                if e.Box then e.Box:Remove() end if e.HPBarBg then e.HPBarBg:Remove() end
                if e.HPBarFill then e.HPBarFill:Remove() end if e.Name then e.Name:Remove() end
                if e.Tracer then e.Tracer:Remove() end
                if e.Skeleton then for _, sk in ipairs(e.Skeleton) do sk.Line:Remove() end end
                ESP_Store[p] = nil
            end
        end

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                if not ESP_Store[p] then
                    ESP_Store[p] = {
                        Box = Drawing.new("Square"), HPBarBg = Drawing.new("Square"), HPBarFill = Drawing.new("Square"),
                        Name = Drawing.new("Text"), Tracer = Drawing.new("Line"), Skeleton = CreateSkeleton()
                    }
                    ESP_Store[p].Box.Thickness = 1.5
                    ESP_Store[p].HPBarBg.Filled, ESP_Store[p].HPBarFill.Filled = true, true
                    ESP_Store[p].HPBarBg.Color = Color3.fromRGB(20, 20, 20)
                    ESP_Store[p].Name.Size, ESP_Store[p].Name.Center = 13, true
                end

                local e, ch = ESP_Store[p], p.Character
                local root = ch and ch:FindFirstChild("HumanoidRootPart")
                local head = ch and ch:FindFirstChild("Head")
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                local valid = root and head and hum and hum.Health > 0

                if valid then
                    local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    local headV = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legV = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))

                    if onScreen then
                        local h = math.abs(headV.Y - legV.Y)
                        local w = h / 2

                        e.Box.Visible = Features.ESP_Box
                        e.Box.Size = Vector2.new(w, h)
                        e.Box.Position = Vector2.new(pos.X - w/2, headV.Y)
                        e.Box.Color = currentEspColor

                        -- ХП БАР
                        if Features.ESP_Box and Features.ESP_HPBar then
                            local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            e.HPBarBg.Visible, e.HPBarFill.Visible = true, true
                            e.HPBarBg.Size = Vector2.new(3, h)
                            e.HPBarBg.Position = Vector2.new(pos.X - w/2 - 6, headV.Y)
                            e.HPBarFill.Size = Vector2.new(3, h * hpPct)
                            e.HPBarFill.Position = Vector2.new(pos.X - w/2 - 6, headV.Y + (h * (1 - hpPct)))
                            e.HPBarFill.Color = Color3.fromRGB(0, 255, 100)
                        else
                            e.HPBarBg.Visible, e.HPBarFill.Visible = false, false
                        end

                        e.Name.Visible = Features.ESP_Names
                        e.Name.Text = p.Name
                        e.Name.Position = Vector2.new(pos.X, headV.Y - 15)
                        e.Name.Color = Color3.fromRGB(255, 255, 255)

                        e.Tracer.Visible = Features.ESP_Tracers
                        e.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        e.Tracer.To = Vector2.new(pos.X, legV.Y)
                        e.Tracer.Color = currentEspColor

                        -- СКЕЛЕТ
                        if Features.ESP_Skeleton then
                            for _, sk in ipairs(e.Skeleton) do
                                local pA = ch:FindFirstChild(sk.A)
                                local pB = ch:FindFirstChild(sk.B)
                                if pA and pB then
                                    local vA, sA = Camera:WorldToViewportPoint(pA.Position)
                                    local vB, sB = Camera:WorldToViewportPoint(pB.Position)
                                    if sA and sB then
                                        sk.Line.Visible = true
                                        sk.Line.From = Vector2.new(vA.X, vA.Y)
                                        sk.Line.To = Vector2.new(vB.X, vB.Y)
                                        sk.Line.Color = currentEspColor
                                    else
                                        sk.Line.Visible = false
                                    end
                                else
                                    sk.Line.Visible = false
                                end
                            end
                        else
                            for _, sk in ipairs(e.Skeleton) do sk.Line.Visible = false end
                        end
                    else
                        e.Box.Visible, e.HPBarBg.Visible, e.HPBarFill.Visible, e.Name.Visible, e.Tracer.Visible = false, false, false, false, false
                        for _, sk in ipairs(e.Skeleton) do sk.Line.Visible = false end
                    end
                else
                    e.Box.Visible, e.HPBarBg.Visible, e.HPBarFill.Visible, e.Name.Visible, e.Tracer.Visible = false, false, false, false, false
                    for _, sk in ipairs(e.Skeleton) do sk.Line.Visible = false end
                end
            end
        end
    end)

    RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                if Features.SpeedHack then hum.WalkSpeed = Features.SpeedValue end
                if Features.JumpHack then hum.UseJumpPower = true hum.JumpPower = Features.JumpValue end
            end
            if Features.Noclip then
                for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
            end
        end
    end)

    UserInputService.JumpRequest:Connect(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Features.InfJump and hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == CORRECT_KEY then
        LaunchHub()
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "❌ Неправильний ключ!"
    end
end)
