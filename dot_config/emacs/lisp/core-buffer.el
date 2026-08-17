;;; core-buffer.el --- Configure Emacs buffer options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs buffer options
;; C source, bookmark.el, cus-edit.el, simple.el, uniquify.el


;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(setq custom-buffer-done-kill t)

;; Disable auto-adding a new line at the bottom when scrolling.
(setq next-line-add-newlines nil)

;; This setting forces Emacs to save bookmarks immediately after each change.
;; Benefit: you never lose bookmarks if Emacs crashes.
(setq bookmark-save-flag 1)

(setq uniquify-buffer-name-style 'forward)

;; Disable fontification during user input to reduce lag in large buffers.
;; Also helps marginally with scrolling performance.
(setq redisplay-skip-fontification-on-input t)

(provide 'core-buffer)
;;; core-buffer.el ends here.
