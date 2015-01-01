### Version 6.0.3.24

* Added a workaround for some addons passing invalid GUIDs to GetColoredName

### Version 6.0.3.23

* Updated for Warlords of Draenor

### Version 5.4.8.101

* Added Russian translations from Yafis

### Version 5.4.7.94

* Updated chat player name coloring for realm name changes in WoW 5.4.7

### Version 5.4.2.90

* Added a NotifyChanges method for addons that provide their own class color options UI, but not their own CUSTOM_CLASS_COLORS implementation, and want to propigate their changes to other addons through the CUSTOM_CLASS_COLORS system.
* Added support for female-specific class names to the GetClassToken method, though I suspect nobody has ever actually used this method.

### Version 5.4.2.88

* Fixed an issue preventing player specialization names from appearing the inspect frame

### Version 5.4.1.87

* Fixed an error on the PTR caused by Blizzard fixing a typo in a function name

### Version 5.4.1.86

* Updated for WoW 5.4
* Fixed coloring in the LFG cooldown list

### Version 5.3.0.83

* Updated for WoW 5.3
* Fixed coloring in Challenge Mode best times tooltips

### Version 5.2.0.80

* Updated for WoW 5.2

### Version 5.1.0.78

* Updated for WoW 5.1

### Version 5.0.4.76

* Updated for WoW 5.0.4
* Added better compatibility with other implementations of CUSTOM_CLASS_COLORS

### Version 4.3.4.56

* Raid and party member blips on the world map will now be recolored using your custom colors.
* *Due to Blizzard restrictions, it is **not** possible to recolor blips on the minimap.*
* Added Português (ptBR) localization.

### Version 4.2.0.51

* Updated for WoW 4.2

### Version 4.1.0.49

* Updated for WoW 4.1
* Removed the IterateClasses metamethod since nobody uses it
* Changed the GetColoredName override to more closely emulate the original Blizzard function, as requested by Funkydude on WowAce

### Version 4.0.3.43

* Fixed LFR browser and who list coloring

### Version 4.0.3.40

* Fixed raid panel coloring

### Version 4.0.1.36

* Someday I will remember to turn off debugging before posting a release...

### Version 4.0.1.35

* Updated Blizzard UI coloring for WoW 4.0

### Version 4.0.1.33

* Removed a function that no longer exists in WoW 4.0
* Guild panel coloring hasn't been updated yet

### Version 3.3.3.29

* Player names in the raid panel will now always be colored correctly
* Added additional checks to prevent GetPlayerInfoByGUID usage errors

### Version 3.3.0.26

* Added coloring of class names in the channel pane of the chat config window

### Version 3.3.0.24

* Added coloring of names in the LookingForRaid interface
* Fixed drycode errors

### Version 3.3.0.22

* Updated for WoW 3.3
* Removed coloring for parts of the UI that aren't normally colored. This functionality may or may not reappear in a separate addon at a later date.
