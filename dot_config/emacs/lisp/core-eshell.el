;;; packages-eshell.el --- Configure the emacs shell

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: December 4th, 2025

;;; Commentary:
;; Configure the eshell mode behaviour. Add helper functions for both emacs and the eshell mode.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;;; History settings

;; make sure the history vars are defined
(customize-set-variable 'eshell-history-size 1024)
(if (boundp 'eshell-save-history-on-exit)
    (customize-set-variable 'eshell-save-history-on-exit t))
(if (boundp 'ehsell-ask-to-save-history)
    (customize-set-variable 'eshell-ask-to-save-history 'always))

;;; Eshell helper functions

;; Open an eshell buffer at the current buffers directory.
(defun mrb/eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier.
If the eshell window is already showing, it will be closed instead."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (name (car (last (split-string parent "/" t))))
         (eshell-buf-name (concat "*eshell: " name "*"))
         (existing-window (get-buffer-window eshell-buf-name))
         (existing-buffer (get-buffer eshell-buf-name)))
    (if existing-window
        (delete-window existing-window)
      (let ((height (/ (window-total-height) 3)))
        (split-window-vertically (- height))
        (other-window 1)
        (if existing-buffer
            (switch-to-buffer existing-buffer)
          (eshell "new")
          (rename-buffer eshell-buf-name))))))

;; Bind key to open eshell here function
(global-set-key (kbd "C-`") 'mrb/eshell-here)

;;; Eshell commands

;; A command to exit the eshell buffer and delete the window
(defun eshell/x ()
  (insert "exit")
  (eshell-send-input)
  (delete-window))

;;; Load any additional eshell configuration
(require 'core-eshell-prompt)

(provide 'core-eshell)
