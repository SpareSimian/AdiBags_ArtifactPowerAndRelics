--[[
AdiBags_Legion - Adds Legion items filter to AdiBags.
Based on AdiBags_Bound Copyright 2010-2015 Kevin (kevin@outroot.com)
--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
-- localization table
local L = setmetatable({}, {__index = addon.L})

do -- Localization
  L['LegionKey'] = 'Legion'
  L['Legion'] = 'Legion items'
  L['Put Legion items in their own sections.'] = 'Put Legion items in their own sections.'
  -- color determined empirically
  L['ArtifactPowerTooltip'] = '|cFFE6CC80Artifact Power|r'
  L['ArtifactRelicTooltip'] = 'Artifact Relic'
  L['ArtifactPowerSectionTitle'] = 'Power'
  L['ArtifactRelicsSectionTitle'] = 'Relic'
  L['Enable Legion items'] = 'Enable Legion items'
  L['Check this if you want sections for Legion items.'] = 'Check this if you want sections for Legionitems.'

  local locale = GetLocale()
  if locale == "frFR" then

  elseif locale == "deDE" then
    
  elseif locale == "esMX" then
    
  elseif locale == "ruRU" then
    
  elseif locale == "esES" then
    
  elseif locale == "zhTW" then
    
  elseif locale == "zhCN" then
    
  elseif locale == "koKR" then
    
  end
end

local tooltip
local function create()
  local tip, leftside = CreateFrame("GameTooltip"), {}
  for i = 1,6 do
    local L,R = tip:CreateFontString(), tip:CreateFontString()
    L:SetFontObject(GameFontNormal)
    R:SetFontObject(GameFontNormal)
    tip:AddFontStrings(L,R)
    leftside[i] = L
  end
  tip.leftside = leftside
  return tip
end

-- The filter itself

-- priority 93, one higher than the bound (BoA/BoE) filter so both BoA and BoE relics are gathered

local setFilter = addon:RegisterFilter("Legion", 93, 'ABEvent-1.0')
setFilter.uiName = L['Legion']
setFilter.uiDesc = L['Put Legion items in their own sections.']

function setFilter:OnInitialize()
  self.db = addon.db:RegisterNamespace('Legion', {
    profile = { enableLegion = true },
    char = {  },
  })
end

function setFilter:Update()
  self:SendMessage('AdiBags_FiltersChanged')
end

function setFilter:OnEnable()
  addon:UpdateFilters()
end

function setFilter:OnDisable()
  addon:UpdateFilters()
end

local setNames = {}

function setFilter:Filter(slotData)

  if IsArtifactPowerItem(slotData.itemId) then
    return L['ArtifactPowerSectionTitle']
  end

  if IsArtifactRelicItem(slotData.itemId) then
    return L['ArtifactRelicsSectionTitle']
  end

--[[
  tooltip = tooltip or create()
  tooltip:SetOwner(UIParent,"ANCHOR_NONE")
  tooltip:ClearLines()

  if slotData.bag == BANK_CONTAINER then
    tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
  else
    tooltip:SetBagItem(slotData.bag, slotData.slot)
  end

  for i = 1,6 do
    local t = tooltip.leftside[i]:GetText()
    if t and self.db.profile.enableLegion then
      if t == L['ArtifactPowerTooltip'] then
        return L['ArtifactPowerSectionTitle']
      end
      -- for relic, relic is preceded by type (eg. iron, storm, frost), so we look for substring
      if string.find(t, L['ArtifactRelicTooltip']) then
        return L['ArtifactRelicsSectionTitle']
      end
    end
  end
  tooltip:Hide()
--]]
end

function setFilter:GetOptions()
  return {
    enableLegion = {
      name = L['Enable Legion items'],
      desc = L['Check this if you want sections for Legion items.'],
      type = 'toggle',
      order = 10,
    },
  }, addon:GetOptionHandler(self, false, function() return self:Update() end)
end
