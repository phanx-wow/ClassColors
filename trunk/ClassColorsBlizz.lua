--[[--------------------------------------------------------------------
	Class Colors
	Change class colors without breaking the Blizzard UI.
	by Phanx < addons@phanx.net >
	Copyright ©2009 Alyssa "Phanx" Kinley
	See accompanying README for license terms and API details.
	http://www.wowinterface.com/downloads/info12513-ClassColors.html
	http://wow.curse.com/downloads/wow-addons/details/classcolors.aspx
----------------------------------------------------------------------]]

local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS

------------------------------------------------------------------------
--	FriendsFrame.lua
--

local GetGuildRosterInfo = GetGuildRosterInfo
local GetWhoInfo = GetWhoInfo
local GUILDMEMBERS_TO_DISPLAY = GUILDMEMBERS_TO_DISPLAY
local WHOS_TO_DISPLAY = WHOS_TO_DISPLAY

hooksecurefunc("WhoList_Update", function()
	-- ChatFrame7:AddMessage("WhoList_Update")
	local class, color, _
	local offset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	for i = 1, WHOS_TO_DISPLAY, 1 do
		_, _, _, _, _, _, class = GetWhoInfo(i + offset)
		if class then
			color = CUSTOM_CLASS_COLORS[class]
			if color then
				_G["WhoFrameButton" .. i .. "Class"]:SetTextColor(color.r, color.g, color.b)
			end
		end
	end
end)

hooksecurefunc("GuildStatus_Update", function()
	-- ChatFrame7:AddMessage("GuildStatus_Update")
	if FriendsFrame.playerStatusFrame then
		local class, color, online, _
		local offset = FauxScrollFrame_GetOffset(GuildListScrollFrame)
		for i = 1, GUILDMEMBERS_TO_DISPLAY, 1 do
			_, _, _, _, _, _, _, _, online, _, class = GetGuildRosterInfo(i + offset)
			if online and class then
				color = CUSTOM_CLASS_COLORS[class]
				if color then
					_G["GuildFrameButton" .. i .. "Class"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	else
		local class, color, online, _
		local offset = FauxScrollFrame_GetOffset(GuildListScrollFrame)
		for i = 1, GUILDMEMBERS_TO_DISPLAY, 1 do
			_, _, _, _, _, _, _, _, online, _, class = GetGuildRosterInfo(i + offset)
			if online and class then
				color = CUSTOM_CLASS_COLORS[class]
				if color then
					_G["GuildFrameGuildStatusButton" .. i .. "Online"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end
end)

------------------------------------------------------------------------
--	LFRFrame.lua
--

hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, i)
	local _, _, _, _, _, _, _, class = SearchLFGGetResults(i)
	if class then
		local color = CUSTOM_CLASS_COLORS[class]
		if color then
			button.class:SetTextColor(color.r, color.g, color.b)
		end
	end
end)

------------------------------------------------------------------------

local numAddons = 0
local addonFuncs = { }

------------------------------------------------------------------------
--	Blizzard_Calendar
--

