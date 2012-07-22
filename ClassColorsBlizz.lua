--[[--------------------------------------------------------------------
	CustomClassColors
	Change class colors without breaking parts of the Blizzard UI.
	Copyright (c) 2009–2012 Phanx <addons@phanx.net>. All rights reserved.
	See the accompanying README and LICENSE files for more information.
	http://www.wowinterface.com/downloads/info12513
	http://www.curse.com/addons/wow/classcolors
----------------------------------------------------------------------]]

local _, ns = ...
if ns.alreadyLoaded then
	return
end

------------------------------------------------------------------------

local addonFuncs = { }

local blizzHexColors = { }
for class, color in pairs(RAID_CLASS_COLORS) do
	blizzHexColors[color.colorStr] = class
end

------------------------------------------------------------------------
-- ChatFrame.lua

function GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
	local chatType = event:sub(10)
	if chatType:sub(1, 7) == "WHISPER" then
		chatType = "WHISPER"
	end
	if chatType:sub(1, 7) == "CHANNEL" then
		chatType = "CHANNEL"..arg8
	end

	local info = ChatTypeInfo[chatType]
	if info and info.colorNameByClass and arg12 ~= "" then
		local _, class = GetPlayerInfoByGUID(arg12)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				return ("|c%s%s|r"):format(color.colorStr, arg2)
			end
		end
	end

	return arg2
end

do
	-- Lines 3188-3208
	-- Fix class colors in raid roster listing
	local AddMessage = {}
	local function FixClassColors(frame, message, ...)
		if message:find("|cff") then
			for hex, class in pairs(blizzHexColors) do
				local color = CUSTOM_CLASS_COLORS[class]
				message = message:gsub(hex, color.colorStr)
			end
		end
		return AddMessage[frame](frame, message, ...)
	end
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G["ChatFrame"..i]
		AddMessage[frame] = frame.AddMessage
		frame.AddMessage = FixClassColors
	end
end

------------------------------------------------------------------------
--	CompactUnitFrame.lua

hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
	if frame.optionTable.useClassColors and UnitIsConnected(frame.unit) then
		local _, class = UnitClass(frame.unit)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				local r, g, b = color.r, color.g, color.b
				frame.healthBar:SetStatusBarColor(r, g, b)
				frame.healthBar.r, frame.healthBar.g, frame.healthBar.g = r, g, b
			end
		end
	end
end)

------------------------------------------------------------------------
--	FriendsFrame.lua

hooksecurefunc("WhoList_Update", function()
	local offset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	for i = 1, WHOS_TO_DISPLAY do
		local who = i + offset
		local _, _, _, _, _, _, class = GetWhoInfo(who)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				_G["WhoFrameButton"..i.."Class"]:SetTextColor(color.r, color.g, color.b)
			end
		end
	end
end)

------------------------------------------------------------------------
--	LFDFrame.lua

hooksecurefunc("LFDQueueFrameRandomCooldownFrame_Update", function()
	for i = 1, GetNumSubgroupMembers() do
		local _, class = UnitClass("party"..i)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				_G["LFDQueueFrameCooldownFrameName"..i]:SetFormattedText("|c%s%s|r", color.colorStr, UnitName("party"..i))
			end
		end
	end
end)

------------------------------------------------------------------------
--	LFRFrame.lua

hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local _, _, _, _, _, _, _, class = SearchLFGGetResults(index)
	if class then
		local color = CUSTOM_CLASS_COLORS[class]
		if color then
			button.class:SetTextColor(color.r, color.g, color.b)
		end
	end
end)

------------------------------------------------------------------------
--	LootFrame.lua

