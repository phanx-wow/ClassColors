--[[--------------------------------------------------------------------
	!ClassColors
	Change class colors without breaking the Blizzard UI.
	Written by Phanx <addons@phanx.net>
	Maintained by Akkorian <akkorian@hotmail.com>
	Copyright © 2009–2011 Phanx. Some rights reserved. See LICENSE.txt for details.
	http://www.wowinterface.com/downloads/info12513-ClassColors.html
	http://wow.curse.com/downloads/wow-addons/details/classcolors.aspx
----------------------------------------------------------------------]]

local addonFuncs = { }

local PLAYER_LEVEL = PLAYER_LEVEL:gsub( "|c%%s", "|cff%%02x%%02x%%02x", 1 )
local PLAYER_LEVEL_NO_SPEC = PLAYER_LEVEL_NO_SPEC:gsub( "|c%%s", "|cff%%02x%%02x%%02x" )

-- ChatConfigFrame.xml

do
	local colorChatConfig = function( )
		for i, class in ipairs( CLASS_SORT_ORDER ) do
			local color = CUSTOM_CLASS_COLORS[ class ]
			if color then
				ChatConfigChatSettingsClassColorLegend.classStrings[ i ]:SetFormattedText( "|cff%02x%02x%02x%s|r\n", color.r * 255, color.g * 255, color.b * 255, LOCALIZED_CLASS_NAMES_MALE[ class ] )
				ChatConfigChannelSettingsClassColorLegend.classStrings[ i ]:SetFormattedText( "|cff%02x%02x%02x%s|r\n", color.r * 255, color.g * 255, color.b * 255, LOCALIZED_CLASS_NAMES_MALE[ class ] )
			end
		end
	end

	CUSTOM_CLASS_COLORS:RegisterCallback( colorChatConfig )
	colorChatConfig( )
end

-- ChatFrame.lua

function GetColoredName( event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12 )
	if arg12 and arg12 ~= "" then
		local chatType = event:sub( 10 )
		if chatType:sub( 1, 7 ) == "WHISPER" then
			chatType = "WHISPER"
		elseif chatType:sub( 1, 7 ) == "CHANNEL" then
			chatType = "CHANNEL" .. arg8
		end

		local info = ChatTypeInfo[ chatType ]
		if info and info.colorNameByClass then
			local _, class = GetPlayerInfoByGUID( arg12 )
			if class then
				local color = CUSTOM_CLASS_COLORS[ class ]
				if class then
					return format( "\124cff%02x%02x%02x%s\124r", color.r * 255, color.g * 255, color.b * 255, arg2 )
				end
			end
		end
	end

	return arg2
end

-- CompactUnitFrame.lua

hooksecurefunc( "CompactUnitFrame_UpdateHealthColor", function( frame )
	-- print( "CompactUnitFrame_UpdateHealthColor", frame.unit or "NONE" )
	if frame.optionTable.useClassColors and UnitIsConnected( frame.unit ) then
		local _, class = UnitClass( frame.unit )
		local color = CUSTOM_CLASS_COLORS[ class ]
		if color then
			frame.healthBar:SetStatusBarColor( color.r, color.g, color.b )
		end
	end
end )

-- FriendsFrame.lua

hooksecurefunc( "WhoList_Update", function( )
	-- print( "WhoListUpdate" )
	local offset = FauxScrollFrame_GetOffset( WhoListScrollFrame )
	for i = 1, WHOS_TO_DISPLAY do
		local _, _, _, _, _, _, class = GetWhoInfo( i + offset )
		if class then
			local color = CUSTOM_CLASS_COLORS[ class ]
			if color then
				_G[ "WhoFrameButton" .. i .. "Class" ]:SetTextColor( color.r, color.g, color.b )
			end
		end
	end
end )

-- LFDFrame.lua

