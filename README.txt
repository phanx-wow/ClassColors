Class Colors
===============

Lets you to change class colors without breaking the Blizzard UI.

It is supported by many pouplar addons, and also applies your custom
colors to parts of the default UI that are normally class-colored.

To change colors or other options, type "/classcolors" or open the
Class Colors panel in the Interface Options window.


Download
-----------

* [WoWInterface](http://www.wowinterface.com/downloads/info12513-ClassColors.html)
* [Curse](http://wow.curseforge.com/addons/classcolors/)


Localization
---------------

Compatible with English, Deutsch, Español, Français, Italiano, 
Português, Русский, 한국어, 简体中文 and 繁體中文 clients.

Class Colors is translated into English, Deutsch, Español and Português.

If you can provide new or updated translations for any language, please
contact me (see below).


Information for addon authors
--------------------------------

Supporting the CUSTOM_CLASS_COLORS standard is simple. All you need to
do is check for the existence of a global CUSTOM_CLASS_COLORS table, and
read from it instead of RAID_CLASS_COLORS if it exists.

If your addon uses a local upvalue (variable) for RAID_CLASS_COLORS or
keeps a local cache of class colors, you should either delay creating
the upvalue or cache until the PLAYER_LOGIN event fires, or update it
when PLAYER_LOGIN fires. You should also register for a callback to be
notified when class colors are changed so you can update your cache or
apply the new colors immediately.

Finally, please do not check for the !ClassColors addon by name as a
means of determining whether the user has custom class colors. Not only
is it not guaranteed that !ClassColors will be loaded before your addon
-- unless you clutter up your TOC file by listing it as an optional
dependency -- but the CUSTOM_CLASS_COLORS format is meant to be a
community standard and can be implemented by any addon, including an
unpublished one the user has written for personal use!

Get more details, including the callback API documentation, here:  
<http://wow.curseforge.com/addons/classcolors/pages/api-documentation/>


Feedback
-----------

Post a ticket on either download site, or a comment on WoWInterface.

If you are reporting a bug, please include directions I can follow to
reproduce the bug, whether it still happens when all other addons are
disabled, and the exact text of the related error message (if any) from 
[BugSack](http://www.wowinterface.com/downloads/info5995-BugSack.html).

If you need to contact me privately, you can send me a private message
on either download site, or email me at <addons@phanx.net>.


License
----------

Copyright (c) 2009-2014 Phanx <addons@phanx.net>. All rights reserved.
See the accompanying LICENSE file for additional information.
