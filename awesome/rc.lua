-- ~/.config/awesome/rc.lua

-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
-- Widget library
require("vicious")

-- Load Debian menu entries
require("debian.menu")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(awful.util.getdir("config") .. "/zenburn.lua")

-- used for machine-specific options
hostname = vicious.widgets.os()[4]
net_device = "wlan0"
dmenu_font = "-*-terminus-medium-*-*-*-*-*-*-*-*-*-*-*"

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,         -- 1
    awful.layout.suit.tile,             -- 2
    awful.layout.suit.tile.left,        -- 3
    awful.layout.suit.tile.bottom,      -- 4
    awful.layout.suit.tile.top,         -- 5
    awful.layout.suit.fair,             -- 6
    awful.layout.suit.fair.horizontal,  -- 7
    awful.layout.suit.max,              -- 8
    awful.layout.suit.max.fullscreen,   -- 9
    awful.layout.suit.magnifier         -- 10
    --awful.layout.suit.spiral,           -- 11
    --awful.layout.suit.spiral.dwindle,   -- 12
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
    names  = { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" },
    layout = {
        layouts[2], layouts[2], layouts[2],
        layouts[2], layouts[2], layouts[2],
        layouts[2], layouts[2], layouts[2]
    }
}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
    { "restart", awesome.restart },
    { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
-- {{{ Widgets configuration

-- {{{ Reusable separators
spacer    = widget({ type = "textbox"  })
separator = widget({ type = "imagebox" })
spacer.text     = " "
separator.image = image(beautiful.widget_sep)
-- }}}

-- {{{ CPU usage and temperature
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)

-- Initialize widgets
cpugraph  = awful.widget.graph()
tzswidget = widget({ type = "textbox" })

-- Graph properties
cpugraph:set_width(40)
cpugraph:set_height(14)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_color(beautiful.fg_end_widget)
cpugraph:set_gradient_angle(0)
cpugraph:set_gradient_colors({ beautiful.fg_end_widget,
    beautiful.fg_center_widget, beautiful.fg_widget
})

-- Register widgets
vicious.register(cpugraph,  vicious.widgets.cpu,     "$1")
vicious.register(tzswidget, vicious.widgets.thermal, "$1C", 19, "thermal_zone0")
-- }}}

-- {{{ Battery state
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)

-- Initialize widget
batwidget = widget({ type = "textbox" })

-- Register widget
if hostname == "zappa" then
    vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT1")
elseif hostname == "euclid" then
    vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
end
-- }}}

-- {{{ Memory usage
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)

-- Initialize widget
membar = awful.widget.progressbar()

-- Progressbar properties
membar:set_width(10)
membar:set_height(12)
membar:set_vertical(true)
membar:set_background_color(beautiful.fg_off_widget)
membar:set_border_color(beautiful.border_widget)
membar:set_color(beautiful.fg_widget)
membar:set_gradient_colors({ beautiful.fg_widget,
    beautiful.fg_center_widget, beautiful.fg_end_widget
})

-- Register widget
vicious.register(membar, vicious.widgets.mem, "$1", 13)
-- }}}

-- {{{ File system usage
fsicon = widget({ type = "imagebox" })
fsicon.image = image(beautiful.widget_fs)

-- Initialize widgets
fs = {
    r = awful.widget.progressbar(),
    h = awful.widget.progressbar(),
    s = awful.widget.progressbar(),
    b = awful.widget.progressbar()
}

-- Progressbar properties
for _, w in pairs(fs) do
    w:set_width(5)
    w:set_height(12)
    w:set_vertical(true)
    w:set_background_color(beautiful.fg_off_widget)
    w:set_border_color(beautiful.border_widget)
    w:set_color(beautiful.fg_widget)
    w:set_gradient_colors({ beautiful.fg_widget,
        beautiful.fg_center_widget, beautiful.fg_end_widget
    })
end

-- Enable caching
vicious.cache(vicious.widgets.fs)

-- Register widgets
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",              599)
vicious.register(fs.h, vicious.widgets.fs, "${/media/data used_p}",    599)
vicious.register(fs.s, vicious.widgets.fs, "${/media/win-hd used_p}",  599)
vicious.register(fs.b, vicious.widgets.fs, "${/media/sdb1 used_p}",    113)
-- }}}

-- {{{ Network usage
dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })
dnicon.image = image(beautiful.widget_net)
upicon.image = image(beautiful.widget_netup)

-- Initialize widget
netwidget = widget({ type = "textbox" })

-- Register widget
vicious.register(netwidget, vicious.widgets.net, '<span color="'
    .. beautiful.fg_netdn_widget ..'">${' .. net_device .. ' down_kb}</span> <span color="'
    .. beautiful.fg_netup_widget ..'">${' .. net_device .. ' up_kb}</span>', 3)
-- }}}

