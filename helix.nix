{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight";
      editor = {
        line-number = "relative";

        lsp = {
          display-messages = true;
          display-inlay-hints = false;
          display-signature-help-docs = false;
          auto-signature-help = false;
        };
      };
      keys = {
        insert = {
          j = {
            k = "normal_mode";
          };
        };
        normal = {
          "K" = "hover";
        };
      };
    };

    languages = {
      language-server = {
        typescript-language-server = {
          command = "typescript-language-server";
          args = [ "--stdio" ];
        };
        vscode-html-language-server = {
          command = "vscode-html-language-server";
          args = [ "--stdio" ];
        };
        vscode-css-language-server = {
          command = "vscode-css-language-server";
          args = [ "--stdio" ];
        };
        vscode-json-language-server = {
          command = "vscode-json-language-server";
          args = [ "--stdio" ];
        };
        svelte-language-server = {
          command = "svelteserver";
          args = [ "--stdio" ];
        };
        gopls = {
          command = "gopls";
        };
        pyright = {
          command = "pyright-langserver";
          args = [ "--stdio" ];
        };
        clangd = {
          command = "clangd";
        };
        nixd = {
          command = "nixd";
        };
        rust-analyzer = {
          command = "rust-analyzer";
        };
      };

      language = [
        {
          name = "html";
          language-servers = [ "vscode-html-language-server" "emmet-ls" ];
        }
        {
          name = "css";
          language-servers = [ "vscode-css-language-server" "emmet-ls" ];
        }
        {
          name = "javascript";
          language-servers = [ "typescript-language-server" "emmet-ls" ];
        }
        {
          name = "typescript";
          language-servers = [ "typescript-language-server" "emmet-ls" ];
        }
        {
          name = "tsx";
          language-servers = [ "typescript-language-server" "emmet-ls" ];
        }
        {
          name = "svelte";
          language-servers = [ "svelte-language-server" "emmet-ls" ];
        }
        {
          name = "go";
          language-servers = [ "gopls" ];
        }
        {
          name = "python";
          language-servers = [ "pyright" ];
        }
        {
          name = "c";
          language-servers = [ "clangd" ];
        }
        {
          name = "cpp";
          language-servers = [ "clangd" ];
          roots = [ ".clangd" ];
        }
        {
          name = "json";
          language-servers = [ "vscode-json-language-server" ];
        }
        {
          name = "nix";
          file-types = [ "nix" ];
          language-servers = [ "nixd" ];
        }
      ];
    };

    extraPackages = with pkgs; [
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.svelte-language-server
      emmet-ls

      gopls
      pyright
      clang-tools

      nixd
      rust-analyzer
    ];
  };
}
