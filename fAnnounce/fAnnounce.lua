local function Aura(spellID, auraID)
	local spell = {}
	spell["spellID"] = spellID
	spell["auraID"] = auraID or spellID
	return spell
end

local auraids = {
	-- Warriors
	Aura(871), -- Shield Wall
	Aura(12975), -- Last Stand
	Aura(1161), -- Challenging Shout
	
	-- Druids
	Aura(22812), -- Barkskin
	Aura(61336), -- Survival Instincts
	Aura(22842), -- Frenzied Regeneration
	
	-- Paladins
	Aura(498), -- Divine Protection
	Aura(70940), -- Divine Guardian
	Aura(86150), -- Guardian of Ancient Kings
	Aura(31850), -- Ardent Defender
	Aura(6940), -- Hand of Sacrifice
	
	-- Death Knights
	Aura(48792), -- Icebound Fortitude
	Aura(48707), -- Anti-magic Shell
	Aura(49222), -- Bone Shield
	Aura(55233), -- Vampiric Blood
	
	-- Test
	Aura(6229), -- Shadow ward
}

local activeauras = {}

local fAnnounce = CreateFrame("Frame")
fAnnounce:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
fAnnounce:RegisterEvent("UNIT_AURA")
fAnnounce:SetScript("OnEvent", function(self, event, unit, _, _, _, id)
	if (event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player") then
		for key, spell in pairs(auraids) do
			if (id == spell.spellID) then
				local output
				if (GetRealNumRaidMembers() > 0) then
					output = "RAID_WARNING"
				elseif (GetRealNumPartyMembers() > 0) then
					output = "PARTY"
				end
				if (output) then
					SendChatMessage(GetSpellLink(id) .. " used!", output, nil, nil)
					activeauras[spell.auraID] = spell.auraID
				end
			end
		end
	elseif (event == "UNIT_AURA") then
		for key, id in pairs(activeauras) do
			local name = UnitAura("player", select(1, GetSpellInfo(id)))
			if (name == nil) then
				local output
				if (GetRealNumRaidMembers() > 0) then
					output = "RAID_WARNING"
				elseif (GetRealNumPartyMembers() > 0) then
					output = "PARTY"
				end
				if (output) then
					SendChatMessage(GetSpellLink(id) .. " faded!", output, nil, nil)
					activeauras[id] = nil
					break
				end
			end
		end
	end
end)