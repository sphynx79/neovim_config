-- In un file separato, es: lua/sphynx/utils/view.lua
local M = {}

-- Impostazioni per view e session
local function setup_view_options()
    -- Configurazione view
    vim.opt.viewoptions = {
        'cursor',    -- Posizione cursore
        'folds',     -- Stato fold
        'slash',     -- Usa slash invece di backslash
        'unix',      -- Usa format unix
    }

    -- Crea directory se non esiste
    local view_dir = vim.fn.stdpath("data") .. "/view"
    if vim.fn.isdirectory(view_dir) == 0 then
        vim.fn.mkdir(view_dir, "p")
    end
    vim.opt.viewdir = view_dir

    -- Ignora alcuni tipi di file
    local ignore_filetypes = {
        'gitcommit',
        'help',
        'quickfix',
    }

    -- Funzione helper per verificare se il buffer è valido per la view
    local function is_valid_buffer()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname == "" then return false end
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then return false end
        if not vim.bo.modifiable then return false end
        return true
    end

    -- Salva stato del fold insieme alla view
    vim.api.nvim_create_autocmd({"BufWritePost", "BufLeave", "WinLeave"}, {
        group = vim.api.nvim_create_augroup("AutoSaveView", { clear = true }),
        callback = function()
            if is_valid_buffer() then
                -- Salva lo stato del fold auto nel buffer
                pcall(vim.cmd.mkview)
            end
        end
    })

    -- Carica view e ripristina stato fold
    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("AutoLoadView", { clear = true }),
        callback = function()
            if is_valid_buffer() then
                pcall(vim.cmd.loadview)
            -- Leggi lo stato salvato
            local state_file = vim.fn.stdpath("data") .. "/fold_auto_state"
            local file = io.open(state_file, "r")
            if file then
                local state = file:read("*all")
                file:close()
                if state == "1" then
                    vim.opt.foldclose = "all"
                end
            end
            end
        end
    })
end

-- Funzione per ripulire le view vecchie
function M.clean_views()
    local view_dir = vim.fn.stdpath("data") .. "/view"
    local files = vim.fn.glob(view_dir .. "/*", true, true)

    for _, file in ipairs(files) do
        -- Controlla l'ultima modifica del file
        local last_modified = vim.fn.getftime(file)
        local days_old = (vim.fn.localtime() - last_modified) / (60 * 60 * 24)

        -- Elimina file più vecchi di 30 giorni
        if days_old > 30 then
            vim.fn.delete(file)
        end
    end
end

-- Inizializzazione
function M.setup()
    setup_view_options()

    -- Pulisci view vecchie all'avvio
    M.clean_views()

    -- Comando per pulire manualmente le view
    vim.api.nvim_create_user_command("CleanViews", M.clean_views, {
        desc = "Clean old view files"
    })
end

return M
