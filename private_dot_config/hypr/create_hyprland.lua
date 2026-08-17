local hypr_dir = os.getenv("HOME") .. "/.config/hypr/"
package.path = package.path .. ";" .. hypr_dir .. "?.lua;" .. hypr_dir .. "?/init.lua"

require("config.animations")
require("config.autostart")
require("config.cursor")
require("config.decorations")
require("config.environment")
require("config.input")
require("config.monitor")
require("config.variables")
require("config.windowrules")
require("config.keybinds")
