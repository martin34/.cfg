local function get_filename()
    local data = vim.fn.expand('%:~:.')
    if vim.bo.modified then
        data = data .. ' [+]'
    elseif vim.bo.modifiable == false or vim.bo.readonly == true then
        data = data .. ' [-]'
    end
    return data
end

local function lsp_not_active() return vim.tbl_isempty(vim.lsp.buf_get_clients(0)) end

local function diagnostics_ok()
    if lsp_not_active() then return '' end
    local w = vim.lsp.diagnostic.get_count(0, 'Warning')
    local e = vim.lsp.diagnostic.get_count(0, 'Error')
    if w ~= 0 or e ~= 0 then return '' end
    return ' '
 end

local function get_colors()
    if vim.g.color_scheme == 'everforest' then return {red = '#e67e80', green = '#a7c080', yellow = '#dbbc7f', orange = '#e69875'} end
    if vim.g.color_scheme == 'nord' then return {red = '#BF616A', green = '#A3BE8C', yellow = '#EBCB8B', orange = '#D08770'} end
    return {red = '#fb4934', green = '#b8bb26', yellow = '#fabd2f', orange = '#fe8019'}
end

local function get_git_branch()
    local head = vim.fn.FugitiveHead(6)
    if head == '' then return nil end
    return ' ' .. head
end

local colors = get_colors()

local M = {}
function M.setup()
  require'lualine'.setup {
    options = { theme = vim.g.color_scheme },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {{get_git_branch}},
      lualine_c = {{get_filename}, { 'diff', color_added = colors.green, color_modified = colors.orange, color_removed = colors.red, symbols = {added = ' ', modified = ' ', removed = ' '} }},
      lualine_x = {{'diagnostics', sources = {'nvim_lsp'}, color_error = colors.red, color_warn = colors.yellow, color_info = nil, symbols = {error = ' ', warn = ' ', info = ' '}}, {diagnostics_ok}, 'filetype' }, 
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  }
end

return M
