{ pkgs, pkgs-unstable, config, ... }:

{
  # --- Modern Unix Tools ---
  home.packages = with pkgs; [
    ripgrep     # Schnelleres Grep
    fd          # Schnelleres Find
    jq          # JSON Processor
    tldr        # Vereinfachte Man-Pages
  ];

  # --- Yazi (File Manager) ---
  programs.yazi = {
    enable = true;
    # Wir nutzen die Unstable-Version für neueste Features
    package = pkgs-unstable.yazi;
    enableZshIntegration = true;
    
    settings = {
      manager = {
        show_hidden = true;
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
      };
    };
  };

  # --- Zsh (Die Shell) ---
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "eza -l -g --icons";
      la = "eza -la --icons";
      ls = "eza";
      cat = "bat";
      cd = "z"; # Zoxide statt cd
      
      # Git Aliases
      g = "git";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gs = "git status";
      
      # NixOS Helpers
      rebuild = "sudo nixos-rebuild switch --flake ~/kami-nix#shikigami";
      update = "nix flake update ~/kami-nix";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  # --- Starship (Prompt) ---
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # Stylix übernimmt hier automatisch das Coloring!
    settings = {
      # Wir können hier spezielle Icons setzen, wenn gewünscht
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
    };
  };

  # --- Git ---
  programs.git = {
    enable = true;
    userName = "haku";
    userEmail = "rootlogic7@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # --- Zoxide (Smarter 'cd' Befehl) ---
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # --- Eza (ls Replacement) ---
  programs.eza = {
    enable = true;
    git = true;
    icons = "auto";
  };

  # --- FZF (Fuzzy Finder) ---
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  
  # --- Bat (cat Replacement) ---
  programs.bat = {
    enable = true;
  };
}
