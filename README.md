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

## Creating a new window
```lua
WinLib:new(html,options,buttons)
```
### Parameters
```lua
local myWindow = WinLib:new("Hello, world!", {class = "firstWindow", title = "Look at this window!", draggble = true}, {button1, button2})
```
Parameter | Type | Description
-|-|-
**HTML** (required) | HTML | The content of the window.
**Options** | Object | The options for the window; may be `nil`.
**Buttons** | Object | Any buttons you want to include in the window; may be `nil`.

### Window options
```lua
{class = "ThisIsMyWindow", title = "Look at this window!", draggble = true}
```
Option | Type | Description 
-|-|-
**title** | string | Title of the window. Will produce a title bar, which is used to drag the window. If excluded, and the window is flagged to be draggable, the window can be dragged from anywhere within it's bounds.
**class** | string | The name of a custom CSS class you would like to style the window with. Please see "Styling" below.
**posX** | int | The X position, in pixels, you would like the window to open at.
**posY** | int | The Y position, in pixels, you would like the window to open at.
**width** | int | The width, in pixels, the window will be.
**height** | int | The height, in pixels, the window will be.
**titleHeight** | int | The height, in pixels, the title bar will be (if title is provided). Width will always be 100% of the parent.
**draggable** | boolean | TRUE if the window will be draggable.
**alwaysOnTop** | boolean | TRUE if the window will always be on top of other windows.

### Buttons
```lua
{button1, button2}
```
See "Creating a new button" below.

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

## Creating a new button
```lua
WinLib.buttons:new(html,onclick,options)
```
### Parameters
```lua
local button1 = WinLib.buttons:new("Click me!", clickFunction, {posX = 150, posY = 75})
```
Parameter | Type | Description
-|-|-
**HTML** (required) | HTML | The content of the button.
**OnClick** | Function | Function activated when the user clicks the button. May be `nil` only if you plan to assign a function later.
**Options** | Object | The options for the button; may be `nil`.

### Button OnClick
```lua
clickFunction = function() { system.print("You clicked me!") }
```
OnClick is a function called when the user clicks on the button.

### Button options
```lua
{posX = 150, posY = 75}
```
Option | Type | Description 
-|-|-
**class** | string | The name of a custom CSS class you would like to style the button with. Please see "Styling" below.
**posX** | int | The X position, in pixels, you would like the button to be. Position is absolute *within the window*.
**posY** | int | The Y position, in pixels, you would like the button to be. Position is absolute *within the window*.
**width** | int | The width, in pixels, the button will be.
**height** | int | The height, in pixels, the button will be.

### Methods
```lua
local clickFunction = function() { myWindow.delete() }
button1.setHTML("Try clicking me, now!")
button1.setClick(clickFunction)
```
Method | Description
-|-
**setHTML** | Updates the content of the button.
**setClick** | Updates the click function.

## Styling
```css
.firstWindow {
  background:blue !important;
  font-size:120px !important;
 }
 ```
For both Windows and Buttons, you may pass a "class" option to specify a class name. You need simply style in CSS that class name. There are some important notes, however, that should be heeded when styling.
You should not modify the following, as they are set by the code and are used to determine where to detect clicks:
- Width
- Max-Width
- Min-Width
- Height
- Max-Height
- Min-Height
- Position
- Top
- Left
- Right
- Bottom

Additionally, the following will require the !important flag to override:
- Background
- Color
- Font-family
- Border
- Box-Shadow
- Padding
- Font-size

### Example Code
```lua
local clickFunction = function() { system.print("You clicked me!") } -- Our first click function
local button1 = WinLib.buttons:new("Click me!", clickFunction, {posX = 150, posY = 75}) -- Our first button
local button2 = WinLib.buttons:new("Close", nil, {posX = 300, posY = 150}) -- Our second button. Note the nil in function; this is overriden later.
local myWindow = WinLib:new("Hello, world!", {class = "firstWindow", title = "Look at this window!", draggble = true}, {button1, button2}) -- Here we create our window.
local clickClose = function() { myWindow.delete() } -- Created after window was assigned to a variable so we can use it's method.
button2.setClick(clickClose) -- Set the second button's click function
```
