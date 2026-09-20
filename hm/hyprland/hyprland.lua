local uwsm = "uwsm-app -s app.slice -- "
local term = uwsm .. "kitty -1"

hl.on("hyprland.start", function() hl.exec_cmd(term, { workspace = "special:0 silent" }) end)

hl.monitor { output = "", mode = "preferred", scale = 1.25 }

hl.config {
  general = {
    gaps_in = 0,
    gaps_out = 0,
    border_size = 2,
    col = { active_border = colors.accent, inactive_border = "rgba(00000000)" },
    layout = "dwindle",
    allow_tearing = true,
  },

  decoration = {
    rounding_power = 4,
    rounding = 10,

    active_opacity = 1.0,
    inactive_opacity = 0.95,

    dim_inactive = true,
    dim_special = 0.3,
    dim_strength = 0.3,

    blur = {
      enabled = true,
      size = 8,
      passes = 3,
      new_optimizations = true,
      special = false,
      xray = false,
    },

    shadow = {
      enabled = false,
    },
  },

  input = {
    kb_layout = "us",
    kb_options = "caps:swapescape,compose:ins",
    repeat_delay = 300,
    repeat_rate = 30,
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      disable_while_typing = false,
      drag_lock = true,
      natural_scroll = true,
      tap_to_click = true,
    },
    accel_profile = "adaptive",
  },

  group = {
    col = { border_active = colors.accent, border_inactive = "rgba(00000000)" },
    groupbar = {
      gradients = true,
      col = { active = colors.accent, inactive = "rgba(00000000)" },
    },
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    disable_autoreload = true,
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
    enable_swallow = false,
    animate_manual_resizes = true,
    swallow_regex = "^(kitty)$",
    focus_on_activate = true,
  },

  xwayland = {
    force_zero_scaling = true,
  },

  ecosystem = {
    enforce_permissions = true,
    no_donation_nag = true,
    no_update_news = true,
  },

  dwindle = {},
  master = { mfact = 0.5 },
}

hl.gesture {
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
}
hl.gesture {
  fingers = 3,
  direction = "vertical",
  action = "special",
  workspace_name = "0",
}

