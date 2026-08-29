;;; package-ghostel.el --- Install and configure the package ghostel

;; Mike Barker <mike@thebarkers.com>
;; Created: August 28th, 2026
;; Updated: 

;;; Commentary:
;; Ghostel is a terminal emulator for Emacs powered by libghostty-vt, the VT
;; engine behind the Ghostty terminal.
;; It aims to be featureful, fast, robust and correct.
;; Ghostel's features include synchronized output, true color, the Kitty
;; keyboard and graphics protocols, hyperlinks, desktop notifications, progress
;; reports and a lot more.
;; Shell integration (directory tracking, prompt navigation) all works out of
;; the box for bash, zsh, fish and nushell.
;; https://github.com/dakra/ghostel

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package ghostel
  :bind (("C-x m" . ghostel)
         :map ghostel-semi-char-mode-map
         ("C-s"  . consult-line)
         ("C-k"  . my/ghostel-send-C-k-and-kill)
         ;; I'm used to go up/down the shell history with M-n/p from eshell
         ;; Simulate this behavior in ghostel by sending C-p and C-n
         ("M-p" . (lambda () (interactive) (ghostel-send-key "p" "ctrl")))
         ("M-n" . (lambda () (interactive) (ghostel-send-key "n" "ctrl")))
         :map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :config
  (defun my/ghostel-send-C-k-and-kill ()
    "Send `C-k' to ghostel.
Like normal Emacs `C-k'.  Kill to end of line and put content in kill-ring."
    (interactive)
    (kill-ring-save (point) (line-end-position))
    (ghostel-send-key "k" "ctrl"))

  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t)
  (add-to-list 'project-switch-commands '(ghostel-project-list-buffers "Ghostel buffers") t)
  (add-to-list 'ghostel-eval-cmds '("magit-status-setup-buffer" magit-status-setup-buffer)))

(provide 'package-ghostel)
;; end of package-ghostel.el
