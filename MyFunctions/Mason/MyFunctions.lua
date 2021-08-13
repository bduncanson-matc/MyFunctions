
--Uses LIP if on CD returns false, If buffed with LIP then will cast AOE Taunt
--/run LipTaunt()
function LipTaunt()
  Zorlen_useItemByName("Limited Invulnerability Potion")
  if Zorlen_checkSelfBuffByName("Invulnerability") then
    Zorlen_castSpellByName("Challenging Shout")
  end
end

--Nice for sub 20 percent to use your rage smarter than execute.
function PriorBT()
  local a, b, c = UnitAttackPower("player") --API function
  local AP = a + b + c 
  local BTDmg = AP * 0.45
  if BTDmg >= 1000  then
    return true
  else
    return false
  end
end
----------------------------------------------------------------------------------------
--                                  Wrath Shout                                       --
----------------------------------------------------------------------------------------


--Wrath 3 piece give the player a 30 AP Bonus and can be cast out of combat then switched out giving 2 minutes of extra API
--[[
Attempt to clean up and explain this useful function

local WrathInBags = {}
local EquippedItems = {}
local WrathItemEqSlot = {}
local wrathString = "Of Wrath"

--first check and create an array with current equipment
function WrathItemsEquipped()
  local slotId
  local wrathCounter = 0
  for slotId = 1,10 do --slotIds 1-10 cover all possible wrath slots
    local itemLink = GetInventoryItemLink("player", slotId)
    if itemLink then
      local name, id = Zorlen_DecodeItemLink(itemLink) --all the various information about an item can be parsed out the itemLink
      if string.find(name, WrathString) then
        wrathCounter = wrathCounter + 1
        if wrathCounter == 3 then
          return true
        end
      end
    end
  end
  return wrathCounter
end

function WrathInBags() --just looking for 3 items to get to the 30 ap bonus
  local bag, slot, counter = WrathItemsEquipped()
  while counter <= 3 do
    for bag = 4, 0, -1 do --most peole sort items towards the bottom of their bags which is slot 4 on all in one bags
      for slot 1, GetContainerNumSlots(bag) do --bag sizes vary making this api function handy
        local itemLink = GetContainerItemLink(bag, slot) --Loop through each item slot and get the itemLink
        if itemLink then --if the slot is not empty
          local name, itemId = Zorlen_DecodeItemLink(itemLink) --gives infomation that can be used in other API functions
          if name then
            if string.find(name, WrathString) then
              local _, _, _, _, _, _, _, eqSlot = GetItemInfo(itemId)
              WrathInBags[eqSlot] = name
              counter = counter + 1
              if counter == 3 then
                return true
              end
            end
          end
        end
      end
    end
  end
end

function ItemsInvArray()
  if not WrathInBags() and not then
    local slotId
    for slotId = 1, 10 do
      local itemLink = GetInventoryItemLink("player", slotId)
      if itemLink then
        local name, itemId = Zorlen_DecodeItemLink(itemLink)
        if itemId and not string.find(name, wrathString) then
        _, _, _, _, _, _, _, eqSlot = GetItemInfo(itemId)
          for i, v in pairs(WrathItemEqSlot) do
            if i == eqSlot then
              EquippedItems[eqSlot] = name
            end
          end
        end
      end
    end
    return true
  end
end
--]]
WratheqSlot = {}
ItemsEquipped ={}
wrathString = "of Wrath"
WrathItemsEquipped = 0


function WrathEquipped()
  WrathItemsEquipped = 0
  local slotId
  for slotId = 1, 10 do
    local itemLink = GetInventoryItemLink("player",slotId)
    if itemLink then
      name, id = Zorlen_DecodeItemLink(itemLink)
      if string.find(name, wrathString) then
        WrathItemsEquipped = WrathItemsEquipped + 1
        if WrathItemsEquipped == 3 then
          return WrathItemsEquipped
        end
      end
    end
  end
  return WrathItemsEquipped
end

function isWrathEquipped()
  if WrathItemsEquipped == 3 then
    return true
  else
    return fa
  end
end

function WrathInBags()
  local bag, slot
  local counter = WrathItemsEquipped
  for bag = 4, 0, -1 do
    for slot = 1, GetContainerNumSlots(bag) do
      local itemLink = GetContainerItemLink(bag, slot)
      if itemLink then
        name, itemId = Zorlen_DecodeItemLink(itemLink)
        if name then
          if string.find(name, wrathString) then
            if itemId then
              _, _, _, _, _, _, _, eqSlot = GetItemInfo(itemId)
              WratheqSlot[eqSlot] = name
              counter = counter + 1
              if counter == 3 then
                return true
              end
            end
          end
        end
      end
    end
  end
