local Category = {}
Category.__index = Category

Category.type = {}

function Category:drawCategory(Window)
    local Tabs = { Main = Window:AddTab('Main'),
                   Character = Window:AddTab('Character'),
                   Visuals = Window:AddTab('Visuals'),
                   Misc = Window:AddTab('Misc'),
                   Players = Window:AddTab('Players'),
                   ['UI Settings'] = Window:AddTab('UI Settings') }
end

return Category
