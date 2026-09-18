hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 5,
    border_size = 3,
    ["col.active_border"] = "rgba(82dcccff)",
    ["col.inactive_border"] = "rgba(182545ff)",
    layout = "dwindle",
    snap = {
      enabled = true
    }
  },
  group = {
    ["col.border_active"] = "rgba(007d6fff)",
    ["col.border_inactive"] = "rgba(82dcccff)",
    ["col.border_locked_active"] = "rgba(00aa84ff)",
    ["col.border_locked_inactive"] = "rgba(111826ff)",
    groupbar = {
      font_family = "Fira Sans",
      text_color = "rgba(111826ff)",
      ["col.active"] = "rgba(007d6fff)",
      ["col.inactive"] = "rgba(82dcccff)",
      ["col.locked_active"] = "rgba(00aa84ff)",
      ["col.locked_inactive"] = "rgba(111826ff)"
    }
  },
  misc = {
    font_family = "Fira Sans",
    splash_font_family = "Fira Sans",
    disable_hyprland_logo = true,
    ["col.splash"] = "rgba(82dcccff)",
    background_color = "rgba(111826ff)",
    enable_swallow = true,
    swallow_regex = "^(nautilus|nemo|thunar|btrfs-assistant.)$",
    focus_on_activate = true,
    vrr = 2
  },
  render = {
    direct_scanout = 1
  },
  dwindle = {
    special_scale_factor = 0.8,
    preserve_split = true
  },
  master = {
    new_status = "master",
    special_scale_factor = 0.8
  }
})
