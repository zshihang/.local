local utils = require("utils")
local function glug(name, spec)
	return vim.tbl_deep_extend("force", {
		name = name,
		dir = "/usr/share/vim/google/" .. name,
		dependencies = { "maktaba" },
	}, spec or {})
end

local function agent()
	return require("cider-agent")
end

local function input(prompt, on_confirm)
	vim.ui.input({ prompt = string.format("%s: %s\n", prompt, agent().refs()) }, on_confirm)
end

local disabled_highlight_ft = { "build", "bzl", "borg", "blazerc", "sky", "proto" }
if utils.citc then
	vim.lsp.config["ciderlsp"] = {
		cmd = {
			"/google/bin/releases/cider/ciderlsp/ciderlsp",
			"--tooltag=nvim-lsp",
			"--noforward_sync_responses",
		},
		filetypes = {
			"borg",
			"build",
			"bzl",
			"c",
			"cpp",
			"dart",
			"gcl",
			"go",
			"googlesql",
			"java",
			"java",
			"mlir",
			"ncl",
			"piccolo",
			"proto",
			"python",
			"textpb",
			"textproto",
			"yaml",
		},
		offset_encoding = "utf-8",
		root_markers = { ".citc" },
		settings = {},
		on_attach = function(client, bufnr)
			if vim.tbl_contains(disabled_highlight_ft, vim.bo[bufnr].filetype) then
				client.server_capabilities.documentHighlightProvider = false
			end
		end,
	}
	vim.lsp.enable("ciderlsp")
end

local plugins = {}

-- ==============================================================================
-- GLINUX BASELINE OVERRIDES (Applied on any Google workstation)
-- ==============================================================================
table.insert(plugins, {
	"stevearc/conform.nvim",
	init = function()
		-- Force override conform settings after lazy finishes loading
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyDone",
			callback = function()
				local conform = require("conform")
				conform.formatters_by_ft = conform.formatters_by_ft or {}
				conform.formatters_by_ft["c"] = nil
				conform.formatters_by_ft["cpp"] = nil
				conform.formatters_by_ft["go"] = nil
				
				-- Only use google3format if we are actively in a google3 repo
				if utils.google3 then
					conform.formatters_by_ft["c"] = { "google3format" }
					conform.formatters_by_ft["cpp"] = { "google3format" }
					conform.formatters_by_ft["*"] = { "google3format" }
					
					conform.formatters = conform.formatters or {}
					conform.formatters["google3format"] = {
						command = "google3format",
						args = function(_, ctx)
							return { "--depot_path", "//depot/" .. ctx.filename }
						end,
						range_args = function(_, ctx)
							return { ctx.range.start[1] .. ctx.range["end"][1] }
						end,
					}
				end
				
				-- goimports works everywhere on gLinux
				conform.formatters_by_ft["go"] = { "goimports" }
				conform.formatters = conform.formatters or {}
				conform.formatters["goimports"] = {
					command = "/usr/bin/goimports",
				}
				
				-- Ensure mason-conform ignores these if it somehow loads later
				pcall(function()
					require("mason-conform").setup({
						ignore_install = { "clang-format", "goimports", "gofumpt", "golines" }
					})
				end)
			end,
		})
	end,
})

