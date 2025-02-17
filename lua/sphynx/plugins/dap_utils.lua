local M = {}
local dap =  require'dap'

function M.reload_continue()
    dap.disconnect()
    dap.continue()
end

return M

