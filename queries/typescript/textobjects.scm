

;; Jump between variables
(lexical_declaration (variable_declarator name: (identifier) @variable.outer))

;; Jump between return statements
(return_statement) @return_statement


(function_declaration name: (identifier) @function.outer)
(arrow_function) @function.outer

