;;; core-minibuffer.el --- Configure emacs minibuffer options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs emacs minibuffer settings
;; C source, cursor-sensor.el, icomplete.el, savehist.el, subr.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Allow nested minibuffers
(setq enable-recursive-minibuffers t)

;; Keep the cursor out of the read-only portions of the.minibuffer
(setq minibuffer-prompt-properties
      '(read-only t intangible t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;; Save minibuffer history

;; `savehist-mode' is an Emacs feature that preserves the minibuffer history
;; between sessions.
(setq history-length 300)
(setq savehist-additional-variables
      '(register-alist                   ; macros
        mark-ring global-mark-ring       ; marks
        search-ring regexp-search-ring)) ; searches


;; icomplete

;; Do not delay displaying completion candidates in `fido-mode' or
;; `fido-vertical-mode'
(setq icomplete-compute-delay 0.01)

(provide 'core-minibuffer)
;;; core-minibuffer.el ends here.
