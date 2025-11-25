;;; init-customize.el --- Configure the customize file

;; Mike Barker <mike@thebarkers.com>
;; November 23rd, 2025

;;; Commentary:
;; Store the customize settings in a 'custom.el' file in the users emacs directory

;;; History:
;; 2025.11.23
;; - Created

;;; Code:
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

;; When you press 'q' to quit a customize buffer, it will be killed not juts burried
(setq custom-buffer-done-kill t)

(provide 'init-customize)
;;; init-customize.el ends here.
