# Interactive development machines (ringo, kori): AI tooling, secrets,
# Bitwarden SSH agent, heavy editor tooling and language runtimes.
{ config, lib, pkgs, pkgs-dotnet, ... }:
let
  neovimTools = import ../../../packages/neovim-tools { inherit pkgs; };
in
{
  imports = [
    ../programs/claude-code
    ../programs/ghostty
    ../programs/opencode
    ../programs/pi-harness
    ../programs/tinty
  ];

  sops = {
    defaultSopsFile = ../../../secrets/home.yaml;
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets.github_pat = { };
    secrets.context7_api_key = { };
    secrets.openrouter_api_key = { };
    secrets.fireworks_api_key = { };
    secrets.codestral_api_key = { };
  };

  # Bitwarden desktop acts as the SSH agent on workstations.
  programs.ssh.settings."*".IdentityAgent = "~/.bitwarden-ssh-agent.sock";

  programs.nushell = {
    environmentVariables = {
      PI_CACHE_RETENTION = "long";
      PI_SUBAGENT_RUNTIME_ROOT = "${config.home.homeDirectory}/.npm-global/lib/node_modules/pi-subagents";
      SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
    };
    extraEnv = ''
      $env.GITHUB_PAT = (open "${config.sops.secrets.github_pat.path}" | str trim)
      $env.CONTEXT7_API_KEY = (open "${config.sops.secrets.context7_api_key.path}" | str trim)
      $env.OPENROUTER_API_KEY = (open "${config.sops.secrets.openrouter_api_key.path}" | str trim)
      $env.FIREWORKS_API_KEY = (open "${config.sops.secrets.fireworks_api_key.path}" | str trim)
      $env.CODESTRAL_API_KEY = (open "${config.sops.secrets.codestral_api_key.path}" | str trim)
    '';
  };

  home.sessionVariables = {
    # suppress debug noise from codebase-memory-mcp; override per-session with CBM_LOG_LEVEL=debug
    CBM_LOG_LEVEL = "warn";
  };

  # Global codebase-memory-mcp configuration
  # Docs: https://github.com/DeusData/codebase-memory-mcp
  xdg.configFile."codebase-memory-mcp/config.json".text = builtins.toJSON {
    # Map extra file extensions to languages not auto-detected
    extra_extensions = { };
    # Automatically watch indexed projects for changes
    auto_watch = true;
  };

  home.packages = with pkgs; [
    codebase-memory-mcp
    dart-sass
    docfx
    go
    pi-mono
    python313
    python313Packages.west
    tinty
    wezterm
    pkgs-dotnet.dotnet-sdk_9
  ] ++ neovimTools.extra;
}