-- {{{ Volume level
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)

-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = widget({ type = "textbox" })

-- Progressbar properties
volbar:set_width(10)
volbar:set_height(12)
volbar:set_vertical(true)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_border_color(beautiful.border_widget)
volbar:set_color(beautiful.fg_widget)
volbar:set_gradient_colors({ beautiful.fg_widget,
    beautiful.fg_center_widget, beautiful.fg_end_widget
})

-- Enable caching
vicious.cache(vicious.widgets.volume)

-- Register widgets
vicious.register(volbar,    vicious.widgets.volume, "$1",  2, "Master")
vicious.register(volwidget, vicious.widgets.volume, "$1%", 2, "Master")
-- }}}

-- {{{ Date and time
dateicon = widget({ type = "imagebox" })
dateicon.image = image(beautiful.widget_date)

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, " %a %b %d, %H:%M ", 10)
-- }}}

-- {{{ System tray
-- Create a systray
mysystray = widget({ type = "systray" })
-- }}}
-- }}}

-- {{{ Wibox initialisation
-- Create a wibox for each screen and add it
mywibox = {}
mywiboxbottom = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 12 })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            --mylauncher,
            mytaglist[s],
            mylayoutbox[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        s == 1 and mysystray or nil,
        separator, mytextclock, dateicon,
        separator, volwidget, spacer, volbar.widget, volicon,
        separator, upicon, netwidget, dnicon,
        separator, fs.b.widget, fs.s.widget, fs.h.widget, fs.r.widget, fsicon,
        separator, membar.widget, memicon,
        separator, batwidget, baticon,
        separator, tzswidget, spacer, cpugraph.widget, cpuicon,
        layout = awful.widget.layout.horizontal.rightleft
    }

    -- Create bottom wibox
    mywiboxbottom[s] = awful.wibox({ position = "bottom", screen = s, height = 12 })
    mywiboxbottom[s].widgets = {
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    --awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ), -- default
    --awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ), -- default
    awful.key({ modkey,           }, "h",      awful.tag.viewprev       ),
    awful.key({ modkey,           }, "l",      awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    --awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end), -- default
    --awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end), -- default
    awful.key({ modkey,           }, "Right", function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "Left",  function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    --awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    -- use dmenu to run programs
    awful.key({ modkey },            "r",
              function ()
                  awful.util.spawn("dmenu_run -i -fn '" .. dmenu_font .. "' -nb '" ..
                      beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal ..
                      "' -sb '" .. beautiful.bg_focus ..
                      "' -sf '" .. beautiful.fg_focus .. "'", false)
              end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    -- Custom
    -- Print sreen
    awful.key({                   }, "Print",  function () awful.util.spawn("scrot -e 'mv $f ~/Pictures/ 2> /dev/null'", false) end),

    -- Volume
    awful.key({ modkey, "Shift"   }, "Up",     function () awful.util.spawn("amixer -q sset Master 2dB+", false) end),
    awful.key({ modkey, "Shift"   }, "Down",   function () awful.util.spawn("amixer -q sset Master 2dB-", false) end),
    awful.key({ modkey, "Shift"   }, "Left",   function () awful.util.spawn("amixer -q sset Master toggle", false) end),
    -- set Capture to max (default 35) for Digital=42% to work
    awful.key({ modkey, "Shift"   }, "Right",  function () awful.util.spawn("amixer -q sset Digital 0%", false) end),
    awful.key({ modkey, "Control", "Shift" }, "Right", function () awful.util.spawn("amixer -q sset Digital 42%", false) end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     size_hints_honor = false,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },

    -- Fix programs to certain tags
    --{ rule = { class = "Firefox" },
    { rule = { class = "Iceweasel" },
      properties = { tag = tags[1][2] } },
    { rule = { class = "Emesene" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Xchat" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Skype" },
      properties = { tag = tags[1][1] } },
    { rule = { class = "Transmission" },
      properties = { tag = tags[1][9] } }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
