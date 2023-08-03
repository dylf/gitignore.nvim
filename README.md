# gitignore.nvim

A neovim plugin for generating .gitignore files.

## Installation

### Lazy

```lua
return {
    "dylf/gitignore.nvim",
    opts = {},
}
```

## Options

By default this plugin will fetch the gitignore templates from toptal.com.
If you would like to use a different source, you can configure a different
source.

(Note: This plugin currently only supports one source)

```lua
require("gitignore").setup({
	sources = {
		{
            -- return a list of template names
			get_template_list = function()
				local res = vim.fn.system("curl -s https://www.toptal.com/developers/gitignore/api/list")
				res = res.format("%s", res)
				res = res:gsub("\n", ",")
				return vim.split(res, ",")
			end,
            -- retrieve the template content to be written to .gitignore
			get_template_content = function(name)
				local res = vim.fn.system("curl -s https://www.toptal.com/developers/gitignore/api/" .. name)
				return res
			end,
		},
	},
}
```
