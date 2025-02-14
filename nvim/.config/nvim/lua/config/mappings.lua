local M = {}

function M.setup()

    local map = vim.keymap.set
    local wk = require("which-key")
    local show = wk.show
    wk.show = function(keys, opts)
        if vim.bo.filetype == "TelescopePrompt" then
            local map_cr = "<c-r>"
            local key = vim.api.nvim_replace_termcodes(map_cr, true, false, true)
            vim.api.nvim_feedkeys(key, "i", true)
        end
        show(keys, opts)
    end
    wk.setup {}

    -- Remap space as leader key
    vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
    vim.g.mapleader = ','
    vim.g.maplocalleader = ','

    -- multi cursor <M-...> = <Alt-...>
    vim.g.VM_maps = {
      ["Add Cursor Down"]    = "<M-j>",
      ["Add Cursor Up"]      = "<M-k>",
      ["Find Subword Under"] = "<M-n>",
      ["Find Under"]         = "<M-n>"
    }

    wk.register({
      ["<leader>f"]  = { name = "+find"},
      ["<leader>t"]  = { name = "+test"},
      ["<leader>gr"] = { name = "+grep"},
      ["<leader>b"]  = { name = "+bazel"},
      ["<leader>bd"] = { name = "+debug"},
      ["<leader>d"]  = { name = "+debug"},
      ["<leader>w"]  = { name = "+wiki"},
      ["<leader>x"]  = { name = "+trouble"},
      ["<leader>h"]  = { name = "+help +hunk"},
      ["<leader>g"]  = { name = "+git +grep"},
      ["<leader>s"]  = { name = "+swap (TS)"},
      ["<leader>sa"]  = { name = "Swap Arguments Next"},
      ["<leader>sA"]  = { name = "Swap Arguments Previous"},
    })

    wk.register({
      ["<leader>g"] = { name = "+git"},
    }, { mode = "v"})

    -- lsp
    map('n', '<leader>rn', vim.lsp.buf.rename, {desc = "Rename (LSP)"})
    map('n', '<leader>c', vim.lsp.buf.code_action, {desc = "Code Action (LSP)"})
    map('n', '[d', vim.diagnostic.goto_prev, {desc = "Next Diagnostic"})
    map('n', ']d', vim.diagnostic.goto_next, {desc = "Previous Diagnostic"})
    map('n', 'gd', vim.lsp.buf.definition, {desc = "Goto Definition"})
    map('n', 'gi', vim.lsp.buf.implementation, {desc = "Goto Implementation"})
    map('n', '<leader>r', vim.lsp.buf.references, {desc = "References (LSP)"})
    map('n', '<leader>q', vim.diagnostic.setqflist, {desc = "Send Diagnostics to Quickfix"})

    -- dashboard
    map('n', '<leader>;', ":Alpha<CR>", { desc = "Open Dashboard" })

    -- filetree
    local my_nvim_tree = require'config.nvimtree'
    map('n', '<C-n>', my_nvim_tree.nvim_tree_toggle_project, {desc = "Toggle Explorer"})
    map('n', '<Leader>n', my_nvim_tree.nvim_tree_find_file, {desc = "Find File in Explorer"})

    -- parse errors from terminal and put them in quickfix list
    map('n', '<Leader>e',  vim.fn.OpenErrorInQuickfix, {desc = "Errors to Quickfix"})

    -- switch between cpp and header file
    map('n', '<F7>', vim.fn.SwitchSourceHeader, {desc = "Switch Source/Header"})

    -- telescope
    local telescope = require'telescope'
    local mytelescope = require'config.telescope'
    local builtin = require'telescope.builtin'
    map('n', '<leader>ff',  function() builtin.find_files({previewer = false}) end, {desc = "Find Files"})
    map('n', '<leader>fs',  function() builtin.find_files({previewer = false, search_file = vim.fn.expand('<cword>')}) end, {desc = "Find Files String (Current Word under Cursor)"})
    map('n', '<leader>fo',  function() builtin.oldfiles({previewer = false}) end, {desc = "Find Oldfiles"})
    map('n', '<leader>fw',  function() builtin.oldfiles({previewer = false, cwd_only = true}) end, {desc = "Find Cwd"})
    map('n', '<leader>fb',  function() builtin.buffers({sort_mru = true}) end, {desc = "Find Buffers"})
    map('n', '<leader>fq',  builtin.quickfix, {desc = "Find Quickfix"})
    map('n', '<leader>fc',  builtin.commands, {desc = "Find Commands"})
    map('n', '<leader>fh',  builtin.command_history, {desc = "Find Command History"})
    map('n', '<leader>fr',  builtin.registers, {desc = "Find Registers"})
    map('n', '<leader>fl',  builtin.resume, {desc = "Find Last"})
    map('n', '<leader>ht',  builtin.help_tags, {desc = "Find Help Tags"})
    map('n', '<leader>gr',  builtin.live_grep, {desc = "Grep"})
    map('n', '<leader>grs', builtin.grep_string, {desc = "Grep String (Current Word under Cursor)"})
    map('n', '<leader>grb', builtin.current_buffer_fuzzy_find, {desc = "Fuzzy Find Buffer"})
    map('n', '<leader>fy',  telescope.extensions.neoclip.default, {desc = "Find Yanks"})
    map('n', '<leader>fp',  mytelescope.project, {desc = "Find Project"})
    map('n', '<leader>f.',  function() builtin.find_files({prompt_title = ".cfg", cwd = "$HOME/.cfg", hidden = true, file_ignore_patterns = {".git"}}) end, {desc = "Find .cfg"})
    map('n', '<leader>fn',  function() builtin.find_files({prompt_title = ".config/nvim", path_display = { "smart" }, search_dirs = {"$HOME/.config/nvim", "$HOME/.local/share/nvim/site/pack/packer"}}) end, {desc = "Find Neovim Files"})
    map('n', '<leader>gr.', function() builtin.live_grep({cwd = "$HOME/.cfg", vimgrep_arguments = { 'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '--hidden' }, file_ignore_patterns = {".git"}}) end, {desc = "Grep .cfg"})
    map('n', '<leader>grw', function() builtin.live_grep({cwd = "$HOME/projects/vimwiki"}) end, {desc = "Grep Wiki"})
    map('n', '<leader>grn', function() builtin.live_grep({search_dirs = {"$HOME/.config/nvim", "$HOME/.local/share/nvim/site/pack/packer"}}) end, {desc = "Grep Neovim Files"})


    -- git
    map('n', '<leader>gb', function() builtin.git_branches({cwd = vim.fn.expand("%:p:h")}) end, {desc = "Git Branches"})
    map('n', '<leader>gc', function() builtin.git_bcommits({cwd = vim.fn.expand("%:p:h")}) end, {desc = "Git Commits"})
    map('n', '<Leader>gl', ':G log -n 1000<CR>', {desc = "Git Log"})
    map('n', '<Leader>gd', ':GitDiff<CR>', {desc = "Git Diff"})
    map('n', '<Leader>gs', ':G | MaximizerToggle<CR>', {desc = "Git Status"})
    map('v', '<Leader>gb', ':GBrowse<CR>', {desc = "Git Browse"})

    -- Navigation
    map('n', ']c', function() if vim.wo.diff then return ']c' end vim.schedule(function() package.loaded.gitsigns.next_hunk() end) return '<Ignore>' end, {expr=true, desc="Next Hunk"})
    map('n', '[c', function() if vim.wo.diff then return '[c' end vim.schedule(function() package.loaded.gitsigns.prev_hunk() end) return '<Ignore>' end, {expr=true, desc="Previous Hunk"})

    -- Actions
    local gs = require'gitsigns'
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>', {desc = "Stage Hunk"})
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', {desc = "Reset Hunk"})
    map('n', '<leader>hS', gs.stage_buffer, {desc = "Stage Buffer"})
    map('n', '<leader>hu', gs.undo_stage_hunk, {desc = "Undo Stage Hunk"})
    map('n', '<leader>hR', gs.reset_buffer, {desc = "Rest Buffer"})
    map('n', '<leader>hp', gs.preview_hunk, {desc = "Preview Hunk"})
    map('n', '<leader>hd', gs.diffthis, {desc = "Diff This"})
    map('n', '<leader>hD', function() gs.diffthis('~') end, {desc = "Diff This ~"})

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', {desc = ""})

    -- bazel
    local bazel = require'bazel'
    local my_bazel = require'config.bazel'
    vim.api.nvim_create_autocmd("FileType", { pattern = "bzl", callback = function() map('n', 'gd', vim.fn.GoToBazelDefinition, { buffer = 0, desc = "Goto Definition" }) end })
    vim.api.nvim_create_autocmd("FileType", { pattern = "bzl", callback = function() map('n', '<Leader>y',   my_bazel.YankLabel, {desc = "Bazel Yank Label"}) end })
    map('n', 'gbt',         vim.fn.GoToBazelTarget, {desc = "Goto Bazel Build File"})
    map('n', '<Leader>bl',  bazel.run_last, {desc = "Bazel Last"})
    map('n', '<Leader>bdt', my_bazel.DebugTest, {desc = "Bazel Debug Test"})
    map('n', '<Leader>bdr', my_bazel.DebugRun, {desc = "Bazel Debug Run"})
    map('n', '<Leader>bt',  function() bazel.run_here("test",  vim.g.bazel_config)     end, {desc = "Bazel Test"})
    map('n', '<Leader>bb',  function() bazel.run_here("build", vim.g.bazel_config)     end, {desc = "Bazel Build"})
    map('n', '<Leader>br',  function() bazel.run_here("run",   vim.g.bazel_config)     end, {desc = "Bazel Run"})
    map('n', '<Leader>bdb', function() bazel.run_here("build", vim.g.bazel_config .. " --compilation_mode dbg --copt=-O0") end, {desc = "Bazel Debug Build"})

    -- debugger
    local dap = require'dap'
    local mydap = require'config.dap'
    local dap_telescope = require'telescope'.extensions.dap
    map('n', '<leader>m',   ':MaximizerToggle!<CR>', {desc = "Maximize Window Toggle"})
    map('n', '<leader>db',  dap.toggle_breakpoint, {desc = "Set Breakpoint"})
    map('n', '<leader>l',   dap.step_into, {desc = "Step Into (debugger)"})
    map('n', '<leader>j',   dap.step_over, {desc = "Step Over (debugger)"})
    map('n', '<leader>k',   dap.step_out, {desc = "Step Out (debugger)"})
    map('n', '<leader>dr',  dap.run_to_cursor, {desc = "Run to Cursor"})
    map('n', '<leader>dap', mydap.set_python_args_from_input, {desc = "Set Python Arguments"})
    map('n', '<leader>dp',  require('dap-python').test_method, {desc = "Debug python test_method"})
    map('n', '<leader>df',  dap_telescope.frames, {desc = "Frames"})
    map('n', '<leader>dl',  dap.run_last, {desc = "Debug Last"})
    map('n', '<leader>dd',  function() require('dap.ext.vscode').load_launchjs() dap_telescope.configurations() end, {desc = "Available Debug Configurations"})
    map('n', '<leader>de',  mydap.end_debug_session, {desc = "End Debugger"})
    map('n', '<leader>dc',  ':e .vscode/launch.json<CR>', {desc = "Edit Debug Configurations"})
    map('n', '<leader>d<space>', dap.continue, {desc = "Continue (debugger)"})

    -- trouble
    map('n', '<leader>xx', ':TroubleToggle<CR>', {desc = "Toggle Trouble"})
    map('n', '<leader>xw', ':TroubleToggle workspace_diagnostics<CR>', {desc = "Workspace Diagnostics"})
    map('n', '<leader>xd', ':TroubleToggle document_diagnostics<CR>', {desc = "Document Diagnostics"})
    map('n', '<leader>xq', ':TroubleToggle quickfix<CR>', {desc = "Quickfix"})
    map('n', '<leader>xl', ':TroubleToggle loclist<CR>', {desc = "Location List"})

    map('t', '<ESC>', '<C-\\><C-n>', {desc = "Esc in Terminal leaves Insert Mode"})

    -- easy navigation between window splits and tmux panes
    map('n', '<C-J>', '<C-W><C-J>', {desc = "Window <down>"})
    map('n', '<C-K>', '<C-W><C-K>', {desc = "Window <up>"})
    map('n', '<C-L>', '<C-W><C-L>', {desc = "Window <right>"})
    map('n', '<C-H>', '<C-W><C-H>', {desc = "Window <left>"})


    map('v', 'J', [[:m '>+1<CR>gv=gv]], {desc = "Move selected lines down"})
    map('v', 'K', [[:m '<-2<CR>gv=gv]], {desc = "Move selected lines up"})

    map('n', '<Leader>f', ':let @+=expand("%")<CR>', {desc = "Copy full path to clipboard"})
    map('v', '<C-c>', '"+y', {desc = "CTRL-c copies selection"})

    map('v', 'p', '"_dP', {desc = "p in visual mode pastes without changing default register"})

    -- beginning/end of line
    map({'n','v'}, 'H', '^', {desc = "Beginning of Line"})
    map({'n','v'}, 'L', '$', {desc = "End of Line"})

    -- single line diffput/diffget shortcuts
    -- map('n', '<leader>dp', 'V:diffput<CR>', {desc = ""})
    -- map('n', '<leader>do', 'V:diffget<CR>', {desc = ""})

    local neotest = require("neotest")
    map('n', '<leader>to',  neotest.output.open, {desc = "Toggle Test Output"})
    map('n', '<leader>tt',  neotest.run.run, {desc = "Test Nearest Test"})
    map('n', '<leader>tl',  neotest.run.run_last, {desc = "Test Last"})
    map('n', '<leader>tf',  function() neotest.run.run(vim.fn.expand("%")) end, {desc = "Test File"})
    map('n', '<leader>tdt', function() neotest.run.run({strategy = "dap"}) end, {desc = "Test Debug Nearest Test"})
    map('n', '<leader>tdf', function() neotest.run.run({vim.fn.expand("%"), strategy = "dap"}) end, {desc = "Test Debug File"})
    map('n', '<leader>t', require'config.terminal-split'.split_terminal)

    pcall(require, 'user.mappings')
end

return M
