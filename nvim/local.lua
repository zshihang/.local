local utils = require("utils")
local map = utils.map

local disabled_highlight_ft = { "build", "bzl", "borg", "blazerc", "sky", "proto" }
vim.lsp.config["ciderlsp"] = {
	cmd = { "/google/bin/releases/cider/ciderlsp/ciderlsp", "--tooltag=nvim-lsp", "--noforward_sync_responses" },
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

local conform = require("conform")
conform.formatters = {
	google3format = {
		command = "google3format",
		args = function(_, ctx)
			return { "--depot_path", "//depot/" .. ctx.filename }
		end,
		range_args = function(_, ctx)
			return { ctx.range.start[1] .. ctx.range["end"][1] }
		end,
	},
	goimports = {
		command = "/usr/bin/goimports",
	},
}
conform.formatters_by_ft = {
	["*"] = { "google3format" },
	go = { "goimports" },
}

local blink = require("blink.cmp")
blink.add_source_provider("ciderlsp", {
	name = "ciderlsp",
	module = "blink-ciderlsp",
	score_offset = 200,
	async = true,
})

local agent = require("cider-agent")
agent.setup({ server_name = "ciderlsp" })
