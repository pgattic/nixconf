{ inputs, ... }: {
  perSystem = { pkgs, ... }: let
    wlib = inputs.nix-wrapper-modules.lib;
  in {
    packages.neovim = wlib.evalPackage ({ config, lib, ... }: {
      inherit pkgs;
      imports = [ wlib.wrapperModules.neovim ];

      extraPackages = [ pkgs.nil ];
      settings.aliases = [ "vi" "vim" "vimdiff" ];

      specs = let cfg_dir = ./config; in {
        general = {
          data = with pkgs.vimPlugins; [
            nvim-web-devicons
            vscode-nvim
            lualine-nvim
            undotree
            gitsigns-nvim
            nvim-lspconfig
            telescope-nvim
            dressing-nvim
            blink-cmp
            todo-comments-nvim
            mini-files
            lazygit-nvim
            indent-blankline-nvim
          ];
          config = builtins.readFile "${cfg_dir}/main.lua";
        };
        harpoon = {
          data = with pkgs.vimPlugins; [ harpoon2 lualine-nvim ];
          config = builtins.readFile "${cfg_dir}/harpoon_config.lua";
        };
        lean = {
          data = pkgs.vimPlugins.lean-nvim;
          config = builtins.readFile "${cfg_dir}/lean_config.lua";
        };
        wiki = {
          data = pkgs.vimPlugins.vimwiki;
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

