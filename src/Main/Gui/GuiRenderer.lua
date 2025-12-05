if _G.Luminosity_Loaded and _G.MyGui then
    _G.MyGui:Destroy()
end

_G.Luminosity_Loaded = true
_G.MyGui = nil

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Services = setmetatable({}, {__index = function(Self, Index)
    local NewService = game:GetService(Index)
    if NewService then
        Self[Index] = NewService
    end
    return NewService
end})

local LocalPlayer = Services.Players.LocalPlayer

local Objects = {}
local Binds = {}
local Utility = {}

function Utility.new(Class, Properties, Children)
    local NewInstance = Instance.new(Class)
    for i,v in pairs(Properties or {}) do
        if i ~= "Parent" then
            NewInstance[i] = v
        end
    end
    for i,v in ipairs(Children or {}) do
        if typeof(v) == "Instance" then
            v.Parent = NewInstance
        end
    end

    NewInstance.Parent = Properties.Parent
    return NewInstance
end

function Utility.Tween(Object, TweenInformation, Goal)
    local Tween = Services.TweenService:Create(Object, TweenInformation, Goal)
    local Info = {}

    function Info:Yield()
        Tween:Play()
        Tween.Completed:Wait(10)
    end

    return setmetatable(Info, {__index = function(Self, Index)
        local Value = Tween[Index]
        return typeof(Value) ~= "function" and Value or function(self, ...)
            return Tween[Index](Tween, ...)
        end
    end})
end

function Utility.Wait(Seconds)
    if Seconds then
        local StartTime = time()
        repeat
            Services.RunService.Heartbeat:Wait(0.1)
        until time() - StartTime > Seconds
    else
        return Services.RunService.Heartbeat:Wait(0.1)
    end
end

function Utility.BindKey(Key, Callback, ID)
    local BindID = ID or Services.HttpService:GenerateGUID(true)
    Services.ContextActionService:BindAction(BindID, Callback, false, Key)
    return BindID
end

function Utility.CreateDrag(Frame, Parent, Settings)
    local DragPro = {
        DragEnabled = true;
        Dragging = false;
        Settings = Settings or {
            TweenDuration = 0.1,
            TweenStyle = Enum.EasingStyle.Quad
        }
    }

    local DragInfo = {
        Parent = Parent or Frame;
        DragInput = nil;
        MousePosition = nil;
        FramePosition = nil;
    }

    local Connections = {}

    function DragPro:Initialize()
        table.insert(Connections,
                Frame.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        DragPro.Dragging = true
                        DragInfo.MousePosition = Input.Position
                        DragInfo.FramePosition = DragInfo.Parent.Position

                        repeat
                            Input.Changed:Wait()
                        until Input.UserInputState == Enum.UserInputState.End
                        DragPro.Dragging = false
                    end
                end)
        )

        table.insert(Connections,
                Frame.InputChanged:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                        DragInfo.DragInput = Input
                    end
                end)
        )

        table.insert(Connections,
                Services.UserInputService.InputChanged:Connect(function(Input)
                    if DragPro.Dragging == true and Input == DragInfo.DragInput then
                        local PositionChange = Input.Position - DragInfo.MousePosition
                        Utility.Tween(DragInfo.Parent, TweenInfo.new(DragPro.Settings.TweenDuration, DragPro.Settings.TweenStyle), {Position = UDim2.new(DragInfo.FramePosition.X.Scale, DragInfo.FramePosition.X.Offset + PositionChange.X, DragInfo.FramePosition.Y.Scale, DragInfo.FramePosition.Y.Offset + PositionChange.Y)}):Play()
                    end
                end)
        )
    end

    function DragPro:Destroy()
        for i,v in ipairs(Connections) do
            v:Disconnect()
        end
    end

    DragPro:Initialize()

    return DragPro
end

local MyGui = {
    ScreenGui = Utility.new("ScreenGui", {
        DisplayOrder = 5,
        Name = "MyGui",
        Parent = Services.RunService:IsStudio() and LocalPlayer:FindFirstChildOfClass("PlayerGui") or Services.CoreGui,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    });
    Settings = {
        Name = "Template";
        Debug = false;
    };
    ColorScheme = {
        Primary = Color3.fromRGB(66, 134, 245);
        Text = Color3.new(255, 255, 255);
    };
}
_G.MyGui = MyGui.ScreenGui
for i,v in pairs({Name = "Template", Debug = false}) do
    if MyGui.Settings[i] == nil then
        MyGui.Settings[i] = v
    end
end

function MyGui.LoadingScreen()
    coroutine.wrap(function()
        local LoadingScreen = Utility.new("Frame", {
            Name = "LoadingScreen",
            Parent = MyGui.ScreenGui,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 5
        }, {
            Utility.new("VideoFrame", {
                Name = "LoadingVideo",
                Visible = false,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0, 750, 0, 425),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                ZIndex = 10,
                Looped = true,
                Playing = true,
                TimePosition = 0,
                Video = "rbxassetid://5608337069"
            })
        })
        Utility.Tween(LoadingScreen, TweenInfo.new(1), {BackgroundTransparency = 0}):Yield()

        if not LoadingScreen.LoadingVideo.IsLoaded then
            LoadingScreen.LoadingVideo.Loaded:Wait(10)
        end
        LoadingScreen.LoadingVideo.Visible = true

        Utility.Wait(2.5)
        Services.ContentProvider:PreloadAsync({MyGui.ScreenGui})
        Utility.Wait(0.25)

        LoadingScreen.LoadingVideo.Visible = false
        Utility.Tween(LoadingScreen, TweenInfo.new(1), {BackgroundTransparency = 1}):Yield()
        LoadingScreen:Destroy()
    end)()
    Utility.Wait(1)
end

