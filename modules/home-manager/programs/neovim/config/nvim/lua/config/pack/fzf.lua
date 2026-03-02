return {
  'junegunn/fzf.vim',
  lazy = false,
  deps = {
    { 'junegunn/fzf', build = ':call fzf#install()' },
  },
}
