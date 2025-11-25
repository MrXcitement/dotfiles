;;; flyspell-markdownlint-cli2
;; Lint your markdown in Emacs with flymake and markdownlint-cli2
;; https://github.com/ewilderj/flymake-markdownlint-cli2
(when (> emacs-major-version 29)
  (eval
   '(use-package flymake-markdownlint-cli2
      :vc (:url "https://github.com/ewilderj/flymake-markdownlint-cli2"
		:rev :newest
		:branch "main")
      :config
      (add-hook 'markdown-mode-hook 'flymake-mode)
      (add-hook 'markdown-mode-hook 'flymake-markdownlint-cli2-setup))
   ))
