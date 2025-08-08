	vim.filetype.add({
	  extension = {
	    geojson = "json",
	    hjson = "json",
	    vb = "vb",
	    vba = "vb",
        cmd = "dosbatch",
        nim = "nim",
        sh = "bash"
	  },
	  pattern = {
	    [".*/zsh/functions/.*"] = "zsh",
	    [".*/%.config/zsh/functions/.*"] = "zsh",
	  },
	  -- filename = {
	  --   [".foorc"] = "foorc",
	  -- },
	  -- pattern = {
	  --   [".*/etc/foo/.*%.conf"] = "foorc",
	  -- },
	})
