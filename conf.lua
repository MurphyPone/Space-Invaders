function love.conf(t)
    t.identity = nil                   -- The name of the save directory (string)
    t.version = "0.10.1"                -- The LÖVE version this game was made for (string)
    t.console = true                  -- Attach a console (boolean, Windows only)

    t.window.title = "Orbital Firing"        -- The window title (string)
    t.window.width = 800             -- The window width (number)
    t.window.height = 600             -- The window height (number)
end