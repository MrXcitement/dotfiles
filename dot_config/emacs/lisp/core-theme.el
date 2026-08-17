;;; core-theme.el --- Configure Emacs theme options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs theme options

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Customizable dark and light theme variables
(defcustom my-theme-dark 'tango-dark
  "The theme to used when the `appearance' is 'dark."
  :type 'symbol
  :group 'my)

(defcustom my-theme-light 'tango
  "The theme to used when the `appearance' is 'light."
  :type 'symbol
  :group 'my)

;; Theme application functions
(defun my-apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme my-theme-light t))
    ('dark  (load-theme my-theme-dark t))))

(defun my-apply-theme-light ()
  "Apply the light theme."
  (interactive)
  (my-apply-theme 'light))

(defun my-apply-theme-dark ()
  "Apply the dark theme."
  (interactive)
  (my-apply-theme 'dark))

(provide 'core-theme)
;;; core-theme.el ends here.
