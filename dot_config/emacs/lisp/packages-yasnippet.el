;;; packages-yasnippet --- Install and configure the `yasnippet' package.

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
  ;; :hook ((text-mode
  ;; 	  prog-mode
  ;; 	  conf-mode
  ;; 	  snippet-mode) . yas-minor-mode-on)
  :init
  (setq yas-snippet-dir (expand-file-name "snippets" user-emacs-directory))
  :config
  (yas-global-mode-1))


(use-package yasnippet-snippets
  :ensure t)

(provide 'packages-yasnippet)
