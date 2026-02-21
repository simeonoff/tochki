; Entire tags - use @block since tags are the main "blocks" in sassdoc
(tag) @block.outer

; Parameter tags specifically - useful for working with function params
(tag_param) @parameter.outer
(tag_param
  (tag_description
    (line_description) @parameter.inner))

; Property tags - similar structure to params
(tag_property) @parameter.outer
(tag_property
  (tag_description
    (line_description) @parameter.inner))

; Return tags
(tag_return) @return.outer
(tag_return
  (line_description) @return.inner)

; Code blocks in @example - great for editing example code
(tag_example
  (code_block) @block.inner)
(tag_example) @block.outer

; Descriptions - select the description text
(description) @comment.outer
(line_description) @comment.inner
(tag_description) @comment.outer

; URLs in @link tags
(tag_link
  (url) @string.inner)
(tag_link) @string.outer

; Type annotations - select/change types quickly
(type) @type.outer
(type
  (type_name) @type.inner)

; Variable names in params
(variable_name) @variable.outer

; Property names with dot notation
(property_name) @property.outer

; See/require references
(see_reference) @reference.outer
(tag_see) @reference.outer
(tag_require) @reference.outer

