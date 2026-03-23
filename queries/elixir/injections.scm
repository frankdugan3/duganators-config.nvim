;; extends
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "JS")
  (#set! injection.language "javascript"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "TS")
  (#set! injection.language "typescript"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "CSS")
  (#set! injection.language "css"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "SVG")
  (#set! injection.language "svg"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "HTML")
  (#set! injection.language "html"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "SQL")
  (#set! injection.language "sql"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @injection.content
  (#any-of? @_sigil_name "TYPST")
  (#set! injection.language "typst"))
