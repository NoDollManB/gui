local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Theme = {
    Background = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(255, 50, 50),
    TextColor = Color3.fromRGB(255, 255, 255),
    ElementBackground = Color3.fromRGB(30, 30, 30)
}

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = "MyUI"

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Theme.Accent
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame

    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 5, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.TextColor
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.Arcade -- Пиксельный шрифт
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar

    local dragging, dragInput, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    local Window = {Frame = MainFrame, Tabs = {}}
    
    function Window:CreateTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 100, 0, 30)
        TabButton.Position = UDim2.new(0, #Window.Tabs * 100, 0, 30)
        TabButton.BackgroundColor3 = Theme.ElementBackground
        TabButton.Text = tabName
        TabButton.TextColor3 = Theme.TextColor
        TabButton.Font = Enum.Font.Arcade -- Пиксельный шрифт
        TabButton.TextSize = 14
        TabButton.Parent = MainFrame

        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton

        local TabFrame = Instance.new("Frame")
        TabFrame.Size = UDim2.new(1, 0, 1, -60)
        TabFrame.Position = UDim2.new(0, 0, 0, 60)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = false
        TabFrame.Parent = MainFrame

        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Frame.Visible = false
            end
            TabFrame.Visible = true
        end)

        local Tab = {Frame = TabFrame}
        table.insert(Window.Tabs, Tab)

        function Tab:CreateButton(buttonText, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, 150, 0, 30)
            Button.Position = UDim2.new(0, 10, 0, #TabFrame:GetChildren() * 40)
            Button.BackgroundColor3 = Theme.ElementBackground
            Button.Text = buttonText
            Button.TextColor3 = Theme.TextColor
            Button.Font = Enum.Font.Arcade -- Пиксельный шрифт
            Button.TextSize = 14
            Button.Parent = TabFrame

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button

            local AccentLine = Instance.new("Frame")
            AccentLine.Size = UDim2.new(0, 2, 1, 0)
            AccentLine.Position = UDim2.new(0, 0, 0, 0)
            AccentLine.BackgroundColor3 = Theme.Accent
            AccentLine.BorderSizePixel = 0
            AccentLine.Parent = Button

            Button.MouseButton1Click:Connect(callback)
        end

        return Tab
    end

    return Window
end

return Library
