------------------------------------------------------------------------

if not ClassColors then return end

local db
local ClassColorsExtras = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
ClassColors.Extras = ClassColorsExtras

------------------------------------------------------------------------

function ClassColorsExtras:Load()
	print("ClassColorsExtras: Load")

	db = ClassColorsDB
	db.extras = db.extras or { }
	for k, v in pairs({
		friends = true,
		inspect = true,
		pvp = true,
		trade = true,
		unit = true,
	}) do
		if type(db[k]) ~= type(v) then
			db[k] = v
		end
	end

	-------------------------------------------------------------------
	-- Blizzard_InspectUI\Blizzard_InspectUI.lua
	-------------------------------------------------------------------

	local function applyInspectUI()
		print("ClassColorsExtras: applyInspectUI")
	
		local UnitClass = UnitClass

		hooksecurefunc("InspectFrame_OnEvent", function(self, event, ...)
			if not db.inspect then return end

			if event == "UNIT_NAME_UPDATE" and self:IsShow() and unit == self.unit then
				local _, class = UnitClass(unit)
				local color = CUSTOM_CLASS_COLORS[class]
				InspectNameText:SetTextColor(color.r, color.g, color.b)
			end
		end)

		hooksecurefunc("InspectFrame_UnitChanged", function(self)
			if not db.inspect then return end

			local _, class = UnitClass(unit)
			local color = CUSTOM_CLASS_COLORS[class]
			InspectNameText:SetTextColor(color.r, color.g, color.b)
		end)

		hooksecurefunc("InspectFrame_OnShow", function(self)
			if not db.inspect then return end

			if not self.unit then return end

			local _, class = UnitClass(unit)
			local color = CUSTOM_CLASS_COLORS[class]
			InspectNameText:SetTextColor(color.r, color.g, color.b)
		end)

		applyInspectUI = nil
	end
	if InspectFrame_OnEvent then
		applyInspectUI()
	else
		self:RegisterEvent("ADDON_LOADED")
		self:SetScript("OnEvent", function(self, event, addon)
			if addon == "Blizzard_InspectUI" then
				applyInspectUI()
			end
		end)
	end

	-------------------------------------------------------------------
	--	FriendsFrame.lua
	-------------------------------------------------------------------

	local GetFriendInfo = GetFriendInfo

	hooksecurefunc("FriendsList_Update", function()
		if not db.friends then return end

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

	-------------------------------------------------------------------
	--	PVPFrame.lua
	-------------------------------------------------------------------

	local format = string.format
	local GetArenaTeamRosterInfo = GetArenaTeamRosterInfo

	hooksecurefunc("PVPTeamDetails_Update", function(id)
		if not db.pvp then return end

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

	-------------------------------------------------------------------
	--	TradeFrame.lua
	-------------------------------------------------------------------

	hooksecurefunc("TradeFrame_Update", function()
		if not db.trade then return end

		local _, class = UnitClass("player")
		local color = CUSTOM_CLASS_COLORS[class]
		TradeFramePlayerNameText:SetTextColor(color.r, color.g, color.b)

		if UnitIsPlayer("NPC") then
			_, class = UnitClass("NPC")
			color = CUSTOM_CLASS_COLORS[class]
			TradeFrameRecipientNameText:SetTextColor(color.r, color.g, color.b)
		end
	end)

	-------------------------------------------------------------------
	--	UnitFrame.lua
	-------------------------------------------------------------------

	hooksecurefunc("UnitFrame_Update", function(self)
		if not db.unit then return end

		if UnitIsPlayer(self.unit) then
			local _, class = UnitClass(self.unit)
			local color = CUSTOM_CLASS_COLORS[class]
			self.name:SetTextColor(color.r, color.g, color.b)
		end
	end)

	hooksecurefunc("UnitFrame_OnEvent", function(self, event, unit)
		if not db.unit then return end

		if event == "UNIT_PORTRAIT_UPDATE" and UnitIsPlayer(self.unit) then
			local _, class = UnitClass(self.unit)
			local color = CUSTOM_CLASS_COLORS[class]
			self.name:SetTextColor(color.r, color.g, color.b)
		end
	end)

	-------------------------------------------------------------------
	--	Options
	-------------------------------------------------------------------

	self.name = L["Extras"]
	self:Hide()

	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(L["Extra Options"])

	local notes = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	notes:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	notes:SetPoint("RIGHT", self, -32, 0)
	notes:SetHeight(48)
	notes:SetJustifyH("LEFT")
	notes:SetJustifyV("TOP")
	notes:SetNonSpaceWrap(true)
	notes:SetText(L["Use this panel to apply class coloring to additional parts of the default UI."])

	local pvp = self:CreateCheckbox(L["Arena team frame"])
	pvp.hint = L["Color the names of your arena team members in the arena team frame"]
	pvp:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 0, -8)
	pvp:SetChecked(db.pvp)
	pvp:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.pvp = checked
	end)

	local friends = self:CreateCheckbox(L["Friends frame"])
	friends.hint = L["Color the names of online friends in your friends list"]
	friends:SetPoint("TOPLEFT", pvp, "BOTTOMLEFT", 0, -8)
	friends:SetChecked(db.friends)
	friends:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.friends = checked
	end)

	local inspect = self:CreateCheckbox(L["Inspect frame"])
	inspect.hint = L["Color the name of the inspected player in the inspect frame"]
	inspect:SetPoint("TOPLEFT", friends, "BOTTOMLEFT", 0, -8)
	inspect:SetChecked(db.inspect)
	inspect:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.inspect = checked
	end)

	local trade = self:CreateCheckbox(L["Trade frame"])
	trade.hint = L["Color the name of the target player in the trade frame"]
	trade:SetPoint("TOPLEFT", inspect, "BOTTOMLEFT", 0, -8)
	trade:SetChecked(db.trade)
	trade:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.trade = checked
	end)

	local unit = self:CreateCheckbox(L["Unit frames"])
	unit.hint = L["Color the names of players on the default unit frames"]
	unit:SetPoint("TOPLEFT", trade, "BOTTOMLEFT", 0, -8)
	unit:SetChecked(db.unit)
	unit:SetScript("OnClick", function(self)
		local checked = self:GetChecked() and true or false
		PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		db.unit = checked
	end)

	self.parent = ClassColors.name

	InterfaceOptions_AddCategory(self)

	self.Load = nil
end

------------------------------------------------------------------------

do
	local function OnEnter(self)
		if self.hint then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.hint, nil, nil, nil, nil, true)
		end
	end

	local function OnLeave()
		GameTooltip:Hide()
	end

	function extras:CreateCheckbox(text, size)
		local check = CreateFrame("CheckButton", nil, parent)
		check:SetWidth(size or 26)
		check:SetHeight(size or 26)

		check:SetHitRectInsets(0, -100, 0, 0)

		check:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		check:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		check:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
		check:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
		check:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")

		check:SetScript("OnEnter", OnEnter)
		check:SetScript("OnLeave", OnLeave)

		check:SetScript("OnClick", Checkbox_OnClick)

		local label = check:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		label:SetPoint("LEFT", check, "RIGHT", 0, 1)
		label:SetText(text)

		check.label = label

		return check
	end
end

------------------------------------------------------------------------