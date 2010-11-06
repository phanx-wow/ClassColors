## !ClassColors

* by Phanx < addons@phanx.net >
* http://www.wowinterface.com/downloads/info6330-AnkhUp.html
* http://wow.curse.com/downloads/wow-addons/details/ankhup.aspx


## Description

!ClassColors allows you to change class colors without breaking parts of
the default UI.


## Usage

Type "/classcolors" for options, or navigate to them in the standard
Interface Options window.


## Localization

* Compatible with: en*, deDE, esES, esMX, frFR, koKR, ruRU, zhCN, zhTW
* Translated into: en*

If you can provide translations for any locale, please contact me.


## Feedback

Please use the ticket system on either download site report bugs or
request features. Use the comment system only for general questions
or comments.

If you need to contact me privately, you may do by private message
on either download site, or by email at addons@phanx.net.

Note that email and private messaging are not appropriate ways to
report bugs, request features, or ask for help with using an addon,
and that such messages will be ignored.


## Information for Addon Authors

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
dependency of any kind for your addon.

Detailed API documentation can be found here:
http://www.wowinterface.com/portal.php?&id=224&pageid=198


## License

CancelMyBuffs is free as in "free beer", not free as in "free software",
and you may not include it in your compilation or redistribute it in any
other way without first getting permission. The full license text under
which CancelMyBuffs is released can be found in the LICENSE text file
inside the addon's folder. Show your appreciation for the time and 
effort addon authors put into writing, updating, and supporting addons
by respecting our legal rights. Thanks!