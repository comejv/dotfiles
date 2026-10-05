local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- Keep normal key encoding for Fish; Ctrl-H is encoded explicitly below.
config.enable_kitty_keyboard = false

-- Patch OneHalfDark invisible prompt bug
local scheme = wezterm.color.get_builtin_schemes()['OneHalfDark']
scheme.ansi[1] = '#434758'    -- Shift ANSI Black away from #282c34 background
scheme.brights[1] = '#5c6370' -- Shift ANSI Bright Black away from #282c34 background

config.color_schemes = {
  ['OneHalfDarkFixed'] = scheme,
}
config.color_scheme = 'OneHalfDarkFixed'

-- Font
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Medium' })
config.font_size = 13.0

-- Shell Configuration
config.default_domain = 'WSL:Ubuntu'

-- Window
config.window_decorations = 'RESIZE'
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_background_opacity = 1.0
config.adjust_window_size_when_changing_font_size = false

-- Neovim Scrollback
wezterm.on('edit-scrollback', function(window, pane)
  local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
  local name = os.getenv('TEMP') .. '\\wezterm_scrollback_' .. os.time() .. '.txt'

  local wsl_name = name:gsub('\\', '/')

  local f = io.open(name, 'w+')
  if f then
    f:write(text)
    f:flush()
    f:close()
  end

  window:perform_action(
    act.SpawnCommandInNewTab {
      domain = 'CurrentPaneDomain',
      args = { 'bash', '-lc', 'nvim $(wslpath "' .. wsl_name .. '")' },
    },
    pane
  )
  wezterm.sleep_ms(1500)
  os.remove(name)
end)

config.keys = {
  -- Send Ctrl-H as CSI-u so Neovim can distinguish it from Backspace.
  { key = 'h', mods = 'CTRL', action = act.SendString '\x1b[104;5u' },

  -- Clone local WSL tabs, but don't reuse a remote SSH working directory.
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local process = pane:get_foreground_process_name() or ''
      local cwd = pane:get_current_working_dir()
      local cwd_host = cwd and cwd.host or ''
      local local_host = wezterm.hostname()
      local is_remote = cwd_host ~= ''
        and cwd_host:lower() ~= local_host:lower()

      if is_remote or process:match('[/\\]ssh$') then
        window:perform_action(
          act.SpawnCommandInNewTab {
            domain = 'DefaultDomain',
            cwd = '/home/comevinc',
          },
          pane
        )
      else
        window:perform_action(act.SpawnTab 'CurrentPaneDomain', pane)
      end
    end),
  },

  -- Open the main SSH host from a fresh WSL tab.
  {
    key = 't',
    mods = 'CTRL|ALT',
    action = act.SpawnCommandInNewTab {
      domain = 'DefaultDomain',
      cwd = '/home/comevinc',
      args = { 'ssh', '-X', 'vl-comevinc-gridsdca' },
    },
  },

  -- Navigation
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL|SHIFT', action = act.ScrollByLine(-1) },
  { key = 'j', mods = 'CTRL|SHIFT', action = act.ScrollByLine(1) },

  -- Splitting
  { key = 'd', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'e', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- Zoom / Rotate (Kitty layout simulation)
  { key = 'z', mods = 'CTRL|SHIFT', action = act.TogglePaneZoomState },
  { key = 'r', mods = 'CTRL|SHIFT', action = act.RotatePanes 'Clockwise' },

  -- Resizing
  { key = 'LeftArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Left', 1 } },
  { key = 'RightArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Right', 1 } },
  { key = 'UpArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Up', 1 } },
  { key = 'DownArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Down', 1 } },

  -- Existing Scrollback
  { key = 'h', mods = 'CTRL|SHIFT', action = act.EmitEvent 'edit-scrollback' },
}

return config
