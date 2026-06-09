--[[
===============================================================================================
Plugin: image.nvim
===============================================================================================
Description: Rendering di immagini inline dentro Neovim (es. immagini referenziate nei file
             Markdown), usando il protocollo grafico del terminale.
Status: Active
Author: 3rd (Andrei Neculaesei)
Repository: https://github.com/3rd/image.nvim
Notes:
 - Backend = "kitty" (kitty graphics protocol): su Windows + WezTerm rende inline e NON richiede
   di toccare lo shell (verificato 2026-06-09, immagini renderizzate). Il backend "sixel" pure
   funziona ma converte via vim.fn.system con apici Unix, che cmd.exe rompe -> richiederebbe uno
   shell POSIX (bash). Con kitty il processor usa spawn (no shell), quindi nessun problema.
 - processor = "magick_cli": usa il binario ImageMagick (C:/msys64/ucrt64/bin/magick.EXE) via
   spawn diretto, NON il luarock "magick" -> niente LuaRocks da gestire.
 - MONKEY PATCH (necessario su Windows, in M.configs): il plugin ricava le dimensioni del
   terminale via ioctl(TIOCGWINSZ) (Unix-only) -> su Windows get_size() ritorna nil e il render
   si ferma. Forniamo dimensioni stimate; se le immagini sono stirate tarare CELL_W/CELL_H.
 - Caricamento lazy su ft = "markdown": l'integrazione markdown e' attiva di default e mostra
   inline le immagini referenziate (inclusi i wikilink Obsidian a doppia parentesi quadra).
 - build = false: con magick_cli non serve compilare il rock.
 - max_height_window_percentage = 100 (default 50): le immagini usano piu' altezza e si
   avvicinano alla dimensione nativa, restando dentro la finestra (aspect ratio sempre preservato).
 - integrations.markdown: filetypes = markdown + vimwiki; clear_in_insert_mode = true (nasconde
   le immagini in insert mode e le rimostra in normal, come render-markdown col testo);
   window_overlap_clear_enabled = true (pulisce le immagini quando le finestre si sovrappongono);
   download_remote_images = true (scarica e mostra anche le immagini con URL http).
 - PDF: il wrap di from_file ritorna nil per i path .pdf (image.nvim li passerebbe a magick che
   richiede Ghostscript, qui assente -> errore). I link a PDF restano semplici riferimenti.
 - Risoluzione path: image.nvim risolve i path relativi alla cartella del .md, NON alla root
   del vault (Obsidian invece dalla root). Per far funzionare i wikilink Obsidian anche nelle
   note in sottocartelle, in integrations.markdown.resolve_image_path: se il path non esiste
   relativo al file, lo cerca dalla root del vault (rilevata risalendo a .obsidian).
 - Nei link markdown standard gli spazi vanno come %20 (image.nvim fa url-decode).
 - Dimensione wikilink Obsidian "|N" (es. img.png|500): image.nvim non la supporta. La estraiamo
   in resolve_image_path e, via wrap di require("image").from_file, la applichiamo come
   max_width_window_percentage per quella sola immagine (N px -> %, stima via CELL_W). E' un
   TETTO (rimpicciolisce le immagini piu' larghe di N, non ingrandisce le piu' piccole), e il
   valore e' approssimato perche' dipende da CELL_W e dal numero di colonne della finestra.
TODO:
 - [ ] Valutare il caricamento anche all'apertura diretta di file immagine (.png/.jpg),
       non solo nei .md (ora ft = "markdown").
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["image"] = {
        "3rd/image.nvim",
        build = false,
        ft = { "markdown" },
        lazy = true,
    },
}

M.configs = {
    ["image"] = function()
        -- MONKEY PATCH (Windows, fragile): image.nvim ricava le dimensioni del terminale via
        -- ioctl(TIOCGWINSZ), syscall Unix assente su Windows -> get_size() ritorna nil e il
        -- rendering si ferma. Qui forniamo dimensioni stimate cosi' il backend sixel calcola le
        -- geometrie. Le proporzioni dipendono da CELL_W/CELL_H: tarali sul font di WezTerm se le
        -- immagini risultano stirate. (Il backend sixel non usa il tty: scrive via chansend.)
        local CELL_W, CELL_H = 10, 20 -- px per cella stimati (font WezTerm)
        require("image/utils/term").get_size = function()
            local cols, rows = vim.o.columns, vim.o.lines
            return {
                screen_x = cols * CELL_W,
                screen_y = rows * CELL_H,
                screen_cols = cols,
                screen_rows = rows,
                cell_width = CELL_W,
                cell_height = CELL_H,
            }
        end

        -- larghezze richieste dai wikilink Obsidian "|N" (px), mappate per path immagine risolto.
        -- Popolate in resolve_image_path, consumate nel wrap di from_file piu' sotto.
        local pending_widths = {}

        require("image").setup({
            -- kitty graphics protocol: rende inline in WezTerm SENZA toccare lo shell. Il backend
            -- sixel invece richiederebbe uno shell POSIX (cmd.exe rompe il quoting ad apici di magick).
            backend = "kitty",
            processor = "magick_cli", -- usa il binario ImageMagick (spawn diretto), non il luarock
            -- default 50: alzato a 100 cosi' le immagini usano piu' altezza e si avvicinano alla
            -- dimensione nativa (restano comunque dentro la finestra; aspect ratio sempre preservato).
            max_height_window_percentage = 100,
            integrations = {
                markdown = {
                    filetypes = { "markdown", "vimwiki" },
                    -- only_render_image_at_cursor = true,
                    -- only_render_image_at_cursor_mode = "inline",
                    window_overlap_clear_enabled = true,
                    download_remote_images = true,
                    -- nasconde le immagini in insert mode e le rimostra in normal (come render-markdown col testo)
                    clear_in_insert_mode = true,
                    -- Obsidian risolve i wikilink dalla ROOT del vault; image.nvim di default li
                    -- risolve relativi alla cartella del .md (rotto per note in sottocartelle).
                    -- Qui: se il path non esiste relativo al file, lo cerchiamo dalla root del
                    -- vault (rilevata risalendo fino a .obsidian), come fa Obsidian.
                    resolve_image_path = function(document_path, image_path, fallback)
                        -- estrai la larghezza Obsidian "|N" (es. "|500", "|500x300") e toglila dal
                        -- path: image.nvim non interpreta "|N" e lo includerebbe nel path.
                        local width_px = tonumber(image_path:match("|(%d+)"))
                        image_path = image_path:gsub("|.*", "")

                        local resolved = fallback(document_path, image_path)
                        if not vim.uv.fs_stat(resolved) then
                            local dir = vim.fn.fnamemodify(document_path, ":h")
                            local marker = vim.fs.find(".obsidian", { path = dir, upward = true, type = "directory" })[1]
                            if marker then
                                local from_root = vim.fn.fnamemodify(marker, ":h") .. "/" .. image_path
                                if vim.uv.fs_stat(from_root) then
                                    resolved = from_root
                                end
                            end
                        end

                        if width_px then
                            pending_widths[resolved] = width_px
                        end
                        return resolved
                    end,
                },
            },
        })

        -- Applica la larghezza "|N" di Obsidian: image.nvim non la supporta, ma from_file (=
        -- require("image").from_file, usato dall'integrazione markdown) accetta un
        -- max_width_window_percentage per-immagine. Convertiamo N px -> percentuale di finestra
        -- (stima via CELL_W). E' un TETTO, non un target: rimpicciolisce le immagini piu' larghe
        -- di N, non ingrandisce quelle piu' piccole. Approssimato (dipende da CELL_W e colonne).
        local img = require("image")
        local orig_from_file = img.from_file
        img.from_file = function(path, options)
            -- non renderizzare i PDF: image.nvim li passerebbe a magick che richiede Ghostscript
            -- (qui assente) -> errore. I link a PDF restano semplici riferimenti, non immagini.
            if type(path) == "string" and path:lower():match("%.pdf$") then
                return nil
            end
            local width_px = pending_widths[path]
            if width_px then
                pending_widths[path] = nil
                options = options or {}
                local win_px = vim.o.columns * CELL_W
                options.max_width_window_percentage = math.max(1, math.min(100, math.floor(width_px / win_px * 100 + 0.5)))
            end
            return orig_from_file(path, options)
        end
    end,
}

return M
