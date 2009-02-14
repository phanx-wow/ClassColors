--[[--------------------------------------------------------------------

	Class Colors
	Change class colors without breaking the Blizzard UI.
	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info-ClassColors.html
	http://wow.curse.com/downloads/wow-addons/details/classcolors.aspx

	Alyssa S. Kinley hereby grants anyone the right to use this work
	for any purpose, without any conditions, unless such conditions
	are required by law.

	Please see the README file for API and other details!

----------------------------------------------------------------------]]

local L = setmetatable({ }, { __index = function(t, k)
	t[k] = k
	return k
end })

L["Class Colors"] = GetAddOnMetadata("!ClassColors", "Title")
L["Change class colors without breaking the Blizzard UI."] = GetAddOnMetadata("!ClassColors", "Notes")

if GetLocale() == "deDE" then
	L.DEATHKNIGHT = "Todestritter"
	L.DRUID = "Druide"
	L.HUNTER = "Jäger"
	L.MAGE = "Magier"
	L.PALADIN = "Paladin"
	L.PRIEST = "Priester"
	L.ROGUE = "Schurke"
	L.SHAMAN = "Schamane"
	L.WARLOCK = "Hexenmeister"
	L.WARRIOR = "Krieger"

	L["Note that not all addons support this, and you may need to reload the UI before your changes are recognized."] = "Note that not all addons support this, and you may need to reload the UI before your changes are recognized."

elseif GetLocale() == "esES" or GetLocale() == "esMX" then
	L.DEATHKNIGHT = "Caballero de la muerte"
	L.DRUID = "Druida"
	L.HUNTER = "Cazador"
	L.MAGE = "Mago"
	L.PALADIN = "Paladín"
	L.PRIEST = "Sacerdote"
	L.ROGUE = "Pícaro"
	L.SHAMAN = "Chamán"
	L.WARLOCK = "Brujo"
	L.WARRIOR = "Guerrero"

	L["Note that not all addons support this, and you may need to reload the UI before your changes are recognized."] = "Note that not all addons support this, and you may need to reload the UI before your changes are recognized."

elseif GetLocale() == "frFR" then
	L.DEATHKNIGHT = "Chevalier de la mort"
	L.DRUID = "Druide"
	L.HUNTER = "Chasseur"
	L.MAGE = "Mage"
	L.PALADIN = "Paladin"
	L.PRIEST = "Prêtre"
	L.ROGUE = "Voleur"
	L.SHAMAN = "Chaman"
	L.WARLOCK = "Démoniste"
	L.WARRIOR = "Guerrier"

	L["Note that not all addons support this, and you may need to reload the UI before your changes are recognized."] = "Note that not all addons support this, and you may need to reload the UI before your changes are recognized."

elseif GetLocale() == "koKR" then
	L.DEATHKNIGHT = "죽음의 기사"
	L.DRUID = "드루이드"
	L.HUNTER = "사냥꾼"
	L.MAGE = "마법사"
	L.PALADIN = "성기사"
	L.PRIEST = "사제"
	L.ROGUE = "도적"
	L.SHAMAN = "주술사"
	L.WARLOCK = "흑마법사"
	L.WARRIOR = "전사"

	L["Note that not all addons support this, and you may need to reload the UI before your changes are recognized."] = "Note that not all addons support this, and you may need to reload the UI before your changes are recognized."

elseif GetLocale() == "ruRU" then
	L.DEATHKNIGHT = "Рыцарь смерти"
	L.DRUID = "Друид"
	L.HUNTER = "Охотник"
	L.MAGE = "Маг"
	L.PALADIN = "Паладин"
	L.PRIEST = "Жрец"
	L.ROGUE = "Разбойник"
	L.SHAMAN = "Шаман"
	L.WARLOCK = "Чернокнижник"
	L.WARRIOR = "Воин"

	L["Note that not all addons support this, and you may need to reload the UI before your changes are recognized."] = "Note that not all addons support this, and you may need to reload the UI before your changes are recognized."

