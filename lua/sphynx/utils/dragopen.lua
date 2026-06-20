local M = {}

local function clean_dropped_text(text)
    text = text:gsub("[\r\n]+$", "")
    text = text:gsub("^%s+", ""):gsub("%s+$", "")

    if text:match("^file://") then
        text = text:gsub("^file:///*([A-Za-z]:)", "%1")
        text = text:gsub("^file://", "")
        text = text:gsub("%%(%x%x)", function(hex)
            return string.char(tonumber(hex, 16))
        end)
    end

    text = text:match("^['\"](.-)['\"]$") or text
    return text
end

local function paste_text(text)
    vim.api.nvim_put(vim.split(text, "\n", { plain = true }), "c", true, true)
end

local function put_cmdline_text(text)
    local line = vim.fn.getcmdline()
    local pos = vim.fn.getcmdpos()

    local before = line:sub(1, pos - 1)
    local after = line:sub(pos)

    vim.fn.setcmdline(before .. text .. after)
    vim.fn.setcmdpos(pos + #text)
end

function M.setup()
    local orig_paste = vim.paste
    vim.paste = function(lines, phase)
        local mode = vim.fn.mode()
        local text = lines[1] or ""
        text = clean_dropped_text(text)

        if #lines == 1 then
            -- In normal mode il drag&drop di un file apre il file/directory come prima.
            if mode == "n" then
                local expanded = vim.fn.expand(text)

                if vim.fn.filereadable(expanded) == 1 then
                    vim.schedule(function()
                        vim.cmd("edit " .. vim.fn.fnameescape(expanded))
                    end)
                    return
                end

                if vim.fn.isdirectory(expanded) == 1 then
                    vim.schedule(function()
                        vim.cmd("NvimTreeOpen " .. vim.fn.fnameescape(expanded))
                    end)
                    return
                end
            end

            -- Neovim gira nativo su Windows: quando il drop non apre direttamente il file,
            -- mantieni il path Windows originale invece di convertirlo in formato MSYS (/c/...).
            if text:match("^[A-Za-z]:[\\/]") then
                if mode == "c" then
                    put_cmdline_text(vim.fn.fnameescape(text))
                else
                    paste_text(text)
                end
                return
            end
        end

        return orig_paste(lines, phase)
    end
end

return M
