-- vim: set shiftwidth=2 expandtab:

local M = {}

-- declarative: define all patches here
local patches = {
  GitSignsAdd = { bold = true },
  GitSignsChange = { bold = true },
  GitSignsDelete = { bold = true },
  GitSignsCurrentLineBlame = { bold = true },
}

local function merge_hl(name)
  local spec = patches[name]
  if not spec then return end

  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if not ok or not hl or vim.tbl_isempty(hl) then return end

  for k, v in pairs(spec) do
    hl[k] = v
  end

  vim.api.nvim_set_hl(0, name, hl)
end

function M.apply_all()
  for name, _ in pairs(patches) do
    merge_hl(name)
  end
end

function M.setup()
  -- hook once
  local orig = vim.api.nvim_set_hl

  vim.api.nvim_set_hl = function(ns, name, val)
    orig(ns, name, val)
    merge_hl(name)
  end

  -- initial pass
  M.apply_all()
end

M.setup()

return M
