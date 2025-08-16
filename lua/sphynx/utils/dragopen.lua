local M = {}

function M.setup()
    local orig_paste = vim.paste
    vim.paste = function(lines, phase)
        local mode = vim.fn.mode()
        -- Solo in modalità normale e visuale (non in command-line, insert o replace)
        if mode == "n" then
            -- Prendi solo la prima riga
            local text = lines[1] or ""
            -- Pulisci il testo
            text = text:gsub("[\r\n]+$", "")
            -- Gestisci file:// URLs (con URL decoding appropriato)
            if text:match("^file://") then
                text = text:gsub("^file://", "")
                -- URL decode basilare
                text = text:gsub("%%(%x%x)", function(hex)
                    return string.char(tonumber(hex, 16))
                end)
            end
            -- Rimuovi quote esterne
            text = text:match("^['\"]?(.-)['\"]*$")
            -- Espandi ~ e variabili d'ambiente
            local expanded = vim.fn.expand(text)
            -- Verifica se è un file esistente
            if vim.fn.filereadable(expanded) == 1 then
                -- Schedula l'apertura per evitare problemi di timing
                vim.schedule(function()
                    vim.cmd('edit ' .. vim.fn.fnameescape(expanded))
                end)
                return -- blocca il paste
            end
            -- Se è una directory, aprila con netrw
            if vim.fn.isdirectory(expanded) == 1 then
                vim.schedule(function()
                    vim.cmd('NvimTreeOpen ' .. vim.fn.fnameescape(expanded))
                end)
                return
            end
        end
        -- Fallback al paste normale
        return orig_paste(lines, phase)
    end

end

return M
