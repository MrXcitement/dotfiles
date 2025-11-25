;;; init-dired.el --- Initialize the `dired' mode

;; Mike Barker <mike@thebarkers.com>
;; November 24th, 2025

;;; Commentary:
;; Any user customizations to the `dired' mode should go here.

;;; History:
;; 2025.11.24
;; - Created.


;;; Code:

;; Highlight the current line when in dired mode.
(add-hook 'dired-mode-hook
	  (lambda() (hl-line-mode 1)))


(provide 'init-dired)
;;; End of init-dired.el
