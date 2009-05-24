--[[--------------------------------------------------------------------

	Class Colors
	Change class colors without breaking the Blizzard UI.
	by Phanx < addons@phanx.net >
	Copyright ©2009 Alyssa "Phanx" Kinley
	See accompanying README for license terms and API details.
	http://www.wowinterface.com/downloads/info12513-ClassColors.html
	http://wow.curse.com/downloads/wow-addons/details/classcolors.aspx

----------------------------------------------------------------------]]

local db

local numAddons = 0
local addonFuncs = { }

--
--	Blizzard_InspectUI
--

addonFuncs["Blizzard_InspectUI"] = function()
	local UnitClass = UnitClass

	hooksecurefunc("InspectFrame_OnEvent", function(self, event, ...)
		if not db.InspectFrame then return end

		if event == "UNIT_NAME_UPDATE" and self:IsShow() and unit == self.unit then
			print("InspectFrame_OnEvent")
			local _, class = UnitClass(unit)
			local color = CUSTOM_CLASS_COLORS[class]
			InspectNameText:SetTextColor(color.r, color.g, color.b)
		end
	end)

	hooksecurefunc("InspectFrame_UnitChanged", function(self)
		if not db.InspectFrame then return end
		print("InspectFrame_UnitChanged")

		local _, class = UnitClass(unit)
		local color = CUSTOM_CLASS_COLORS[class]
		InspectNameText:SetTextColor(color.r, color.g, color.b)
	end)

	hooksecurefunc("InspectFrame_OnShow", function(self)
		if not db.InspectFrame then return end

		if not self.unit then return end
		print("InspectFrame_OnShow")

		local _, class = UnitClass(unit)
		local color = CUSTOM_CLASS_COLORS[class]
		InspectNameText:SetTextColor(color.r, color.g, color.b)
	end)
end

--
--	Go!
--

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then

		local defaults = {
			["FriendsFrame"] = true,
			["InspectFrame"] = true,
			["PvPFrame"] = true,
			["TradeFrame"] = true,
			["UnitFrame"] = true,
		}

		ClassColorsDB.extras = ClassColorsDB.extras or { }
		db = ClassColorsDB.extras
		
		for k, v in pairs(defaults) do
			if type(db[k]) ~= type(v) then
				db[k] = v
			end
		end

		--
		--	FriendsFrame.lua
		--

		local GetFriendInfo = GetFriendInfo
		hooksecurefunc("FriendsList_Update", function()
			if not db.FriendsFrame then return end
			print("FriendsList_Update")

			local n = GetNumFriends()
			local offset = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame)

			for i = 1, FRIENDS_TO_DISPLAY do
				local _, _, class = GetFriendInfo(offset + i)
				if class then
					class = CUSTOM_CLASS_COLORS:GetClassToken(class) or class
					local color = CUSTOM_CLASS_COLORS[class]
					if color then
						_G["FriendsFrameFriendButton"..i.."ButtonTextName"]:SetTextColor(color.r, color.g, color.b)
					end
				end
			end
		end)

		--
		--	PVPFrame.lua
		--

		local format = string.format
		local GetArenaTeamRosterInfo = GetArenaTeamRosterInfo
		hooksecurefunc("PVPTeamDetails_Update", function(id)
			if not db.PvPFrame then return end
			print("PVPTeamDetails_Update")

			for i = 1, MAX_ARENA_TEAM_MEMBERS do
				if _G["PVPTeamDetailsButton"..i]:IsShown() then
					name, _, _, classLocal, online = GetArenaTeamRosterInfo(id, i)
					local class = classLocal and CUSTOM_CLASS_COLORS:GetClassToken(classLocal)
					if class then
						local color = CUSTOM_CLASS_COLORS[class]

						local r, g, b = color.r, color.g, color.b
						if not online then
							r = r / 2
							g = g / 2
							b = g / 2
						end

						button.tooltip = format("%s %s |cff%02x%02x%02x%s|r", LEVEL, level, r * 255, g * 255, b * 255, classLocal)

						_G["PVPTeamDetailsButton"..i.."NameText"]:SetTextColor(r, g, b)
						_G["PVPTeamDetailsButton"..i.."ClassText"]:SetTextColor(r, g, b)
					end
				end
			end
		end)

		--
		--	TradeFrame.lua
		--

		hooksecurefunc("TradeFrame_Update", function()
			if not db.TradeFrame then return end
			print("TradeFrame_Update")

			local _, class = UnitClass("player")
			local color = CUSTOM_CLASS_COLORS[class]
			TradeFramePlayerNameText:SetTextColor(color.r, color.g, color.b)

			if UnitIsPlayer("NPC") then
				_, class = UnitClass("NPC")
				color = CUSTOM_CLASS_COLORS[class]
				TradeFrameRecipientNameText:SetTextColor(color.r, color.g, color.b)
			end
		end)

		--
		--	UnitFrame.lua
		--

		hooksecurefunc("UnitFrame_Update", function(self)
			if not db.UnitFrame then return end

			if UnitIsPlayer(self.unit) then
				print("UnitFrame_Update")
				local _, class = UnitClass(self.unit)
				local color = CUSTOM_CLASS_COLORS[class]
				self.name:SetTextColor(color.r, color.g, color.b)
			end
		end)

		hooksecurefunc("UnitFrame_OnEvent", function(self, event, unit)
			if not db.UnitFrame then return end

			if event == "UNIT_PORTRAIT_UPDATE" and UnitIsPlayer(self.unit) then
				print("UnitFrame_OnEvent")
				local _, class = UnitClass(self.unit)
				local color = CUSTOM_CLASS_COLORS[class]
				self.name:SetTextColor(color.r, color.g, color.b)
			end
		end)

		--
		--	See if we need to watch ADDON_LOADED
		--

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

		--
		--	ADDON_LOADED
		--

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