local function CreateOptions(Frame)
    local Options = {}

    function Options.TextLabel(Title)
        local Container = Utility.new("Frame", {
            Name = "Switch",
            Parent = typeof(Frame) == "Instance" and Frame or Frame(),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25),
        }, {
            Utility.new("TextLabel", {
                Name = "Title",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = Title and tostring(Title) or "TextLabel",
                RichText = true,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextTransparency = 0.3,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        })

        local Properties = {
            Text = Title and tostring(Title) or "TextLabel";
        }

        return setmetatable({}, {
            __index = function(Self, Index)
                return Properties[Index]
            end;
            __newindex = function(Self, Index, Value)
                if Index == "Text" then
                    Container.Title.Text = Value and tostring(Value) or "TextLabel"
                end
                Properties[Index] = Value
            end;
        })
    end

    function Options.Button(Title, ButtonText, Callback)
        local Properties = {
            Title = Title and tostring(Title) or "Button";
            Function = Callback or function(Status) end;
        }

        local Container = Utility.new("ImageButton", {
            Name = "Button",
            Parent = typeof(Frame) == "Instance" and Frame or Frame(),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25),
        }, {
            Utility.new("TextLabel", {
                Name = "Title",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = Title and tostring(Title) or "Button",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextTransparency = 0.3,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Utility.new("TextButton", {
                Name = "Button",
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(50, 55, 60),
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0.2, 25, 0, 20),
                Text = ButtonText and tostring(ButtonText) or "Button",
                Font = Enum.Font.Gotham,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                TextTransparency = 0.3
            }, {
                Utility.new("UICorner", {CornerRadius = UDim.new(0, 4)})
            })
        })

        Container.Button.MouseButton1Down:Connect(function()
            local Success, Error = pcall(Properties.Function)
            assert(MyGui.Settings.Debug == false or Success, Error)
        end)

        return setmetatable({}, {
            __index = function(Self, Index)
                return Properties[Index]
            end;
            __newindex = function(Self, Index, Value)
                if Index == "Title" then
                    Container.Title.Text = Value and tostring(Value) or "Button"
                elseif Index == "ButtonText" then
                    Container.Button.Text = Value and tostring(Value) or "Button"
                end
                Properties[Index] = Value
            end
        })
    end

    function Options.Switch(Title, Callback)
        local Properties = {
            Title = Title and tostring(Title) or "Switch";
            Value = false;
            Function = Callback or function(Status) end;
        }

        local Container = Utility.new("ImageButton", {
            Name = "Switch",
            Parent = typeof(Frame) == "Instance" and Frame or Frame(),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25),
        }, {
            Utility.new("TextLabel", {
                Name = "Title",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Font = Enum.Font.Gotham,
                Text = Title and tostring(Title) or "Switch",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextTransparency = 0.3,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Utility.new("Frame", {
                Name = "Switch",
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Color3.fromRGB(100, 100, 100),
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0, 25, 0, 15),
            }, {
                Utility.new("UICorner", {CornerRadius = UDim.new(1, 0)}),
                Utility.new("Frame", {
                    Name = "Circle",
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14)
                }, {Utility.new("UICorner", {CornerRadius = UDim.new(1, 0)})})
            })
        })

        local Tweens = {
            [true] = {
                Utility.Tween(Container.Switch, TweenInfo.new(0.5), {BackgroundColor3 = MyGui.ColorScheme.Primary}),
                Utility.Tween(Container.Switch.Circle, TweenInfo.new(0.25), {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0)})
            };

            [false] = {
                Utility.Tween(Container.Switch, TweenInfo.new(0.5), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}),
                Utility.Tween(Container.Switch.Circle, TweenInfo.new(0.25), {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0)})
            };
        }

        Container.MouseButton1Down:Connect(function()
            Properties.Value = not  Properties.Value
            for i,v in ipairs(Tweens[Properties.Value]) do
                v:Play()
            end
            local Success, Error = pcall(Properties.Function, Properties.Value)
            assert(MyGui.Settings.Debug == false or Success, Error)
        end)

        return setmetatable({}, {
            __index = function(Self, Index)
                return Properties[Index]
            end;
            __newindex = function(Self, Index, Value)
                if Index == "Title" then
                    Container.Title.Text = Value and tostring(Value) or "Switch"
                elseif Index == "Value" then
                    for i,v in ipairs(Tweens[Value]) do
                        v:Play()
                    end
                    local Success, Error = pcall(Properties.Function, Value)
                    assert(MyGui.Settings.Debug == false or Success, Error)
                end
                Properties[Index] = Value
            end;
        })
    end

    function Options.Toggle(Title, Callback)
        local Properties = {
            Title = Title and tostring(Title) or "Switch";
            Value = false;
            Function = Callback or function(Status) end;
        }

        local Container = Utility.new("ImageButton", {
            Name = "Toggle",
            Parent = typeof(Frame) == "Instance" and Frame or Frame(),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25)
        }, {
            Utility.new("TextLabel", {
                Name = "Title",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Font = Enum.Font.Gotham,
                Text = Title and tostring(Title) or "Switch",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextTransparency = 0.3,
                TextXAlignment = Enum.TextXAlignment.Left
            }),

            Utility.new("ImageLabel", {
                Name = "Toggle",
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0, 20, 0, 20),
                ZIndex = 2,
                Image = "rbxassetid://6031068420"
            }, {
                Utility.new("ImageLabel", {
                    Name = "Fill",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Image = "rbxassetid://6031068421",
                    ImageTransparency = 1
                })
            })
        })

        local Tweens = {
            [true] = {
                Utility.Tween(Container.Toggle.Fill, TweenInfo.new(0.2), {ImageTransparency = 0}),
                Utility.Tween(Container.Toggle, TweenInfo.new(0.5), {ImageColor3 = Color3.fromRGB(240, 240, 240)})
            };
            [false] = {
                Utility.Tween(Container.Toggle.Fill, TweenInfo.new(0.2), {ImageTransparency = 1}),
                Utility.Tween(Container.Toggle, TweenInfo.new(0.5), {ImageColor3 = Color3.fromRGB(255, 255, 255)})
            };
        }

        Container.MouseButton1Down:Connect(function()
            Properties.Value = not Properties.Value
            for i,v in ipairs(Tweens[Properties.Value]) do
                v:Play()
            end
            local Success, Error = pcall(Properties.Function, Properties.Value)
            assert(MyGui.Settings.Debug == false or Success, Error)
        end)

        return setmetatable({}, {
            __index = function(Self, Index)
                return Properties[Index]
            end;
            __newindex = function(Self, Index, Value)
                if Index == "Title" then
                    Container.Title.Text = Value and tostring(Value) or "Switch"
                elseif Index == "Value" then
                    for i,v in ipairs(Tweens[Value]) do
                        v:Play()
                    end
                    local Success, Error = pcall(Properties.Function, Value)
                    assert(MyGui.Settings.Debug == false or Success, Error)
                end
                Properties[Index] = Value
            end
        })
    end

    function Options.TextBox(Title, PlaceHolder, Callback)
        local Properties = {
            Title = Title and tostring(Title) or "TextBox";
            Value = "";
            PlaceHolder = PlaceHolder and tostring(PlaceHolder) or "Input";
            Function = Callback or function(Status) end;
        }

        local Container = Utility.new("ImageButton", {
            Name = "TextBox",
            Parent = typeof(Frame) == "Instance" and Frame or Frame(),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25)
        }, {
            Utility.new("TextLabel", {
                Name = "Title",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = Title and tostring(Title) or "TextBox",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextTransparency = 0.3,
                TextXAlignment = Enum.TextXAlignment.Left
            }),
            Utility.new("ImageLabel", {
                Name = "TextBox",
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.new(0.2, 25, 0, 20),
                Image = "rbxassetid://3570695787",
                ImageColor3 = Color3.fromRGB(50, 55, 60),
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(100, 100, 100, 100),
                SliceScale = 0.04
            }, {
                Utility.new("TextBox", {
                    Name = "Input",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Enum.Font.Gotham,
                    PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                    PlaceholderText = PlaceHolder and tostring(PlaceHolder) or "Input",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 12,
                    TextTransparency = 0.3,
                    TextXAlignment = Enum.TextXAlignment.Left
                }, {Utility.new("UIPadding", {PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})})
            })
        })

        Container.MouseButton1Down:Connect(function()
            Container.TextBox.Input:CaptureFocus()
        end)

        Container.TextBox.Input:GetPropertyChangedSignal("Text"):Connect(function()
            local TextLength = Container.TextBox.Input.TextBounds.X
            local MaxSize = (Container.AbsoluteSize.X - Container.Title.TextBounds.X) - 40
            if Container.TextBox.Input.TextTruncate == Enum.TextTruncate.None then
                Utility.Tween(Container.TextBox, TweenInfo.new(0.1), {Size = UDim2.new(0.2, math.clamp(TextLength - (Container.AbsoluteSize.X * 0.2) + 15, 25, MaxSize), 0, 20)}):Play()
            end
            Container.TextBox.Input.TextTruncate = TextLength + 10 > MaxSize and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None
            Properties.Value = Container.TextBox.Input.Text
        end)

        Container.TextBox.Input.FocusLost:Connect(function(EnterPressed, Input)
            if EnterPressed then
                coroutine.wrap(function()
                    local Success, Error = pcall(Properties.Function, Properties.Value)
                    assert(MyGui.Settings.Debug == false or Success, Error)
                end)
                Container.TextBox.Input.Text = ""
            end
        end)

        return setmetatable({}, {
            __index = function(Self, Index)
                return Properties[Index]
            end;
            __newindex = function(Self, Index, Value)
                if Index == "Title" then
                    Container.Title.Text = Value and tostring(Value) or "TextBox"
                elseif Index == "Placeholder" then
                    Container.TextBox.Input.PlaceholderText = Value and tostring(Value) or "Input"
                elseif Index == "Value" then
                    Container.TextBox.Input.Text = Value and tostring(Value) or ""
                end
                Properties[Index] = Value
            end
        })
    end

    function Options.SwitchAndBinding(Title, Callback)
        local Properties = {
            Title = Title and tostring(Title) or "Switch",
            Value = false,
            Function = Callback or function(Status) end,
            Keybind = nil
        }

        local Container = Utility.new("ImageButton", {
            Name = "SwitchContainer",
            Parent = typeof(Frame) == "Instance" and Frame or Frame(),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25),
        })

        local Binding = false
        local CurrentKey = nil
        local IgnoreNextInput = false

        -- Заголовок
        local TitleLabel = Utility.new("TextLabel", {
            Name = "Title",
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, -30, 1, 0),
            Font = Enum.Font.Gotham,
            Text = Properties.Title,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            TextTransparency = 0.3,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        TitleLabel.Parent = Container

        -- Кнопка бинда
        local KeybindButton = Utility.new("TextButton", {
            Name = "Keybind",
            Parent = Container,
            BackgroundColor3 = Color3.fromRGB(50, 55, 60),
            Size = UDim2.new(0, 40, 0, 18),
            Position = UDim2.new(1, -70, 0.5, -9),
            Text = "None",
            Font = Enum.Font.Gotham,
            TextSize = 9,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextWrapped = false,
            ClipsDescendants = true
        }, {
            Utility.new("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Utility.new("UIPadding", {PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 2)})
        })

        KeybindButton.MouseButton1Down:Connect(function()
            if Binding then
                Binding = false
                CurrentKey = nil
                Properties.Keybind = nil
                KeybindButton.Text = "None"
            else
                Binding = true
                KeybindButton.Text = "..."
            end
        end)

        local SwitchFrame = Utility.new("Frame", {
            Name = "Switch",
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0, 25, 0, 15),
        }, {
            Utility.new("UICorner", {CornerRadius = UDim.new(1, 0)}),
            Utility.new("Frame", {
                Name = "Circle",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(0, 14, 0, 14)
            }, {Utility.new("UICorner", {CornerRadius = UDim.new(1, 0)})})
        })
        SwitchFrame.Parent = Container

        local Tweens = {
            [true] = {
                Utility.Tween(SwitchFrame, TweenInfo.new(0.5), {BackgroundColor3 = MyGui.ColorScheme.Primary}),
                Utility.Tween(SwitchFrame.Circle, TweenInfo.new(0.25), {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0)})
            },
            [false] = {
                Utility.Tween(SwitchFrame, TweenInfo.new(0.5), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}),
                Utility.Tween(SwitchFrame.Circle, TweenInfo.new(0.25), {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0)})
            }
        }

        local function ToggleSwitch()
            if Binding then return end
            Properties.Value = not Properties.Value
            for _, tween in ipairs(Tweens[Properties.Value]) do
                tween:Play()
            end
            local Success, Error = pcall(Properties.Function, Properties.Value)
            assert(MyGui.Settings.Debug == false or Success, Error)
        end

        Container.MouseButton1Down:Connect(ToggleSwitch)

        Services.UserInputService.InputBegan:Connect(function(Input, Processed)
            if Processed then return end

            if Binding then
                if Input.UserInputType == Enum.UserInputType.Keyboard then
                    if Input.KeyCode == Enum.KeyCode.Delete then
                        CurrentKey = nil
                        Properties.Keybind = nil
                        KeybindButton.Text = "None"
                    else
                        CurrentKey = Input.KeyCode
                        Properties.Keybind = CurrentKey
                        KeybindButton.Text = tostring(CurrentKey):gsub("Enum.KeyCode.", "")
                    end
                    Binding = false
                    IgnoreNextInput = true
                end
                return
            end

            if IgnoreNextInput then
                IgnoreNextInput = false
                return
            end

            if CurrentKey and Input.KeyCode == CurrentKey then
                ToggleSwitch()
            end
        end)

        return setmetatable({}, {
            __index = function(_, Index)
                return Properties[Index]
            end,
            __newindex = function(_, Index, Value)
                if Index == "Title" then
                    TitleLabel.Text = Value
                elseif Index == "Value" then
                    for _, tween in ipairs(Tweens[Value]) do
                        tween:Play()
                    end
                    local Success, Error = pcall(Properties.Function, Value)
                    assert(MyGui.Settings.Debug == false or Success, Error)
                elseif Index == "Keybind" then
                    CurrentKey = Value
                    KeybindButton.Text = Value and tostring(Value):gsub("Enum.KeyCode.", "") or "None"
                end
                Properties[Index] = Value
            end
        })
    end

    function Options.ModeSetting(Title, OptionsList, Callback)
        local Properties = {
            Title = Title or "Mode",
            Options = OptionsList or {"Option1", "Option2"},
            Selected = OptionsList[1],
            Function = Callback or function(Selected) end
        }

        -- Получаем родительский контейнер и считаем количество уже существующих элементов
        local ParentContainer = typeof(Frame) == "Instance" and Frame or Frame()
        local existingChildren = ParentContainer:GetChildren()
        local moduleCount = 0

        for _, child in ipairs(existingChildren) do
            if child:IsA("ImageButton") and child.Name:find("ModeContainer") then
                moduleCount = moduleCount + 1
            end
        end

        -- Вычисляем позицию для нового модуля
        local yOffset = moduleCount * 30  -- 25 высота + 5 отступ

        local Container = Utility.new("ImageButton", {
            Name = "ModeContainer",
            Parent = ParentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 0, 0, yOffset)  -- Автоматическое позиционирование
        })

        -- Заголовок
        local TitleLabel = Utility.new("TextLabel", {
            Name = "Title",
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, -80, 1, 0),
            Font = Enum.Font.Gotham,
            Text = Properties.Title,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            TextTransparency = 0.3,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        TitleLabel.Parent = Container

        local DropdownButton = Utility.new("TextButton", {
            Name = "DropdownButton",
            Parent = Container,
            BackgroundColor3 = Color3.fromRGB(50, 55, 60),
            Size = UDim2.new(0, 70, 0, 18),
            Position = UDim2.new(1, -75, 0.5, -9),
            Text = Properties.Selected,
            Font = Enum.Font.Gotham,
            TextSize = 9,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextWrapped = false,
            ClipsDescendants = true
        }, {
            Utility.new("UICorner", {CornerRadius = UDim.new(0, 4)}),
            Utility.new("UIPadding", {PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 2)})
        })

        local DropdownOpen = false
        local ListContainer = Utility.new("Frame", {
            Name = "DropdownList",
            Parent = Container,
            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
            Position = UDim2.new(1, -70, 1, 0),
            Size = UDim2.new(0, 70, 0, #Properties.Options * 18),
            Visible = false,
            ClipsDescendants = true
        }, {
            Utility.new("UICorner", {CornerRadius = UDim.new(0, 4)})
        })

        for i, option in ipairs(Properties.Options) do
            local OptionButton = Utility.new("TextButton", {
                Name = "Option_" .. option,
                Parent = ListContainer,
                BackgroundColor3 = Color3.fromRGB(50, 55, 60),
                Size = UDim2.new(1, 0, 0, 18),
                Position = UDim2.new(0, 0, 0, (i-1)*18),
                Text = option,
                Font = Enum.Font.Gotham,
                TextSize = 9,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }, {
                Utility.new("UICorner", {CornerRadius = UDim.new(0, 4)})
            })

            OptionButton.MouseButton1Click:Connect(function()
                Properties.Selected = option
                DropdownButton.Text = option
                ListContainer.Visible = false
                DropdownOpen = false
                local Success, Error = pcall(Properties.Function, option)
                assert(MyGui.Settings.Debug == false or Success, Error)
            end)
        end

        -- Логика открытия/закрытия
        DropdownButton.MouseButton1Click:Connect(function()
            DropdownOpen = not DropdownOpen
            ListContainer.Visible = DropdownOpen
        end)

        -- Обновляем размер родительского контейнера, если это необходимо
        if ParentContainer:IsA("ScrollingFrame") then
            ParentContainer.CanvasSize = UDim2.new(0, 0, 0, (moduleCount + 1) * 30)
        end

        -- Метатаблица для удобного доступа
        return setmetatable({}, {
            __index = function(_, Index)
                return Properties[Index]
            end,
            __newindex = function(_, Index, Value)
                if Index == "Selected" then
                    Properties.Selected = Value
                    DropdownButton.Text = Value
                    local Success, Error = pcall(Properties.Function, Value)
                    assert(MyGui.Settings.Debug == false or Success, Error)
                elseif Index == "Options" then
                    Properties.Options = Value
                    -- Можно добавить обновление GUI, если нужно
                end
                Properties[Index] = Value
            end
        })
    end
    
    function Options.Binding(Title, Callback)
        local Properties = {
            Title = Title and tostring(Title) or "Bind",
            Keybind = nil,
            Function = Callback or function() end,
        }

        local Binding = false

        -- контейнер
        local Container = Utility.new("Frame", {
            Name = "BindContainer",
            Parent = Frame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 25),
        })

        -- название
        local TitleLabel = Utility.new("TextLabel", {
            Name = "Title",
            Parent = Container,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, -50, 1, 0),
            Font = Enum.Font.Gotham,
            Text = Properties.Title,
            TextSize = 14,
            TextTransparency = 0.3,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            AnchorPoint = Vector2.new(0, 0.5),
            TextXAlignment = Enum.TextXAlignment.Left
        })

        -- кнопка бинда
        local KeyButton = Utility.new("TextButton", {
            Name = "KeybindButton",
            Parent = Container,
            BackgroundColor3 = Color3.fromRGB(50, 55, 60),
            Size = UDim2.new(0, 40, 0, 18),
            Position = UDim2.new(1, -45, 0.5, -9),
            Text = "None",
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextColor3 = Color3.fromRGB(255, 255, 255),
        }, {
            Utility.new("UICorner", {CornerRadius = UDim.new(0, 4)})
        })

        KeyButton.MouseButton1Down:Connect(function()
            Binding = true
            KeyButton.Text = "..."
        end)

        Services.UserInputService.InputBegan:Connect(function(Input, Processed)
            if Processed then return end

            if Binding then
                if Input.UserInputType == Enum.UserInputType.Keyboard then

                    if Input.KeyCode == Enum.KeyCode.Delete then
                        Properties.Keybind = nil
                        KeyButton.Text = "None"
                    else
                        Properties.Keybind = Input.KeyCode
                        KeyButton.Text = tostring(Input.KeyCode):gsub("Enum.KeyCode.", "")
                    end

                    Binding = false
                end
                return
            end

            -- trigger
            if Properties.Keybind and Input.KeyCode == Properties.Keybind then
                pcall(Properties.Function, Properties.Keybind)
            end
        end)

        return setmetatable({}, {
            __index = function(_, Index)
                return Properties[Index]
            end,
            __newindex = function(_, Index, Value)

                if Index == "Title" then
                    TitleLabel.Text = Value

                elseif Index == "Keybind" then
                    Properties.Keybind = Value
                    KeyButton.Text = Value and tostring(Value):gsub("Enum.KeyCode.", "") or "None"

                elseif Index == "Function" then
                    Properties.Function = Value
                end

                Properties[Index] = Value
            end
        })
    end

    function Options.Dropdown(Title, List, Callback, Placeholder)

    end

    function Options.Slider(Title, Settings, Callback)
        Settings = Settings or {}

        local Properties = {
            Title = Title or "Slider",
            Value = nil,
            Settings = Settings,
            Function = Callback or function() end,
        }

        for i, v in pairs({
            Precise = false,
            Default = 1,
            Min = 1,
            Max = 10,
            Step = 0.1,
        }) do
            if Properties.Settings[i] == nil then
                Properties.Settings[i] = v
            end
        end

        local Min = Properties.Settings.Min
        local Max = Properties.Settings.Max
        local Step = Properties.Settings.Step

        Properties.Value = math.clamp(Properties.Settings.Default, Min, Max)

        local Container = Utility.new("ImageButton", {
            Name = "Slider",
            Parent = Frame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
        }, {
            Utility.new("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, 2),
                Size = UDim2.new(1, -75, 0, 20),
                Font = Enum.Font.Gotham,
                Text = Title,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextTransparency = 0.3,
                TextXAlignment = Enum.TextXAlignment.Left,
            }),

            Utility.new("TextBox", {
                Name = "Value",
                Active = true,
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, 0, 0, 2),
                Size = UDim2.new(0, 75, 0, 20),
                Font = Enum.Font.Gotham,
                Text = tostring(Properties.Value),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextTransparency = 0.3,
                TextXAlignment = Enum.TextXAlignment.Right,
            }),

            Utility.new("ImageLabel", {
                Name = "Bar",
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0, 25),
                Size = UDim2.new(1, 5, 0, 5),
                Image = "rbxassetid://5028857472",
                ImageColor3 = Color3.fromRGB(20, 20, 20),
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(2, 2, 298, 298),
            }, {
                Utility.new("ImageLabel", {
                    Name = "Fill",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 1, 0),
                    Image = "rbxassetid://5028857472",
                    ImageColor3 = MyGui.ColorScheme.Primary,
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(2, 2, 298, 298),
                }, {
                    Utility.new("Frame", {
                        Name = "Circle",
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        ZIndex = 2,
                        Position = UDim2.new(1, 0, 0.5, 0),
                        Size = UDim2.new(0, 10, 0, 10),
                    }, {
                        Utility.new("UICorner", { CornerRadius = UDim.new(1, 0) }),
                        Utility.new("Frame", {
                            Name = "Ripple",
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            BackgroundTransparency = 0.75,
                            Size = UDim2.new(0, 0, 0, 0),
                        }, {
                            Utility.new("UICorner", { CornerRadius = UDim.new(1, 0) }),
                        }),
                    }),
                }),
            }),
        })

        local Info = {
            Sliding = false,
            LastUpdated = 0,
        }

        local function UpdateSlider(Value)
            if time() - Info.LastUpdated < 0.01 then
                return
            end
            Info.LastUpdated = time()
            Value = math.clamp(Value, Min, Max)
            Value = math.floor(Value / Step + 0.5) * Step
            local decimals = tostring(Step):match("%.(%d+)")
            decimals = decimals and #decimals or 0
            Container.Value.Text = string.format("%." .. decimals .. "f", Value)
            Properties.Value = Value
            local percent = (Value - Min) / (Max - Min)
            Utility.Tween(Container.Bar.Fill, TweenInfo.new(0.1), {
                Size = UDim2.new(percent, 0, 1, 0),
            }):Play()
        end

        Services.UserInputService.InputChanged:Connect(function(Input)
            if Info.Sliding and Input.UserInputType == Enum.UserInputType.MouseMovement then
                local px = Input.Position.X
                local bar = Container.Bar

                local percent = (px - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                UpdateSlider(Min + percent * (Max - Min))

                pcall(Properties.Function, Properties.Value)
            end
        end)

        Container.MouseButton1Down:Connect(function()
            Info.Sliding = true

            local mx = Services.UserInputService:GetMouseLocation().X
            local bar = Container.Bar
            local percent = (mx - bar.AbsolutePosition.X) / bar.AbsoluteSize.X

            UpdateSlider(Min + percent * (Max - Min))
            pcall(Properties.Function, Properties.Value)
        end)

        Container.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Info.Sliding = false
            end
        end)

        Container.Value.FocusLost:Connect(function()
            local n = tonumber(Container.Value.Text)
            if not n then
                n = Min
            end
            UpdateSlider(n)
            pcall(Properties.Function, Properties.Value)
        end)

        UpdateSlider(Properties.Value)

        return setmetatable({}, {
            __index = function(_, Index)
                return Properties[Index]
            end,
            __newindex = function(_, Index, Value)
                if Index == "Value" then
                    UpdateSlider(Value)
                end
                Properties[Index] = Value
            end,
        })
    end

    return Options
