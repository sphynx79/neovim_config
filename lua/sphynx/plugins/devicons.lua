--[[
===============================================================================================
Plugin: nvim-web-devicons
===============================================================================================
Description: Aggiunge icone colorate per i file in Neovim, supportando vari tipi di file
             e permettendo personalizzazioni avanzate di colori e simboli.
Status: Active
Author: kyazdani42
Repository: https://github.com/kyazdani42/nvim-web-devicons
Notes:
 - Utilizza i colori definiti nel tema corrente tramite `require("sphynx.colors").get_color()`
 - Configura override personalizzati per oltre 70 tipi di file comuni
 - Supporta icone specifiche per file di configurazione popolari (.env, package.json, ecc.)
 - Aggiunge icone speciali per file di test (test.js, spec.ts, ecc.)
 - Include icone per file multimediali (png, jpg, mp3, mp4)
 - Personalizza icone per file di configurazione di strumenti di sviluppo (Docker, Prettier, ecc.)
 - Icone dedicate per file di build e dependency management (yarn.lock, .nvmrc, ecc.)
 - Supporto per linguaggi di programmazione comuni con icone rappresentative (Lua, Python, JS, TS)

Personalizzazioni notevoli:
 - HTML: "" in colore arancione
 - CSS/SCSS/SASS: "" in colore blu/rosa
 - JavaScript: "" in colore giallo
 - TypeScript: "ﯤ" in colore blu
 - Python: "" in colore arancione
 - Lua: "" in colore blu
 - Markdown: "" in colore magenta
 - File di configurazione Git: "" in colore arancione
 - File Docker: "" in colore blu
 - Package.json: "" in colore rosso

Configurazione:
 - Le icone sono usate in vari componenti UI come NvimTree, Telescope, bufferline, ecc.
 - L'opzione `default = true` permette l'uso delle icone predefinite per file non esplicitamente definiti

TODO:
 - [ ] Aggiungere icone per altri linguaggi di programmazione (Rust, Go, ecc.)
 - [ ] Personalizzare icone per file di configurazione CI/CD (GitHub Actions, GitLab CI)
 - [ ] Valutare l'uso di font più moderni per alcune icone
 - [ ] Aggiungere override per formati di documentazione (pdf, docx, ecc.)
===============================================================================================
--]]

local M = {}

M.plugins = {
    ["nvim-web-devicons"] = {
        "kyazdani42/nvim-web-devicons",
    },
}

