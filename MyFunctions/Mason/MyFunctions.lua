
--Uses LIP if on CD returns false
--If buffed with LIP then will cast AOE Taunt
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