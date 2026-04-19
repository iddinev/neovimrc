local opt = vim.opt

-- modeline (file-local config; disable if editing untrusted files)
opt.modeline = true

-- UI
opt.termguicolors = true
opt.mouse = "a"
opt.signcolumn = "yes"

-- command-line (minimal modern baseline)
opt.showcmd = true
opt.inccommand = "split"
opt.history = 1000

-- editing behavior
opt.backspace = { "indent", "eol", "start" }

-- search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- wrapping
opt.wrap = true
opt.linebreak = true
opt.showbreak = "  >>  "
opt.breakindent = true
opt.breakindentopt = "min:20,shift:0,sbr"

-- text layout
opt.textwidth = 120
opt.scrolloff = 999
local ns = vim.api.nvim_create_namespace("overflow")

local function highlight_overflow()
  local buf = 0
  local tw = vim.bo.textwidth
  if tw == 0 then return end

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if #line > tw then
      vim.api.nvim_buf_add_highlight(buf, ns, "Error", i - 1, tw, tw + 1)
    end
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "InsertLeave" }, {
  callback = highlight_overflow,
})

-- indentation
opt.autoindent = true
opt.expandtab = true
opt.softtabstop = 4
opt.tabstop = 4
opt.shiftwidth = 4

-- whitespace visualization
opt.list = true
opt.listchars = {
  tab = "| ", 
  trail = "·", -- UTF 00B7
  extends = "›", -- UTF 203A
  precedes = "‹", -- UTF 2039
  nbsp = "␣", -- UTF 2423
}

-- line numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2


-- window splitting
opt.splitright = true
opt.splitbelow = true

-- diff
opt.diffopt:append({ "vertical", "algorithm:histogram", "indent-heuristic" })

-- completion (insert-mode baseline)
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10
opt.shortmess:append("c")

-- performance / responsiveness
opt.updatetime = 500
