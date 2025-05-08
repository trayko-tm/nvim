;; extends
;; textobjects.scm
;; Capture the entire function as “outer”
(function_declaration
  name: (identifier) @function.name
  body: (block)? @function.outer)

(method_declaration
  name: (field_identifier) @function.name
  body: (block)? @function.outer)

