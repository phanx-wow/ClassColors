!ClassColors
============

* Written by Phanx <addons@phanx.net>
* http://www.wowinterface.com/downloads/info12513-ClassColors.html
* http://wow.curse.com/downloads/wow-addons/details/classcolors.aspx


Description
-----------

!ClassColors allows you to change class colors without tainting the
Blizzard UI.

It is supported by many pouplar addons, and also applies your custom
colors to parts of the default UI that are normally class-colored.

Options are available in the Interface Options window. You can type
“/classcolors” to open the window directly to the Class Colors panel.


Localization
------------

Compatible with English, Deutsch, Español, Français, Português, Русский,
한국어, 简体中文, and 正體中文 clients.

Translated into English, Español, and Português. If you can provide
translations for any locale, send me a PM on either download site.


Feedback
--------

Please use the ticket system on either download site report bugs or
request features. Use the comment system only for general questions
or comments.

If you need to contact me privately, you may do by private message
on either download site, or by email at <akkorian@hotmail.com>.


Information for Addon Authors
-----------------------------

Supporting the CUSTOM_CLASS_COLORS standard is simple. All you need to
do is check for the existence of a global CUSTOM_CLASS_COLORS table, and
read from it instead of RAID_CLASS_COLORS if it exists.

If your addon keeps a local cache of class colors, you should also
register for a callback when class colors are changed, and update your
cache when the callback is fired.

Also, if you build your cache before the PLAYER_LOGIN event, you should
also update it during or after that event. !ClassColors stores custom
class colors in saved variables, and may not have been loaded before
your addon. Because CUSTOM_CLASS_COLORS is a standard and can be
implemented by any addon, you should avoid listing !ClassColors as a
dependency (optional or otherwise) for your addon.

Detailed API documentation can be found here:
http://wow.curseforge.com/addons/classcolors/pages/api-documentation/