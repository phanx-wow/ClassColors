--[[--------------------------------------------------------------------

	Class Colors
	Change class colors without breaking the Blizzard UI.
	by Phanx < addons@phanx.net >
	Copyright ©2009 Alyssa "Phanx" Kinley
	See accompanying README for license terms and API details.
	http://www.wowinterface.com/downloads/info12513-ClassColors.html
	http://wow.curse.com/downloads/wow-addons/details/classcolors.aspx

----------------------------------------------------------------------]]

local L = setmetatable({ }, { __index = function(t, k)
	t[k] = k
	return k
end })

FillLocalizedClassList(L, false)

L["Class Colors"] = GetAddOnMetadata("!ClassColors", "Title")
L["Change class colors without breaking the Blizzard UI."] = GetAddOnMetadata("!ClassColors", "Notes")

--	if GetLocale() == "xxXX" then
--		L["Note that not all addons support this, and you may need to reload the UI before your changes are recognized."] = ""
--	end

------------------------------------------------------------------------

CUSTOM_CLASS_COLORS = { }

------------------------------------------------------------------------

local function iter(t, key)
	local nextkey = next(RAID_CLASS_COLORS, key)
	return nextkey, t[nextkey]
end

local function IterateClasses(self)
	return iter, self
end

------------------------------------------------------------------------

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
		method(handler ~= true and handler)
	end
end

------------------------------------------------------------------------

local classTokens = { }
for i, class in ipairs(classes) do
	classTokens[L[class]] = class
end

local function GetClassToken(self, className)
	return className and classTokens[className]
end

------------------------------------------------------------------------

setmetatable(CUSTOM_CLASS_COLORS, { __index = function(t, k)
	if k == "GetClassToken" then return GetClassToken end
	if k == "IterateClasses" then return IterateClasses end
	if k == "RegisterCallback" then return RegisterCallback end
	if k == "UnregisterCallback" then return UnregisterCallback end
end })

------------------------------------------------------------------------

local f = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "!ClassColors" then return end
	-- print("ClassColors: ADDON_LOADED")

	--------------------------------------------------------------------

	local db
	local defaults = { }

	--------------------------------------------------------------------

	local classes = { }
	for class in pairs(RAID_CLASS_COLORS) do
		table.insert(classes, class)
	end
	table.sort(classes)

	--------------------------------------------------------------------

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

	--------------------------------------------------------------------

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
	notes:SetHeight(48)
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
			self.label:SetTextColor(r, g, b)

			color.r = r
			color.g = g
			color.b = b

			CUSTOM_CLASS_COLORS[class].r = r
			CUSTOM_CLASS_COLORS[class].g = g
			CUSTOM_CLASS_COLORS[class].b = b

			if cache[i].r ~= r or cache[i].g ~= g or cache[i].b ~= b then
				DispatchCallbacks()
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

	--------------------------------------------------------------------

	self:SetScript("OnShow", function(self)
		-- print("ClassColors: OnShow")

		for i, picker in ipairs(pickers) do
			local r, g, b = picker:GetValue()
			cache[i].r = r
			cache[i].g = g
			cache[i].b = b
		end

		shown = true
	end)

	self.okay = function()
		if not shown then return end
		-- print("ClassColors: okay")

		for i, t in ipairs(cache) do
			wipe(t)
		end

		shown = false
	end

	self.cancel = function()
		if not shown then return end
		-- print("ClassColors: cancel")

		local changed

		for i, picker in ipairs(pickers) do
			local class = picker.class

			if db[class].r ~= cache[i].r or db[class].r ~= cache[i].r or db[class].r ~= cache[i].r then
				changed = true

				picker:SetColor(cache[class].r, cache[class].g, cache[class].b)

				db[class].r = cache[i].r
				db[class].g = cache[i].g
				db[class].b = cache[i].b

				CUSTOM_CLASS_COLORS[class].r = cache[i].r
				CUSTOM_CLASS_COLORS[class].g = cache[i].g
				CUSTOM_CLASS_COLORS[class].b = cache[i].b
			end

			wipe(cache[i])
		end

		if changed then
			DispatchCallbacks()
		end

		shown = false
	end

	self.defaults = function()
		-- print("ClassColors: defaults")

		local changed

		for i, picker in ipairs(pickers) do
			local class = picker.class
			local color = RAID_CLASS_COLORS[class]

			if db[class].r ~= color.r or db[class].g ~= color.g or db[class].b ~= color.b then
				changed = true

				picker:SetColor(color.r, color.g, color.b)

				cache[i].r = color.r
				cache[i].g = color.g
				cache[i].b = color.b

				db[class].r = color.r
				db[class].g = color.g
				db[class].b = color.b

				CUSTOM_CLASS_COLORS[class].r = color.r
				CUSTOM_CLASS_COLORS[class].g = color.g
				CUSTOM_CLASS_COLORS[class].b = color.b
			end
		end

		if changed then
			DispatchCallbacks()
		end
	end

	--------------------------------------------------------------------

	local reset = CreateFrame("Button", nil, self)
	reset:SetPoint("BOTTOMRIGHT", self, -16, 16)
	reset:SetWidth(80)
	reset:SetHeight(24)
	reset:SetNormalFontObject(GameFontNormalSmall)
	reset:SetDisabledFontObject(GameFontDisable)
	reset:SetHighlightFontObject(GameFontHighlightSmall)
	reset:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
	reset:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
	reset:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	reset:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
	reset:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
	reset:GetHighlightTexture():SetBlendMode("ADD")
	reset:SetScript("OnEnter", function(self)
		if self.hint then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.hint, nil, nil, nil, nil, true)
		end
	end)
	reset:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	reset:SetText(L["Reset"])
	reset.hint = L["Reset all class colors to their Blizzard defaults."]
	reset:SetScript("OnClick", self.defaults)

	--------------------------------------------------------------------

	InterfaceOptions_AddCategory(self)

	--------------------------------------------------------------------

	SLASH_CLASSCOLORS1 = "/classcolors"
	SlashCmdList.CLASSCOLORS = function()
		InterfaceOptionsFrame_OpenToCategory(self)
	end

	--------------------------------------------------------------------

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

	function f:CreateColorPicker(name)
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