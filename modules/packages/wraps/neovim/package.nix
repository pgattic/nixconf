{ inputs, ... }: {
  perSystem = { pkgs, ... }: let
    wlib = inputs.nix-wrapper-modules.lib;
  in {
    packages.neovim = wlib.evalPackage ({ config, lib, ... }: {
      inherit pkgs;
      imports = [ wlib.wrapperModules.neovim ];

      extraPackages = [
        pkgs.nil # Nix language server
      ];

      settings = {
        config_directory = ./.;
        aliases = [ "vi" "vim" "vimdiff" ];
      };

      specs = with pkgs.vimPlugins; {
        devicons   = nvim-web-devicons;
        vscode     = vscode-nvim;
        lualine    = lualine-nvim;
        undotree   = undotree;
        gitsigns   = gitsigns-nvim;
        lspconfig  = nvim-lspconfig;
        telescope  = telescope-nvim;
        dressing   = dressing-nvim;
        blink      = blink-cmp;
        todo       = todo-comments-nvim;
        mini-files = mini-files;
        lazygit    = lazygit-nvim;
        ibl        = indent-blankline-nvim;
        harpoon    = harpoon2;
        lean       = lean-nvim;
        wiki = {
          data = vimwiki;
          config = ''
            vim.g.vimwiki_path = "~/vimwiki/"
            vim.g.vimwiki_syntax = "markdown"
            vim.g.vimwiki_ext = "md"
            vim.g.vimwiki_global_ext = 0
            vim.treesitter.language.register("markdown", "vimwiki")
            vim.api.nvim_create_autocmd("FileType", {
              pattern = "vimwiki",
              callback = function()
                vim.treesitter.start()
              end,
            })
          '';
        };
      };
      hosts.python3.nvim-host.enable = false;
      hosts.ruby.nvim-host.enable = false;
      hosts.node.nvim-host.enable = false;
    });
  };
}

