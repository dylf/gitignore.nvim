local M = {}

---@class Source
---@field get_template_list fun(): table
---@field get_template_content fun(name: string): string

---@class Config
---@field sources Source[]
local config = {
	sources = {
		{
			get_template_list = function()
				local res = vim.fn.system("curl -s https://www.toptal.com/developers/gitignore/api/list")
				res = res.format("%s", res)
				res = res:gsub("\n", ",")
				return vim.split(res, ",")
			end,
			get_template_content = function(name)
				local res = vim.fn.system("curl -s https://www.toptal.com/developers/gitignore/api/" .. name)
				return res
			end,
		},
	},
}

M.config = config

---@param args Config?
M.setup = function(args)
	M.config = vim.tbl_deep_extend("force", M.config, args or {})
	local templates = {}
	for _, v in ipairs(M.config.sources) do
		templates = vim.tbl_extend("force", templates, v.get_template_list())
	end
	vim.api.nvim_create_user_command("GitIgnore", function(cmd)
		-- @TODO: Ask if the user wants to overwrite the file
		local file = io.open(".gitignore", "w")

		if file then
			-- @TODO: Add a way to specify the template source
			file:write(M.config.sources[1].get_template_content(cmd.args))
			file:close()

			print(".gitignore created!")
		else
			print("Error opening the file.")
		end
	end, {
		nargs = 1,
		complete = function(arg, _)
			local res = {}
			for _, v in ipairs(templates) do
				if vim.startswith(v, arg) then
					table.insert(res, v)
				end
			end
			return res
		end,
	})
end

return M
