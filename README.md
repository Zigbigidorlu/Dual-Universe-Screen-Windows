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

## Creating a new window:
```lua
WinLib:new(html,options,buttons)
```
### Parameters:
```lua
local myWindow = WinLib:new("Hello, world!",{class = "ThisIsMyWindow", title = "Look at this window!", draggble = true},{button1, button2})
```
Parameter | Type | Description
-|-|-
**HTML** (required) | HTML | The content of the window.
**Options** | Object | The options for the window; may be `nil`.
**Buttons** | Object | Any buttons you want to include in the window; may be `nil`.

### Window options:
```lua
{class = "ThisIsMyWindow", title = "Look at this window!", draggble = true}
```
Option | Type | Description 
-|-|-
**title** | string | Title of the window. Will produce a title bar, which is used to drag the window. If excluded, and the window is flagged to be draggable, the window can be dragged from anywhere within it's bounds.
**class** | string | The name of a custom CSS class you would like to style the window with. Please see "styling windows" below.
**posX** | int | The X position, in pixels, you would like the window to open at.
**posY** | int | The Y position, in pixels, you would like the window to open at.
**width** | int | The width, in pixels, the window will be.
**height** | int | The height, in pixels, the window will be.
**titleHeight** | int | The height, in pixels, the title bar will be (if title is provided). Width will always be 100% of the parent.
**draggable** | boolean | TRUE if the window will be draggable.
**alwaysOnTop** | boolean | TRUE if the window will always be on top of other windows.

### Methods
```lua
myWindow.setHTML("Goodbye, world!")
myWindow.delete()
```
Method | Description
-|-
**setHTML** | Updates the content of the window.
**setTitle** | Updates the title of the window. If set to `nil`, title bar will disappear.
**delete** | Removes the window from the screen.
