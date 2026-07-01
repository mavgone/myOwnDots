local M = {}

function M.reload()
  local matugen_path = vim.fn.stdpath("config") .. "/matugen_colors.lua"
  local overrides = {}

  if vim.fn.filereadable(matugen_path) == 1 then
    local chunk = loadfile(matugen_path)

    if chunk then
      local colors = chunk()

      if type(colors) == "table" then
        overrides = {
          all = colors,
          mocha = colors,
        }
      end
    end
  end

  for k, _ in pairs(package.loaded) do
    if k:match("^catppuccin") then
      package.loaded[k] = nil
    end
  end

  vim.cmd("hi clear")

  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.g.colors_name = nil

  local ok, cat = pcall(require, "catppuccin")

  if ok then
    cat.setup({
      flavour = "mocha",
      compile = {
        enabled = false,
      },
      color_overrides = overrides,
    })

    vim.cmd("colorscheme catppuccin")
  end

  vim.cmd("redraw!")
  vim.notify("Matugen colors reloaded")
end

vim.api.nvim_create_user_command("MatugenReload", function()
  M.reload()
end, {})

local uv = vim.uv
local config_dir = vim.fn.stdpath("config")

local timer = uv.new_timer()
local watcher = uv.new_fs_event()

if watcher then
  watcher:start(
    config_dir,
    {},
    vim.schedule_wrap(function(err, filename)
      if err then
        return
      end

      if filename == "matugen_colors.lua" then
        timer:stop()

        timer:start(
          250,
          0,
          vim.schedule_wrap(function()
            M.reload()
          end)
        )
      end
    end)
  )
end

vim.schedule(function()
  M.reload()
end)

return M