elseif GetLocale() == "zhCN" then
	L.DEATHKNIGHT = "死亡骑士"
	L.DRUID = "德鲁伊"
	L.HUNTER = "猎人"
	L.MAGE = "法师"
	L.PALADIN = "法师"
	L.PRIEST = "牧师"
	L.ROGUE = "潜行者"
	L.SHAMAN = "萨满祭司"
	L.WARLOCK = "术士"
	L.WARRIOR = "战士"

	L["Note that not all addons support this, and you may need to reload the UI before your changes are recognized."] = "Note that not all addons support this, and you may need to reload the UI before your changes are recognized."

elseif GetLocale() == "zhTW" then
	L.DEATHKNIGHT = "死亡騎士"
	L.DRUID = "德魯伊"
	L.HUNTER = "獵人"
	L.MAGE = "法師"
	L.PALADIN = "聖騎士"
	L.PRIEST = "牧師"
	L.ROGUE = "盜賊"
	L.SHAMAN = "薩滿"
	L.WARLOCK = "術士"
	L.WARRIOR = "戰士"

	L["Note that not all addons support this, and you may need to reload the UI before your changes are recognized."] = "Note that not all addons support this, and you may need to reload the UI before your changes are recognized."

else
	L.DEATHKNIGHT = "Death Knight"
	L.DRUID = "Druid"
	L.HUNTER = "Hunter"
	L.MAGE = "Mage"
	L.PALADIN = "Paladin"
	L.PRIEST = "Priest"
	L.ROGUE = "Rogue"
	L.SHAMAN = "Shaman"
	L.WARLOCK = "Warlock"
	L.WARRIOR = "Warrior"
end

------------------------------------------------------------------------

local ClassColors = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)

