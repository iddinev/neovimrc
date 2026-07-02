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

opt.foldlevel = 2
opt.foldlevelstart = 2
opt.foldcolumn = "1"
opt.fillchars = {
    foldopen = "⌄", -- UTF 2304
    foldclose = "›", -- 203A
    foldsep = " ",
    foldinner = "│",
    fold = " ", -- UTF 2502
}

-- line numbers
opt.relativenumber = true
opt.statuscolumn = "%s%=%{v:virtnum < 0 ? '' : (v:relnum == 0 ? v:lnum : v:relnum)} %C "

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
