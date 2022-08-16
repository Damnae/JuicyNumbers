local settings =
{
	--showAllSources = true,
	--personal = true,
	nameplateOffset = -48,
	behavior = "ADD", -- "STACK", "ADD" or nil
	maxCombo = 20, -- Makes sure a STACK or ADD combo doesn't last too long
	fontStyle = "", -- "OUTLINE, THICKOUTLINE, MONOCHROME" or empty
	fontShadow = true,
	--colorByCrit = true,
	colorPhysicalByCrit = true,
	--longLastingPeriodics = true,
	juiceFactor = 1,

	hitAudio = true,
	critAudio = true,
	periodicHitAudio = true,
	periodicCritAudio = true,

	--@debug@
	--debugNonPeriodic = true,
	--debugPeriodic = true,
	--debugSchool = true,
	--@end-debug@
};

local periodicSpellIDs =
{
	-- Includes "passive" spellIds that aren't marked as "_PERIODIC"
	-- > Autoattacks from player or pets
	-- > Dots that simply aren't "_PERIODIC"
	-- > Long Periodic Aoes that aren't channelled and tick slowly
	-- X Procs on attack like Frost mage's icicles

	-- Warrior

	-- Death Knight
	52212, -- Death And Decay
	196771, -- Remorseless Winter
	323798, -- Abomination Limb
	323710, -- Abomination Limb
	91776, -- Claw
	341340, -- Death's Due
	50401, -- Razorice

	-- Paladin
	204301, -- Blessed Hammer
	269937, -- Zeal
	81297, -- Consecration

	-- Hunter
	131900, -- A Murder of Crows

	-- Shaman
	77478, -- Earthquake
	10444, -- Flametongue Attack
	25504, -- Windfury Attack
	157331, -- Wind Gust

	-- Druid
	191037, -- Starfall
	365640, -- Fury of Elune
	211545, -- Fury of Elune

	-- Rogue
	315585, -- Instant Poison
	113780, -- Deadly Poison
	8680, -- Wound Poison
	86392, -- Main Gauche
	341277, -- Serrated Bone Spike

	-- Monk
	123996, -- Crackling Tiger Lightning

	-- Demon Hunter
	258922, -- Immolation Aura

	-- Priest
	148859, -- Shadowy Apparition
	346111, -- Shadow Weaving

	-- Warlock
	42223, -- Rain of Fire
	3110, -- Firebolt
	104318, -- Fel Firebolt
	205231, -- Eye Beam
	270481, -- Demonfire
	54049, -- Shadow Bite
	20153, -- (Infernal's) Immolation
	--196100, -- Grimoire of Sacrifice (seems to proc on spell cast?)

	-- Mage
	205345, -- Conflagration Flare Up
	59638, -- (Mirror Image's) Frostbolt

	-- Void Elf
	259756, -- Entropic Embrace
};

nonPeriodicSpellIDs =
{
	-- Channeled spells are periodic but shouldn't be

	-- Priest
	15407, -- Mind Flay
	263165, -- Void Torrent

	-- Warlock
	-- Drain life
	198590, -- Drain soul
}

spellIDRemap =
{
	-- Warrior
	[85384] = 96103, -- Raging Blow (Off-Hand) -> Raging Blow
	[163558] = 280849, -- Execute Off-Hand -> Execute

	-- Death Knight
	[66198] = 222024, -- Obliterate Off-Hand -> Obliterate
	[222026] = 66196, -- Frost Strike Off-Hand -> Frost Strike

	-- Shaman
	[31175] = 32175, -- Stormstrike Off-Hand -> Stormstrike
	[32176] = 32175, -- Stormstrike Off-Hand -> Stormstrike
	[285466] = 285452, -- Lava Burst Overload -> Lava Burst
	[45284] = 188196, -- Lightning Bolt Overload -> Lightning Bolt
	-- Find ID for Elemental Blast Overload -> Elemental Blast
	-- Find ID for Icefury Overload -> Icefury

	-- Demon Hunter
	[225921] = 225919, -- Fracture (Offhand) -> Fracture (Main hand)

	-- Rogue
	[197834] = 193315, -- Sinister Strike (2nd hit) -> Sinister Strike
	[341541] = 193315, -- Sinister Strike (???) -> Sinister Strike

	-- Monk
	[199552] = 200685, -- Blade Dance (???) -> Blade Dance
	[228649] = 100784, -- Blackout Kick (???) -> Blackout Kick

	-- Priest
	[344752] = 49821, -- Mind Sear (???) -> Mind Sear
}

local damageColors =
{
	-- Pure
	[1] = "FFFFFF", -- physical
	[2] = "FFE680", -- holy
	[4] = "FF8000", -- fire
	[8] = "5ADB4D", -- nature
	[16] = "70D2FA", -- frost
	[32] = "8D5FCE", -- shadow
	[64] = "EA9AF9", -- arcane

	-- Arcane variants
	[2 + 64] = "FFE680", -- divine		(+holy, use holy color)
	[8 + 64] = "5ADB4D", -- astral		(+nature, use nature color)
	[4 + 64] = "FF8000", -- spellfire	(+fire, use fire color)
	[16 + 64] = "70D2FA", -- spellfrost	(+frost, use frost color)
	[32 + 64] = "8D5FCE", -- spellshadow	(+shadow, use shadow color)

	-- Shadow variants
	[2 + 32] = "8D5FCE", -- twilight		(+holy, use shadow color)
	[4 + 32] = "C65615", -- shadowflame	(+fire)
	[8 + 32] = "BADDAD", -- plague		(+nature)
	[16 + 32] = "B1ABF7", -- shadowfrost	(+frost)

	-- Fire variants
	[4 + 16] = "A8F0FF", -- frostfire	(fire + frost)
	[2 + 4] = "FFE680", -- radiant		(fire + holy, use holy color)
	[4 + 8] = "FF8000", -- firestorm	(fire + nature, use fire color)

	-- Misc
	[8 + 16] = "70D2FA", -- froststorm	(frost + nature, use frost color)
	[4 + 8 + 16] = "4DFFD1", -- elemental	(fire + frost + nature)

	-- Chaos is Arcane Fire Frost Nature Shadow + optionally Physical and Holy
	[4 + 8 + 16 + 32 + 64] = "CFF81F", -- chaos
	[2 + 4 + 8 + 16 + 32 + 64] = "CFF81F", -- chaos + holy

	-- Cosmic is Arcane, Holy, Nature, Shadow
	[2 + 8 + 32 + 64] = "D7C0EC", -- cosmic

	-- Special cases
	["bleed"] = "FF0000",
	["earth"] = "F1B622",
	["lightning"] = "B38CC1",
	["crit"] = "FCFA00",
	["unknown"] = "5ADB4D",
};

local frame = CreateFrame("Frame", "JuicyNumbersFrame", UIParent);
frame:SetPoint("CENTER");
frame:SetSize(1, 1);
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
frame:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
frame:SetScript("OnEvent", function(self, event, ...)
	frame[event](self, ...);
end);

local playerGUID;
local unitToGuid = {};
local guidToUnit = {};

-- Events

function frame:PLAYER_LOGIN()
	playerGUID = UnitGUID("player");
end

function frame:NAME_PLATE_UNIT_ADDED(unitID)
	local guid = UnitGUID(unitID);
	unitToGuid[unitID] = guid;
	guidToUnit[guid] = unitID;
end

function frame:NAME_PLATE_UNIT_REMOVED(unitID)
	local guid = unitToGuid[unitID];
	frame:recycleByDestGUID(guid);

	unitToGuid[unitID] = nil;
	guidToUnit[guid] = nil;
end

function frame:COMBAT_LOG_EVENT_UNFILTERED()
	return frame:CombatFilter(CombatLogGetCurrentEventInfo());
end

-- Combat

function frame:CombatFilter(_, clue, _, sourceGUID, _, sourceFlags, _, destGUID, _, _, _, ...)
	local isPet = (bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_GUARDIAN) > 0
		or bit.band(sourceFlags, COMBATLOG_OBJECT_TYPE_PET) > 0);
	local mine = isPet and bit.band(sourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) > 0;

	if settings.showAllSources
		or sourceGUID == playerGUID
		or (isPet and mine)
		or (settings.personal and destGUID == playerGUID)
	then
		local destUnit = guidToUnit[destGUID];
		if destUnit or (destGUID == playerGUID and settings.personal) then
			if (string.find(clue, "_DAMAGE")) then
				local spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand;
				if (string.find(clue, "SWING")) then
					spellName, amount, overkill, school_ignore, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = "swing"
						, ...;
				elseif (string.find(clue, "ENVIRONMENTAL")) then
					spellName, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing = ...;
				else
					spellID, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing
						, isOffHand = ...;
				end

				if not school or not spellID or spellID == 75 then
					-- Auto Attack / Auto Shot
					school = 1;
					spellID = nil;
				elseif isPet then
					-- Merge non-auto pet actions
					if mine then
						-- With the owner (only works for the local player)
						sourceGUID = playerGUID;
					else
						-- Everyone else
						sourceGUID = nil
					end
				end
				frame:HandleDamageEvent(sourceGUID, destGUID, spellID, amount, school, critical, clue, spellName);
			end
		end
	end
end

function frame:HandleDamageEvent(sourceGUID, destGUID, spellID, amount, school, crit, clue, spellName)

	-- Nameplate

	local unit = guidToUnit[destGUID];
	if unit then
		nameplate = C_NamePlate.GetNamePlateForUnit(unit);
	elseif destGUID == playerGUID then
		nameplate = player;
	else
		return;
	end

	-- Setup

	spellID = spellIDRemap[spellID] or spellID;

	local periodic = not spellID
		or string.find(clue, "_PERIODIC") and not tContains(nonPeriodicSpellIDs, spellID)
		or tContains(periodicSpellIDs, spellID);

	amount = amount * settings.juiceFactor;

	local fontSize = 20 * math.log10(amount) * 0.5;
	if periodic then fontSize = fontSize * .6; end
	fontSize = math.max(16, fontSize);

	-- Initialize

	local floatingText = frame:acquireFloatingText(sourceGUID, destGUID, spellID, amount, crit);

	local text = frame:toCommaSeperated(floatingText.amount);
	if floatingText.critCount >= math.max(3, floatingText.hitCount * .9) then
		text = text .. "!!!"; -- 90% of hits are crit, at least 3 hits
	elseif floatingText.critCount >= math.max(2, floatingText.hitCount * .5) then
		text = text .. "!!"; -- Half the hits are crit, at least 2 hits
	elseif crit or floatingText.critCount >= floatingText.hitCount * .2 then
		text = text .. "!"; -- Last hit was a crit, or at least 20% of hits were crits
	end
	text = frame:withColor(text, spellID, spellName, school, crit, periodic);

	if settings.debugNonPeriodic and not periodic
		or settings.debugPeriodic and periodic then
		text = text .. " " .. spellName .. " " .. tostring(spellID)
	end

	local drawLayer = "ARTWORK";
	if periodic then
		drawLayer = "BACKGROUND";
	elseif floatingText.critCount > 0 then
		drawLayer = "OVERLAY";
	end

	floatingText:SetDrawLayer(drawLayer);
	floatingText:SetPoint("CENTER", nameplate, "CENTER", floatingText.posX, floatingText.posY + settings.nameplateOffset);
	floatingText:SetFont("Interface\\Addons\\JuicyNumbers\\Media\\gi.ttf", fontSize, settings.fontStyle);
	floatingText:SetText(text);

	if settings.fontShadow then
		floatingText:SetShadowOffset(2, -1);
	else
		floatingText:SetShadowOffset(0, 0);
	end

	-- Animate

	local mainDuration = math.min(0.25 + 0.25 * math.log(1 + amount * 0.002), 1.0);
	local scaleDuration = 0.2;
	local fadeDuration = 0.15;

	local startScale = 2.0;

	if crit then
		mainDuration = mainDuration * 1.2;
	end

	if periodic then
		startScale = 1.2;
		if settings.longLastingPeriodics then
			mainDuration = 1.0;
		end
	end

	if floatingText.hitCount > 1 then
		startScale = startScale * 0.75;
	end

	floatingText.animation:Stop();

	floatingText:SetTextScale(startScale, startScale);
	floatingText.animation.scale.start = startScale;
	floatingText.animation.scale:SetDuration(scaleDuration);
	floatingText.animation.alpha:SetStartDelay(mainDuration);
	floatingText.animation.alpha:SetDuration(fadeDuration);
	floatingText.animation:Play();

	floatingText:SetAlpha(1.0);
	floatingText:Show();

	-- Audio

	if crit then
		if settings.critAudio and not periodic or
			settings.periodicCritAudio and periodic then
			PlaySoundFile("Interface\\AddOns\\JuicyNumbers\\Media\\crit.mp3", "SFX");
		end
	else
		if settings.hitAudio and not periodic or
			settings.periodicHitAudio and periodic then
			PlaySoundFile("Interface\\AddOns\\JuicyNumbers\\Media\\hit.mp3", "SFX");
		end
	end
end

-- Floating Text

local activeFloatingText = {};
local floatingTextCache = {};

function frame:getFloatingText()
	local floatingText;
	if (next(floatingTextCache)) then
		floatingText = table.remove(floatingTextCache);
	else
		floatingText = frame:CreateFontString();

		floatingText.animation = floatingText:CreateAnimationGroup();
		floatingText.animation:SetScript("OnFinished", function(self, event, ...)
			frame:recycleFloatingText(floatingText);
		end);

		floatingText.animation.scale = floatingText.animation:CreateAnimation("Animation");
		floatingText.animation.scale:SetSmoothing("OUT");

		floatingText.animation.alpha = floatingText.animation:CreateAnimation("Alpha");
		floatingText.animation.alpha:SetFromAlpha(1.0);
		floatingText.animation.alpha:SetToAlpha(0);
		floatingText.animation.alpha:SetSmoothing("IN");
	end

	floatingText.animation.scale:SetScript("OnUpdate", function(self)
		local s = Lerp(floatingText.animation.scale.start, 1.0, self:GetSmoothProgress());
		floatingText:SetTextScale(s, s);
	end)

	floatingText.critCount = 0;
	floatingText.hitCount = 0;
	floatingText.stacked = false;

	table.insert(activeFloatingText, floatingText);
	return floatingText;
end

function frame:recycleFloatingText(floatingText)
	floatingText.animation.scale:SetScript("OnUpdate", nil);
	frame:recyclePosition(floatingText.x, floatingText.y);

	floatingText:Hide();
	floatingText:ClearAllPoints();

	tDeleteItem(activeFloatingText, floatingText);
	table.insert(floatingTextCache, floatingText);
end

function frame:recycleByDestGUID(destGUID)
	for _, floatingText in ipairs(activeFloatingText) do
		if floatingText.destGUID == destGUID then
			floatingText.animation:Stop();
			frame:recycleFloatingText(floatingText)
		end
	end
end

function frame:findFloatingText(sourceGUID, destGUID, spellID)
	for _, floatingText in ipairs(activeFloatingText) do
		if (floatingText.sourceGUID == sourceGUID
			and floatingText.destGUID == destGUID
			and floatingText.spellID == spellID
			and floatingText.hitCount <= settings.maxCombo
			and not floatingText.stacked) then
			return floatingText;
		end
	end
	return nil;
end

function frame:acquireFloatingText(sourceGUID, destGUID, spellID, amount, crit)
	local floatingText;

	if settings.behavior == "STACK" then
		local existingFt = frame:findFloatingText(sourceGUID, destGUID, spellID);
		if existingFt then
			existingFt.stacked = true;

			floatingText = frame:getFloatingText();
			floatingText.x, floatingText.y = existingFt.x, existingFt.y;
			existingFt.x, existingFt.y = nil, nil;
			floatingText.posX, floatingText.posY = existingFt.posX + math.random(-5, 4), existingFt.posY + math.random(-5, 4);
			floatingText.amount = amount;
		end

	elseif settings.behavior == "ADD" then
		local existingFt = frame:findFloatingText(sourceGUID, destGUID, spellID);
		if existingFt then
			floatingText = existingFt;
			floatingText.amount = floatingText.amount + amount;
			floatingText.posX, floatingText.posY = floatingText.posX + math.random(-2, 1), floatingText.posY + math.random(-2, 1);
		end
	end

	if not floatingText then
		floatingText = frame:getFloatingText();
		floatingText.x, floatingText.y = frame:reservePosition();

		local posX, posY = floatingText.x, floatingText.y;
		if posX == nil then posX = math.random(-4.0, 4.0); end
		if posY == nil then posY = math.random(-8.0, 0.0); end
		floatingText.posX, floatingText.posY = posX * 8, posY * 12;
		floatingText.amount = amount;
	end

	floatingText.sourceGUID = sourceGUID;
	floatingText.destGUID = destGUID;
	floatingText.spellID = spellID;
	if crit then floatingText.critCount = floatingText.critCount + 1; end
	floatingText.hitCount = floatingText.hitCount + 1;

	return floatingText;
end

-- Formatting

function frame:withColor(text, spellID, spellName, school, crit, periodic)
	if (school == 1 or school == 8) and spellName and string.find(spellName, "Earth") ~= nil then
		school = "earth" -- Physical or nature damage that contains "Earth" is earth
	elseif school == 8 and spellName and string.find(spellName, "Lightning") ~= nil then
		school = "lightning" -- Nature damage that contains "Lightning" is lightning
	elseif spellID and school == 1 and periodic then
		school = "bleed" -- Non-auto physical periodic damage is assumed to be from a bleed
	end

	local color;
	if settings.colorByCrit
		or settings.colorPhysicalByCrit and school == 1 then
		if crit then
			color = damageColors["crit"];
		else
			color = damageColors[1];
		end
	else
		color = damageColors[school];
		-- If the spell has a physical component but a color cannot be found, remove it
		if color == nil and school % 2 == 1 then
			school = school - 1;
			color = damageColors[school];
		end
		-- Can't find a color
		if color == nil then
			color = damageColors["unknown"];
			if settings.debugSchool then text = text .. "<" .. school .. ">"; end
		end
	end
	return "|Cff" .. color .. text .. "|r";
end

function frame:toCommaSeperated(number)
	local _, _, sign, value, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)');
	value = value:reverse():gsub("(%d%d%d)", "%1,");
	return sign .. value:reverse():gsub("^,", "") .. fraction;
end

-- Positionning

local availableX = {};
local availableY = {};

function frame:shuffle(t)
	for i = #t, 2, -1 do
		local j = math.random(i);
		t[i], t[j] = t[j], t[i];
	end
end

function frame:initializePositions()
	for i = -8, 8 do
		table.insert(availableX, i);
	end
	for i = -12, 0 do
		table.insert(availableY, i);
	end
	frame:shuffle(availableX);
	frame:shuffle(availableY);
end

function frame:reservePosition()
	local x = frame:findAndReserveValue(availableX);
	local y = frame:findAndReserveValue(availableY);
	return x, y;
end

function frame:recyclePosition(x, y)
	table.insert(availableX, x);
	table.insert(availableY, y);
end

function frame:findAndReserveValue(available)
	return table.remove(available, 1);
end

frame:initializePositions();
