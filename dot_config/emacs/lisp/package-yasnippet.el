;;; package-yasnippet --- Install and configure the `yasnippet' package.

;; Mike Barker <mike@thebarkers.com>

;;; Commentary:
;; Provide a snippet/template engine
;; Also install some default snippets

;;; History:
;; See my github dotfiles repository
;; https://github.com/mrxcitement/dotfiles

;;; Code:
(use-package yasnippet
  :ensure t
  :config (yas-reload-all)
  :custom (setq yas-snippet-dir (expand-file-name "snippets" user-emacs-directory))
  :hook
  ((text-mode
    prog-mode
    conf-mode
    snippet-mode) . yas-minor-mode-on))


(use-package yasnippet-snippets
  :ensure t)

(provide 'package-yasnippet)