end

function ItemsInvArray()
  local slotId
  WrathInBags()
  for slotId = 1, 10 do
    local itemLink = GetInventoryItemLink("player", slotId)
    if itemLink then
      local name, itemId = Zorlen_DecodeItemLink(itemLink)
      if itemId and not string.find(name, wrathString) then
        _, _, _, _, _, _, _, eqSlot = GetItemInfo(itemId)
        for i, v in pairs(WratheqSlot) do
          if i == eqSlot then
            ItemsEquipped[eqSlot] = name;
          end
        end
      end
    end
  end
  return true
end

function SwapInWrath()
  WrathEquipped()
  if not isWrathEquipped() then
    WrathInBags()
    if ItemsInvArray() then
      for i, v in pairs(WratheqSlot) do
        Zorlen_useItemByName(v)
      end
    end
  end
end

function SwapBack()
  if isWrathEquipped() then
    for i, v in pairs(ItemsEquipped) do
      Zorlen_useItemByName(v)
    end
  end
end


function WrathBS()
  WrathEquipped()
  WrathInBags()
  ItemsInvArray()
  local _,_,_,_,curRank = GetTalentInfo(2,15)  --returns imp zerker rage talents
  if isWrathEquipped() then
    if Zorlen_inCombat() then
      if Zorlen_checkSelfBuffByName("Bloodrage") then
        if IsShiftKeyDown() then
          Zorlen_CancelSelfBuffByName("Bloodrage")
        end
      end
    end
  end

  if IsShiftKeyDown() then
    if Zorlen_notInCombat() and isWrathEquipped() then
      SwapBack()
    end
  end

  if Zorlen_notInCombat() and isBS() and (Zorlen_GetTimer("WrathBS") > 60) then
    SwapBack()
  end

  if Zorlen_notInCombat() then
    if isBS() and (Zorlen_GetTimer("WrathBS") < 60) or not Zorlen_IsTimer("WrathBS") then
      Zorlen_CancelSelfBuffByName("Battle Shout")
    end
  end

  if Zorlen_notInCombat() then
    if not isBS() then
      SwapInWrath()
      if isRage(10) and isWrathEquipped() then
        Zorlen_castSpellByName("Battle Shout");
        Zorlen_SetTimer(120, "WrathBS")
      elseif not isRage(10) and not curRank == 2 or not Zorlen_checkCooldownByName("Berserker Rage") then
        Zorlen_castSpellByName("Bloodrage")
      elseif curRank == 2 and isBerserkerStance() then
        forceBerserkerRage()
        Zorlen_castSpellByName("Battle Shout");
        Zorlen_SetTimer(120, "WrathBS")
      end
    else
      if isWrathEquipped() then
        SwapBack()
      end
    end
  else
    if isRage(10) and isWrathEquipped() and (not Zorlen_IsTimer("WrathBS")) or (Zorlen_GetTimer("WrathBS") < 60) then
      Zorlen_castSpellByName("Battle Shout");
      Zorlen_SetTimer(120, "WrathBS")
    end
  end
end
--------------------------------------------------------------
---             Stancing from one Key                      ---
--------------------------------------------------------------
StanceOption = {
  ["tank"] = false,
  ["dps"] = true,
}
--set options for
function StanceOption:SetStance()
  if self.tank == true then
    self.dps = true
    self.tank = false
    self.string = "Defensive Stance will change to Zerker stance"
  else
    self.tank = true
    self.dps = false
    self.string = "Defensive Stance will change to Battle Stance"
  end
end


function OneActionStancing()
  if IsShiftKeyDown() then
    if not isDefensiveStance() then
      Zorlen_castSpellByName("Defensive Stance")
    elseif isDefensiveStance() and UnitHealth("player") <= 60 then
      Zorlen_useItemByName("The Face of Death")
    end
  elseif IsControlKeyDown() then
    StanceOption:SetStance()
    DEFAULT_CHAT_FRAME:AddMessage(StanceOption["string"])
  else
    if isDefensiveStance() then
      if StanceOption["tank"] == true then
        castBattleStance(test)
      else
        castBerserkerStance(test)
      end
    elseif isBattleStance() then
      castBerserkerStance(test)
    elseif isBerserkerStance() then
      castBattleStance(test)
    end
  end
end