-- ~/.config/nvim/lua/dragopen.lua
-- Quando arriva un bracketed-paste con ESATTAMENTE una riga
-- e quella riga è un file leggibile → lo si apre in :edit
vim.paste = (function(original)
  return function(lines, phase)
    vim.notify("Open file:" ..  lines[1])
    if phase == -1 and #lines == 1 then          -- inizio del paste, una sola riga
      local path = lines[1]
      if vim.fn.filereadable(path) == 1 then    -- è un file esistente?
        vim.cmd('edit ' .. vim.fn.fnameescape(path))
        return                                  -- stop: non incollare il testo
      end
    end
    return original(lines, phase)               -- fallback: comportamento normale
  end
end)(vim.paste)