hooksecurefunc("MasterLooterFrame_UpdatePlayers", function()
	-- TODO: Find a better way of doing this... Blizzard's way is frankly quite awful,
	--		 creating multiple new local tables every time the function runs. :(
	for k, playerFrame in pairs(MasterLooterFrame) do
		if k:match("^player%d+$") and type(playerFrame) == "table" and playerFrame.id and playerFrame.Name then
			local i = playerFrame.id
			local _, class
			if IsInRaid() then
				_, class = UnitClass("raid"..i)
			else
				_, class = UnitClass("party"..i)
			end
			if class then
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					playerFrame.Name:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end
end)

------------------------------------------------------------------------
--	LootHistory.lua

hooksecurefunc("LootHistoryFrame_UpdateItemFrame", function(self, itemFrame)
	local itemID = itemFrame.itemIdx
	local rollID, _, _, done, winnerID = C_LootHistory.GetItem(itemID)
	local expanded = self.expandedRolls[rollID]
	if done and winnerID and not expanded then
		local _, class = C_LootHistory.GetPlayerInfo(itemID, winnerID)
		if class then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				itemFrame.WinnerName:SetVertexColor(color.r, color.g, color.b)
			end
		end
	end
end)

hooksecurefunc("LootHistoryFrame_UpdatePlayerFrame", function(self, playerFrame)
	local name, class = C_LootHistory.GetPlayerInfo(playerFrame.itemIdx, playerFrame.playerIdx)
	if name then
		local color = CUSTOM_CLASS_COLORS[class]
		if color then
			playerFrame.playerName:SetVertexColor(color.r, color.g, color.b)
		end
	end
end)

function LootHistoryDropDown_Initialize(self)
	local info = UIDropDownMenu_CreateInfo()
	info.isTitle = 1
	info.text = MASTER_LOOTER
	info.fontObject = GameFontNormalLeft
	info.notCheckable = 1
	UIDropDownMenu_AddButton(info)

	info = UIDropDownMenu_CreateInfo()
	info.notCheckable = 1
	local name, class = C_LootHistory.GetPlayerInfo(self.itemIdx, self.playerIdx)
	local color = CUSTOM_CLASS_COLORS[class]
	info.text = MASTER_LOOTER_GIVE_TO:format(("|c%s%s|r"):format(color.colorStr, name))
	info.func = LootHistoryDropDown_OnClick

	UIDropDownMenu_AddButton(info)
end

------------------------------------------------------------------------
--	PaperDollFrame.lua

hooksecurefunc("PaperDollFrame_SetLevel", function()
	local className, class = UnitClass("player")
	local color = CUSTOM_CLASS_COLORS[class]
	if color then
		local spec = GetSpecialization()
		if spec then
			local _, spec = GetSpecializationInfo(spec)
			if specName then
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), color.colorStr, specName, className)
			else
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), color.colorStr, className)
			end
		end
	end
end)

------------------------------------------------------------------------
--	RaidFinder.lua

hooksecurefunc("RaidFinderQueueFrameCooldownFrame_Update", function()
	local prefix, members
	if IsInRaid() then
		prefix, members = "raid", GetNumGroupMembers()
	else
		prefix, members = "party", GetNumSubgroupMembers()
	end

	local cooldowns = 0
	for i = 1, members do
		local unit = prefix .. i
		if UnitHasLFGDeserter(unit) and not UnitIsUnit(unit, "player") then
			cooldowns = cooldowns + 1
			if cooldowns <= MAX_RAID_FINDER_COOLDOWN_NAMES then
				local _, class = UnitClass(unit)
				if class then
					local color = CUSTOM_CLASS_COLORS[class]
					if color then
						_G["RaidFinderQueueFrameCooldownFrameName" .. cooldowns]:SetFormattedText("|c%s%s|r", color.colorStr, UnitName(unit))
					end
				end
			end
		end
	end
end)

------------------------------------------------------------------------
--	RaidWarning.lua

do
	local AddMessage = RaidNotice_AddMessage
	RaidNotice_AddMessage = function(frame, message, ...)
		if message:find("|cff") then
			for hex, class in pairs(blizzHexColors) do
				local color = CUSTOM_CLASS_COLORS[class]
				message = message:gsub(hex, color.colorStr)
			end
		end
		return AddMessage(frame, message, ...)
	end
end

------------------------------------------------------------------------

local numAddons = 0

for addon, func in pairs(addonFuncs) do
	if IsAddOnLoaded(addon) then
		addonFuncs[addon] = nil
		func()
	else
		numAddons = numAddons + 1
	end
end

if numAddons > 0 then
	local f = CreateFrame("Frame")
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, event, addon)
		local func = addonFuncs[addon]
		if func then
			addonFuncs[addon] = nil
			numAddons = numAddons - 1
			func()
		end
		if numAddons == 0 then
			self:UnregisterEvent("ADDON_LOADED")
			self:SetScript("OnEvent", nil)
		end
	end)
end