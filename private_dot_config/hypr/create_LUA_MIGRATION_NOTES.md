# Hyprland Lua Migration Notes & Pitfalls

This file logs the issues encountered when trying to migrate your Hyprland configuration from `.conf` to `.lua` format using the community `hyprconf2lua` tool, so you can tackle them when you have time.

## 1. Do Not Test by Running `hyprland -c`
When testing your new `.lua` config, **DO NOT** run `hyprland -c ~/.config/hypr/hyprland.lua`. This will actually spawn a nested Hyprland session inside your current one (which is why you saw the new window with a desktop inside it). 
**Solution:** Always use the verify flag to check syntax: 
`hyprland --verify-config -c ~/.config/hypr/hyprland.lua`

## 2. Global Variables (`$mainMod`, `$terminal`, etc.)
`hyprconf2lua` fails to substitute variables. It literally writes `"$mainMod"` into your Lua scripts instead of replacing it with `"SUPER"`. Hyprland's Lua parser will reject `"$mainMod"` as an unknown keysym, causing massive parsing failures.
**Solution:** You must use find-and-replace to change all variables (like `$mainMod`, `$terminal`, `$filemanager`, `$browser`) to their actual string values in the `.lua` files.

## 3. `package.path` for `require()`
If you split your configs (e.g., `require("config.keybinds")`), Lua needs to know where to find them. Hyprland launches in your home directory by default, so it won't find `.lua` files inside `~/.config/hypr/config/`.
**Solution:** Add this to the top of your `hyprland.lua`:
```lua
local hypr_dir = os.getenv("HOME") .. "/.config/hypr/"
package.path = package.path .. ";" .. hypr_dir .. "?.lua;" .. hypr_dir .. "?/init.lua"
```

## 4. Broken Dispatchers in `keybinds.lua`
The converter messes up complex bindings, generating invalid Lua tables instead of proper dispatchers.
- Mouse bindings (`bindm`) are converted as `hl.bind("SUPER", "mouse:272", nil)`.
- Workspace movement bindings (e.g. `movetoworkspace -1`) are converted as `hl.dsp.window.move({ direction = -1 })` which throws "invalid direction -1".
**Solution:** For bindings that fail to convert, you can wrap them in `hl.cmd()` or use the raw config table. Example:
```lua
hl.config({ bindm = { "SUPER, mouse:272, movewindow" } })
```

## 5. Invalid Lua Keys (Dots and Hyphens)
The converter leaves invalid syntax in your tables:
- **Dots in keys:** `col.active = ...` is invalid Lua inside a table definition. It must be written as `["col.active"] = ...`.
- **Hyphens in variable names:** `local shot-region` is invalid because Lua interprets the hyphen as a subtraction symbol. Use `local shot_region` instead.

## 6. Monitor and Animation Arrays
- **Monitor:** `hyprconf2lua` generates a `monitorv2` block which is unrecognized. It should be converted to `hl.config({ monitor = { "eDP-1,preferred,auto,1" } })`.
- **Animations:** It generates escaped strings like `animation = "{ \"slide\", \"right\" },"` which breaks parsing. It needs to be simplified back to the standard string `animation = "slide right",`.

## 7. `hyprland.conf` Stub Generation
If Hyprland encounters syntax errors in your `.lua` file, it will abort loading it. Since it won't find a valid config, it will automatically generate a default `hyprland.conf` stub, which breaks your keyboard layout (reverts to QWERTY) and font scaling.
**Solution:** Always delete the auto-generated `hyprland.conf` after fixing your `.lua` errors, otherwise Hyprland will continue to prioritize the stub `hyprland.conf` over your `.lua` config.
## 8. Hot-Reloading and Native Filename
- **Native Filename:** Hyprland's native Lua manager looks for `hyprland.lua` as its default configuration file, not `init.lua`. If you rename it to anything else, Hyprland will fail to find it and will auto-generate a generic `hyprland.lua` stub, breaking your layout.
- **Hot-Reloading:** If your active session was originally launched using `hyprland.conf`, running `hyprctl reload` will **NOT** switch the internal configuration parser from `.conf` to `.lua`. Even if you symlink `hyprland.conf` to `hyprland.lua` or use `source`, `hyprctl reload` will still attempt to parse the Lua file using standard `.conf` syntax, resulting in massive syntax errors (which appear on your screen as the red error overlay).
**Solution:** To switch from `.conf` to `.lua`, you **must completely restart your Hyprland session** (log out and log back in). `hyprctl reload` alone will not work.
