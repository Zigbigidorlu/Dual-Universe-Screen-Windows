-- Please note, you need the system update script as well to make this work from raw.

-- Window Library
WindowLib = {["index"] = 0}

local refresh_rate = 60 --export: Rate in which the screen refreshes (fps)

-- Defaults
local Default_Window_Position_X = 0 --export: Default window horizontal position on screen
local Default_Window_Position_Y = 0 --export: Default window vertical position on screen
local Default_Window_Width = 300 --export: Default window width
local Default_Window_Height = 150 --export: Default window height
local Default_Window_TitleBar_Height = 20 --export: Default window title bar height
local Default_Button_Position_X = 0
local Default_Button_Position_Y = 0
local Default_Button_Width = 96
local Default_Button_Height = 24

-- WindowLib CSS
WindowLib.css = {}
WindowLib.css.custom = nil
WindowLib.css.base = [[
    BODY {
        background:#808080;
        color:#000000;
        width:100%%;
        height:100%%;
    }
    DIV.WinLib_window {
        position:absolute;
        background:#FFFFFF;
        font-family:"Segoe UI", Sans-Serif;
        border:3px solid #D8D8D8;
        box-shadow:10px 10px #333333;
        font-size:20px;
    }
    DIV.WinLib_window_title {
        height:20px;
        background-color: #2a2a72;
        background-image: linear-gradient(315deg, #2a2a72 0%%, #009ffd 74%%);
        color:#FFFFFF;
        font-size:12px;
        font-weight:bold;
        padding-left:4px;
    }
    DIV.WinLib_window>.WinLib_content {
        padding:4px;
    }
    DIV.WinLib_button {
        position:absolute;
        background:#0078D4;
        color:#FFFFFF;
        font-size:16px;
        text-align:center;
        overflow:hidden;
    }
    .fixed {
        z-index:1 !important;
    }
    .demo {
	   text-align:center;
    }
    #blink {
        background: linear-gradient(to right, red, orange, yellow, green, blue, indigo, violet);
        -webkit-background-clip: text;
        background-clip: text;
        color:transparent;
        background-size: 400%% 100%%;
        animation: rainbow 10s ease-in-out infinite;
        text-align:center;
	   font-family:"Century Gothic" !important;
	   font-weight:bold;
    }
    @keyframes rainbow {
        0%%,100%% {
            background-position: 0 0;
        }

        50%% {
            background-position: 100%% 0;
        }
    }]]
WindowLib.css.window_block = [[

    #{wlib_id} {
        width:{wlib_width}px;
        height:{wlib_height}px;
        top:{wlib_posY}px;
        left:{wlib_posX}px;
        z-index:{wlib_zIndex};
    }
    #{wlib_id}>.WinLib_window_title {
        height:{wlib_title_height}px;
        line-height:{wlib_title_height}px;
    }
    {wlib_buttons_generated}]]
WindowLib.css.button_block = [[

    #{wlib_id} {
        width:{wlib_width}px;
        height:{wlib_height}px;
        top:{wlib_posY}px;
        left:{wlib_posX}px;
    }]]

-- WindowLib HTML
WindowLib.html = {}
WindowLib.html.base = [[

<style type="text/css">
{wlib_css}
{wlib_css_generated}
{wlib_css_custom}
</style>
{wlib_html_generated}
]]
WindowLib.html.window = [[
<DIV class="WinLib_window {wlib_custom_class}" id="{wlib_id}">
{wlib_title_bar}
    <DIV class="WinLib_content">
{wlib_html}
{wlib_buttons_generated}
    </DIV>
</DIV>]]
WindowLib.html.window_title = [[
    <DIV class="WinLib_window_title" id="title_bar">
        {wlib_title}
    </DIV>]]
WindowLib.html.button = [[
    <DIV class="WinLib_button{wlib_custom_class}" id="{wlib_id}">
        {wlib_html}
    </DIV>]]

