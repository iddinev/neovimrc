return {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },

            workspace = {
                ibrary = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },

            telemetry = {
                enable = false,
            },

            hint = {
                enable = true,
            },
        },
    },
}
