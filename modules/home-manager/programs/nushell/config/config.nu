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
  ls -la | filter {|x| $x.name != ".DS_Store"} | sort-by type
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
