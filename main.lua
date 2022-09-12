--TODO
--make frame display inventory items, filtered to be disenchantable
--make a button next to each item, that will cast disenchant on that item
--make the window resizable and scrollable
--make the window have a tab for milling
--make the window have a tab for prospecting

local disenchantWindow = CreateFrame("Frame",nil,UIParent)

--this integrates with the Ace Library, which adds certain functions for managing flow and state
local addon = LibStub("AceAddon-3.0"):NewAddon("Disenchant", "AceConsole-3.0")

--this adds the minimap button
local disenchantLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Disenchant", {
    type = "data source",
    text = "Disenchant",
    icon = "Interface\\Icons\\inv_enchant_disenchant",
    OnClick = function()
        addon:ShowHideWindow()
    end
})

local icon = LibStub("LibDBIcon-1.0")

--code that runs to initialize the addon
function addon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("DisenchantDB", { profile = { minimap = { hide = false, }, }, }) 
    icon:Register("Disenchant", disenchantLDB, self.db.profile.minimap) 
    self:RegisterChatCommand("disenchant", "ShowHide") 
    addon:CreateDisenchantFrame()
end

--function to show/hide the minimap button that is called by chat command
function addon:ShowHide() 
    self.db.profile.minimap.hide = not self.db.profile.minimap.hide 
    if self.db.profile.minimap.hide 
    then 
        icon:Hide("Disenchant") 
    else 
        icon:Show("Disenchant") 
    end 
end

--function to show/hide the main window, called when the minimap button is pressed
function addon:ShowHideWindow()
    if disenchantWindow:IsShown()
    then 
        disenchantWindow:Hide()
        disenchantWindow:SetParent(nil)
    else 
        disenchantWindow:SetParent(UIParent)
        disenchantWindow:Show()
    end
end

--register and define the window, then stored for access in the disenchantWindow variable
function addon:CreateDisenchantFrame()
    --integrating with the LibWindow library makes it easy to have the window be moveable
    local lwin = LibStub("LibWindow-1.1")
    disenchantWindow = CreateFrame("Frame",nil,UIParent)
    lwin.RegisterConfig(disenchantWindow, self.db.profile) 
    lwin.MakeDraggable (disenchantWindow)
    lwin.RestorePosition(disenchantWindow) -- restores scale also lwin.MakeDraggable(myframe) lwin.EnableMouseOnAlt(myframe) lwin.EnableMouseWheelZoom(myframe)

    disenchantWindow:SetFrameStrata("MEDIUM")
    disenchantWindow:SetWidth(128) -- Set these to whatever height/width is needed 
    disenchantWindow:SetHeight(64) -- for your Texture
    
    disenchantWindow:EnableMouse(true)
    disenchantWindow:SetMovable(true)
    disenchantWindow:SetResizable(true)
    disenchantWindow:SetClampedToScreen(true)


    local t = disenchantWindow:CreateTexture(nil,"BACKGROUND")
    t:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Factions.blp")
    t:SetAllPoints(disenchantWindow)
    disenchantWindow.texture = t

    disenchantWindow:SetPoint("CENTER",0,0)
    disenchantWindow:Hide()
end