ClassColors:RegisterEvent("ADDON_LOADED")
ClassColors:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "!ClassColors" then return end
	-- print("ClassColors: ADDON_LOADED")

	-------------------------------------------------------------------

	local db
	local defaults = { }

	-------------------------------------------------------------------

	local classes = { }
	for class in pairs(RAID_CLASS_COLORS) do
		table.insert(classes, class)
	end
	table.sort(classes)

	-------------------------------------------------------------------

	CUSTOM_CLASS_COLORS = { }

	-------------------------------------------------------------------

	if not ClassColorsDB then ClassColorsDB = { } end
	db = ClassColorsDB

	for i, class in ipairs(classes) do
		local color = RAID_CLASS_COLORS[class]

		defaults[class] = { r = color.r, g = color.g, b = color.b }

		if not db[class] or not db[class].r or not db[class].g or not db[class].b then
			db[class] = { r = color.r, g = color.g, b = color.b }
		end

		CUSTOM_CLASS_COLORS[class] = { r = db[class].r, g = db[class].g, b = db[class].b }
	end

	-------------------------------------------------------------------

	local function iter(t, key)
	    local nextkey = next(RAID_CLASS_COLORS, key)
	    return nextkey, t[nextkey]
	end

	local function IterateClasses(self)
	    return iter, self
	end

	-------------------------------------------------------------------

	local callbacks = { }
	local numCallbacks = 0

	local function RegisterCallback(self, method, handler)
		if type(method) ~= "string" and type(method) ~= "function" then
			error("Bad argument #1 to RegisterCallback (string or function expected)")
		end

		if type(method) == "string" then
			if type(handler) ~= "table" then
				error("Bad argument #2 to RegisterCallback (table expected)")
			elseif type(handler[method]) ~= "function" then
				error("Bad argument #1 to RegisterCallback (method \"" .. method .. "\" not found)")
			end

			method = handler[method]
		end

		if callbacks[method] then
		--	Nobody cares. Shut up and play along.
		--	error("Callback already registered!")
			return
		end

		callbacks[method] = handler or true
		numCallbacks = numCallbacks + 1
	end

	local function UnregisterCallback(self, method, handler)
		if type(method) ~= "string" and type(method) ~= "function" then
			error("Bad argument #1 to RegisterCallback (string or function expected)")
		end

		if type(method) == "string" then
			if type(handler) ~= "table" then
				error("Bad argument #2 to RegisterCallback (table expected)")
			elseif type(handler[method]) ~= "function" then
				error("Bad argument #1 to RegisterCallback (method \"" .. method .. "\" not found)")
			end

			method = handler[method]
		end

		if not callbacks[method] then
		--	Nobody cares. Shut up and play along.
		--	error("Callback not registered!")
			return
		end

		callbacks[method] = nil
		numCallbacks = numCallbacks - 1
	end

	local function DispatchCallbacks()
		if numCallbacks < 1 then return end
		-- print("CUSTOM_CLASS_COLORS, DispatchCallbacks")

		for method, handler in pairs(callbacks) do
			if type(handler) == "table" then
				handler[method](handler)
			else
				method()
			end
		end
	end

	-------------------------------------------------------------------
	
	setmetatable(CUSTOM_CLASS_COLORS, { __index = function(t, k)
		if k == "IterateClasses" then return IterateClasses end
		if k == "RegisterCallback" then return RegisterCallback end
		if k == "UnregisterCallback" then return UnregisterCallback end
	end)

	-------------------------------------------------------------------

	local fire
	local shown
	local cache = { }
	local pickers = { }

	self.name = L["Class Colors"]
	self:Hide()

	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText(L["Class Colors"])

	local notes = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	notes:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	notes:SetPoint("RIGHT", self, -32, 0)
	notes:SetHeight(32)
	notes:SetJustifyH("LEFT")
	notes:SetJustifyV("TOP")
	notes:SetNonSpaceWrap(true)
	notes:SetText(L["Change class colors without breaking the Blizzard UI."] .. " " .. L["Note that not all addons support this, and you may need to reload the UI before your changes are recognized."])

	for i, class in ipairs(classes) do
		local color = db[class]

		cache[i] = { }

		pickers[i] = self:CreateColorPicker(L[class])
		pickers[i].class = class

		pickers[i].GetValue = function()
			return color.r, color.g, color.b
		end

		pickers[i].SetValue = function(self, r, g, b)
			color.r = r
			color.g = g
			color.b = b

			self.label:SetTextColor(r, g, b)

			if cache[i].r ~= r or cache[i].g ~= g or cache[i].b ~= b then
				fire = true
			end
		end

		pickers[i]:SetColor(color.r, color.g, color.b)
		pickers[i].label:SetTextColor(color.r, color.g, color.b)

		if i == 1 then
			pickers[i]:SetPoint("TOPLEFT", notes, "BOTTOMLEFT", 8, -16)
		elseif i == 2 then
			pickers[i]:SetPoint("TOPLEFT", notes, "BOTTOM", 8, -16)
		else
			pickers[i]:SetPoint("TOPLEFT", pickers[i-2], "BOTTOMLEFT", 0, -8)
		end
	end

	-------------------------------------------------------------------

	self:SetScript("OnShow", function(self)
		-- print("ClassColors: OnShow")

		for i, picker in ipairs(pickers) do
			local r, g, b = picker:GetValue()
			cache[i].r = r
			cache[i].g = g
			cache[i].b = b
		end

		fire = false
		shown = true
	end)

	self.okay = function()
		-- print("ClassColors: okay")

		for class, color in pairs(db) do
			CUSTOM_CLASS_COLORS[class].r = color.r
			CUSTOM_CLASS_COLORS[class].g = color.g
			CUSTOM_CLASS_COLORS[class].b = color.b
		end
		for i, t in ipairs(cache) do
			wipe(t)
		end
		if fire and shown then
			DispatchCallbacks()
			fire = false
			shown = false
		end
	end

	self.cancel = function()
		-- print("ClassColors: cancel")

		for k, v in pairs(db) do
			CUSTOM_CLASS_COLORS[k].r = v.r
			CUSTOM_CLASS_COLORS[k].g = v.g
			CUSTOM_CLASS_COLORS[k].b = v.b
		end
		for i, picker in ipairs(pickers) do
			local class = picker.class

			picker:SetColor(db[class].r, db[class].g, db[class].b)

			wipe(cache[i])
		end
	end

	self.defaults = function()
		-- print("ClassColors: defaults")

		for k, v in pairs(defaults) do
			db[k].r = v.r
			db[k].g = v.g
			db[k].b = v.b

			CUSTOM_CLASS_COLORS[k].r = v.r
			CUSTOM_CLASS_COLORS[k].g = v.g
			CUSTOM_CLASS_COLORS[k].b = v.b
		end
		for i, picker in ipairs(pickers) do
			local color = db[picker[class]]

			picker:SetColor(color.r, color.g, color.b)

			cache[i].r = color.r
			cache[i].g = color.g
			cache[i].b = color.b
		end
		DispatchCallbacks()
		fire = false
	end

	-------------------------------------------------------------------

	InterfaceOptions_AddCategory(self)

	SLASH_CLASSCOLORS1 = "/classcolors"
	SlashCmdList.CLASSCOLORS = function()
		InterfaceOptionsFrame_OpenToCategory(self)
	end

	-------------------------------------------------------------------

	self:UnregisterEvent("ADDON_LOADED")
	self:SetScript("OnEvent", nil)
end)