end

function MyGui.new(Name, Header, Icon)
    local Main = Utility.new(
    -- Class --
            "ImageButton",

    -- Properties --
            {
                Name = "Main",
                Parent = MyGui.ScreenGui,
                Active = true,
                Modal = true,
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                Size = UDim2.new(0, 700, 0, 475),
                ZIndex = 0,
                ClipsDescendants = true,
                Image = "rbxassetid://3570695787",
                ImageColor3 = Color3.fromRGB(50, 53, 59),
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(100, 100, 100, 100),
                SliceScale = 0.1
            },

    -- Children --
            {
                -- Contents
                Utility.new("Frame", {
                    Name = "Contents",
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Position = UDim2.new(0, 200, 0, 0),
                    Size = UDim2.new(1, -200, 1, 0),
                    ZIndex = 0
                }, {
                    Utility.new("UIPageLayout", {
                        EasingStyle = Enum.EasingStyle.Quad,
                        TweenTime = 0.25,
                        FillDirection = Enum.FillDirection.Vertical,
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        GamepadInputEnabled = false,
                        ScrollWheelInputEnabled = false,
                        TouchInputEnabled = false
                    })
                }),

                -- SideBar
                Utility.new("ImageLabel", {
                    Name = "SideBar",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 200, 1, 0),
                    Image = "rbxassetid://3570695787",
                    ImageColor3 = Color3.fromRGB(47, 49, 54),
                    ScaleType = Enum.ScaleType.Slice,
                    SliceCenter = Rect.new(100, 100, 100, 100),
                    SliceScale = 0.1
                }, {
                    -- Info
                    Utility.new("Frame", {
                        Name = "Info",
                        BackgroundTransparency = 1,
                        LayoutOrder = -5,
                        Size = UDim2.new(1, 0, 0, 75)
                    }, {
                        Utility.new("ImageLabel", {
                            Name = "Logo",
                            BackgroundTransparency = 1,
                            Size = UDim2.new(0, 30, 0, 30),
                            Image = Icon and "rbxassetid://" .. tostring(Icon) or "rbxassetid://4370345701",
                            ScaleType = Enum.ScaleType.Fit
                        }),
                        Utility.new("TextLabel", {
                            Name = "Title",
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 35, 0, 15),
                            Size = UDim2.new(1, -35, 0, 25),
                            Font = Enum.Font.GothamBold,
                            Text = Name and tostring(Name) or "MyGui",
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextScaled = true,
                            TextWrapped = true,
                            TextXAlignment = Enum.TextXAlignment.Left
                        }),
                        Utility.new("TextLabel", {
                            Name = "Header",
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 0, 0, 32),
                            Size = UDim2.new(0, 125, 0, 15),
                            Font = Enum.Font.Gotham,
                            Text = Header and tostring(Header) or "v1.0.0",
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            TextSize = 15,
                            TextTransparency = 0.3,
                            TextWrapped = true,
                            TextXAlignment = Enum.TextXAlignment.Left
                        }),
                        Utility.new("Frame", {
                            Name = "Divider",
                            AnchorPoint = Vector2.new(0.5, 1),
                            BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                            BackgroundTransparency = 0.25,
                            BorderSizePixel = 0,
                            Position = UDim2.new(0.5, 0, 1, 0),
                            Size = UDim2.new(1, 0, 0, 1)
                        }, {Utility.new("UIGradient", {Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.25, 0.1), NumberSequenceKeypoint.new(1, 1)}})}),

                        Utility.new("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 20)})
                    }),

                    -- Ornaments
                    Utility.new("Folder", {Name = "Ornaments"}, {
                        Utility.new("Frame", {
                            Name = "Shadow",
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 5, 0, 0),
                            Size = UDim2.new(1, 0, 1, 0),
                            ZIndex = 0
                        }, {
                            Utility.new("ImageLabel", {
                                Name = "umbraShadow",
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 2, 1, 2),
                                ZIndex = 0,
                                Image = "rbxassetid://1316045217",
                                ImageColor3 = Color3.fromRGB(0, 0, 0),
                                ImageTransparency = 0.86,
                                ScaleType = Enum.ScaleType.Slice,
                                SliceCenter = Rect.new(10, 10, 118, 118)
                            }),
                            Utility.new("ImageLabel", {
                                Name = "penumbraShadow",
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 2, 1, 2),
                                ZIndex = 0,
                                Image = "rbxassetid://1316045217",
                                ImageColor3 = Color3.fromRGB(0, 0, 0),
                                ImageTransparency = 0.76,
                                ScaleType = Enum.ScaleType.Slice,
                                SliceCenter = Rect.new(10, 10, 118, 118)
                            }),
                            Utility.new("ImageLabel", {
                                Name = "ambientShadow",
                                BackgroundTransparency = 1,
                                Size = UDim2.new(1, 2, 1, 2),
                                ZIndex = 0,
                                Image = "rbxassetid://1316045217",
                                ImageColor3 = Color3.fromRGB(0, 0, 0),
                                ImageTransparency = 0.75,
                                ScaleType = Enum.ScaleType.Slice,
                                SliceCenter = Rect.new(10, 10, 118, 118)
                            })
                        }),
                        Utility.new("Frame", {
                            Name = "Hider",
                            AnchorPoint = Vector2.new(1, 0.5),
                            BackgroundColor3 = Color3.fromRGB(47, 49, 54),
                            BorderSizePixel = 0,
                            Position = UDim2.new(1, 0, 0.5, 0),
                            Size = UDim2.new(0, 5, 1, 0)
                        })
                    }),
                    -- UIListLayout
                    Utility.new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
                }),

                -- UISizeConstraint
                Utility.new("UISizeConstraint", {MaxSize = Vector2.new(1400, 950), MinSize = Vector2.new(300, 200)})
            }
    )
    local DragPro = Utility.CreateDrag(Main, Main, {TweenDuration = 0.15, TweenStyle = Enum.EasingStyle.Quad})
    local UIPageLayout = Main.Contents.UIPageLayout

    -- Scripts --
    Main.SideBar.MouseWheelBackward:Connect(function()
        UIPageLayout:Next()
    end)

    Main.SideBar.MouseWheelForward:Connect(function()
        UIPageLayout:Previous()
    end)

    -- Window --
    local Window = {
        Title = Name and tostring(Name) or "MyGui";
        Header = Header and tostring(Header) or "v1.0.0";
        Icon = tostring(Icon) or "4370345701";
        Toggled = true;
    }

    local WindowInfo = {
        SizeSave = UDim2.new(0, 700, 0, 500)
    }

    function Window:Toggle(Value)
        Window.Toggled = Value or not Window.Toggled

        -- Инициализация сохранённых значений при первом открытии
        WindowInfo.SizeSave = WindowInfo.SizeSave or Main.Size
        WindowInfo.PositionSave = WindowInfo.PositionSave or Main.Position
        WindowInfo.AnchorSave = WindowInfo.AnchorSave or Main.AnchorPoint

        if Window.Toggled then
            -- Восстанавливаем позицию и размер
            Main.Visible = true
            Main.AnchorPoint = WindowInfo.AnchorSave
            Main.Position = WindowInfo.PositionSave

            Utility.Tween(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = WindowInfo.SizeSave
            }):Yield()
        else
            -- Сохраняем текущий размер и позицию
            WindowInfo.SizeSave = Main.Size
            WindowInfo.PositionSave = Main.Position
            WindowInfo.AnchorSave = Main.AnchorPoint

            -- Анимация закрытия: сжатие к центру окна
            local centerOffset = UDim2.fromOffset(WindowInfo.SizeSave.X.Offset/2, WindowInfo.SizeSave.Y.Offset/2)
            local targetPos = WindowInfo.PositionSave + centerOffset

            Utility.Tween(Main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0,0,0,0),
                Position = targetPos
            }):Yield()

            Main.Visible = false
        end
    end


    function Window.Tab(Title, Icon)
        local TabFrame = Utility.new("ScrollingFrame", {
            Name = "Tab",
            Parent = Main.Contents,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, -40),
            ScrollBarThickness = 0
        }, {
            Utility.new("UIListLayout", {HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10)})
        })

        local TabButton = Utility.new("Frame", {
            Name = "Button",
            Parent = Main.SideBar,
            BackgroundColor3 = MyGui.ColorScheme.Primary,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 40)
        }, {
            Utility.new("ImageLabel", {
                Name = "Icon",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0.5, 0),
                Size = UDim2.new(0, 20, 0, 20),
                Image = Icon and "rbxassetid://" .. tostring(Icon) or "rbxassetid://6023426915",
                ImageTransparency = 0.3
            }),
            Utility.new("TextLabel", {
                Name = "Title",
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 40, 0.5, 0),
                Size = UDim2.new(1, -50, 0, 19),
                Font = Enum.Font.Gotham,
                Text = Title and tostring(Title) or "Tab",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 15,
                TextTransparency = 0.3,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left
            })
        })

        -- Scripts --
        TabFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabFrame.UIListLayout.AbsoluteContentSize.Y)
        end)

        TabButton.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                UIPageLayout:JumpTo(TabFrame)
                Utility.Wait()
                DragPro.Dragging = false
            end
        end)

        local ButtonTweens = {
            Focused = {
                Utility.Tween(TabButton, TweenInfo.new(0.25), {BackgroundTransparency = 0}),
                Utility.Tween(TabButton.Title, TweenInfo.new(0.25), {TextTransparency = 0}),
                Utility.Tween(TabButton.Icon, TweenInfo.new(0.25), {ImageTransparency = 0})
            };
            Idle = {
                Utility.Tween(TabButton, TweenInfo.new(0.25), {BackgroundTransparency = 1}),
                Utility.Tween(TabButton.Title, TweenInfo.new(0.25), {TextTransparency = 0.3}),
                Utility.Tween(TabButton.Icon, TweenInfo.new(0.25), {ImageTransparency = 0.3})
            };
            Selected = false;
        }

        UIPageLayout:GetPropertyChangedSignal("CurrentPage"):Connect(function()
            local PageFocused = UIPageLayout.CurrentPage == TabFrame
            if PageFocused and ButtonTweens.Selected == false then
                for i,v in ipairs(ButtonTweens.Focused) do
                    v:Play()
                end
            elseif PageFocused == false and ButtonTweens.Selected == true then
                for i,v in ipairs(ButtonTweens.Idle) do
                    v:Play()
                end
            end
            ButtonTweens.Selected = PageFocused
        end)

        -- Tab --
        local Tab = {}

        function Tab.Folder(Title, Description)
            local Properties = {}

            local Base =  Utility.new("ImageLabel", {
                Name = "Content",
                Parent = TabFrame,
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Size = UDim2.new(1, 0, 0, 40),
                Image = "rbxassetid://3570695787",
                ImageColor3 = Color3.fromRGB(64, 68, 75),
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(100, 100, 100, 100),
                SliceScale = 0.05
            }, {
                -- Icon --
                Utility.new("ImageLabel", {
                    Name = "Icon",
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 10),
                    Size = UDim2.new(0, 10, 0, 10),
                    Image = "rbxassetid://6031625146",
                    ImageTransparency = 0.3
                }),

                -- Title --
                Utility.new("TextLabel", {
                    Name = "Title",
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 20, 0, 10),
                    Size = UDim2.new(1, -50, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = Title and tostring(Title) or "Folder",
                    RichText = true,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 15,
                    TextTransparency = 0.3,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),

                -- Arrow --
                Utility.new("ImageLabel", {
                    Name = "Arrow",
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 10),
                    Size = UDim2.new(0, 25, 0, 25),
                    Image = "rbxassetid://6034818372",
                    ImageTransparency = 0.3,
                    ScaleType = Enum.ScaleType.Fit,
                    SliceCenter = Rect.new(30, 30, 30, 30),
                    SliceScale = 7
                }),

                -- UIPadding --
                Utility.new("UIPadding", {PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10)}),

                -- Info --
                Utility.new("ImageButton", {
                    Name = "Info",
                    Active = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 0)
                }, {
                    Utility.new("TextLabel", {
                        Name = "Description",
                        BackgroundTransparency = 1,
                        LayoutOrder = -5,
                        Size = UDim2.new(1, 0, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = Description and tostring(Description) or "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras justo urna, mattis et neque non.",
                        RichText = true,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 14,
                        TextTransparency = 0.3,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top
                    }),
                    Utility.new("UIListLayout", {
                        Padding = UDim.new(0, 1),
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                })
            })
            Base.Info.Description.Size = UDim2.new(1, 0, 0, Services.TextService:GetTextSize(Base.Info.Description.Text, 14, Enum.Font.Gotham, Vector2.new(Base.Info.Description.AbsoluteSize.X, math.huge)).Y + 5)

            local Info = {
                Collapsed = true;
            }

            local Tweens = {
                [true] = {
                    function()
                        Utility.Tween(Base, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 45 + Base.Info.UIListLayout.AbsoluteContentSize.Y)}):Play()
                        Utility.Wait(0.1)
                        Base.Icon.Image = "rbxassetid://6026681577"
                    end,
                    Utility.Tween(Base.Arrow, TweenInfo.new(0.5), {ImageTransparency = 0, Rotation = 180}),
                    Utility.Tween(Base.Title, TweenInfo.new(0.5), {TextTransparency = 0, TextColor3 = MyGui.ColorScheme.Primary}),
                    Utility.Tween(Base.Icon, TweenInfo.new(0.5), {ImageTransparency = 0, ImageColor3 = MyGui.ColorScheme.Primary}),
                };
                [false] = {
                    function()
                        Utility.Wait(0.1)
                        Base.Icon.Image = "rbxassetid://6031625146"
                    end,
                    Utility.Tween(Base, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 40)}),
                    Utility.Tween(Base.Arrow, TweenInfo.new(0.5), {ImageTransparency = 0.3, Rotation = 0}),
                    Utility.Tween(Base.Title, TweenInfo.new(0.5), {TextTransparency = 0.3, TextColor3 = Color3.fromRGB(255, 255, 255)}),
                    Utility.Tween(Base.Icon, TweenInfo.new(0.5), {ImageTransparency = 0.3, ImageColor3 = Color3.fromRGB(255, 255, 255)})
                };
            }

            Base.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    for i,v in ipairs(Tweens[Info.Collapsed]) do
                        if typeof(v) == "function" then
                            coroutine.wrap(v)()
                        else
                            v:Play()
                        end
                    end
                    Info.Collapsed = not Info.Collapsed
                    Utility.Wait()
                    DragPro.Dragging = false
                end
            end)

            Base.Info.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Base.Info.Size = UDim2.new(1, 0, 0, Base.Info.UIListLayout.AbsoluteContentSize.Y + 5)
            end)

            -- Folder --
            for i,v in pairs(CreateOptions(Base.Info)) do
                Properties[i] = v
            end

            return setmetatable({}, {
                __index = function(Self, Index)
                    return Properties[Index]
                end;
                __newindex = function(Self, Index, Value)
                    if Index == "Title" then
                        Base.Title.Text = Value and tostring(Value) or "Folder"
                    elseif Index == "Description" then
                        Base.Info.Description.Text = Value and tostring(Value) or "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras justo urna, mattis et neque non."
                        Base.Info.Description.Size = UDim2.new(1, 0, 0, Services.TextService:GetTextSize(Base.Info.Description.Text, 14, Enum.Font.Gotham, Vector2.new(Base.Info.Description.AbsoluteSize.X, math.huge)).Y + 5)
                    end
                    rawset(Properties, Index, Value)
                end;
            })
        end

        function Tab.Cheat(Title, Description, Callback)
            local Properties = {
                Function = Callback or function(Status) end;
            }

            local Base = Utility.new("ImageLabel", {
                Name = "Content",
                Parent = TabFrame,
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Size = UDim2.new(1, 0, 0, 40),
                Image = "rbxassetid://3570695787",
                ImageColor3 = Color3.fromRGB(64, 68, 75),
                ScaleType = Enum.ScaleType.Slice,
                SliceCenter = Rect.new(100, 100, 100, 100),
                SliceScale = 0.05
            }, {
                -- Icon --
                Utility.new("ImageLabel", {
                    Name = "Icon",
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 10),
                    Size = UDim2.new(0, 10, 0, 10),
                    Image = "rbxassetid://6031625146",
                    ImageTransparency = 0.3
                }),

                -- Title --
                Utility.new("TextLabel", {
                    Name = "Title",
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 20, 0, 10),
                    Size = UDim2.new(1, -50, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = Title and tostring(Title) or "Cheat",
                    RichText = true,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 15,
                    TextTransparency = 0.3,
                    TextXAlignment = Enum.TextXAlignment.Left
                }),

                -- Switch --
                Utility.new("ImageButton", {
                    Name = "Switch",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Color3.fromRGB(100, 100, 100),
                    Position = UDim2.new(1, -30, 0, 10),
                    Size = UDim2.new(0, 30, 0, 15)
                }, {
                    Utility.new("UICorner", {CornerRadius = UDim.new(1, 0)}),
                    Utility.new("Frame", {
                        Name = "Circle",
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Position = UDim2.new(0, 0, 0.5, 0),
                        Size = UDim2.new(0, 14, 0, 14)
                    }, {Utility.new("UICorner", {CornerRadius = UDim.new(1, 0)})})
                }),

                -- Arrow --
                Utility.new("ImageLabel", {
                    Name = "Arrow",
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, 0, 0, 10),
                    Size = UDim2.new(0, 25, 0, 25),
                    Image = "rbxassetid://6034818372",
                    ImageTransparency = 0.3,
                    ScaleType = Enum.ScaleType.Fit,
                    SliceCenter = Rect.new(30, 30, 30, 30),
                    SliceScale = 7
                }),

                -- UIPadding --
                Utility.new("UIPadding", {PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10)}),

                -- Info --
                Utility.new("ImageButton", {
                    Name = "Info",
                    Active = true,
                    AnchorPoint = Vector2.new(0.5, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 0),
                    ImageTransparency = 1
                }, {
                    Utility.new("TextLabel", {
                        Name = "Description",
                        BackgroundTransparency = 1,
                        LayoutOrder = -5,
                        Size = UDim2.new(1, 0, 0, 30),
                        Font = Enum.Font.Gotham,
                        Text = Description and tostring(Description) or "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras justo urna, mattis et neque non.",
                        RichText = true,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 14,
                        TextTransparency = 0.3,
                        TextWrapped = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Top
                    }),
                    Utility.new("UIListLayout", {
                        Padding = UDim.new(0, 1),
                        HorizontalAlignment = Enum.HorizontalAlignment.Center,
                        SortOrder = Enum.SortOrder.LayoutOrder
                    })
                })
            })
            Base.Info.Description.Size = UDim2.new(1, 0, 0, Services.TextService:GetTextSize(Base.Info.Description.Text, 14, Enum.Font.Gotham, Vector2.new(Base.Info.Description.AbsoluteSize.X, math.huge)).Y + 5)

            local Info = {
                Toggled = false;
                Collapsed = true;
            }

            local FolderTweens = {
                [true] = {
                    function()
                        Utility.Tween(Base, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 45 + Base.Info.UIListLayout.AbsoluteContentSize.Y)}):Play()
                        Utility.Wait(0.1)
                        Base.Icon.Image = "rbxassetid://6026681577"
                    end,
                    Utility.Tween(Base.Arrow, TweenInfo.new(0.5), {ImageTransparency = 0, Rotation = 180}),
                    Utility.Tween(Base.Title, TweenInfo.new(0.5), {TextTransparency = 0, TextColor3 = MyGui.ColorScheme.Primary}),
                    Utility.Tween(Base.Icon, TweenInfo.new(0.5), {ImageTransparency = 0, ImageColor3 = MyGui.ColorScheme.Primary}),
                };
                [false] = {
                    function()
                        Utility.Wait(0.1)
                        Base.Icon.Image = "rbxassetid://6031625146"
                    end,
                    Utility.Tween(Base, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 0, 40)}),
                    Utility.Tween(Base.Arrow, TweenInfo.new(0.5), {ImageTransparency = 0.3, Rotation = 0}),
                    Utility.Tween(Base.Title, TweenInfo.new(0.5), {TextTransparency = 0.3, TextColor3 = Color3.fromRGB(255, 255, 255)}),
                    Utility.Tween(Base.Icon, TweenInfo.new(0.5), {ImageTransparency = 0.3, ImageColor3 = Color3.fromRGB(255, 255, 255)}),
                };
            }

            local SwitchTweens = {
                [true] = {
                    Utility.Tween(Base.Switch, TweenInfo.new(0.5), {BackgroundColor3 = MyGui.ColorScheme.Primary}),
                    Utility.Tween(Base.Switch.Circle, TweenInfo.new(0.25), {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0)})
                };

                [false] = {
                    Utility.Tween(Base.Switch, TweenInfo.new(0.5), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}),
                    Utility.Tween(Base.Switch.Circle, TweenInfo.new(0.25), {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0)})
                };
            }

            Base.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    for i,v in ipairs(FolderTweens[Info.Collapsed]) do
                        if typeof(v) == "function" then
                            coroutine.wrap(v)()
                        else
                            v:Play()
                        end
                    end
                    Info.Collapsed = not Info.Collapsed
                    Utility.Wait()
                    DragPro.Dragging = false
                end
            end)

            Base.Switch.MouseButton1Down:Connect(function()
                Info.Toggled = not Info.Toggled
                for i,v in ipairs(SwitchTweens[Info.Toggled]) do
                    v:Play()
                end
                local Success, Error = pcall(Properties.Function, Info.Toggled)
                assert(MyGui.Settings.Debug == false or Success, Error)
            end)

            Base.Info.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Base.Info.Size = UDim2.new(1, 0, 0, Base.Info.UIListLayout.AbsoluteContentSize.Y + 5)
            end)

            -- Cheat --
            for i,v in pairs(CreateOptions(Base.Info)) do
                Properties[i] = v
            end

            return setmetatable({}, {
                __index = function(Self, Index)
                    return Properties[Index]
                end;
                __newindex = function(Self, Index, Value)
                    if Index == "Title" then
                        Base.Title.Text = Value and tostring(Value) or "Cheat"
                    elseif Index == "Description" then
                        Base.Info.Description.Text = Value and tostring(Value) or "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras justo urna, mattis et neque non."
                        Base.Info.Description.Size = UDim2.new(1, 0, 0, Services.TextService:GetTextSize(Base.Info.Description.Text, 14, Enum.Font.Gotham, Vector2.new(Base.Info.Description.AbsoluteSize.X, math.huge)).Y + 5)
                    elseif Index == "Value" then
                        Info.Toggled = Value
                        for i,v in ipairs(SwitchTweens[Info.Toggled]) do
                            v:Play()
                        end
                        local Success, Error = pcall(Properties.Function, Info.Toggled)
                        assert(MyGui.Settings.Debug == false or Success, Error)
                    end
                    rawset(Self, Index, Value)
                end
            })
        end

        return setmetatable(Tab, {__newindex = function(Self, Index, Value)
            if Index == "Title" then
                TabButton.Title.Text = Value and tostring(Value) or "Tab"
            elseif Index == "Icon" then
                TabButton.Icon.Image = Value and "rbxassetid://" .. tostring(Value) or "rbxassetid://4370345701"
            end
        end})
    end

    function Window:Alert()

    end

    return setmetatable(Window, {__newindex = function(Self, Index, Value)
        if Index == "Title" then
            Main.SideBar.Info.Title.Text = Value and tostring(Value) or "MyGui"
        elseif Index == "Header" then
            Main.SideBar.Info.Header.Text = Value and tostring(Value) or "v1.0.0"
        elseif Index == "Icon" then
            Main.SideBar.Info.Logo.Image = Value and "rbxassetid://" .. tostring(Value) or "rbxassetid://4370345701"
        end
        rawset(Self, Index, Value)
    end})
end

return MyGui