-- ==============================================================================
-- GOOGLE3 SPECIFIC PLUGINS (Only loaded inside google3/citc)
-- ==============================================================================
if utils.google3 then
	table.insert(plugins, {
		dir = "/usr/share/vim/google/maktaba",
		lazy = true,
		dependencies = {},
		config = function()
			vim.cmd("source /usr/share/vim/google/glug/bootstrap.vim")
		end,
	})
	table.insert(plugins, glug("blazedeps", { event = "BufWritePost", cmd = "BlazeDepsUpdate" }))
	table.insert(plugins, glug("google-filetypes", { event = utils.LazyFile }))
	table.insert(plugins, glug("googlespell", { event = utils.LazyFile }))
	
	table.insert(plugins, {
		"Saghen/blink.cmp",
		dependencies = { url = "sso://user/zshihang/blink-ciderlsp" },
		opts = {
			sources = {
				-- list is not merged in neovim.
				default = {
					"buffer",
					"lsp",
					"path",
					"snippets",
					"ciderlsp",
				},
				providers = {
					ciderlsp = {
						name = "ciderlsp",
						module = "blink-ciderlsp",
						score_offset = 200,
						async = true,
						opts = {
							show_model = true,
						},
					},
				},
			},
		},
	})
	
	table.insert(plugins, {
		url = "sso://user/idk/cider-agent.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>cc",
				mode = { "n", "v" },
				function()
					input("Cider Chat", agent().chat)
				end,
				desc = "[C]ider [C]hat",
			},
			{
				"<leader>ce",
				mode = { "n", "v" },
				function()
					input("Cider Edit", agent().simple_coding)
				end,
				desc = "[C]ider [E]dit",
			},
			{
				"<leader>cx",
				mode = { "n", "v" },
				function()
					input("Cider Complex", agent().complex_task)
				end,
				desc = "[C]ider Comple[X]",
			},
		},
		opts = {
			ui = {
				number = false,
			},
		},
	})
	
	table.insert(plugins, {
		dir = "/usr/local/google/home/zshihang/workspace/snacks-sources",
		lazy = false,
		dependencies = { "folke/snacks.nvim" },
		keys = {
			{
				"<leader>cs",
				function()
					require("snacks").picker.codesearch({})
				end,
				desc = "Code Search (Snacks)",
			},
		},
		opts = {},
	})
	
	table.insert(plugins, {
		"yairhochner/google-snacks.nvim",
		url = "sso://user/yairhochner/google-snacks.nvim",
		lazy = false,
		dependencies = { "folke/snacks.nvim" },
		config = {}, -- add your config and customize here !
		keys = {
			{
				"<leader>hw",
				function()
					require("google-snacks").citc.workspaces()
				end,
				desc = "Fig Workspaces",
			},
			{
				"<leader>cw",
				function()
					require("google-snacks").citc.create()
				end,
				desc = "Create Workspace",
			},
			{
				"<leader>hx",
				function()
					require("google-snacks").fig.xl()
				end,
				desc = "Fig XL",
			},
			{
				"<leader>hm",
				function()
					require("google-snacks").fig.pstatus()
				end,
				desc = "Hg Parent Diff",
			},
			{
				"<leader>hs",
				function()
					require("google-snacks").fig.status()
				end,
				desc = "Fig Diff",
			},
			{
				"<leader>hr",
				function()
					require("google-snacks").fig.revstatus()
				end,
				desc = "Fig Rev Status",
			},
			{
				"<leader>fg",
				function()
					require("google-snacks").fig.grep()
				end,
				desc = "Fig Grep",
			},
			{
				"<leader>co",
				function()
					require("google-snacks").fig.commit()
				end,
				desc = "Commit",
			},
			-- IMPORTANT : for the related_files picker to work, relatedfiles (vim plugin) is needed.
			{
				"<leader>rl",
				function()
					require("google-snacks").nav.related_files()
				end,
				desc = "Related Files",
			},
			{
				"<leader>cl",
				function()
					require("google-snacks").comments.list()
				end,
				desc = "Comments",
			},
			{
				"<leader>clu",
				function()
					require("google-snacks").comments.list({ resolved = false })
				end,
				desc = "Comments (unresolved)",
			},
			-- Blaze keys
			{
				"<leader>b",
				function()
					require("google-snacks").blaze.build()
				end,
				desc = "blaze build",
			},
			{
				"<leader>ba",
				function()
					require("google-snacks").blaze.build({ on_pkg = true })
				end,
				desc = "blaze build current package",
			},
			{
				"<leader>bu",
				function()
					require("google-snacks").blaze.build({ under_cursor = true })
				end,
				desc = "blaze build under cursor",
			},
			{
				"<leader>ib",
				function()
					require("google-snacks").blaze.build({ exec = "iblaze" })
				end,
				desc = "blaze build",
			},
			{
				"<leader>it",
				function()
					require("google-snacks").blaze.test({ exec = "iblaze" })
				end,
				desc = "blaze build",
			},
			{
				"<leader>bt",
				function()
					require("google-snacks").blaze.test()
				end,
				desc = "blaze test",
			},
			{
				"<leader>bta",
				function()
					require("google-snacks").blaze.test({ on_pkg = true })
				end,
				desc = "blaze test current package",
			},
			{
				"<leader>ut",
				function()
					require("google-snacks").blaze.test({ under_cursor = true })
				end,
				desc = "blaze test under cursor",
			},
			{
				"<leader>tl",
				function()
					require("google-snacks").blaze.targets()
				end,
				desc = "blaze targets",
			},
			{
				"<leader>bc",
				function()
					require("google-snacks").blaze.commands()
				end,
				desc = "blaze commands",
			},
			{
				"<leader>bcl",
				function()
					require("google-snacks").blaze.build_cleaner()
				end,
				desc = "build cleaner",
			},
		},
	})
end

return plugins
