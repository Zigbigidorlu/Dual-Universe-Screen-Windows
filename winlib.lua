{"slots":{"0":{"name":"Screen","type":{"events":[],"methods":[]}},"1":{"name":"slot2","type":{"events":[],"methods":[]}},"2":{"name":"slot3","type":{"events":[],"methods":[]}},"3":{"name":"slot4","type":{"events":[],"methods":[]}},"4":{"name":"slot5","type":{"events":[],"methods":[]}},"5":{"name":"slot6","type":{"events":[],"methods":[]}},"6":{"name":"slot7","type":{"events":[],"methods":[]}},"7":{"name":"slot8","type":{"events":[],"methods":[]}},"8":{"name":"slot9","type":{"events":[],"methods":[]}},"9":{"name":"slot10","type":{"events":[],"methods":[]}},"-1":{"name":"unit","type":{"events":[],"methods":[]}},"-2":{"name":"system","type":{"events":[],"methods":[]}},"-3":{"name":"library","type":{"events":[],"methods":[]}}},"handlers":[{"code":"-- Window Library\nWindowLib = {[\"index\"] = 0}\n\nlocal refresh_rate = 60\n\n-- Defaults\nlocal Default_Window_Position_X = 0\nlocal Default_Window_Position_Y = 0\nlocal Default_Window_Width = 300\nlocal Default_Window_Height = 150\nlocal Default_Window_TitleBar_Height = 20\nlocal Default_Button_Position_X = 0\nlocal Default_Button_Position_Y = 0\nlocal Default_Button_Width = 96\nlocal Default_Button_Height = 24\n\n-- WindowLib CSS\nWindowLib.css = {}\nWindowLib.css.base = [[\n    HTML {\n        background:#808080;\n    }\n    DIV.WinLib_window {\n        position:absolute;\n        background:#FFFFFF;\n        font-family:\"Segoe UI\", Sans-Serif;\n        border:3px solid #D8D8D8;\n        box-shadow:10px 10px #333333;\n        font-size:20px;\n    }\n    DIV.WinLib_window_title {\n        height:20px;\n        background-color: #2a2a72;\n        background-image: linear-gradient(315deg, #2a2a72 0%%, #009ffd 74%%);\n        color:#FFFFFF;\n        font-size:12px;\n        font-weight:bold;\n        padding-left:4px;\n    }\n    DIV.WinLib_window>.WinLib_content {\n        padding:4px;\n    }\n    DIV.WinLib_button {\n        position:absolute;\n        background:#0078D4;\n        color:#FFFFFF;\n        font-size:16px;\n        text-align:center;\n        overflow:hidden;\n    }]]\nWindowLib.css.window_block = [[\n\n    #{wlib_id} {\n        width:{wlib_width}px;\n        height:{wlib_height}px;\n        top:{wlib_posY}px;\n        left:{wlib_posX}px;\n        z-index:{wlib_zIndex};\n    }\n    #{wlib_id}>.WinLib_window_title {\n        height:{wlib_title_height}px;\n        line-height:{wlib_title_height}px;\n    }\n    {wlib_buttons_generated}]]\nWindowLib.css.button_block = [[\n\n    #{wlib_id} {\n        width:{wlib_width}px;\n        height:{wlib_height}px;\n        top:{wlib_posY}px;\n        left:{wlib_posX}px;\n    }]]\n\n-- WindowLib HTML\nWindowLib.html = {}\nWindowLib.html.base = [[\n\n<style type=\"text/css\">\n{wlib_css}\n{wlib_css_generated}\n{wlib_css_custom}\n</style>\n{wlib_html_generated}\n]]\nWindowLib.html.window = [[\n<DIV class=\"WinLib_window {wlib_custom_class}\" id=\"{wlib_id}\">\n{wlib_title_bar}\n    <DIV class=\"WinLib_content\">\n{wlib_html}\n{wlib_buttons_generated}\n    </DIV>\n</DIV>]]\nWindowLib.html.window_title = [[\n    <DIV class=\"WinLib_window_title\" id=\"title_bar\">\n        {wlib_title}\n    </DIV>]]\nWindowLib.html.button = [[\n    <DIV class=\"WinLib_button{wlib_custom_class}\" id=\"{wlib_id}\">\n        {wlib_html}\n    </DIV>]]\n\n-- WindowLib: Window object\nfunction WindowLib:new(html,options,buttons)\n    local window        = {} -- Window object (new)\n\n    -- User-provided properties (via options)\n    window.title        = nil -- Not provided via exported variable\n    window.class        = nil -- Custom class name for styling\n    window.posX         = Default_Window_Position_X -- Window position on the X axis\n    window.posY         = Default_Window_Position_Y -- Window position on the Y axis\n    window.width        = Default_Window_Width -- Window width\n    window.height       = Default_Window_Height -- Window Height\n    window.titleHeight  = Default_Window_TitleBar_Height -- Window Title bar height\n    window.draggable    = false -- Window allowed to be dragged\n    window.alwaysOnTop  = false -- Window always on top\n\n    -- Assign user-provided properties\n    if(options ~= nil) then\n        window.title    = (options.title ~= nil) and options.title or window.title\n        window.class    = (options.class ~= nil) and options.class or window.class\n        window.posX     = (options.posX ~= nil) and options.posX or window.posX\n        window.posY     = (options.posY ~= nil) and options.posY or window.posY\n        window.width    = (options.width ~= nil) and options.width or window.width\n        window.height   = (options.height ~= nil) and options.height or window.height\n        window.titleHeight = (options.titleHeight ~= nil) and options.titleHeight or window.titleHeight\n        window.draggable= (options.draggable ~= nil) and true or false\n        window.alwaysOnTop = (options.alwaysOnTop ~= nil) and true or false\n    end\n\n    -- Assign buttons if provided\n    window.buttons      = (buttons == nil) and {} or buttons\n\n    -- Generated properties\n    self.index          = self.index + 1 -- Global index increment\n    window.id           = \"wlib_window_\" .. self.index -- Unique ID\n    window.zIndex       = (window.alwaysOnTop == true) and 999999 + self.index or self.index -- Z position (determines if it's in front of the others)\n    window.html         = (html == nil) and \"\" or html -- Content provided by the user\n\n    -- Empty output properties\n    window.css          = \"\"\n    window.content      = \"\"\n\n    -- Update the window object and it's content\n    window.refresh      = function()\n        -- Generate our buttons blocks\n        local button_html  = \"\"\n        local button_css   = \"\"\n\n        for _, button in pairs(window.buttons) do\n            button:refresh()\n            button_html = button_html .. button.content\n            button_css  = button_css .. button.css\n        end\n\n        window.css      = self.css.window_block\n                              :gsub(\"{wlib_id}\",window.id)\n                              :gsub(\"{wlib_width}\",window.width)\n                              :gsub(\"{wlib_height}\",window.height)\n                              :gsub(\"{wlib_posX}\",window.posX)\n                              :gsub(\"{wlib_posY}\",window.posY)\n                              :gsub(\"{wlib_zIndex}\",window.zIndex)\n                              :gsub(\"{wlib_title_height}\",window.titleHeight)\n                              :gsub(\"{wlib_buttons_generated}\",button_css)\n\n        local title_bar = (window.title == nil) and \"\" or self.html.window_title\n                                                              :gsub(\"{wlib_title}\",window.title)\n        local custom_class = (window.class == nil) and \"\" or window.class\n        window.content = self.html.window\n                             :gsub(\"{wlib_id}\",window.id)\n                             :gsub(\"{wlib_custom_class}\",custom_class)\n                             :gsub(\"{wlib_title_bar}\",title_bar)\n                             :gsub(\"{wlib_html}\",window.html)\n                             :gsub(\"{wlib_buttons_generated}\",button_html)\n    end\n\n    -- Updates the HTML within the window\n    window.setHTML      = function(content)\n        window.html     = content\n    end\n\n    -- Updates the window's title\n    window.setTitle     = function(content)\n        window.title    = content\n    end\n\n    -- Removes the window\n    window.delete       = function()\n        self.windows[window.id] = nil\n    end\n\n    self.windows[window.id] = window -- Add the new window to the generated stack\n    return window -- Returns the window to the user\nend\n\nfunction WindowLib:custom_css(css)\n    self.css_custom = css\nend\n\n-- WindowLib update: Compiles our content into strings and updates the screen with it\nfunction WindowLib:update()\n    -- Empty output properties\n    local gen_css       = \"\"\n    local windows       = \"\"\n\n    -- Loop through our window objects\n    for _, window in pairs(self.windows) do\n        window:refresh() -- Updates our window content; Done in separate space for convenience\n        gen_css         = gen_css .. window.css -- Appends to the generated CSS property\n        windows         = windows .. window.content -- Appends to the windows property\n    end\n    \n    -- Custom CSS block\n    local custom_css = (self.css_custom ~= nil) and self.css_custom or \"\" \n\n    local generated     = self.html.base\n                              :gsub(\"{wlib_css}\",self.css.base) -- Add base CSS\n                              :gsub(\"{wlib_css_generated}\",gen_css) -- Add generated CSS\n                              :gsub(\"{wlib_css_custom}\",custom_css) -- Add custom CSS\n                              :gsub(\"{wlib_html_generated}\",windows) -- Add generated content\n    Screen.resetContent(self.screen, generated) -- Add the content to our screen\n    self:mouseListener() -- Perform mouse listening each frame\nend\n\n-- Listens for window grab events\nfunction WindowLib:mouseListener()\n    if(Screen.getMouseState() == 1 and self.grabbed == nil) then -- Only works if nothing else is grabbed\n        local mouse     = self:getMousePos() -- Gets our mouse position\n\n        -- Cycle through windows to check if clicked\n        for _, window in pairs(self.windows) do\n            local bound = { x1 = window.posX, y1 = window.posY,\n                            x2 = window.posX + window.width, y2 = window.posY + window.height } -- Our window's bounds\n            if(mouse.x >= bound.x1 and mouse.y >= bound.y1\n                    and mouse.x <= bound.x2 and mouse.y <= bound.y2) then -- Check if clicked within bounds\n                if(self.grabbed == nil) then -- If there's nothing assigned yet\n                    self.grabbed = window\n                else -- Check against grabbed\n                    if(window.zIndex > self.grabbed.zIndex) then -- Replace if zIndex is higher\n                        self.grabbed = window -- This assures we don't grab a window behind\n                    end\n                end\n            end\n        end\n\n        if(self.grabbed ~= nil) then -- If something was grabbed, act upon it\n            if(self.grabbed.zIndex ~= self.index) then -- Only increment if not already on top\n                if(self.grabbed.alwaysOnTop ~= true) then\n                    self.index = self.index + 1 -- Increment our index\n                    self.grabbed.zIndex = self.index -- Bring our window to the front\n                end\n            end\n\n            self.buttonCheck() -- Check for a button click\n\n            if(self.grabbed.draggable) then -- Only act if we're allowed to\n                if(self.grabbed.title == nil) then -- Perform the drag from anywhere on the window\n                    self:beginDrag()\n                elseif(mouse.y <= self.grabbed.posY + self.grabbed.titleHeight) then -- Only from the title bar\n                    self:beginDrag()\n                else -- If we haven't grabbed a valid spot, release the grab\n                    self.grabbed = nil\n                end\n            else\n                self.grabbed = nil\n            end\n        end\n    else\n        self.buttonLock = nil -- Release the button lock\n    end\nend\n\n-- Prepare to drag the window\nfunction WindowLib:beginDrag()\n    local mouse = self:getMousePos() -- Get the mouse position\n    self.grabbed.offset = {x = mouse.x - self.grabbed.posX,\n                           y = mouse.y - self.grabbed.posY} -- Get the offset of the mouse from the top left\n\n    -- wlib_drag timer uses a tick with the content: WindowLib:performDrag()\n    unit.setTimer(\"wlib_drag\",1/refresh_rate) -- Loop the drag action\nend\n\n-- Drag the window\nfunction WindowLib:performDrag()\n    if(Screen.getMouseState() == 1) then -- If our mouse is still down\n        local mouse     = self:getMousePos() -- Get the mouse position\n        local new_x     = tonumber(string.format(\"%.2f\",mouse.x - self.grabbed.offset.x)) -- Rounded new X position\n        local new_y     = tonumber(string.format(\"%.2f\",mouse.y - self.grabbed.offset.y)) -- Rounded new Y position\n\n        -- Move window position; Additional check prevents hold flickering\n        self.grabbed.posX = (self.grabbed.posX ~= new_x) and new_x or self.grabbed.posX -- Move along the X axis\n        self.grabbed.posY = (self.grabbed.posY ~= new_y) and new_y or self.grabbed.posY -- Move along the Y axis\n    else -- If we've let go of the mouse\n        self:releaseWindow() -- Stop dragging\n    end\nend\n\n-- Stop dragging\nfunction WindowLib:releaseWindow()\n    self.grabbed = nil -- Clear the dragged property\n    unit.stopTimer(\"wlib_drag\") -- Stop the drag loop\nend\n\n-- Perform a click check (only on release to avoid a loop)\nfunction WindowLib:buttonCheck()\n    for _, button in pairs(WindowLib.grabbed.buttons) do\n        local mouse     = WindowLib:getMousePos() -- Get the mouse position\n        local bound = { x1 = button.posX + WindowLib.grabbed.posX,\n                        y1 = button.posY + WindowLib.grabbed.posY,\n                        x2 = button.posX + WindowLib.grabbed.posX + button.width,\n                        y2 = button.posY + WindowLib.grabbed.posY + button.height } -- Our button's bounds\n        if(mouse.x >= bound.x1 and mouse.x <= bound.x2 and\n                mouse.y >= bound.y1 and mouse.y <= bound.y2 and\n                WindowLib.buttonLock ~= button) then -- Check if clicked within bounds\n            WindowLib.buttonLock = button\n            button:__click()\n        end\n    end\nend\n\n-- Get our mouse position (in pixels)\nfunction WindowLib:getMousePos()\n    -- Interesting fact: Screens are 1024px x 612px\n    return {\n        x               = Screen.getMouseX()*1024, -- Convert percent to pixels\n        y               = Screen.getMouseY()*612 -- Convert percent to pixels\n    }\nend\n\n\n-- WindowLib buttons\nWindowLib.buttons       = {}\n\n-- WindowLib: Button object\nfunction WindowLib.buttons:new(html, onclick, options)\n    local button        = {} -- Button object (new)\n\n    -- User-provided properties (via options)\n    button.class        = nil -- Custom class name for styling\n    button.posX         = Default_Button_Position_X -- Button position on the X axis\n    button.posY         = Default_Button_Position_Y -- Button position on the Y axis\n    button.width        = Default_Button_Width -- Button width\n    button.height       = Default_Button_Height -- Window Height\n\n    -- Assign user-provided properties\n    if(options ~= nil) then\n        button.class    = (options.class ~= nil) and options.class or button.class\n        button.posX     = (options.posX ~= nil) and options.posX or button.posX\n        button.posY     = (options.posY ~= nil) and options.posY or button.posY\n        button.width    = (options.width ~= nil) and options.width or button.width\n        button.height   = (options.height ~= nil) and options.height or button.height\n    end\n\n    -- Generated properties\n    WindowLib.index     = WindowLib.index + 1 -- Global index increment\n    button.id           = \"wlib_button_\" .. WindowLib.index -- Unique ID\n    button.html         = (html == nil) and \"\" or html -- Content provided by the user\n\n    -- Empty output properties\n    button.css          = \"\"\n\n    -- Update the button object and it's content\n    button.refresh      = function()\n        button.css      = WindowLib.css.button_block\n                                   :gsub(\"{wlib_id}\",button.id)\n                                   :gsub(\"{wlib_width}\",button.width)\n                                   :gsub(\"{wlib_height}\",button.height)\n                                   :gsub(\"{wlib_posX}\",button.posX)\n                                   :gsub(\"{wlib_posY}\",button.posY)\n        local custom_class = (button.class == nil) and \"\" or button.class\n        button.content  = WindowLib.html.button\n                                   :gsub(\"{wlib_id}\",button.id)\n                                   :gsub(\"{wlib_custom_class}\",custom_class)\n                                   :gsub(\"{wlib_html}\",button.html)\n    end\n\n    button.__click = onclick -- Set click function\n\n    -- Override click function\n    button.setClick = function(clickMethod)\n        button.__click = clickMethod\n    end\n\n    -- Updates the HTML within the button\n    button.setHTML      = function(content)\n        button.html     = content\n    end\n\n    return button\nend\n\n-- WindowLib initializer: Gets our environment ready\nfunction WindowLib:init()\n    self.screen         = Screen.addContent(0,0,nil) -- Everything we write will be on this layer\n    self.windows        = {} -- Table containing all our windows\n    self.buttonLock     = nil -- Lets us lock a button so it doesn't loop\n\n    -- wlib timer uses a tick with the content: WindowLib:update()\n    unit.setTimer(\"wlib\",1/refresh_rate) -- Begins our update loop to keep the screen current\nend\n\nWindowLib:init()","filter":{"args":[],"signature":"start()","slotKey":"-1"},"key":"0"},{"code":"WindowLib:update()","filter":{"args":[{"value":"wlib"}],"signature":"tick(timerId)","slotKey":"-1"},"key":"1"},{"code":"WindowLib:performDrag()","filter":{"args":[{"value":"wlib_drag"}],"signature":"tick(timerId)","slotKey":"-1"},"key":"2"},{"code":"local window = WindowLib.demo\nif(tick == nil) then\n    window.setHTML(\"This window is static -- you can't drag it!\")\n    tick = 1\nelseif(tick == 1) then\n    window.setHTML(\"You can update the content in any window on the fly!\")\n    tick = 2\nelseif(tick == 2) then\n    window.setHTML(\"And customize it's content...\")\n    tick = 3\nelse\n    window.setHTML(\"<span id='blink'>However you like!</span>\")\n    tick = nil\nend","filter":{"args":[{"value":"demo"}],"signature":"tick(timerId)","slotKey":"-1"},"key":"3"}],"methods":[],"events":[]}