hl.curve("emphasizedDecel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1 } } })
hl.curve("emphasizedAccel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("menu_decel", { type = "bezier", points = { { 0.1, 1 }, { 0, 1 } } })
hl.curve("menu_accel", { type = "bezier", points = { { 0.52, 0.03 }, { 0.72, 0.08 } } })
hl.curve("stall", { type = "bezier", points = { { 1, -0.1 }, { 0.7, 0.85 } } })

hl.animation { leaf = "monitorAdded", enabled = 0 }
hl.animation { leaf = "windowsIn", enabled = true, speed = 3, bezier = "emphasizedDecel", style = "popin 80%" }
hl.animation { leaf = "fadeIn", enabled = true, speed = 3, bezier = "emphasizedDecel" }
hl.animation { leaf = "windowsOut", enabled = true, speed = 2, bezier = "emphasizedDecel", style = "popin 90%" }
hl.animation { leaf = "fadeOut", enabled = true, speed = 2, bezier = "emphasizedDecel" }
hl.animation { leaf = "windowsMove", enabled = true, speed = 3, bezier = "emphasizedDecel", style = "slide" }
hl.animation { leaf = "border", enabled = true, speed = 10, bezier = "emphasizedDecel" }
hl.animation { leaf = "layersIn", enabled = true, speed = 2.7, bezier = "emphasizedDecel", style = "popin 93%" }
hl.animation { leaf = "layersOut", enabled = true, speed = 2.4, bezier = "menu_accel", style = "popin 94%" }
hl.animation { leaf = "fadeLayersIn", enabled = true, speed = 0.5, bezier = "menu_decel" }
hl.animation { leaf = "fadeLayersOut", enabled = true, speed = 2.7, bezier = "stall" }
hl.animation { leaf = "workspaces", enabled = true, speed = 7, bezier = "menu_decel", style = "slide" }
hl.animation { leaf = "specialWorkspaceIn", enabled = true, speed = 2.8, bezier = "emphasizedDecel", style = "slidevert" }
hl.animation { leaf = "specialWorkspaceOut", enabled = true, speed = 1.2, bezier = "emphasizedAccel", style = "slidevert" }

local function bindS(keys, dsp, opts) hl.bind("SUPER +" .. keys, dsp, opts) end

bindS("C", hl.dsp.window.close())
bindS("Q", hl.dsp.window.kill())
bindS("F", hl.dsp.window.float { action = "toggle" })
bindS("SHIFT + F", hl.dsp.window.fullscreen { action = "toggle" })

bindS("G", hl.dsp.group.toggle())
bindS("tab", hl.dsp.group.next())
bindS("SHIFT+tab", hl.dsp.group.prev())

bindS("ALT + M", hl.dsp.window.move { workspace = "special:0" })
bindS("T", hl.dsp.workspace.toggle_special("0"))

local function bindSe(keys, cmd, opts) bindS(keys, hl.dsp.exec_cmd(cmd), opts) end
local function bindSeu(keys, app, opts) bindSe(keys, uwsm .. app, opts) end

bindSeu("B", "firefox")
bindSe("Return", term)
bindSe("ALT + T", term)

for _, v in pairs { "", "SUPER +" } do
  for _, i in pairs { { "", "screen" }, { "ALT+", "active" }, { "SHIFT+", "area" } } do
    hl.bind(i[1] .. v .. "Print", hl.dsp.exec_cmd("grimblast --notify copy" .. (v == "" and "" or "save") .. " " .. i[2]))
  end
end

bindSe("SHIFT+C", "hyprpicker -a -n")
bindSe("W", "pkill -USR1 waybar || waybar")
bindSe("SHIFT+W", "pkill -USR2 waybar")
bindSe("ALT+CTRL+L", "hyprlock")
bindSe("D", "dunstctl set-paused toggle")

local rof1 = "pkill rofi||rofi"
local rof2 = rof1 .. " -no-sidebar-mode -show "
local rof3 = rof1 .. " -show "
bindSe("SPACE", rof3 .. "drun")
bindSe("R", rof2 .. "run")
bindSe("E", rof2 .. "filebrowser -modes filebrowser")
bindSe("escape", rof2 .. "p -modes p:rofi-power-menu")
bindSe("S", rof1 .. "-systemd")
bindSe("V", "pkill rofi || cliphist list | rofi -dmenu | cliphist decode | wl-copy")

local vimToDir = { H = "l", J = "d", K = "u", L = "r" }

for k, i in pairs { "H", "J", "K", "L" } do
  local d = vimToDir[i]
  bindS(i, hl.dsp.focus { direction = d })
  bindS("ALT +" .. i, hl.dsp.window.move { direction = d })
  bindS("CTRL +" .. i, hl.dsp.window.move { into_group = d })
  local t = ((k % 2) * -2) + 1
  bindS("SHIFT +" .. i, hl.dsp.window.resize { relative = true, x = ((i == "H" or i == "L") and t * 20) or 0, y = ((i == "J" or i == "K") and t * 20) or 0 }, { repeating = true })
end

for i = 1, 10 do
  local w = i % 10
  bindS(w, hl.dsp.focus { workspace = i })
  bindS("ALT +" .. w, hl.dsp.window.move { workspace = i })
end
bindS("grave", hl.dsp.focus { workspace = "e+1" }, { repeating = true })
bindS("SHIFT+grave", hl.dsp.focus { workspace = "e-1" }, { repeating = true })

local function bindX(xkey, cmd) hl.bind("XF86" .. xkey, hl.dsp.exec_cmd(cmd), { repeating = true, locked = true }) end

bindX("MonBrightnessUp", "changeBrightness 5%+")
bindX("MonBrightnessDown", "changeBrightness 5%-")
bindX("AudioRaiseVolume", "changeVolume 5%+")
bindX("AudioLowerVolume", "changeVolume 5%-")
bindX("AudioMute", "wpctl set-mute @DEFAULT_SINK@ toggle")

for _, v in ipairs { "iwgtk", "dconf Editor", "Firefox - Sharing Indicator" } do
  hl.window_rule { match = { title = "^(" .. v .. ")$" }, float = true }
end
for _, v in ipairs { "zoom", "xdg-desktop-portal-gtk" } do
  hl.window_rule { match = { class = v }, float = true }
end

hl.window_rule { match = { class = "mpv" }, idle_inhibit = "focus", fullscreen = true, border_size = 0, opaque = true, no_dim = true }
hl.window_rule { match = { class = "firefox" }, idle_inhibit = "fullscreen" }

hl.window_rule { match = { class = "^(rofi)$" }, stay_focused = true }
hl.window_rule { match = { class = "^(kitty)$" }, xray = true }
hl.window_rule { match = { title = "^(Authentication Required)$" }, float = true, pin = true, stay_focused = true }

hl.window_rule { match = { workspace = "w[tv1]", float = false }, border_size = 0, rounding = 0 }

for _, v in pairs { "gtk-layer-shell", "notifications", "rofi", "waybar" } do
  hl.layer_rule { match = { namespace = v }, blur = true, ignore_alpha = 0 }
end
