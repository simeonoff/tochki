$env.config = {
    show_banner: false,
    buffer_editor: "nvim",
    edit_mode: "vi",
    keybindings: [
        {
            name: accept-autosuggestion,
            modifier : control,
            keycode: char_y,
            mode: vi_insert,
            event: {
                send: HistoryHintComplete
            }
        }
    ],
    rm: {
        always_trash: true
    },
}

$env.PATH = ($env.PATH | prepend [
    $"($env.HOME)/dotfiles/bin"
    $"($env.HOME)/.npm-global/bin"
    $"/etc/profiles/per-user/($env.USER)/bin"
])

# Rex puts its `rex` CLI first on PATH, but the Nix-managed login PATH drops it
if ($env.REX_BIN_DIR? | is-not-empty) {
    $env.PATH = ($env.PATH | prepend $env.REX_BIN_DIR)
}

# Name a Rex session after the project it's first used in: the git root's
# folder, or the current folder outside a repo. Runs once per session, so
# later cd's and manual renames stick.
def rex-name-session [] {
    if ($env.REX_SESSION? | is-empty) or $env.PWD == $env.HOME { return }

    let marker = ($nu.cache-dir | path join "rex-sessions" ($env.REX_SESSION | str replace --all ":" "_"))
    if ($marker | path exists) { return }

    let git = (^git rev-parse --show-toplevel | complete)
    let name = if $git.exit_code == 0 { $git.stdout | str trim | path basename } else { $env.PWD | path basename }

    if (^rex --timeout 2s session rename $env.REX_SESSION $name | complete).exit_code == 0 {
        mkdir ($marker | path dirname)
        touch $marker
    }
}

$env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt? | default [] | append {|| rex-name-session })

$env.FZF_DEFAULT_OPTS = [
"--pointer=' '"
"--prompt='   '"
"--color=fg:8,bg:-1,hl:2"
"--color=fg+:-1,bg+:-1,hl+:4"
"--color=info:8,prompt:2,pointer:2"
"--color=marker:#87ff00,spinner:#af5fff,header:8"
] | str join " "

alias cp = cp -i
alias mv = mv -i

alias vim = nvim
alias vi = nvim

def ll [] {
  ls -la | where {|x| $x.name != ".DS_Store"} | sort-by type
}

def t [] {
  sesh connect (sesh list | fzf)
}

# cpath
# Copies the expanded path of the first file matching the given type.
#
# Parameters:
#   - type: A string pattern to match against file names.
def cpath [
    type: string # The file type (regex pattern) to search for.
] {
    let files = ls | where name =~ $type

    if not ($files | is-empty) {
        let filepath = ($files | first | get name | path expand)

        $filepath | pbcopy

        { status: "Copied", path: $filepath }
    } else {
        print "No matching file found."
    }
}
