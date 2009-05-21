------------------------------------------------------------------------
--	Description
------------------------------------------------------------------------

Class Colors
Change class colors without breaking the Blizzard UI.
by Phanx < addons@phanx.net >

http://www.wowinterface.com/downloads/info12513-ClassColors.html
http://wow.curse.com/downloads/wow-addons/details/classcolors.aspx

------------------------------------------------------------------------
--	Information For Users
------------------------------------------------------------------------

Class Colors currently provides a GUI for changing class colors, and 
applies custom class colors to the Blizzard UI. Type "/classcolors" or 
open the Blizzard Interface Options window, click the AddOns tab, and 
click the Class Colors entry in the left-hand column.

------------------------------------------------------------------------
--	Bug Reports & Feature Requests
------------------------------------------------------------------------

Please file bug reports and feature requests here:
- http://wow.curseforge.com/projects/classcolors/tickets/?filter_status=+

or here:
- http://www.wowinterface.com/portal.php?id=224&a=listbugs
- http://www.wowinterface.com/portal.php?id=224&a=listfeatures

------------------------------------------------------------------------
--	General Feedback
------------------------------------------------------------------------

Please post general comments, questions, and suggestions here:
- http://www.wowinterface.com/downloads/info12513-ClassColors.html#comments

or here:
- http://forums.wowace.com/showthread.php?p=265975

------------------------------------------------------------------------
--	Information For Addon Authors
------------------------------------------------------------------------

Supporting this system is as easy as checking for the existence of a 
global table CUSTOM_CLASS_COLORS and reading from it instead of 
RAID_CLASS_COLORS if it exists.

If your addon creates a local cache of class colors, it is recommended 
that you also register for a callback when class colors are changed by 
the user (see API documentation below) and update your color cache when 
the callback is fired.

------------------------------------------------------------------------
--	API Documentation
------------------------------------------------------------------------

CUSTOM_CLASS_COLORS:RegisterCallback(method[, handler])
	- method - function or string
	- handler - table containing function value 'method' (required if 
		'method' is a string, ignored if 'method' is a function)

	* Registers a function to be called when class colors are changed.
	* If 'method' is a function, that function will be called with no
	  arguments.
	* If 'method' is a string, 'handler[method]' will be called with
	  'handler' as the first argument.

CUSTOM_CLASS_COLORS:UnregisterCallback(method[, handler])
	- method - function or string
	- handler - table containing function value 'method' (required if 
		'method' is a string, ignored if 'method' is a function)

	* Removes a function from the callback registry.

------------------------------------------------------------------------
--	Implementation Details
------------------------------------------------------------------------

Class Colors is built on a proposed community standard for a global 
table of alternate class colors that can be freely modified without 
tainting anything. This means that addons must explicitly support this 
standard (see below for details). Class Colors is only one possible 
implementation of this standard. Any implementation must provide the 
following:

	* Create and populate a global table CUSTOM_CLASS_COLORS with the 
	  same keys and value structure as RAID_CLASS_COLORS
	* Define methods :RegisterCallback, and :UnregisterCallback on the 
	  CUSTOM_CLASS_COLORS table (see API documentation above), using a 
	  metatable __index so that people can still iterate over the table 
	  using pairs() without having to work around function values

The following are highly recommended, and generally expected, but won't 
technically break anything if they aren't provided:

	* Provide a facility by which users may change class colors
	* Store changed class colors between sessions
	* Maintain a registry of functions requesting callbacks when class 
	  colors are changed, and call those functions when appropriate (see 
	  API documentation above)
	* Apply user-defined class colors to the Blizzard UI

------------------------------------------------------------------------
--	Example #1
------------------------------------------------------------------------

Before:

	local color = RAID_CLASS_COLORS[class]

After:

	local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

Or:

	local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
	local color = RAID_CLASS_COLORS[class]

------------------------------------------------------------------------
--	Example #2
------------------------------------------------------------------------

Before:

	local classColors = { }
	for class, color = pairs(RAID_CLASS_COLORS) do
		classColors[class] = { color.r, color.g, color.b }
	end

After:

	local classColors = { }
	for class, color in pairs(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
		classColors[class] = { color.r, color.g, color.b }
	end
	if CUSTOM_CLASS_COLORS then
		CUSTOM_CLASS_COLORS:RegisterCallback(function()
			for class, color in pairs(CUSTOM_CLASS_COLORS) do
				classColors[class] = { color.r, color.g, color.b }
			end
			-- update visible addon parts with new colors here!
		end)
	end

------------------------------------------------------------------------
--	License
------------------------------------------------------------------------

Copyright ©2008–2009 Alyssa "Phanx" Kinley

The contents of this addon, excluding third-party resources, are copyrighted
to its author with all rights reserved under United States copyright law and
international treaty. Copyright specifies certain rights and restrictions
persuant to your use of this addon, and this license grants you certain
additional rights. Installing, using, or distributing this addon shall
constitute acceptance of the terms of this license.

1. You MAY download, install, and use this addon for private use.

2. You MAY make modifications to this addon for private use.

3. You MAY NOT distribute this addon, modified or unmodified, including as 
part of a compilation or premade user interface, without the prior written 
consent of the copyright holder. The copyright owner, through the act of 
uploading this addon to a distributor, grants that distributor a 
non-exclusive and terminable right to distribute this addon to end users.

4. You MAY use source code from this addon in your own addon or for any 
other purpose, provided that the name of this addon or its author do not 
appear in the title, source code, file names, documentation, or any other 
materials associated with your project, and that the name of this addon 
and its author are not used to promote your project.

All rights that are not explicitly addressed in this licence are reserved by
the copyright holder.

------------------------------------------------------------------------