addonFuncs["Blizzard_Calendar"] = function()
	local CalendarEventGetInvite = CalendarEventGetInvite

	hooksecurefunc("CalendarViewEventInviteListScrollFrame_Update", function()
		-- ChatFrame7:AddMessage("CalendarViewEventInviteListScrollFrame_Update")
		local buttons = CalendarViewEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset(CalendarViewEventInviteListScrollFrame)
		local button, class, color, _
		for i = 1, #buttons do
			_, _, _, class = CalendarEventGetInvite(i + offset)
			if class then
				color = CUSTOM_CLASS_COLORS[class]
				if color then
					button = buttons[i]:GetName()
					_G[button .. "Name"]:SetTextColor(color.r, color.g, color.b)
					_G[button .. "Class"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)

	hooksecurefunc("CalendarCreateEventInviteListScrollFrame_Update", function()
		-- ChatFrame7:AddMessage("CalendarCreateEventInviteListScrollFrame_Update")
		local buttons = CalendarCreateEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset(CalendarCreateEventInviteListScrollFrame)
		local button, class, color, _
		for i = 1, #buttons do
			_, _, _, class = CalendarEventGetInvite(i + offset)
			if class then
				color = CUSTOM_CLASS_COLORS[class]
				if color then
					button = buttons[i]:GetName()
					_G[button .. "Name"]:SetTextColor(color.r, color.g, color.b)
					_G[button .. "Class"]:SetTextColor(color.r, color.g, color.b)
				end
			end
		end
	end)
end

------------------------------------------------------------------------
--	Blizzard_RaidUI
--

addonFuncs["Blizzard_RaidUI"] = function()
	local GetNumRaidMembers = GetNumRaidMembers
	local GetRaidRosterInfo = GetRaidRosterInfo
	local UnitClass = UnitClass
	local UnitName = UnitName
	local MAX_RAID_MEMBERS = MAX_RAID_MEMBERS
	local MEMBERS_PER_RAID_GROUP = MEMBERS_PER_RAID_GROUP
	local UNKNOWNOBJECT = UNKNOWNOBJECT

	hooksecurefunc("RaidGroupFrame_Update", function()
		-- ChatFrame7:AddMessage("RaidGroupFrame_Update")
		local button, class, color, dead, name, online, subgroup, _
		local n = GetNumRaidMembers()
		for i = 1, MAX_RAID_MEMBERS do
			if i <= n then
				name, _, subgroup, _, _, class, _, online, dead = GetRaidRosterInfo(i)
				if online and not dead and _G["RaidGroup" .. subgroup].nextIndex <= MEMBERS_PER_RAID_GROUP then
					color = CUSTOM_CLASS_COLORS[class]
					if color then
						_G["RaidGroupButton"..i.."Name"]:SetTextColor(color.r, color.g, color.b)
						_G["RaidGroupButton"..i.."Class"]:SetTextColor(color.r, color.g, color.b)
						_G["RaidGroupButton"..i.."Level"]:SetTextColor(color.r, color.g, color.b)
					end
				end
			end
		end
	end)

	hooksecurefunc("RaidGroupFrame_UpdateHealth", function(i)
		-- ChatFrame7:AddMessage("RaidGroupFrame_UpdateHealth")
		local _, _, _, _, _, class, _, online, dead = GetRaidRosterInfo(i)
		if online and not dead then
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				_G["RaidGroupButton" .. i .. "Name"]:SetTextColor(color.r, color.g, color.b)
				_G["RaidGroupButton" .. i .. "Class"]:SetTextColor(color.r, color.g, color.b)
				_G["RaidGroupButton" .. i .. "Level"]:SetTextColor(color.r, color.g, color.b)
			end
		end
	end)

	hooksecurefunc("RaidPullout_UpdateTarget", function(frame, button, unit, which)
		-- ChatFrame7:AddMessage("RaidPullout_UpdateTarget")
		if _G[frame]["show" .. which] then
			local name = UnitName(unit)
			if name and name ~= UNKNOWNOBJECT then
				local _, class = UnitClass(unit)
				if class then
					local color = CUSTOM_CLASS_COLORS[class]
					if color then
						_G[button .. which .. "Name"]:SetVertexColor(color.r, color.g, color.b)
					end
				end
			end
		end
	end)

	hooksecurefunc("RaidPulloutButton_UpdateDead", function(button, dead, class)
		-- ChatFrame7:AddMessage("RaidPulloutButton_UpdateDead")
		if not dead then
			if class == "PETS" then
				class = UnitClass(button.unit:gsub("raidpet", "raid", 1))
			end
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				button.nameLabel:SetVertexColor(color.r, color.g, color.b)
			end
		end
	end)
end

------------------------------------------------------------------------
--	Event handling
--

local ADDON_NAME = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == ADDON_NAME then
		for addon, func in pairs(addonFuncs) do
			if IsAddOnLoaded(addon) then
				func()
				addonFuncs[addon] = nil
			else
				numAddons = numAddons + 1
			end
		end

		if numAddons < 1 then
			self:UnregisterEvent("ADDON_LOADED")
			self:SetScript("OnEvent", nil)
		end

		------------------------------------------------------------------------
		--	ChatConfigFrame.lua
		--

		local function ColorizeChatConfigFrame()
			for i, class in ipairs(CLASS_SORT_ORDER) do
				local color = CUSTOM_CLASS_COLORS[class]
				if color then
					ChatConfigChatSettingsClassColorLegend.classStrings[i]:SetFormattedText("|cff%02x%02x%02x%s|r\n", color.r * 255, color.g * 255, color.b * 255, LOCALIZED_CLASS_NAMES_MALE[class])
					ChatConfigChannelSettingsClassColorLegend.classStrings[i]:SetFormattedText("|cff%02x%02x%02x%s|r\n", color.r * 255, color.g * 255, color.b * 255, LOCALIZED_CLASS_NAMES_MALE[class])
				end
			end
		end
		CUSTOM_CLASS_COLORS:RegisterCallback(ColorizeChatConfigFrame)
		ColorizeChatConfigFrame()

		------------------------------------------------------------------------
		--	ChatFrame.lua
		--

		function GetColoredName(event, _, senderName, _, _, _, _, _, channelNumber, _, _, _, senderGUID)
			local chatType = event:sub(10)
			if chatType:sub(1, 7) == "WHISPER" then
				chatType = "WHISPER"
			end
			if chatType:sub(1, 7) == "CHANNEL" then
				chatType = "CHANNEL" .. channelNumber
			end
			local info = ChatTypeInfo[chatType]
			if info and info.colorNameByClass and senderGUID ~= "" then
				local _, class = GetPlayerInfoByGUID(senderGUID)
				if class then
					local color = CUSTOM_CLASS_COLORS[class]
					if color then
						return ("|cff%02x%02x%02x%s|r"):format(color.r * 255, color.g * 255, color.b * 255, senderName)
					end
				end
			end
			return senderName
		end

		------------------------------------------------------------------------
	elseif addonFuncs[addon] then
		addonFuncs[addon]()
		addonFuncs[addon] = nil
		numAddons = numAddons - 1

		if numAddons < 1 then
			self:UnregisterEvent("ADDON_LOADED")
			self:SetScript("OnEvent", nil)
		end
	end
end)

------------------------------------------------------------------------