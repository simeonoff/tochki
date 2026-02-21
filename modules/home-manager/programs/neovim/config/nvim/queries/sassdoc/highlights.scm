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
(description) @comment
(line_description) @comment

; Example language identifier
(example_language) @label

; Code blocks
(code_block) @string

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
(link_caption) @comment

; Custom names
(custom_name) @string

; Default values
(default_value) @string.special
