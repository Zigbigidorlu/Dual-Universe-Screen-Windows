# Dual Universe Window Library (WinLib)
Easily create flexable, independently updateable, fully customizable windows and buttons for your screens in Dual Universe!
* Create independently controllable sections on your screen
* Update content on the fly
* Drag and drop, create and destroy windows
* Assign a title bar to limit draggable regions
* Assign custom classes for high customization

![winlib](https://user-images.githubusercontent.com/7476963/99282992-07236700-27fa-11eb-8b77-bc749330678b.png)

## Requirements
WinLib requires that you have a programming board and a screen (any size will do). The screen must be linked to the board and be the first linked item.

## Installing WinLib
### IMPORTANT: If you have existing LUA on your Core slot, it WILL be overwritten!
1. From the sources menu above, open "winlib.lua."
2. Click the "raw" button in the upper right above the code.
3. Copy the contents of the page (Ctrl + A, Ctrl + C).
4. In DU, right click your programming board.
5. Choose Advanced > Paste Lua configuration from clipboard.

## Usage

Creating a new window:
```lua
WinLib:new(html,options,buttons)
```
