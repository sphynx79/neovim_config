--[[
===============================================================================================
Plugin: render-markdown.nvim
===============================================================================================
Description: Abbellisce la vista dei file Markdown direttamente dentro Neovim (heading con
             icone, code block, checkbox, callout, tabelle, link) senza finestre esterne.
             In insert/visual mostra il markup raw, in normal lo rende.
Status: Active
Author: MeanderingProgrammer
Repository: https://github.com/MeanderingProgrammer/render-markdown.nvim
Notes:
 - Requisiti soddisfatti: nvim 0.12.2 (richiesto >= 0.9), parser treesitter markdown e
   markdown_inline BUNDLED in nvim; opzionali html/latex/yaml gia' presenti. Icon provider:
   nvim-web-devicons. Caricamento lazy su ft = "markdown"; dependencies coi nomi-repo del
   progetto (treesitter, kyazdani42/nvim-web-devicons) per non duplicare gli spec.
 - render_modes = { "n" }: rende SOLO in normal mode; in insert/visual mostra il markup raw.
 - completions lsp + blink abilitati: blink completa callout ([!NOTE]...), checkbox e link.
 - conceal/conceallevel gestiti per-finestra da win_options (rendered: conceallevel=3,
   concealcursor="n"); in rendered disattiva anche wrap/linebreak/breakindent. Il
   document.conceal nasconde il frontmatter YAML (--- ... ---).
 - heading: niente sign, icone nf-md-numeric_1_box..6_box, position="inline", nessuno sfondo
   (backgrounds={}), width="block" con min_width/right_pad per livello. Colori Nord Aurora su
   icona E testo (RenderMarkdownHN + @markup.heading.N.markdown), riapplicati su ColorScheme.
 - code block: nessuna label di linguaggio in alto (language=false) ma nome+icona (language_name/
   icon), bordo "thin", sfondo custom RenderMarkdownCodeCustom (#3A4150) e nome linguaggio
   arancione RenderMarkdownCodeLanguageOrange (#D08770). Inoltre @markup.strong forzato bold.
 - link.wiki.body: per i wikilink immagine con alias numerico (es. nome.png|400) mostra solo il
   nome file (la dimensione |N e' gestita da image.nvim); conceal_destination nasconde il path.
 - indent per_level=4 (da H2, skip_level=1); paragraph.left_margin=2; yaml rendering OFF;
   custom.pdf: icona dedicata per i link .pdf.
 - Integrazione con image.nvim: all'apertura di Telescope le immagini vengono disabilitate
   (image.disable) e ripristinate alla chiusura, per non sovrapporsi ai popup di Telescope.
 - vim-markdown (markdown.lua) e markdown-preview.nvim sono DISABILITATI (DISABLED LANGUAGE in
   3-plugins.lua): il primo faceva conceal in conflitto, il secondo non piu' usato (le immagini
   si vedono inline via image.nvim).
Keymaps:
 - (nessuna keymap) il prefix <leader>m e' gia' interamente di marks.nvim; si usano i comandi
Commands:
 - :RenderMarkdown toggle      → attiva/disattiva il rendering (globale)
 - :RenderMarkdown enable      → attiva il rendering
 - :RenderMarkdown disable     → disattiva il rendering
 - :RenderMarkdown buf_toggle  → attiva/disattiva solo per il buffer corrente
 - :RenderMarkdown preview     → mostra il buffer renderizzato di fianco
TODO:
 - [ ] Ritarare min_width/right_pad degli heading e paragraph.left_margin se cambia il font Nerd Font
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["render-markdown"] = {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown",
        dependencies = { "nvim-treesitter/nvim-treesitter", "kyazdani42/nvim-web-devicons" },
        lazy = true,
    },
}

M.configs = {
    ["render-markdown"] = function()
        local opts = {
            render_modes = { "n" },
            completions = {
                lsp = { enabled = true }, -- blink.cmp completa callout/checkbox/link nei .md
                blink = { enabled = true },
            },
            document = {
                enabled = true,
                render_modes = { "n" },
                conceal = {
                    line_patterns = {
                        "^%-%-%-\n.-\n%-%-%-",
                    },
                },
            },
            heading = {
                sign = false, -- niente icona nella sign column
                position = "inline",
                icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " }, -- nf-md-numeric_1_box..6_box
                backgrounds = {}, -- nessuno sfondo: niente evidenziazione della riga heading
                width = "block",
                min_width = { 80, 65, 50, 40, 30, 24 },
                right_pad = { 4, 3, 3, 2, 2, 1 },
                left_pad = 0,
                left_margin = 0,
            },
            indent = {
                enabled = true,

                -- quanti spazi aggiungere per ogni livello heading
                per_level = 4,

                -- 1 = non indentare H1, inizia da H2
                -- 0 = indenta anche il contenuto sotto H1
                skip_level = 1,

                icon = "",

                -- true = non sposta il titolo, sposta solo il corpo sotto
                skip_heading = false,

            },
            paragraph = {
                enabled = true,

                -- allinea il paragrafo dopo l'icona heading
                -- prova 2 o 3 in base al font Nerd Font
                left_margin = 2,

                indent = 0,
            },
            link = {
                enabled = true,

                wiki = {
                    enabled = true,

                    -- lascia attivo: nasconde la destinazione originale
                    conceal_destination = true,

                    -- icona per wikilink
                    -- icon = "󰥶 ",

                    -- decide cosa mostrare al posto di [[...|alias]]
                    body = function(ctx)
                        local dest = ctx.destination or ""
                        local alias = ctx.alias

                        -- riconosci file immagine
                        local is_image = dest:match("%.png$")
                            or dest:match("%.jpg$")
                            or dest:match("%.jpeg$")
                            or dest:match("%.webp$")
                            or dest:match("%.gif$")
                            or dest:match("%.svg$")

                        if not is_image then
                            return nil
                        end

                        -- se l'alias è numerico, in Obsidian probabilmente è una width: |400
                        if alias and alias:match("^%d+$") then
                            -- mostra solo il nome file
                            return vim.fn.fnamemodify(dest, ":t")
                        end

                        -- per immagini senza alias numerico, comportamento normale
                        return nil
                    end,

                    highlight = "RenderMarkdownWikiLink",
                },
            },
            code = {
                language = false,
                sign = false,
                language_name = true,
                language_icon = true, -- metti true se vuoi anche l'icona
                style = 'normal',
                left_pad = 1,
                right_pad = 1,
                width = 'block',
                min_width = 100,
                border = "thin", -- bordo sopra/sotto
                -- language_left = '',
                -- language_right = '',
                highlight_language = "RenderMarkdownCodeLanguageOrange",
                highlight = "RenderMarkdownCodeCustom", -- sfondo
                -- highlight_border = "RenderMarkdownCodeBorderCustom",
            },
            yaml = {
                -- Turn on / off all yaml rendering.
                enabled = false,
                -- Additional modes to render yaml.
                render_modes = false,
            },
            win_options = {
                conceallevel = {
                    default = vim.o.conceallevel,
                    rendered = 3,
                },
                concealcursor = {
                    default = vim.o.concealcursor,
                    rendered = "n",
                },

                -- parte importante
                wrap = {
                    default = vim.o.wrap,
                    rendered = false,
                },
                linebreak = {
                    default = vim.o.linebreak,
                    rendered = false,
                },
                breakindent = {
                    default = vim.o.breakindent,
                    rendered = false,
                },
            },
            custom = {
                pdf = {
                    icon = " ",
                    pattern = "%.pdf$",
                    kind = "suffix",
                    highlight = "RenderMarkdownPdfLink",
                },
            },
            -- anti_conceal = {
            --     enabled = true,
            --     ignore = {
            --         code_background = true,
            --         code_border = true,
            --         code_language = true, -- questa è la parte importante
            --         indent = true,
            --         sign = true,
            --         virtual_lines = true,
            --     },
            -- },
        }

        -- Il terminale di Obsidian (ConPTY+xterm.js) corrompe i caratteri non-BMP
        -- (icone Nerd Font Plane 15). Con OBSIDIAN_TERMINAL=1 (impostata nei profili
        -- del plugin terminal) il rendering resta attivo ma si tolgono le sole icone
        -- non-BMP; bullet/quote/dash (BMP) restano. WezTerm e altri terminali: invariati.
        if vim.env.OBSIDIAN_TERMINAL then
            local default = require("render-markdown").default or {}
            opts.heading.icons = { "", "", "", "", "", "" } -- icona vuota: nasconde i # senza glifo non-BMP
            opts.code.language_icon = false     -- icone devicons per linguaggio
            opts.checkbox = { enabled = false } -- 󰄱/󰱒 → raw [ ] / [x]
            opts.link.image = ""
            opts.link.email = ""
            opts.link.hyperlink = ""
            opts.link.wiki.icon = ""
            opts.link.custom = {}               -- mappa con chiavi: override per nome
            for name in pairs((default.link or {}).custom or {}) do
                opts.link.custom[name] = { icon = "" }
            end
            opts.callout = {}                   -- 󰋽 Note, 󰌶 Tip… icona dentro 'rendered'
            for name, cfg in pairs(default.callout or {}) do
                if type(cfg) == "table" and type(cfg.rendered) == "string" then
                    opts.callout[name] = { rendered = cfg.rendered:gsub("^%S+%s+", "") }
                end
            end
        end

        require("render-markdown").setup(opts)

        -- Colori heading in palette Nord Aurora: stesso colore per icona e testo, per livello.
        -- RenderMarkdownHN colora l'icona; @markup.heading.N.markdown colora il testo (treesitter).
        local aurora = { "#BF616A", "#D08770", "#EBCB8B", "#A3BE8C", "#88C0D0", "#81A1C1" }

        local function apply_nord_headings()
            for i, fg in ipairs(aurora) do
                vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, { fg = fg, bold = true })
                vim.api.nvim_set_hl(0, "@markup.heading." .. i .. ".markdown", { fg = fg, bold = true })
            end
            vim.api.nvim_set_hl(0, "RenderMarkdownCodeLanguageOrange", {
                fg = "#D08770",
                bold = false,
            })

            vim.api.nvim_set_hl(0, "RenderMarkdownCodeCustom", {
                bg = "#3A4150",
            })

            vim.api.nvim_set_hl(0, "RenderMarkdownCodeBorderCustom", {
                -- fg = "#88C0D0",
                bg = "#88C0D0",
            })

            vim.api.nvim_set_hl(0, "@markup.strong", {
                bold = true,
            })

            vim.api.nvim_set_hl(0, "@markup.strong.markdown_inline", {
                bold = true,
            })

            vim.api.nvim_set_hl(0, "@markup.strong.markdown", {
                bold = true,
            })
        end

        apply_nord_headings()
        -- il tema su :colorscheme ridefinisce i gruppi: riapplichiamo i colori Nord
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("RenderMarkdownNordHeadings", { clear = true }),
            callback = apply_nord_headings,
        })


        local image_was_enabled_before_telescope = false

        local function telescope_is_open()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
                if ok and vim.api.nvim_buf_is_valid(buf) then
                    local ft = vim.bo[buf].filetype

                    if ft == "TelescopePrompt"
                        or ft == "TelescopeResults"
                        or ft == "TelescopePreview"
                    then
                        return true
                    end
                end
            end

            return false
        end

        local function disable_images_for_telescope()
            local ok, image = pcall(require, "image")
            if not ok then
                return
            end

            if image.is_enabled() then
                image_was_enabled_before_telescope = true
                image.disable()
            end
        end

        local function restore_images_after_telescope()
            vim.defer_fn(function()
                if telescope_is_open() then
                    return
                end

                if not image_was_enabled_before_telescope then
                    return
                end

                local ok, image = pcall(require, "image")
                if not ok then
                    return
                end

                image.enable()
                image_was_enabled_before_telescope = false
            end, 120)
        end

        vim.api.nvim_create_autocmd("User", {
            pattern = "TelescopeFindPre",
            callback = disable_images_for_telescope,
        })

        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "TelescopePrompt",
                "TelescopeResults",
                "TelescopePreview",
            },
            callback = disable_images_for_telescope,
        })

        vim.api.nvim_create_autocmd({
            "BufWinLeave",
            "WinClosed",
            "BufLeave",
        }, {
            callback = restore_images_after_telescope,
        })
    end,
}

return M
