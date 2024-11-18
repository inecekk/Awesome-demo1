------------------------------------------------
--        	 Full Color Awesome 3.5       	  --
--               by Luca Manni                --
--     http://lucamanni88.deviantart.com/     --
--     https://github.com/lucamanni           --
------------------------------------------------

-- {{{ Required Libraries
awful           = require("awful")
awful.rules     = require("awful.rules")
awful.autofocus = require("awful.autofocus")
wibox           = require("wibox")
beautiful       = require("beautiful")
naughty         = require("naughty")
vicious         = require("vicious")
--revelation      = require("revelation")
menubar         = require("menubar")
--drop            = require("scratchdrop")
-- }}}
-- {{{ Variable Definitions
-- {{{ Keys
altkey           = "Mod1"
modkey           = "Mod4"
control          = "Control"
shift            = "Shift"
-- }}}
-- {{{ Commands
key     = awful.key
exec    = awful.util.spawn
execs   = awful.util.spawn_with_shell
font    = "Tamsyn 10"
-- }}}
-- {{{ Directories
home             = os.getenv("HOME")
confdir          = home .. "/.config/awesome"
themes           = confdir .. "/themes"
active_theme     = themes .. "/colored"
beautiful.init(active_theme .. "/theme.lua")
scripts          = " sh " .. home .. "/.scripts/"
-- }}}
-- {{{ Colors
coloff  = "</span>"
red     = "<span color='" .. beautiful.fg_red     .. "'>"
green   = "<span color='" .. beautiful.fg_green   .. "'>"
yellow  = "<span color='" .. beautiful.fg_yellow  .. "'>"
blue    = "<span color='" .. beautiful.fg_blue    .. "'>"
magenta = "<span color='" .. beautiful.fg_magenta .. "'>"
grey    = "<span color='" .. beautiful.fg_grey    .. "'>"
white   = "<span color='" .. beautiful.fg_white   .. "'>"
-- }}}
-- {{{ Apps
terminal         = " urxvt "
terminale        = terminal .. " -title Terminal "
root_terminal    = " sudo " .. terminal .. " -title 'Root Terminal' "
editor           = os.getenv("EDITOR") or "vim"
cli_editor       = terminal .. " -e " .. editor
gui_editor       = " geany "
browser2         = " firefox "
browser1         = " chromium "
player           = " mplayer "
fileman          = " thunar "
root_fileman     = " sudo " .. fileman .. "/root"
cli_fileman      = terminal .. " -title 'File Manager' -e ranger "
cli_root_fileman = terminal .. " -title 'Root File Manager' -e sudo ranger " 
music            = terminal .. " -geometry 199x57 -title Music -e ncmpcpp "
chat             = terminal .. " -title Chat -e " .. scripts .. "weechat"
torrent          = terminal .. " -title Torrent -e " .. scripts .. "torrent"
cli_browser      = terminal .. " -title Elinks -e elinks "
tasks            = terminal .. " -title Tasks -e sudo htop "
powertop         = terminal .. " -title Powertop -e sudo powertop "
update           = terminal .. " -title Updating -e yaourt -Syua --noconfirm "
mail             = terminal .. " -title Mail -e mutt " 
mail_gui         = " thunderbird "
feed             = terminal .. " -title Feed -e newsbeuter " 
mixer            = terminal .. " -title Mixer -e alsamixer " 
youtube          = terminal .. " -title Youtube -e youtube-viewer -C "
youtube2mp3      = terminal .. " -title Youtube2mp3 -e youtube2mp3 "
abook            = terminal .. " -title Abook -e abook "
saidar           = terminal .. " -geometry 80x18 -e saidar -c "
lock             = " i3lock -d -p default -i /home/luca/.antergos.png "
slimlock         = scripts .. "lock"
-- }}}
-- }}}
-- {{{ Autostart
-- os.execute("sh ~/.autostart/awesome.sh")

function run_once(cmd)
  findme = cmd
  firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("sh .autostart/awesome")
-- run_once("compton --backend glx --paint-on-overlay --vsync opengl-mswc -c -r 12 -l -15 -t -11 -G -b")
run_once("compton --backend glx --paint-on-overlay --vsync opengl-mswc -b")
run_once("udiskie -aNqs -f thunar")
run_once("pulseaudio --start")

-- }}}
-- {{{ Error Handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                        title = "Oops, an error happened!",
                        fg = beautiful.fg_yellow,
                        bg = beautiful.fg_black,
                        font = font,
                        border_width = 1,
                        border_color = beautiful.border_tooltip,
                        -- opacity = 0.94,
                        timeout = 0,
                        text = err })
        in_error = false
    end)
end
-- }}}
-- {{{ Layouts & Tags
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
}

tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ "term ", "web ", "files ", "chat ", "media ", "work ", "kodi" }, s,
  		       { layouts[4], layouts[2], layouts[4],
 			  layouts[2], layouts[4], layouts[2], layouts[2]
 		       })
    
    -- awful.tag.seticon(active_theme .. "/widgets/cyan/arch_10x10.png", tags[s][1])
    -- awful.tag.seticon(active_theme .. "/widgets/red/cat.png", tags[s][2])
    -- awful.tag.seticon(active_theme .. "/widgets/magenta/dish.png", tags[s][3])
    -- awful.tag.seticon(active_theme .. "/widgets/green/mail.png", tags[s][4])
    -- awful.tag.seticon(active_theme .. "/widgets/yellow/phones.png", tags[s][5])
    -- awful.tag.seticon(active_theme .. "/widgets/blue/pacman.png", tags[s][6])
    
end
-- }}}
-- {{{ Menu

-- {{{ Menù di spegnimento
mypoweroffmenu = awful.menu({ items = {
                    { "Aggiorna", awesome.restart },
		            { "Blocca", lock },
                    { "Esci", awesome.quit }, 
                    -- { "Openbox", scripts .. "switchtoopenboxfromawesome" },
		            { "Riavvia", "sudo systemctl reboot" },
		            { "Spegni", "sudo systemctl poweroff" }},
                    theme = { width = 80, height = 17, font = "Tamsyn 9" }
                    })

mypoweroff = wibox.widget.imagebox()
mypoweroff:set_image(beautiful.widget_poweroff)
mypoweroff:buttons(awful.util.table.join(awful.button({ }, 1, function () mypoweroffmenu:toggle() end )))
-- }}}

-- {{{ Accessori
myacc = {
		{ "Geany", "geany
		