-- WindowLib: Window object
function WindowLib:new(html,options,buttons)
    local window        = {} -- Window object (new)

    -- User-provided properties (via options)
    window.title        = nil -- Not provided via exported variable
    window.class        = nil -- Custom class name for styling
    window.posX         = Default_Window_Position_X -- Window position on the X axis
    window.posY         = Default_Window_Position_Y -- Window position on the Y axis
    window.width        = Default_Window_Width -- Window width
    window.height       = Default_Window_Height -- Window Height
    window.titleHeight  = Default_Window_TitleBar_Height -- Window Title bar height
    window.draggable    = false -- Window allowed to be dragged
    window.alwaysOnTop  = false -- Window always on top
    window.fixed  	   = false -- Prevents the window from going over others

    -- Assign user-provided properties
    if(options ~= nil) then
        window.title    = (options.title ~= nil) and options.title or window.title
        window.class    = (options.class ~= nil) and options.class or window.class
        window.posX     = (options.posX ~= nil) and options.posX or window.posX
        window.posY     = (options.posY ~= nil) and options.posY or window.posY
        window.width    = (options.width ~= nil) and options.width or window.width
        window.height   = (options.height ~= nil) and options.height or window.height
        window.titleHeight = (options.titleHeight ~= nil) and options.titleHeight or window.titleHeight
        window.draggable= (options.draggable ~= nil) and true or false
        window.alwaysOnTop = (options.alwaysOnTop ~= nil) and true or false
        window.fixed    = (options.fixed ~= nil) and true or false
    end

    -- Assign buttons if provided
    window.buttons      = (buttons == nil) and {} or buttons

    -- Generated properties
    self.index          = self.index + 1 -- Global index increment
    window.id           = "wlib_window_" .. self.index -- Unique ID
    window.html         = (html == nil) and "" or html -- Content provided by the user

    -- Z-index increment
    if(window.fixed == true) then
        window.zIndex   = 1
    else
        window.zIndex   = (window.alwaysOnTop == true) and 999999 + self.index or self.index -- Z position (determines if it's in front of the others)
    end

    -- Empty output properties
    window.css          = ""
    window.content      = ""

    -- Update the window object and it's content
    window.refresh      = function()
        -- Generate our buttons blocks
        local button_html  = ""
        local button_css   = ""

        for _, button in pairs(window.buttons) do
            button:refresh()
            button_html = button_html .. button.content
            button_css  = button_css .. button.css
        end

        window.css      = self.css.window_block
                              :gsub("{wlib_id}",window.id)
                              :gsub("{wlib_width}",window.width)
                              :gsub("{wlib_height}",window.height)
                              :gsub("{wlib_posX}",window.posX)
                              :gsub("{wlib_posY}",window.posY)
                              :gsub("{wlib_zIndex}",window.zIndex)
                              :gsub("{wlib_title_height}",window.titleHeight)
                              :gsub("{wlib_buttons_generated}",button_css)

        local title_bar = (window.title == nil) and "" or self.html.window_title
                                                              :gsub("{wlib_title}",window.title)
        local custom_class = (window.class == nil) and "" or window.class
        window.content = self.html.window
                             :gsub("{wlib_id}",window.id)
                             :gsub("{wlib_custom_class}",custom_class)
                             :gsub("{wlib_title_bar}",title_bar)
                             :gsub("{wlib_html}",window.html)
                             :gsub("{wlib_buttons_generated}",button_html)
    end

    -- Updates the HTML within the window
    window.setHTML      = function(content)
        window.html     = content
    end

    -- Updates the window's title
    window.setTitle     = function(content)
        window.title    = content
    end

    -- Removes the window
    window.delete       = function()
        self.windows[window.id] = nil
    end

    self.windows[window.id] = window -- Add the new window to the generated stack
    return window -- Returns the window to the user
end

-- WindowLib update: Compiles our content into strings and updates the screen with it
function WindowLib:update()
    -- Empty output properties
    local gen_css       = ""
    local windows       = ""

    -- Loop through our window objects
    for _, window in pairs(self.windows) do
        window:refresh() -- Updates our window content; Done in separate space for convenience
        gen_css         = gen_css .. window.css -- Appends to the generated CSS property
        windows         = windows .. window.content -- Appends to the windows property
    end
    
    local custom_css = self.css.custom == nil and "" or self.css.custom
    local generated     = self.html.base
                              :gsub("{wlib_css}",self.css.base) -- Add base CSS
                              :gsub("{wlib_css_generated}",gen_css) -- Add base CSS
                              :gsub("{wlib_html_generated}",windows) -- Add generated content
    					 :gsub("{wlib_css_custom}",custom_css) -- Add custom CSS
    Screen.resetContent(self.screen, generated) -- Add the content to our screen
    self:mouseListener() -- Perform mouse listening each frame
end

-- Listens for window grab events
function WindowLib:mouseListener()
    if(Screen.getMouseState() == 1 and self.grabbed == nil) then -- Only works if nothing else is grabbed
        local mouse     = self:getMousePos() -- Gets our mouse position

        -- Cycle through windows to check if clicked
        for _, window in pairs(self.windows) do
            local bound = { x1 = window.posX, y1 = window.posY,
                            x2 = window.posX + window.width, y2 = window.posY + window.height } -- Our window's bounds
            if(mouse.x >= bound.x1 and mouse.y >= bound.y1
                    and mouse.x <= bound.x2 and mouse.y <= bound.y2) then -- Check if clicked within bounds
                if(self.grabbed == nil) then -- If there's nothing assigned yet
                    self.grabbed = window
                else -- Check against grabbed
                    if(window.zIndex > self.grabbed.zIndex) then -- Replace if zIndex is higher
                        self.grabbed = window -- This assures we don't grab a window behind
                    end
                end
            end
        end

        if(self.grabbed ~= nil) then -- If something was grabbed, act upon it
            if(self.grabbed.zIndex ~= self.index) then -- Only increment if not already on top
                if(self.grabbed.alwaysOnTop ~= true) then
                    self.index = self.index + 1 -- Increment our index
                    self.grabbed.zIndex = self.index -- Bring our window to the front
                end
            end

            self.buttonCheck() -- Check for a button click

            if(self.grabbed.draggable) then -- Only act if we're allowed to
                if(self.grabbed.title == nil) then -- Perform the drag from anywhere on the window
                    self:beginDrag()
                elseif(mouse.y <= self.grabbed.posY + self.grabbed.titleHeight) then -- Only from the title bar
                    self:beginDrag()
                else -- If we haven't grabbed a valid spot, release the grab
                    self.grabbed = nil
                end
            else
                self.grabbed = nil
            end
        end
    else
        self.buttonLock = nil -- Release the button lock
    end
end

-- Prepare to drag the window
function WindowLib:beginDrag()
    local mouse = self:getMousePos() -- Get the mouse position
    self.grabbed.offset = {x = mouse.x - self.grabbed.posX,
                           y = mouse.y - self.grabbed.posY} -- Get the offset of the mouse from the top left

    -- wlib_drag timer uses a tick with the content: WindowLib:performDrag()
    unit.setTimer("wlib_drag",1/refresh_rate) -- Loop the drag action
end

-- Drag the window
function WindowLib:performDrag()
    if(Screen.getMouseState() == 1 and self.grabbed ~= nil) then -- If our mouse is still down
        local mouse     = self:getMousePos() -- Get the mouse position
        local new_x     = tonumber(string.format("%.2f",mouse.x - self.grabbed.offset.x)) -- Rounded new X position
        local new_y     = tonumber(string.format("%.2f",mouse.y - self.grabbed.offset.y)) -- Rounded new Y position

        -- Move window position; Additional check prevents hold flickering
        self.grabbed.posX = (self.grabbed.posX ~= new_x) and new_x or self.grabbed.posX -- Move along the X axis
        self.grabbed.posY = (self.grabbed.posY ~= new_y) and new_y or self.grabbed.posY -- Move along the Y axis
    else -- If we've let go of the mouse
        self:releaseWindow() -- Stop dragging
    end
end

-- Stop dragging
function WindowLib:releaseWindow()
    self.grabbed = nil -- Clear the dragged property
    unit.stopTimer("wlib_drag") -- Stop the drag loop
end

-- Perform a click check (only on release to avoid a loop)
function WindowLib:buttonCheck()
    for _, button in pairs(WindowLib.grabbed.buttons) do
        local mouse     = WindowLib:getMousePos() -- Get the mouse position
        local bound = { x1 = button.posX + WindowLib.grabbed.posX,
                        y1 = button.posY + WindowLib.grabbed.posY,
                        x2 = button.posX + WindowLib.grabbed.posX + button.width,
                        y2 = button.posY + WindowLib.grabbed.posY + button.height } -- Our button's bounds
        if(mouse.x >= bound.x1 and mouse.x <= bound.x2 and
                mouse.y >= bound.y1 and mouse.y <= bound.y2 and
                WindowLib.buttonLock ~= button) then -- Check if clicked within bounds
            WindowLib.buttonLock = button
            button:__click()
        end
    end
end

-- Get our mouse position (in pixels)
function WindowLib:getMousePos()
    -- Interesting fact: Screens are 1024px x 612px
    return {
        x               = Screen.getMouseX()*1024, -- Convert percent to pixels
        y               = Screen.getMouseY()*612 -- Convert percent to pixels
    }
end

-- Set custom CSS
function WindowLib:custom_css(custom)
    self.css.custom = custom
end


-- WindowLib buttons
WindowLib.buttons       = {}

-- WindowLib: Button object
function WindowLib.buttons:new(html, onclick, options)
    local button        = {} -- Button object (new)

    -- User-provided properties (via options)
    button.class        = nil -- Custom class name for styling
    button.posX         = Default_Button_Position_X -- Button position on the X axis
    button.posY         = Default_Button_Position_Y -- Button position on the Y axis
    button.width        = Default_Button_Width -- Button width
    button.height       = Default_Button_Height -- Window Height

    -- Assign user-provided properties
    if(options ~= nil) then
        button.class    = (options.class ~= nil) and options.class or button.class
        button.posX     = (options.posX ~= nil) and options.posX or button.posX
        button.posY     = (options.posY ~= nil) and options.posY or button.posY
        button.width    = (options.width ~= nil) and options.width or button.width
        button.height   = (options.height ~= nil) and options.height or button.height
    end

    -- Generated properties
    WindowLib.index     = WindowLib.index + 1 -- Global index increment
    button.id           = "wlib_button_" .. WindowLib.index -- Unique ID
    button.html         = (html == nil) and "" or html -- Content provided by the user

    -- Empty output properties
    button.css          = ""

    -- Update the button object and it's content
    button.refresh      = function()
        button.css      = WindowLib.css.button_block
                                   :gsub("{wlib_id}",button.id)
                                   :gsub("{wlib_width}",button.width)
                                   :gsub("{wlib_height}",button.height)
                                   :gsub("{wlib_posX}",button.posX)
                                   :gsub("{wlib_posY}",button.posY)
        local custom_class = (button.class == nil) and "" or button.class
        button.content  = WindowLib.html.button
                                   :gsub("{wlib_id}",button.id)
                                   :gsub("{wlib_custom_class}",custom_class)
                                   :gsub("{wlib_html}",button.html)
    end

    button.__click = onclick -- Set click function

    -- Override click function
    button.setClick = function(clickMethod)
        button.__click = clickMethod
    end

    -- Updates the HTML within the button
    button.setHTML      = function(content)
        button.html     = content
    end

    return button
end

-- WindowLib initializer: Gets our environment ready
function WindowLib:init()
    Screen.clear()
    Screen.activate() -- Turn on the screen

    self.screen         = Screen.addContent(0,0,nil) -- Everything we write will be on this layer
    self.windows        = {} -- Table containing all our windows
    self.buttonLock     = nil -- Lets us lock a button so it doesn't loop

    -- wlib timer uses a tick with the content: WindowLib:update()
    unit.setTimer("wlib",1/refresh_rate) -- Begins our update loop to keep the screen current
end

WindowLib:init()
