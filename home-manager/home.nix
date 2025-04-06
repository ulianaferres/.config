{ config, pkgs, ... }:

{
  home.username = "uliana";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    lens
    zoxide
    fzf
    wireshark
    libyaml
    ruby
    coreutils-full
    git-quick-stats
    gnumake
    inkscape
    gnumake
    cargo
    wl-clipboard
    qbittorrent
    tree
    zstd
    walk
    rsync
    watch
    tmux
    bmon
    nmap
    ncdu

    pciutils
    tmux
    ipmitool
    teams-for-linux
    gst_all_1.gstreamer
    yarn
    nodejs_23
    screen
    killall
    file
    gh
    gcc
    fastfetch
    algotex
    smartmontools
    btop
    sshfs
    icu
    discord
    vesktop
    google-chrome
    feishin
    spotify
    neofetch
    jetbrains.idea-ultimate
    jetbrains.clion
    obsidian
    zotero
    signal-desktop
    prismlauncher
    git
    git-annex
    #mpv
    ffmpeg
    darktable
    thunderbird
    kotlin
    dafny
    dotnet-sdk
    k9s
    kubectl
    minikube
    zoom-us
    wget
    cabextract
    podman
    ookla-speedtest
    iperf
    iperf2
    python311Packages.pygments

    # Haskell
    ghc
    haskell-language-server
    haskellPackages.stack

    # JVM
    gradle
    scala
    metals
    coursier
    sbt
    scala-cli
    kotlin
  ];

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".tmux.conf".text = ''
      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
    '';
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs = {
    home-manager.enable = true;
    gpg.enable = true;
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
      };
      autosuggestion = {
        enable = true;
      };
      enableCompletion = true;
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      initExtra = ''
        source ~/.p10k.zsh
      '';
    };
    java = {
      enable = true;
      package = pkgs.jdk23;
    };
    vscode = {
      enable = true;
      profiles.default.extensions = with pkgs.vscode-extensions; [
       # dafny-lang
      ];
    };
    nano = {
      enable = true;
      nanorc = ''
        set tabsize 2
        set tabstospaces
      '';
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      extraConfig = ''
      '';
      extraLuaConfig = ''
        vim.cmd("colorscheme nightfly")
        local metals_config = require("metals").bare_config()
        metals_config.settings = {
          showImplicitArguments = true,
          excludedPackages = { "akka.actor.typed.javadsl" }
        }
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "scala", "sbt", "java" },
          callback = function()
            require("metals").initialize_or_attach(metals_config)
          end
        })
      '';
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-metals
        plenary-nvim
        ale
        {
          plugin = deoplete-nvim;
          config = ''
            let g:deoplete#enable_at_startup = 1
            set completeopt=menu,noinsert
          '';
        }
        {
          plugin = deoplete-lsp;
          config = ''
            g:deoplete#lsp#handler_enabled = 1
          '';
        }
        {
          plugin = nerdtree;
          config = ''
            " Start NERDTree and put the cursor back in the other window.
            autocmd VimEnter * NERDTree | wincmd p
            " Open the existing NERDTree on each new tab.
            autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == "" | silent NERDTreeMirror | endif
            " Exit Vim if NERDTree is the only window remaining in the only tab.
            autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
            " Close the tab if NERDTree is the only window remaining in it.
            autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
          '';
        }
        {
          plugin = telescope-nvim;
          config = ''
            nnoremap ff <cmd>Telescope find_files<cr>
            nnoremap fg <cmd>Telescope live_grep<cr>
            nnoremap f:b <cmd>Telescope buffers<cr>
            nnoremap fh <cmd>Telescope help_tags<cr>
          '';
        }
        {
          plugin = vim-tmux-navigator;
        }
        {
          plugin = nightfly;
        }
      ];
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage =
      if pkgs.stdenv.isLinux then
        pkgs.pinentry-all
      else
        pkgs.pinentry_mac;
  };
}
