--      ████████╗██╗████████╗██╗     ███████╗██████╗  █████╗ ██████╗ 
--      ╚══██╔══╝██║╚══██╔══╝██║     ██╔════╝██╔══██╗██╔══██╗██╔══██╗
--         ██║   ██║   ██║   ██║     █████╗  ██████╔╝███████║██████╔╝
--         ██║   ██║   ██║   ██║     ██╔══╝  ██╔══██╗██╔══██║██╔══██╗
--         ██║   ██║   ██║   ███████╗███████╗██████╔╝██║  ██║██║  ██║
--         ╚═╝   ╚═╝   ╚═╝   ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝

-- ===================================================================
-- Imports
-- ===================================================================


local awful = require("awful")
local gears = require("gears")
local wibox = require('wibox')
local beautiful = require("beautiful")
local dpi = require('beautiful').xresources.apply_dpi


-- ===================================================================
-- Add titlebars and rounded corners to clients
-- ===================================================================


-- define shape of non rounded corner windows
rectangle_shape = function(cr, w, h)
  gears.shape.rectangle(cr, w, h)
end

-- define shape of rounded corner windows
rounded_corner_shape = function(cr, width, height)
  gears.shape.rounded_rect(cr, width, height, beautiful.corner_radius)
end

-- Connect signal when client layout is changed
screen.connect_signal("arrange", function(s)
  for _, c in pairs(s.clients) do
    -- if client is maximized or fullscreen hide titlebar, no round corners
    if c.fullscreen or c.maximized or c.first_tag.layout.name == 'max' then
      awful.titlebar.hide(c)
      c.shape = rectangle_shape

    -- otherwise add round corners
    else
      awful.titlebar.show(c)
      c.shape = rounded_corner_shape
    end
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules (rules.lua)
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({ }, 1, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
      c:emit_signal("request::activate", "titlebar", {raise = true})
      awful.mouse.client.resize(c)
    end)
  )

  -- titlebar setup
  awful.titlebar(c) : setup {
    { -- Left
      buttons = buttons,
      layout  = wibox.layout.fixed.horizontal
    },
    { -- Middle
      { -- Title
        align  = "center",
        widget = awful.titlebar.widget.titlewidget(c)
      },
      buttons = buttons,
      layout  = wibox.layout.flex.horizontal
    },
    { -- Right
      awful.titlebar.widget.floatingbutton (c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton   (c),
      awful.titlebar.widget.ontopbutton    (c),
      awful.titlebar.widget.closebutton    (c),
      layout = wibox.layout.fixed.horizontal()
    },
    layout = wibox.layout.align.horizontal
  }
end)