;;; core-buffer.el --- Configure Emacs buffer options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: September 17th, 2026

;;; Commentary:
;; Configure Emacs buffer options
;; C source, simple.el, uniquify.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(use-package emacs
  :ensure nil
  :custom
  ;; Disable auto-adding a new line at the bottom when scrolling.
  (next-line-add-newlines nil)
  ;; Disable fontification during user input to reduce lag in large buffers.
  ;; Also helps marginally with scrolling performance.
  (redisplay-skip-fontification-on-input t)
  ;; Use forward slashes between the folders and name of the file in a buffer.
  ;; This is used when you have multiple buffers with the same named file and
  ;; will create a unique buffer name.
  (uniquify-buffer-name-style 'forward))

(provide 'core-buffer)
;;; core-buffer.el ends here.
