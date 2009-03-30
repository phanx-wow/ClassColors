local numAddons = 0
local addonFuncs = { }

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

addonFuncs["Blizzard_RaidUI"] = function()
	local GetNumRaidMembers = GetNumRaidMembers
	local GetRaidRosterInfo = GetRaidRosterInfo
	local UnitClass = UnitClass
	local UnitName = UnitName
	local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
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
				-- if name then
					-- ChatFrame7:AddMessage(tostring(name) .. " = " .. tostring(class))
				-- end
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
				class = UnitClass(string.gsub(button.unit, "raidpet", "raid", 1))
			end
			local color = CUSTOM_CLASS_COLORS[class]
			if color then
				button.nameLabel:SetVertexColor(color.r, color.g, color.b)
			end
		end
	end)
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then

		-- FriendsFrame.lua

		local GetGuildRosterInfo = GetGuildRosterInfo
		local GetWhoInfo = GetWhoInfo
		local CUSTOM_CLASS_COLORS = CUSTOM_CLASS_COLORS
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

		-- LFGFrame.lua

		local GetLFGResults = GetLFGResults
		local LFGS_TO_DISPLAY = LFGS_TO_DISPLAY

		hooksecurefunc("LFMFrame_Update", function()
			-- ChatFrame7:AddMessage("LFMFrame_Update")
			local type = UIDropDownMenu_GetSelectedID(LFMFrameTypeDropDown)
			local name = UIDropDownMenu_GetSelectedID(LFMFrameNameDropDown)
			local n = GetNumLFGResults(type, name)
			local offset = FauxScrollFrame_GetOffset(LFMListScrollFrame)
			local index, class, color, _
			for i = 1, LFGS_TO_DISPLAY, 1 do
				index = i + offset
				if index <= n then
					_, _, _, _, _, _, _, _, _, _, class = GetLFGResults(type, name, index)
					if class then
						color = CUSTOM_CLASS_COLORS[class]
						if class then
							_G["LFMFrameButton" .. i .. "Class"]:SetTextColor(color.r, color.g, color.b)
						end
					end
				end
			end
		end)

		for addon, func in pairs(addonFuncs) do
			if IsAddOnLoaded(addon) then
				func()
				addonFuncs[addon] = nil
			else
				numAddons = numAddons + 1
			end
		end
		if numAddons > 1 then
			self:RegisterEvent("ADDON_LOADED")
		end

	else

		-- ADDON_LOADED

		local addon = ...

		if addonFuncs[addon] then
			addonFuncs[addon]()
			addonFuncs[addon] = nil
			numAddons = numAddons - 1
		end

		if numAddons < 1 then
			self:UnregisterEvent("ADDON_LOADED")
		end

	end
end)