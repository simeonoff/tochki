; Base: paint entire document as doc comment so /// markers and all
; uncaptured regions get a consistent doc comment color.
; More specific patterns below will override for semantic elements.
(document) @comment.documentation @spell

; Tag keywords
[
  "@param"
  "@parameter"
  "@arg"
  "@argument"
  "@return"
  "@returns"
  "@access"
  "@alias"
  "@author"
  "@content"
  "@deprecated"
  "@group"
  "@ignore"
  "@link"
  "@source"
  "@name"
  "@output"
  "@outputs"
  "@package"
  "@property"
  "@prop"
  "@since"
  "@throw"
  "@throws"
  "@exception"
  "@todo"
  "@type"
  "@see"
  "@example"
  "@require"
  "@requires"
] @keyword

; Access modifiers
(tag_access
  ["public" "private"] @keyword.modifier)

; Reference types
(reference) @type

; Type names
(type_name) @type

; Variable names
(variable_name) @variable

; Version numbers
(version) @number

; Description text
(description) @comment.documentation
(line_description) @comment.documentation

; Example language identifier
(example_language) @label

; Code blocks and lines - use @comment.documentation as fallback,
; injection will override with language-specific highlights
(code_block) @comment.documentation
(code_line) @comment.documentation

; See references
(see_reference) @function

; Group names
(group_name) @module

; Alias names
(alias_name) @function

; Package names
(package_name) @module

; Property names
(property_name) @property

; URLs
(url) @string.special.url

; Link captions
(link_caption) @comment.documentation

; Custom names
(custom_name) @string

; Default values
(default_value) @string.special

; Punctuation
[
  "{"
  "}"
] @punctuation.bracket

"|" @punctuation.delimiter

(tag_description
  "-" @punctuation.delimiter)
