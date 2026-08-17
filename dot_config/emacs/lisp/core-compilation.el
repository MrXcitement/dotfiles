;;; core-compilation.el --- Configure Emacs compilation options

;; Mike Barker <mike@thebarkers.com>
;; Created: August 13th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Configure Emacs compilation options
;; compile.el, files.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(setq compilation-ask-about-save nil
      compilation-always-kill t
      ;; Parse up to 2048 characters per line in compilation buffers. This
      ;; safely catches deep errors and long paths without risking hangs.
      compilation-max-output-line-length 2048
      compilation-scroll-output 'first-error)

;; Skip confirmation prompts when creating a new file or buffer
(setq confirm-nonexistent-file-or-buffer nil)

(provide 'core-compilation)
;;; core-compilation.el ends here.
