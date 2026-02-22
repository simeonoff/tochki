; Inject language into @example code blocks based on example_language
; The language name (scss, css, html, javascript, etc.) is used directly
; Using injection.combined to merge code_lines into one parse
; #offset! adjusts the capture to skip the leading space in example_language
((tag_example
  (example_language) @injection.language
  (code_block
    (code_line) @injection.content))
  (#offset! @injection.language 0 1 0 0)
  (#set! injection.combined))
