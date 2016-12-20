--[[
AdiBags_ArtifactPowerAndRelics - Adds artifact power filter to AdiBags.
Based on AdiBags_Bound Copyright 2010-2015 Kevin (kevin@outroot.com)
--]]

local _, ns = ...

local addon = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
-- localization table
local L = setmetatable({}, {__index = addon.L})

do -- Localization
  L['ArtifactPowerAndRelicsKey'] = 'ArtifactPowerAndRelics'
  L['ArtifactPowerAndRelics'] = 'Artifact power and relics'
  L['Put Artifact Power and Relics in their own sections.'] = 'Put Artifact Power and Relics in their own sections.'
  -- color determined empirically
  L['ArtifactPowerTooltip'] = '|cFFE6CC80Artifact Power|r'
  L['ArtifactRelicTooltip'] = 'Artifact Relic'
  L['ArtifactPowerSectionTitle'] = 'Power'
  L['ArtifactRelicsSectionTitle'] = 'Relic'
  L['Enable Artifact Power and Relics'] = 'Enable Artifact Power and Relics'
  L['Check this if you want sections for Artifact Power and Relic items.'] = 'Check this if you want sections for Artifact Power and Relic items.'

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

local setFilter = addon:RegisterFilter("ArtifactPowerAndRelics", 93, 'ABEvent-1.0')
setFilter.uiName = L['ArtifactPowerAndRelics']
setFilter.uiDesc = L['Put Artifact Power and Relics in their own sections.']

function setFilter:OnInitialize()
  self.db = addon.db:RegisterNamespace('ArtifactPowerAndRelics', {
    profile = { enableArtifactPowerAndRelics = true },
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
    if t and self.db.profile.enableArtifactPowerAndRelics then
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
end

function setFilter:GetOptions()
  return {
    enableArtifactPowerAndRelics = {
      name = L['Enable Artifact Power and Relics'],
      desc = L['Check this if you want sections for Artifact Power and Relic items.'],
      type = 'toggle',
      order = 10,
    },
  }, addon:GetOptionHandler(self, false, function() return self:Update() end)
end