------------------------------------------------------------------------

do
	local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
	local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR
	local ColorPickerFrame = ColorPickerFrame
	local GameTooltip = GameTooltip

	local function OnEnter(self)
		local color = NORMAL_FONT_COLOR
		self.bg:SetVertexColor(color.r, color.g, color.b)

		if self.hint then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.hint, nil, nil, nil, nil, true)
		end
	end

	local function OnLeave(self)
		local color = HIGHLIGHT_FONT_COLOR
		self.bg:SetVertexColor(color.r, color.g, color.b)

		GameTooltip:Hide()
	end

	local function OnClick(self)
		OnLeave(self)

		if ColorPickerFrame:IsShown() then
			ColorPickerFrame:Hide()
		else
			self.r, self.g, self.b = self:GetValue()

			UIDropDownMenuButton_OpenColorPicker(self)
			ColorPickerFrame:SetFrameStrata("TOOLTIP")
			ColorPickerFrame:Raise()
		end
	end

	local function SetColor(self, r, g, b)
		self.swatch:SetVertexColor(r, g, b)
		if not ColorPickerFrame:IsShown() then
			self:SetValue(r, g, b)
		end
	end

	function ClassColors:CreateColorPicker(name)
		local frame = CreateFrame("Button", nil, self)
		frame:SetHeight(19)
		frame:SetWidth(100)

		local swatch = frame:CreateTexture(nil, "OVERLAY")
		swatch:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")
		swatch:SetPoint("LEFT")
		swatch:SetWidth(19)
		swatch:SetHeight(19)

		local bg = frame:CreateTexture(nil, "BACKGROUND")
		bg:SetTexture(1, 1, 1)
		bg:SetPoint("CENTER", swatch)
		bg:SetWidth(16)
		bg:SetHeight(16)

		local label = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		label:SetPoint("LEFT", swatch, "RIGHT", 4, 1)
		label:SetHeight(19)
		label:SetText(name)

		frame.SetColor = SetColor
		frame.swatchFunc = function() frame:SetColor(ColorPickerFrame:GetColorRGB()) end
		frame.cancelFunc = function() frame:SetColor(frame.r, frame.g, frame.b) end

		frame:SetScript("OnClick", OnClick)
		frame:SetScript("OnEnter", OnEnter)
		frame:SetScript("OnLeave", OnLeave)

		local width = 19 + 4 + label:GetStringWidth()
		if width > 100 then
			frame:SetWidth(width)
		end

		frame.swatch = swatch
		frame.bg = bg
		frame.label = label

		return frame
	end
end

------------------------------------------------------------------------
--[[

PowerBarColor.MANA.r = 0
PowerBarColor.MANA.g = 144/255
PowerBarColor.MANA.b = 1

RAID_CLASS_COLORS.SHAMAN.r = 0
RAID_CLASS_COLORS.SHAMAN.g = 0.86
RAID_CLASS_COLORS.SHAMAN.b = 0.73

local o = RAID_CLASS_COLORS.DEATHKNIGHT
local x = 1 / o.r
RAID_CLASS_COLORS.DEATHKNIGHT.r = o.r * x
RAID_CLASS_COLORS.DEATHKNIGHT.g = o.g * x
RAID_CLASS_COLORS.DEATHKNIGHT.b = o.b * x

]]