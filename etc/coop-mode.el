; Emacs mode for coop, derived from OCaml tuareg-mode. See LICENSE.txt
; for licensing information.
;
; This code could be much improved.
;
; To use the coop-mode, put this file somewhere and add something like the following
; in your .emacs file:
;
;   (autoload 'coop-mode "<coop-mode-install-dir>/etc/coop-mode" "Major mode for editing Coop files" t)
;   (setq auto-mode-alist (cons '("\\.coop$" . coop-mode) auto-mode-alist))

(defvar coop-keywords
  '(
  "and"
  "as"
  "cohandler"
  "else"
  "end"
  "external"
  "finally"
  "fun"
  "if"
  "in"
  "int"
  "let"
  "load"
  "match"
  "of"
  "operation"
  "rec"
  "signal"
  "then"
  "type"
  "use"
  "val"
  "with"
  ))

(defvar coop-constants
  '(
  "false"
  "true"
  ))

(defvar coop-types
  '(
  "any"
  "bool"
  "empty"
  "string"
  "unit"
  ))

(defvar coop-tab-width 2 "Width of tab for Coop mode")

(defvar coop-font-lock-defaults
    `((
      ;; stuff between "
       ("\"\\.\\*\\?" . font-lock-string-face)
      ;; prefix and infix operators, can be improved
       ("+\\|,\\|;" . font-lock-keyword-face)
       ( ,(regexp-opt coop-keywords 'words) . font-lock-keyword-face)
       ( ,(regexp-opt coop-types 'words) . font-lock-type-face)
       ( ,(regexp-opt coop-constants 'words) . font-lock-constant-face)
       )))

(define-derived-mode coop-mode
  tuareg-mode
  "Coop"
  "Major mode for Coop (rudimentary)."

  (setq font-lock-defaults coop-font-lock-defaults)

;  (when coop-tab-width (setq tab-width coop-tab-width))
;
;  (setq comment-start "(*")
;  (setq comment-end "*)")
)

(provide 'coop-mode)
