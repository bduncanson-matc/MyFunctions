
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
      for _, v in pairs(WratheqSlot) do
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
----------------------------------------------------------------------------------------
---                          One Key Warrior Stancing                                 --
----------------------------------------------------------------------------------------

StanceOption = {
  ["tank"] = false,  --Defensive stance to Batle Stance
  ["dps"] = true,    --Defensive stance goes to Berserker Stance
}
--set options for what defenseive stance goes to
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

function OneActionStancing(shield)
  if IsShiftKeyDown() then
    if not isDefensiveStance() then
      Zorlen_castSpellByName("Defensive Stance")
    elseif isDefensiveStance() and UnitHealth("player") <= 60 and shield then
      Zorlen_useItemByName(shield)
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


--------------------------------------------------------------
---                Cooldown Sequences                      ---
--------------------------------------------------------------

function isDWActive()
  if Zorlen_checkDebuff("DeathWish", "player") then
    return true
  end
  return false
end

function isBadgeActive()
  if Zorlen_checkSelfBuffByName("Badge of the Swarmguard", "player") then
    return true
  end
  return false
end

--Both having 30 second duration the best strategy is to couple their useage

function DeathBadge()
  if isDWActive() then
    if Zorlen_isItemByNameEquipped("Badge of the Swarmguard") then
      Zorlen_useTrinketByName("Badge of the Swarmgaurd")
    end
  else
    castDeathWish(test)
  end
end

function isExpose()
	if Zorlen_checkDebuffByName("Expose Armor","target") then
		return true
	else
		return false
	end
end
	
function BSOrSunder(dps)  --dps boolean arg if true it will always be sunder armor if left blank or given the value of false it will cast Battle shout if expose armor is up.
	if UnitClass("Player") == "Warrior" then  -- added to prevent bugs from attempted use outside of the warrior c;ass
		if dps then  --added a shift modifer to give this macro two spells shift press battle shout and regular press sunder armor.
			if IsShiftKeyDown() then
				Zorlen_castSpellByName("Battle Shout")
			elseif not IsShiftKeyDown() then
				if isSunderFull() then --no reason to sunder as DPS if it is fully stacked
					return false --do nothing could add a console message to notify player its fully stacked
				else
					if UnitMana("Player") >= 15 then --rage check could add check for targets range but its late
						Zorlen_castSpellByName("Sunder Armor")
					end
				end
			end
		else 
			if isExpose() and UnitMana("player") >= 10 then --a few reasons 1)in the case of active expose sunder returns an error message and doesnt work 
				Zorlen_castSpellByName("Battle Shout")  --reason 2 battle shout grants the player 70 rage per player the buff reaches(group of 5 hitting all = 350 threat
			elseif not isExpose() and UnitMana("Player") >=15 then --where as sunder armor is a flat 270 threat at 15 rage so threat per rage point battle shout outshines in single target
 				Zorlen_castSpellByName("Sunder Armor") --With that said it splits the threat generation between all active targets so while great for pulling far away not as good as sunder with 3+ targets
			end
		end
	end
end
