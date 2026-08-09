;;; packages-eshell.el --- Configure the emacs shell

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: August 9th, 2026

;;; Commentary:
;; Configure the eshell mode behaviour. Add helper functions for both emacs and the eshell mode.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package eshell
  :straight nil
  :bind
  ("C-`" . my-eshell-here)

  :custom
  (eshell-history-size 1024)
  (eshell-save-history-on-exit t)
  (eshell-ask-to-save-history always)

  :config
  ;; Open an eshell buffer at the current buffers directory.
  (defun my-eshell-here ()
    "Opens up a new shell in the current directory.

The eshell is renamed to match that directory to make multiple eshell windows easier.
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

  ;; A command to quit the eshell buffer and delete the window
  (defun eshell/q ()
    (insert "exit")
    (eshell-send-input)
    (delete-window)))

(provide 'core-eshell)
