
-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                         Keybinds                            ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛


-- https://wiki.hyprland.org/Configuring/Binds/
hl.bind("SUPER + Return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + e", hl.dsp.exec_cmd("thunar"))
hl.bind("SUPER + q", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + m", hl.dsp.exec_cmd("loginctl terminate-user \"\""))
hl.bind("SUPER + t", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + space", hl.dsp.exec_cmd("wofi"))
hl.bind("SUPER + f", hl.dsp.window.fullscreen())
hl.bind("SUPER + y", hl.dsp.window.pin())
hl.bind("SUPER + j", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + v", hl.dsp.exec_cmd("vivaldi"))
hl.bind("SUPER + p", hl.dsp.exec_cmd("planify-quick-add"))

hl.bind("Print", hl.dsp.exec_cmd("grimblast copy area"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("grimblast copy active"))
hl.bind("ALT + Print", hl.dsp.exec_cmd("grimblast copy output"))

-- ======= Grouping Windows =======

hl.bind("SUPER + K", hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))
hl.bind("SUPER + Tab", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive f"))

-- ======= Toggle Gaps =======

hl.bind("SUPER + SHIFT + g", hl.dsp.exec_cmd("hyprctl --batch \"keyword general:gaps_out 5;keyword general:gaps_in 3\""))
hl.bind("SUPER + g", hl.dsp.exec_cmd("hyprctl --batch \"keyword general:gaps_out 0;keyword general:gaps_in 0\""))

-- ======= Volume Control =======

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd([[bash -c 'pactl set-sink-volume @DEFAULT_SINK@ +5% && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\''\d+(?=%)'\'' | awk '\''{if($1>100) system("pactl set-sink-volume @DEFAULT_SINK@ 100%")}'\'' && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\''\d+(?=%)'\'' | awk '\''{print $1}'\'' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob # Raise Volume']]), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd([[bash -c 'pactl set-sink-volume @DEFAULT_SINK@ -5% && pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\''\d+(?=%)'\'' | awk '\''{print $1}'\'' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob # Lower Volume']]), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd([[bash -c 'amixer sset Master toggle | sed -En '\''/\[on\]/ s/.*\[([0-9]+)%\].*/\1/ p; /\[off\]/ s/.*/0/p'\'' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob']]), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd([[bash -c 'pactl set-source-mute @DEFAULT_SOURCE@ toggle && pactl get-source-mute @DEFAULT_SOURCE@ | grep -oP '\''\d+'\'' | awk '\''{print $1}'\'' | head -1 > /tmp/$HYPRLAND_INSTANCE_SIGNATURE.wob # Mutes microphone']]), { locked = true, repeating = true })

-- ======= Playback Control =======

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

-- ======= Screen Brightness =======

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { locked = true, repeating = true })
hl.bind("SUPER + l", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + o", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"))
hl.bind("SUPER + SHIFT + t", hl.dsp.exec_cmd("toggle-theme toggle"))

-- ======= Window Actions =======

--# Move window with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag())
--# Move window towards a direction
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + j", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + k", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + l", hl.dsp.window.move({ direction = "r" }))
--# Move active floating window towards a direction
hl.bind("SUPER + ALT + h", hl.dsp.window.move({ x = -30, y = 0 }))
hl.bind("SUPER + ALT + l", hl.dsp.window.move({ x = 30, y = 0 }))
hl.bind("SUPER + ALT + k", hl.dsp.window.move({ x = 0, y = -30 }))
hl.bind("SUPER + ALT + j", hl.dsp.window.move({ x = 0, y = 30 }))
--# Move focus with mainMod + arrow keys
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }))

--# Resizing windows
-- Activate keyboard window resize mode
-- https://wiki.hyprland.org/Configuring/Binds/#submaps
hl.bind("SUPER + r", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
  hl.bind("right", hl.dsp.window.resize({ x = 15, y = 0, relative = true }))
  hl.bind("left", hl.dsp.window.resize({ x = -15, y = 0, relative = true }))
  hl.bind("up", hl.dsp.window.resize({ x = 0, y = -15, relative = true }))
  hl.bind("down", hl.dsp.window.resize({ x = 0, y = 15, relative = true }))
  hl.bind("l", hl.dsp.window.resize({ x = 15, y = 0, relative = true }))
  hl.bind("h", hl.dsp.window.resize({ x = -15, y = 0, relative = true }))
  hl.bind("k", hl.dsp.window.resize({ x = 0, y = -15, relative = true }))
  hl.bind("j", hl.dsp.window.resize({ x = 0, y = 15, relative = true }))
  hl.bind("escape", hl.dsp.submap("reset"))
end)
-- Quick resize window with keyboard
-- !!! added $mainMod here because CTRL + SHIFT is used for word selection in various text editors
hl.bind("SUPER + CTRL + SHIFT + right", hl.dsp.window.resize({ x = 15, y = 0, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + left", hl.dsp.window.resize({ x = -15, y = 0, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -15, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 15, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + l", hl.dsp.window.resize({ x = 15, y = 0, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + h", hl.dsp.window.resize({ x = -15, y = 0, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + k", hl.dsp.window.resize({ x = 0, y = -15, relative = true }))
hl.bind("SUPER + CTRL + SHIFT + j", hl.dsp.window.resize({ x = 0, y = 15, relative = true }))
-- Resize window with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
--# Resizing Windows End #

--# Move active window to a workspace with $mainMod + CTRL + [0-9]
hl.bind("SUPER + CTRL + ampersand", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + CTRL + eacute", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + CTRL + quotedbl", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + CTRL + apostrophe", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + CTRL + parenleft", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + CTRL + minus", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + CTRL + egrave", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + CTRL + underscore", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + CTRL + ccedilla", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + CTRL + agrave", hl.dsp.window.move({ workspace = 10 }))
hl.bind("SUPER + CTRL + left", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + CTRL + right", hl.dsp.window.move({ workspace = "+1" }))
--# Same as above, but doesn't switch to the workspace
hl.bind("SUPER + SHIFT + ampersand", hl.dsp.window.move({ workspace = 1, silent = true }))
hl.bind("SUPER + SHIFT + eacute", hl.dsp.window.move({ workspace = 2, silent = true }))
hl.bind("SUPER + SHIFT + quotedbl", hl.dsp.window.move({ workspace = 3, silent = true }))
hl.bind("SUPER + SHIFT + apostrophe", hl.dsp.window.move({ workspace = 4, silent = true }))
hl.bind("SUPER + SHIFT + parenleft", hl.dsp.window.move({ workspace = 5, silent = true }))
hl.bind("SUPER + SHIFT + minus", hl.dsp.window.move({ workspace = 6, silent = true }))
hl.bind("SUPER + SHIFT + egrave", hl.dsp.window.move({ workspace = 7, silent = true }))
hl.bind("SUPER + SHIFT + underscore", hl.dsp.window.move({ workspace = 8, silent = true }))
hl.bind("SUPER + SHIFT + ccedilla", hl.dsp.window.move({ workspace = 9, silent = true }))
hl.bind("SUPER + SHIFT + agrave", hl.dsp.window.move({ workspace = 10, silent = true }))
-- Move active window to next monitor
hl.bind("SUPER + m", hl.dsp.window.move({ monitor = "+1" }))
-- Window actions End #

-- ======= Workspace Actions =======

-- Switch workspaces with mainMod + [0-9]
hl.bind("SUPER + ampersand", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + eacute", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + quotedbl", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + apostrophe", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + parenleft", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + minus", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + egrave", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + underscore", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + ccedilla", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + agrave", hl.dsp.focus({ workspace = 10 }))
-- Scroll through existing workspaces with mainMod + , or .
hl.bind("SUPER + semicolon", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + comma", hl.dsp.focus({ workspace = "e-1" }))
-- With $mainMod + scroll
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + slash", hl.dsp.focus({ workspace = "previous" }))
-- Special workspaces (scratchpads)
hl.bind("SUPER + equal", hl.dsp.window.move({ workspace = "special" }))
hl.bind("SUPER + asterisk", hl.dsp.workspace.toggle_special("special"))
hl.bind("SUPER + F1", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind("SUPER + ALT + SHIFT + F1", hl.dsp.window.move({ workspace = "special:scratchpad", silent = true }))

-- ======= Additional Settings =======

-- https://wiki.hyprland.org/Configuring/Binds
hl.config({
  binds = {
    allow_workspace_cycles = 1,
    workspace_back_and_forth = 1,
    workspace_center_on = 1,
    movefocus_cycles_fullscreen = true,
    window_direction_monitor_fallback = true
  }
})
