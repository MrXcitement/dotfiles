;; init-spelling.el -- initialize the spelling sub system.

;; Mike Barker <mike@thebarkers.com>
;; November 24th, 2025

;;; Commentary:
;; When the spelling program exists, initialize the spelling system.

;;; History:
;; - Created.

;;; Code:

(when (executable-find "hunspell")
  (setq ispell-program-name "hunspell")

  (when (eq system-type 'darwin)
    (setenv "DICTIONARY" "en_US"))

  (when (eq system-type 'windows-nt)
    (setq ispell-local-dictionary-alist
	  '((nil "[[:alpha:]]" "[^[:alpha:]]" "[']" t ("-d" "en_US") nil utf-8)))))

(provide 'init-spelling)
;; init-spelling.el ends here.