M.configs = {
    ["nvim-web-devicons"] = function()
        local colors = require("sphynx.colors").get_color()

        require("nvim-web-devicons").setup {
            override = {
                html = {
                    icon = "",
                    color = colors.orange,
                    name = "html",
                },
                css = {
                    icon = "",
                    color = colors.blue,
                    name = "css",
                },
                scss = {
                    icon = "",
                    color = colors.pink,
                    name = "scss",
                },
                sass = {
                    icon = "",
                    color = colors.pink,
                    name = "sass",
                },
                js = {
                    icon = "",
                    color = colors.yellow,
                    name = "js",
                },
                ts = {
                    icon = "ﯤ",
                    color = colors.blue,
                    name = "ts",
                },
                kt = {
                    icon = "󱈙",
                    color = colors.orange,
                    name = "kt",
                },
                png = {
                    icon = "󰸭",
                    color = colors.magenta,
                    name = "png",
                },
                jpg = {
                    icon = "󰈥",
                    color = colors.cyan,
                    name = "jpg",
                },
                jpeg = {
                    icon = "󰈥",
                    color = colors.cyan,
                    name = "jpeg",
                },
                mp3 = {
                    icon = "",
                    color = colors.green,
                    name = "mp3",
                },
                mp4 = {
                    icon = "",
                    color = colors.green,
                    name = "mp4",
                },
                out = {
                    icon = "",
                    color = colors.blue,
                    name = "out",
                },
                rb = {
                    icon = "",
                    color = colors.red,
                    name = "rb",
                },
                vue = {
                    icon = "",
                    color = colors.green,
                    name = "vue",
                },
                py = {
                    icon = "",
                    color = colors.orange,
                    name = "py",
                },
                toml = {
                    icon = "",
                    color = colors.blue,
                    name = "toml",
                },
                lock = {
                    icon = "󰌾",
                    color = colors.red,
                    name = "lock",
                },
                zip = {
                    icon = "",
                    color = colors.cyan,
                    name = "zip",
                },
                xz = {
                    icon = "",
                    color = colors.cyan,
                    name = "xz",
                },
                deb = {
                    icon = "",
                    color = colors.red,
                    name = "deb",
                },
                rpm = {
                    icon = "",
                    color = colors.red,
                    name = "rpm",
                },
                lua = {
                    icon = "",
                    color = colors.blue,
                    name = "lua",
                },
                nim = {
                    icon = '',
                    color = "orange",
                    name = "Nim",
                },
                txt = {
                    icon = "󰈙",
                    color = colors.blue,
                    name = "txt",
                },
                md = {
                    icon = "",
                    color = colors.magenta,
                    name = "markdown",
                },
                graphql = {
                    icon = "",
                    color = colors.pink,
                    name = "graphql",
                },
                env = {
                    icon = "",
                    color = colors.yellow,
                    name = "dotenvexample",
                },
                [".env.production"] = {
                    icon = "",
                    color = colors.yellow,
                    name = "envprod",
                },
                [".env.development"] = {
                    icon = "",
                    color = colors.yellow,
                    name = "envdev",
                },
                [".env.testing"] = {
                    icon = "",
                    color = colors.yellow,
                    name = "envtest",
                },
                [".env.example"] = {
                    icon = "",
                    color = colors.yellow,
                    name = "dotenvexample",
                },
                [".env"] = {
                    icon = "",
                    color = colors.yellow,
                    name = "dotenv",
                },
                ["docker-compose.yml"] = {
                    icon = "",
                    color = colors.cyan,
                    name = "dockercompose",
                },
                [".dockerignore"] = {
                    icon = "",
                    color = colors.orange,
                    name = "dockerignore",
                },
                [".prettierignore"] = {
                    icon = "󰏣",
                    color = colors.orange,
                    name = "prettierignore",
                },
                [".prettierrc"] = {
                    icon = "󰏣",
                    color = colors.cyan,
                    name = "prettier",
                },
                [".prettierrc.json"] = {
                    icon = "󰏣",
                    color = colors.cyan,
                    name = "prettierjson",
                },
                [".prettierrc.js"] = {
                    icon = "󰏣",
                    color = colors.cyan,
                    name = "prettierrcjs",
                },
                ["prettier.config.js"] = {
                    icon = "󰏣",
                    color = colors.cyan,
                    name = "prettierjsconfig",
                },
                [".prettier.yaml"] = {
                    icon = "󰏣",
                    color = colors.cyan,
                    name = "prettieryaml",
                },
                ["test.js"] = {
                    icon = "",
                    color = colors.yellow,
                    name = "javascripttest",
                },
                ["test.jsx"] = {
                    icon = "",
                    color = colors.yellow,
                    name = "reactrest",
                },
                ["test.ts"] = {
                    icon = "",
                    color = colors.blue,
                    name = "typescripttest",
                },
                ["test.tsx"] = {
                    icon = "",
                    color = colors.blue,
                    name = "reacttypescripttest",
                },
                ["spec.js"] = {
                    icon = "",
                    color = colors.yellow,
                    name = "javascriptspectest",
                },
                ["spec.jsx"] = {
                    icon = "",
                    color = colors.yellow,
                    name = "reactspectest",
                },
                ["spec.ts"] = {
                    icon = "",
                    color = colors.blue,
                    name = "typescriptspectest",
                },
                ["spec.tsx"] = {
                    icon = "",
                    color = colors.blue,
                    name = "reacttypescriptspectest",
                },
                ["yarn-error.log"] = {
                    icon = "󰄛",
                    color = colors.red,
                    name = "yarnerrorlog",
                },
                ["yarn.lock"] = {
                    icon = "󰄛",
                    color = colors.blue,
                    name = "yarnlock",
                },
                ["package.json"] = {
                    icon = "",
                    color = colors.red,
                    name = "npm_packagejson",
                },
                [".gitignore"] = {
                    icon = "",
                    color = colors.orange,
                    name = "gitignore",
                },
                [".gitattributes"] = {
                    icon = "",
                    color = colors.orange,
                    name = "gitattributes",
                },
                ["Dockerfile"] = {
                    icon = "",
                    color = colors.blue,
                    name = "dockerfilex",
                },
                [".nvmrc"] = {
                    icon = "",
                    color = colors.green,
                    name = "nvmrc",
                },
                [".eslintrc.js"] = {
                    icon = "ﯶ",
                    color = colors.magenta,
                    name = "eslintrcjs",
                },
                [".travis.yml"] = {
                    icon = "",
                    color = colors.red,
                    name = "travis",
                },
                ["babel.config.js"] = {
                    icon = "󰂡",
                    color = colors.yellow,
                    name = "babelconfig",
                },
                [".commitlintrc.json"] = {
                    icon = "󰜜",
                    color = colors.green,
                    name = "commitlinrcjson",
                },
            },
            default = true,
        }
    end,
}

return M
