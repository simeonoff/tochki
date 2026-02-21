; extends
; Inject sassdoc into /// documentation comments
; Match single line comments that start with ///
; Use injection.combined to merge consecutive /// comments into one sassdoc parse
((single_line_comment) @injection.content
  (#match? @injection.content "^///")
  (#set! injection.language "sassdoc"))
