
!ClassColors - a World of Warcraft user interface addon

	by Phanx < addons@phanx.net >
	http://www.wowinterface.com/downloads/info6330-AnkhUp.html
	http://wow.curse.com/downloads/wow-addons/details/ankhup.aspx

Description

	!ClassColors allows you to change class colors without breaking the
	default UI.

Usage

	Options are available in the Interface Options window. Type
	"/classcolors" to open the Interface Options window directly to the
	!ClassColors panel.

Localization

	Compatible with: en*, deDE, esES, esMX, frFR, koKR, ruRU, zhCN, zhTW
	Translated into: en*

	If you can help translate for any locale, please contact me.

Feedback

	Please use the ticket system on either download site report bugs or
	request features. Use the comment system only for general questions
	or comments.

	If you need to contact me privately, you may do by private message
	on either download site, or by email at addons@phanx.net.

	Note that email and private messaging are not appropriate ways to
	report bugs, request features, or ask for help with using an addon.

Information for Addon Authors

	Supporting the CUSTOM_CLASS_COLORS standard is simple. All you need
	to do is check for the existence of a global CUSTOM_CLASS_COLORS
	table, and read from it instead of RAID_CLASS_COLORS if it exists.

	If your addon keeps a local cache of class colors, you should also
	register for a callback when class colors are changed, and update
	your cache when the callback is fired.
	
	Also, is you build your cache before the PLAYER_LOGIN event, you
	should also update it during or after that event. !ClassColors
	stores custom class colors in saved variables, and may not have been
	loaded before your addon. Because CUSTOM_CLASS_COLORS is a standard
	and can be implemented by any addon, you should avoid setting an
	OptionalDependency on !ClassColors.
	
	Detailed API documentation can be found here:
	http://www.wowinterface.com/portal.php?&id=224&pageid=198

License

	Copyright ©2009 Alyssa "Phanx" Kinley.

	The contents of this addon, excluding third-party resources, are
	copyrighted to its author with all rights reserved, under United
	States copyright law and various international treaties.

	The author of this addon hereby grants you the following rights:

	1. You may make modifications to this addon for private use only.

	2. You may use source code from this addon for any purpose, provided
	that the names of this addon and its author do not appear in the
	title, source code, or file names of your project, and are not used
	to promote your project.

	3. If you are a compilation creator, you may include this addon in
	your compilation provided that you do not modify it in any way, and
	that your compilation's download page includes a hyperlink to one of
	this addon's download pages. If you are not a compilation creator,
	this does not give you permission to distribute this addon inside of
	compilations.

	All rights not explicitly addressed in this license are reserved by
	the copyright holder.
