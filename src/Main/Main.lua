
local EventLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Core/EventLoader.lua"))()

local modules = {
    Chat    = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Chat/UChat.lua",
    Render  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/URender2D.lua",
    FontRender  = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Util/Render/UFontRenderer.lua",

    Updater = "https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/Update/Updater.lua",

    GuiRenderer = 'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Gui/GuiRenderer.lua',

    ModuleLoader = 'https://raw.githubusercontent.com/Okayevls/givemeloot/refs/heads/main/src/Main/Module/ModuleManager.lua'
}

EventLoader:Init(modules)

local Chat = EventLoader:Get("Chat")
local Updater = EventLoader:Get("Updater")
local Render = EventLoader:Get("Render")
local FontRender = EventLoader:Get("FontRender")
local GuiRenderer = EventLoader:Get("GuiRenderer")
local ModuleLoader = EventLoader:Get("ModuleLoader")

local updaterReconnect = Updater:new()

local Window = GuiRenderer.new("ClosedPvP UI", "v0.0.1", 4370345701)

local Tab1 = Window.Tab("Tab 1", 6026568198)

local Folder = Tab1.Folder("Options", "A bunch of options you can use")
Folder.Button("Button", function()
    print("Button Clicked")
end)
Folder.Switch("Switch", function(Status)
    print("Switch Triggered: " .. tostring(Status))
end)
Folder.Toggle("Toggle", function(Status)
    print("Toggle Triggered: " .. tostring(Status))
end)
Folder.TextBox("Textbox", "Placeholder", function(Text)
    print("TextBox Triggered: " .. Text)
end)
Tab1.Folder("ClosedPvP Expanded", "Test this is govnishe.")

local Cheat = Tab1.Cheat("Options", "A bunch of options you can use", function(Status)
    print("Cheat Triggered: " .. tostring(Status))
end)
Cheat.Button("Button", function()
    print("Button Clicked")
end)
Cheat.Switch("Switch", function(Status)
    print("Switch Triggered: " .. tostring(Status))
end)
Cheat.Toggle("Toggle", function(Status)
    print("Toggle Triggered: " .. tostring(Status))
end)
Cheat.Toggle("Toggle", function(Status)
    print("Toggle Triggered: " .. tostring(Status))
end)
Cheat.TextBox("Textbox", "Placeholder", function(Text)
    print("TextBox Triggered: " .. Text)
end)

Tab1.Cheat("Lipsum Expanded", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur eu mollis urna, quis feugiat tellus. Integer ut ligula sodales, sodales ipsum ut, imperdiet ipsum. In aliquet quam et venenatis pulvinar. Nullam fermentum porta felis sit amet interdum. Sed tristique fringilla mollis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam quis tempus mauris, nec ultrices metus. Suspendisse mi urna, accumsan at nisi a, tristique porta libero. Integer lobortis elementum lacus cursus consectetur. Morbi mauris ante, posuere at malesuada et, tristique non ipsum. Proin vitae purus pretium, convallis est vitae, dignissim leo. Praesent nec felis vitae.", function(Status)
    print("Cheat Triggered: " .. tostring(Status))
end)

-- Tab 2 --
local Tab2 = Window.Tab("Tab 2", 6022668945)
local Folder = Tab2.Folder("Options", "A bunch of options you can use")
Folder.Button("Button", function()
    print("Button Clicked")
end)
Folder.Switch("Switch", function(Status)
    print("Switch Triggered: " .. tostring(Status))
end)
Folder.Toggle("Toggle", function(Status)
    print("Toggle Triggered: " .. tostring(Status))
end)
Folder.Toggle("Toggle", function(Status)
    print("Toggle Triggered: " .. tostring(Status))
end)
Folder.TextBox("Textbox", "Placeholder", function(Text)
    print("TextBox Triggered: " .. Text)
end)
Tab2.Folder("Lipsum Expanded", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur eu mollis urna, quis feugiat tellus. Integer ut ligula sodales, sodales ipsum ut, imperdiet ipsum. In aliquet quam et venenatis pulvinar. Nullam fermentum porta felis sit amet interdum. Sed tristique fringilla mollis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam quis tempus mauris, nec ultrices metus. Suspendisse mi urna, accumsan at nisi a, tristique porta libero. Integer lobortis elementum lacus cursus consectetur. Morbi mauris ante, posuere at malesuada et, tristique non ipsum. Proin vitae purus pretium, convallis est vitae, dignissim leo. Praesent nec felis vitae.")

local Cheat = Tab2.Cheat("Options", "A bunch of options you can use", function(Status)
    print("Cheat Triggered: " .. tostring(Status))
end)
Cheat.Button("Button", function()
    print("Button Clicked")
end)
Cheat.Switch("Switch", function(Status)
    print("Switch Triggered: " .. tostring(Status))
end)
Cheat.Toggle("Toggle", function(Status)
    print("Toggle Triggered: " .. tostring(Status))
end)
Cheat.Toggle("Toggle", function(Status)
    print("Toggle Triggered: " .. tostring(Status))
end)
Cheat.TextBox("Textbox", "Placeholder", function(Text)
    print("TextBox Triggered: " .. Text)
end)

Tab2.Cheat("Lipsum Expanded", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur eu mollis urna, quis feugiat tellus. Integer ut ligula sodales, sodales ipsum ut, imperdiet ipsum. In aliquet quam et venenatis pulvinar. Nullam fermentum porta felis sit amet interdum. Sed tristique fringilla mollis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam quis tempus mauris, nec ultrices metus. Suspendisse mi urna, accumsan at nisi a, tristique porta libero. Integer lobortis elementum lacus cursus consectetur. Morbi mauris ante, posuere at malesuada et, tristique non ipsum. Proin vitae purus pretium, convallis est vitae, dignissim leo. Praesent nec felis vitae.", function(Status)
    print("Cheat Triggered: " .. tostring(Status))
end)

game:GetService("UserInputService").InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.F then
        Window:Toggle()
    end
end)


Chat.chat.sendMessage("Created by Prokosik x Flyaga other sucked dick")
Chat.chat.sendMessage("Build to loading 000000002")



