# fixture_to_presets
Grandma3 lua plugin to store presets, based on info provided by fixture files

All object manipulations are done using commands, visible in the "Command Line History" screen.

works on **v1.8.8.2**

## Little important info:
- This plugin can fail on fixtures types having "User" defined as Source in the "fixture types" overview, when these fixtures are not created according the ma3 standards
- A scrollbar will be added later as a feature, for when their is more to show than what your screen can handle


## Donations

Just checking how motivated you can make us, to post more of our plugins !

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=DYYUK9H8NLV28)

## Example

https://user-images.githubusercontent.com/95590073/199271857-11ac8645-fafa-498f-9ad6-1acc2f8ecdf5.mp4

## Installation

1. Copy the lua code from https://github.com/kevinhayen/fixture_to_presets/blob/main/fixture_to_presets.lua
2. In the plugin pool, create a new plugin
3. label this plugin as "fixture_to_presets", or another name without a space
4. Open this plugin by editing, and click "Insert new ComponentLua"
5. Click "Edit", which opens the LUA editor
6. Paste your copied LUA code in this screen, and press "Save" on the top right
7. execute "ReloadPlugins" in commandline

## How does it work?

### Navigating

When running the plugin, the first screen shows all fixture types of patched fixtures. Subfixtures are shown in red.

![image](https://user-images.githubusercontent.com/95590073/199273784-42c2c9a8-90d7-4332-9478-f53d20b1c31d.png)

When clicking one of those fixture types, a list of attributes are shown.
- The upper section of this plugin now shows 2 buttons, the left shows the clicked fixture (and mode)
- The other part of this plugin now lists all linked attributes. Each attribute button shows first the attribute name, having the featuregroup below it

![image](https://user-images.githubusercontent.com/95590073/199276903-4d0eb1be-67bb-4074-b890-384964fba042.png)

---------

When clicking an attribute, the right button in the upper section shows the clicked attribute, while the lower part of this plugin now shows possible values to be stored as a preset.

![image](https://user-images.githubusercontent.com/95590073/199278078-c7d06bde-3377-4a9b-9341-906d91fb2ec6.png)

---

next to "Store Preset by clicking", we have ways to indicate in which preset the value will be stored

![image](https://user-images.githubusercontent.com/95590073/199311746-71ba0f02-e071-4fb2-a040-af279d8ff4a1.png)

The 3 buttons are used to navigate over empty presets. 

By pressing the middle button, you can enter a number manually. The first empty found preset number, started from the manually entered number, will be selected.

The **Merge** checkbox will show an inputbox to manually enter a preset number, this overrules the buttons on the left of it

---

### Cross navigating

The plugin is built in a way that makes navigating between fixtures and attributes very dynamic.

For example, when you selected "Zoom" in one fixture type
![image](https://user-images.githubusercontent.com/95590073/199284906-25bf4961-46d9-4fd0-8069-1ee371a91f84.png)

and you want to store "Zoom" values from another fixture type, then simply press the left upper button, indicating "(Click to change Fixture)", which brings you to the overview of the fixture types
![image](https://user-images.githubusercontent.com/95590073/199285196-37669a04-4b9a-40e3-a54b-673163fedb74.png)

Here you select the next fixture you want to store the "Zoom" values from, which brings you to the "Zoom" values of that selected fixture
![image](https://user-images.githubusercontent.com/95590073/199285538-733fcab9-8589-4d58-8863-81dfc2bea0d1.png)

to catch strange changes, for example, when beein in the "Pan" attribute of a movinghead, and changing to a ledpar fixture, which in most cases is not possible, then this messages will show up:
![image](https://user-images.githubusercontent.com/95590073/199286615-2f122e21-2f75-4dd0-a865-84a0e43a38e0.png)

### Storing a preset

All actions of storing a preset are visible in the commandline history. The goal of this plugin is not to inject any grandma3 objects using LUA, but to execute commands, so you can clearly see all executed commands.

In this example, we have 4 fixtures patched from the same fixture group, having fixtureID 1, 2, 3 and 4.
When pressing a value, the plugin will:
1. verify and select all fixtures linked to this fixturegroup
2. set the attribute value
3. store to the defined preset number
4. label the preset, as how that value is described in the fixture file

![image](https://user-images.githubusercontent.com/95590073/199282427-de652418-cef3-4435-a12c-5a6c138c470d.png)

### Colors

Fixtures having at least CMY or RGB values, will not have all combinations of colors stored in their fixture file.
In this case, most people create their macro's to create their color presets using the 3 parameters (C, M, Y) or (R, G, B).
Well, this is now built into this plugin as well.

In the official MA3 attributes list, there is no "Color" attribute, so this name is used in this plugin when CMY or RGB channels are found in the selected fixture group.. which is shown in this example as the middle attribute button:

![image](https://user-images.githubusercontent.com/95590073/199290248-614fa4dc-7825-4ce2-80d5-bf57f7cee493.png)

When clicking "Color", you get an overview of colors:
You can create each color preset seperatly by clicking the color name, or you can create all colors at once by clicking "Create All Colors".

![image](https://user-images.githubusercontent.com/95590073/199290491-5bc91606-deb0-44f9-8e3e-566e59dd3d21.png)

These values can be found in the LUA plugin file on top, so you can edit your own colors:

![image](https://user-images.githubusercontent.com/95590073/199290814-c22a91d5-14d2-46c0-bc0f-bbd5578cf6f4.png)

---

Next to CMY or RGB, GrandMA3 has other color attributes, defined for specific colors, starting in this overview from line 114 until line 123:

![image](https://user-images.githubusercontent.com/95590073/199293185-7d03859b-3200-4eec-9677-c36c1da40d2a.png)

When deep diving the LUA code, you can find overrules for colors "Amber", "Lime", "Purple", "Pink", "Open", "Warm White", "Cold White" and "UV". Some fixtures have one or more of these colors as a seperate channel. When these channels are found in the selected fixture type, the RGB or CMY values will be set to zero for that color, while for that seperate color channel, the value will be set to full.

example:

https://user-images.githubusercontent.com/95590073/199295136-1848cdb5-6f92-4eb6-8ba8-d032f151a8a6.mov

