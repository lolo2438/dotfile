---
-- Functions
---
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- https://github.com/stayradiated/terminal.sexy
config.color_scheme = 'OneHalfDark'

--config.font = wezterm.font("MonaspiceNe Mono Nerd Font", {weight="Regular", stretch="Normal", style="Normal"}) -- (AKA: MonaspiceNe NF) /usr/share/fonts/OTF/MonaspiceNeNerdFont-Italic.otf, FontConfig

config.font = wezterm.font('JetBrains Mono', { weight = 'Regular'})

config.window_background_opacity = 0.95

config.hide_tab_bar_if_only_one_tab = true

-- Configuration for windows
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then

  --config.color_scheme = 'Ocean (dark) (terminal.sexy)'

  local launch_menu = {}

  -- CMD
  table.insert(
    launch_menu,
    {
      label = 'cmd',
      args = { 'cmd.exe' }
    }
  )


  --local nushell_path = 'C:/tools/nu/nu.exe'
  if file_exists('nu.exe') then
    config.default_prog = { nushell_path }

    table.insert(
      launch_menu,
      {
        label = 'nu',
        args  = { 'nu.exe' }
      }
    )

  end


  -- Insert servers to ssh to
  local username = ''
  local server_list = {
  }

  for i, server in ipairs(server_list) do
    table.insert(
      launch_menu,
      {
        label = 'ssh ' .. server,
        args = {'ssh', username .. '@' .. server .. ':~/'}
      }
    )
  end

  -- POWERSHELL
  table.insert(
    launch_menu,
    {
      label = 'PowerShell',
      args = { 'powershell.exe', '-NoLogo' }
    }
  )


  config.launch_menu = launch_menu;

  -- Configure directory to be launched in
  config.default_cwd = "C:/work"

end


-- and finally, return the configuration to wezterm
return config