hooksecurefunc( "LFDQueueFrameRandomCooldownFrame_Update", function( )
	-- print( "LFDQueueFrameRandomCooldownFrame_Update" )
	for i = 1, GetNumPartyMembers( ) do
		local _, class = UnitClass( "party"..i )
		if class then
			local color = CUSTOM_CLASS_COLORS[ class ]
			if color then
				_G[ "LFDQueueFrameCooldownFrameName"..i ]:SetFormattedText( "|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, UnitName( "party"..i ) )
			end
		end
	end
end )

-- LFRFrame.lua

hooksecurefunc( "LFRBrowseFrameListButton_SetData", function( button, i )
	-- print( "LFRBrowseFrameListButton_SetData" )
	local _, _, _, _, _, _, _, class = SearchLFGGetResults( i )
	if class then
		local color = CUSTOM_CLASS_COLORS[ class ]
		if color then
			button.class:SetTextColor( color.r, color.g, color.b )
		end
	end
end )

-- PaperDollFrame.lua

hooksecurefunc( "PaperDollFrame_SetLevel", function( )
	-- print( "PaperDollFrame_SetLevel" )
	local className, class = UnitClass( "player" )
	local color = CUSTOM_CLASS_COLORS[ class ]
	if color then
		local specName, _
		local primaryTalentTree = GetPrimaryTalentTree( )
		if primaryTalentTree then
			_, specName = GetTalentTabInfo( primaryTalentTree )
		end
		if specName and specName ~= "" then
			CharacterLevelText:SetFormattedText( PLAYER_LEVEL, UnitLevel( "player" ), color.r * 255, color.g * 255, color.b * 255, specName, className )
		else
			CharacterLevelText:SetFormattedText( PLAYER_LEVEL_NO_SPEC, UnitLevel( "player" ), color.r * 255, color.g * 255, color.b * 255, className )
		end
	end
end )

------------------------------------------------------------------------

addonFuncs.Blizzard_Calendar = function( )
	hooksecurefunc( "CalendarViewEventInviteListScrollFrame_Update", function( )
		-- print( "CalendarViewEventInviteListScrollFrame_Update" )
		local buttons = CalendarViewEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset( CalendarViewEventInviteListScrollFrame )
		for i = 1, #buttons do
			local name, _, _, class = CalendarEventGetInvite( i + offset )
			if name and class then
				local color = CUSTOM_CLASS_COLORS[ class ]
				if color then
					local button = buttons[ i ]:GetName( )
					_G[ button .. "Name" ]:SetTextColor( color.r, color.g, color.b )
					_G[ button .. "Class" ]:SetTextColor( color.r, color.g, color.b )
				end
			end
		end
	end )

	hooksecurefunc( "CalendarCreateEventInviteListScrollFrame_Update", function( )
		-- print( "CalendarCreateEventInviteListScrollFrame_Update" )
		local buttons = CalendarCreateEventInviteListScrollFrame.buttons
		local offset = HybridScrollFrame_GetOffset( CalendarCreateEventInviteListScrollFrame )
		for i = 1, #buttons do
			local name, _, _, class = CalendarEventGetInvite( i + offset )
			if name and class then
				local color = CUSTOM_CLASS_COLORS[ class ]
				if color then
					local button = buttons[ i ]:GetName( )
					_G[ button .. "Name" ]:SetTextColor( color.r, color.g, color.b )
					_G[ button .. "Class" ]:SetTextColor( color.r, color.g, color.b )
				end
			end
		end
	end )
end

------------------------------------------------------------------------

addonFuncs.Blizzard_GuildUI = function( )
	hooksecurefunc( "GuildRosterButton_SetStringText", function( buttonString, text, online, class )
		-- print( "GuildRosterButton_SetStringText" )
		if online and class then
			local color = CUSTOM_CLASS_COLORS[ class ]
			if color then
				buttonString:SetTextColor( color.r, color.g, color.b )
			end
		end
	end )
end

------------------------------------------------------------------------

addonFuncs.Blizzard_InspectUI = function( )
	hooksecurefunc( "InspectPaperDollFrame_SetLevel", function( )
		-- print( "InspectPaperDollFrame_SetLevel" )
		local unit = InspectFrame.unit

		local level = UnitLevel( InspectFrame.unit )
		if level == -1 then
			level = "??"
		end

		local className, class = UnitClass( InspectFrame.unit )
		local color = CUSTOM_CLASS_COLORS[ class ]

		local specName, _
		local primaryTalentTree = GetPrimaryTalentTree( true )
		if primaryTalentTree then
			_, specName = GetTalentTabInfo( primaryTalentTree, true )
		end

		if specName and specName ~= "" then
			InspectLevelText:SetFormattedText( PLAYER_LEVEL, level, color.r * 255, color.g * 255, color.b * 255, specName, className )
		else
			InspectLevelText:SetFormattedText( PLAYER_LEVEL_NO_SPEC, level, color.r * 255, color.g * 255, color.b * 255, className )
		end
	end )
end

------------------------------------------------------------------------

addonFuncs.Blizzard_RaidUI = function( )
	hooksecurefunc( "RaidGroupFrame_Update", function( )
		-- print( "RaidGroupFrame_Update" )
		local numRaidMembers = GetNumRaidMembers( )
		for i = 1, MAX_RAID_MEMBERS do
			if i <= numRaidMembers then
				local _, _, subgroup, _, _, class, _, online, dead = GetRaidRosterInfo( i )
				if _G[ "RaidGroup" .. subgroup ].nextIndex <= MEMBERS_PER_RAID_GROUP then
					if online and not dead then
						local color = CUSTOM_CLASS_COLORS[ class ]
						if color then
							local subframes =  _G[ "RaidGroupButton" .. i ].subframes
							subframes.name:SetTextColor( color.r, color.g, color.b )
							subframes.class:SetTextColor( color.r, color.g, color.b )
							subframes.level:SetTextColor( color.r, color.g, color.b )
						end
					end
				end
			end
		end
	end )

	hooksecurefunc( "RaidGroupFrame_UpdateHealth", function( i )
		-- print( "RaidGroupFrame_UpdateHealth", i )
		local _, _, _, _, _, class, _, online, dead = GetRaidRosterInfo( i )
		if online and not dead then
			local color = CUSTOM_CLASS_COLORS[ class ]
			if color then
				_G[ "RaidGroupButton" .. i .. "Name" ]:SetTextColor( color.r, color.g, color.b )
				_G[ "RaidGroupButton" .. i .. "Class" ]:SetTextColor( color.r, color.g, color.b )
				_G[ "RaidGroupButton" .. i .. "Level" ]:SetTextColor( color.r, color.g, color.b )
			end
		end
	end )

	hooksecurefunc( "RaidPullout_UpdateTarget", function( frame, button, unit, which )
		-- print( "RaidPullout_UpdateTarget", frame, unit )
		if _G[ frame ][ "show" .. which ] then
			local name = UnitName( unit )
			if name and name ~= UNKNOWNOBJECT then
				local _, class = UnitClass( unit )
				if class and UnitCanCooperate( "player", unit ) then
					local color = CUSTOM_CLASS_COLORS[ class ]
					if color then
						_G[ button .. which .. "Name" ]:SetVertexColor( color.r, color.g, color.b )
					end
				end
			end
		end
	end )

	hooksecurefunc( "RaidPulloutButton_UpdateDead", function( button, dead, class )
		-- print( "RaidPulloutButton_UpdateDead", button.unit )
		if not dead then
			if class == "PETS" then
				class = UnitClass( button.unit:gsub( "raidpet", "raid" ) )
			end
			local color = CUSTOM_CLASS_COLORS[ class ]
			if color then
				button.nameLabel:SetVertexColor( color.r, color.g, color.b )
			end
		end
	end )
end

------------------------------------------------------------------------

local numAddons = 0

for addon, func in pairs( addonFuncs ) do
	if IsAddOnLoaded( addon ) then
		addonFuncs[ addon ] = nil
		func( )
	else
		numAddons = numAddons + 1
	end
end

if numAddons > 0 then
	local f = CreateFrame( "Frame" )
	f:RegisterEvent( "ADDON_LOADED" )
	f:SetScript( "OnEvent", function( self, event, addon )
		local func = addonFuncs[ addon ]
		if func then
			addonFuncs[ addon ] = nil
			numAddons = numAddons - 1
			func( )
		end
		if numAddons == 0 then
			self:UnregisterEvent( "ADDON_LOADED" )
			self:SetScript( "OnEvent", nil )
		end
	end )
end