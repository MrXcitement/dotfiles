;;; packages.el --- Packages I am using

;; Mike Barker <mike@thebarkers.com>
;; November 14th, 2025

;;; Commentary:
;; 3rd-party packages that I am or have been using. I am using the `use-package' package to manage the packages used by me Emacs configuration.
;; This file is required in the init.el file, if you comment out the require, no 3rd-party packages will be loaded.

;;; History

;;; Code:

;;; ac-html
;; A mode to edit html files.
(use-package ac-html
  :disabled
  :functions my-ac-html-hook
  :init
  (add-hook 'html-mode-hook 'my-ac-html-hook)
  :config
  (progn
    ;; my ac-html auto completion
    (defun my-ac-html-hook()
      ;; Require ac-html since we are setup html auto completion
      (require 'ac-html)
      ;; Require default data provider if you want to use
      (require 'ac-html-default-data-provider)
      ;; Enable data providers,
      ;; currently only default data provider available
      (ac-html-enable-data-provider 'ac-html-default-data-provider)
      ;; Let ac-haml do some setup
      (ac-html-setup)
      ;; Set your ac-source
      (setq ac-sources '(ac-source-html-tag
			 ac-source-html-attr
			 ac-source-html-attrv))
      ;; Enable auto complete mode
      (auto-complete-mode))))

;;; auto-complete
;; This package provides auto complete in a drop down window similar
;; to intelisense in visual studio.
(use-package auto-complete
  :disabled
  :ensure t
  :init
  (progn
    ;; fixup problems with flyspell mode
    (defun my-auto-complete-flyspell-mode-hook()
      (ac-flyspell-workaround))

    ;; set the correct sources for ielm mode
    (defun my-auto-complete-ielm-mode-hook()
      (setq ac-sources '(ac-source-functions
			 ac-source-variables
			 ac-source-features
			 ac-source-symbols
			 ac-source-words-in-same-mode-buffers))
      (add-to-list 'ac-modes 'inferior-emacs-lisp-mode))

    ;; turn off auto-complete menu when in elpy mode
    (defun mrb-auto-complete-elpy-mode-hook()
      (message "elpy-mode uses company-mode, turning off auto-complete menu...")
      (make-local-variable 'ac-auto-start)
      (setq ac-auto-start nil))

    (add-hook 'flyspell-mode 'my-auto-complete-flyspell-hook)
    (add-hook 'ielm-mode-hook 'my-auto-complete-ielm-mode-hook)
    (add-hook 'elpy-mode-hook 'my-auto-complete-elpy-mode-hook))

  :config
  (progn
    ;; set default configuration
    (require 'auto-complete-config)
    (ac-config-default)
    (global-auto-complete-mode t)
    (setq ac-auto-start 2)
    (setq ac-ignore-case nil)))

;;; buffer-move
;; Bind the Ctrl-C and Shift-Arrow Keys to swap the current buffer with
;; the buffer in the window that the arrow key pressed points at.
(use-package buffer-move
  :disabled
  :ensure t
  :bind (("C-c <S-up>" . buf-move-up)
	 ("C-c <S-down>" . buf-move-down)
	 ("C-c <S-left>" . buf-move-left)
	 ("C-c <S-right>" . buf-move-right)))

;;; cc-mode
;; Configure the c major mode
(use-package cc-mode
  :config
  (add-hook 'c-mode-hook
	    (lambda()
	      ;; Use 'extra-line at top/bottom in c-mode only
	      (setq-local comment-style 'extra-line)))
  :custom
  (c-basic-offset 4))

;;; cedet
;; Configure the cedet mode
(use-package cedet
  :disabled
  :config
  (progn
    (require 'cedet)
    ;; Turn on EDE (Project handling mode)
    (global-ede-mode t)
    (semantic-mode 1)))

;;; cider
;; Clojure Interactive Development Environment that Rocks for Emacs,
;; built on top of nREPL, the Clojure networked REPL server.
;; https://github.com/clojure-emacs/cider(when (executable-find "lien")
(when (executable-find "lien")
  (use-package cider))

;;; company:
;; Company is a text and code completion framework for Emacs. The name stands for "complete anything".
;; It uses pluggable back-ends and front-ends to retrieve and display completion candidates.
(use-package company
  :disabled
  :ensure nil
  :demand t 				; make sure this is loaded at startup, not defered.
  :bind (("C-c SPC" . company-complete)	; key to force completion
	 ("C-c /" . company-files))	; key to force file completion

  :config
  (progn
    (global-company-mode)
    (setq company-tooltip-limit 20)                      ; bigger popup window
    (setq company-tooltip-align-annotations 't)          ; align annotations to the right tooltip border
    (setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
    (setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing
    ))

;;; csharp-mode
;; Provide support for editing C Sharp code.
(use-package csharp-mode
  :disabled
  :ensure t
  :mode "\\.cs\\'")

;;; dashboard
;; Provide a 'dasboard' window at start that provides custom information
(use-package dashboard
 :ensure t
 :bind (:map dashboard-mode-map
        ("g" . 'dashboard-refresh-buffer))
 :config
 (setq dashboard-items '((bookmarks . 5)
                         (recents   . 5)
			 (projects  . 5)))
 (dashboard-setup-startup-hook))

;;; elpy
;; Provides a python programming toolset.
(when (or (executable-find "python")
	  (executable-find "python3"))
  (use-package elpy
    :disabled
    :ensure t
    :defer t
    :init
    (advice-add 'python-mode :before 'elpy-enable)))


;;; evil
;; Install and configure evil and associated packages.
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)

  (use-package evil-collection
    :after evil
    :ensure t
    :config
    (evil-collection-init))

  ;; (use-package evil-leader
  ;;   :ensure t
  ;;   :config
  ;;   (global-evil-leader-mode t)
  ;;   (evil-leader/set-leader "<SPC>")
  ;;   (evil-leader/set-key
  ;;     "s s" 'swiper
  ;;     "d x w" 'delete-trailing-whitespace
  ;;     "e" 'counsel-find-file
  ;;     "b" 'switch-to-buffer
  ;;     "k" 'kill-buffer))

  (use-package evil-surround
    :after evil
    :ensure t
    :config (global-evil-surround-mode))

  (use-package evil-indent-textobject
    :after evil
    :ensure t)

  (use-package powerline-evil
    :after evil
    :ensure t
    :config
    (powerline-evil-vim-color-theme)))

;;; exec-path-from-shell
;; When on a Darwin (macOS) system
;; copy important environment variables from the user's shell
;; by asking your shell to print out the variables of interest,
;; then copying them into the Emacs environment.
;; https://github.com/purcell/exec-path-from-shell
(when (eq system-type 'darwin)
  (use-package exec-path-from-shell
    :ensure t
    :config
    (exec-path-from-shell-initialize)))

;;; flyspell-markdownlint-cli2
;; Lint your markdown in Emacs with flymake and markdownlint-cli2
;; https://github.com/ewilderj/flymake-markdownlint-cli2
(use-package flymake-markdownlint-cli2
  :vc (:url "https://github.com/ewilderj/flymake-markdownlint-cli2"
            :rev :newest
            :branch "main")
  :config
  (add-hook 'markdown-mode-hook 'flymake-mode)
  (add-hook 'markdown-mode-hook 'flymake-markdownlint-cli2-setup))

;;; flyspell-popup
;; A mode to show flyspell correction choices in a popup
(use-package flyspell-popup
  :disabled
  :ensure t
  :bind ("C-c $" . flyspell-popup-correct))

;;; git-gutter
;; Provide git status in the gutter of the frame and provide key
;; bindings to operate on the changes.
(use-package git-gutter
  :ensure t
  :config
  (progn
    (global-git-gutter-mode t))

  :bind
  (("C-c C-g" . git-gutter:toggle)
   ("C-c g =" . git-gutter:popup-hunk)
   ("C-c g p" . git-gutter:previous-hunk)
   ("C-c g r" . git-gutter:revert-hunk)
   ("C-c g n" . git-gutter:next-hunk)))

;;; hs-minor-mode
;; Hideshow mode is a buffer-local minor mode that allows you to
;; selectively display portions of a program, which are referred to as
;; blocks. Type M-x hs-minor-mode to toggle this minor mode (see Minor
;; Modes).
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Hideshow.html

;; toggle hiding block on/off
;; will revert to using selective display if it fails
(defun my-toggle-hiding (column)
      (interactive "P")
      (if hs-minor-mode
          (if (condition-case nil
                  (hs-toggle-hiding)
                (error t))
              (hs-show-all))
        (my-toggle-selective-display column)))

;; toggle selective display of to the current column
(defun my-toggle-selective-display (column)
      (interactive "P")
      (set-selective-display
       (or column
           (unless selective-display
             (1+ (current-column))))))

;; rules used to handle hiding nxml sections
(defun my-nxml-forward-sexp-func (pos)
  (my-nxml-forward-element))

(defun my-nxml-forward-element ()
  (let ((nxml-sexp-element-flag)
  	(outline-regexp "\\s *<\\([h][1-6]\\|html\\|body\\|head\\)\\b"))
    (setq nxml-sexp-element-flag (not (looking-at "<!--")))
    (unless (looking-at outline-regexp)
      (condition-case nil
  	  (nxml-forward-balanced-item 1)
  	(error nil)))))

;; initialize and configure the `hideshow.el' system package
(use-package hs-minor-mode
  :bind
  (("C-c =" . my-toggle-hiding)
   ("C-c +" . my-toggle-selective-display))

  :init
  (progn
    ;; hook into the following major modes
    (add-hook 'c-mode-common-hook   'hs-minor-mode)
    (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
    (add-hook 'java-mode-hook       'hs-minor-mode)
    (add-hook 'lisp-mode-hook       'hs-minor-mode)
    (add-hook 'perl-mode-hook       'hs-minor-mode)
    (add-hook 'sh-mode-hook         'hs-minor-mode)
    (add-hook 'nxml-mode-hook       'hs-minor-mode)
    (add-hook 'html-mode-hook       'hs-minor-mode))

  :config
  (progn
    ;; nxml-mode config to hide/show blocks
    (add-to-list 'hs-special-modes-alist
		 '(nxml-mode
		   "<!--\\|<[^/>]>\\|<[^/][^>]*[^/]>"
		   ""
		   "<!--"                        ; won't work on its own; uses syntax table
		   my-nxml-forward-sexp-func
		   nil                           ; my-nxml-hs-adjust-beg-func
		   ))

    ;; html-mode config to hide/show blocks
    (add-to-list 'hs-special-modes-alist
		 '(html-mode
		   "<!--\\|<[^/>]>\\|<[^/][^>]*"
		   "</\\|-->"
		   "<!--"
		   sgml-skip-tag-forward
		   nil))))

;;; icomplete
;; The `icomplete' package implements a more fine-grained minibuffer
;; completion feedback scheme.  Prospective completions are concisely
;; indicated within the minibuffer itself, with each successive
;; keystroke.
(use-package icomplete
  :config
  (progn
    (when (version< emacs-version "28.1")
      (icomplete-mode 1)
      ;; show choices vertically
      (setq icomplete-separator "\n")
      (setq icomplete-hide-common-prefix nil)
      (setq icomplete-in-buffer t)
      (define-key icomplete-minibuffer-map (kbd "<right>") 'icomplete-forward-completions)
      (define-key icomplete-minibuffer-map (kbd "<left>") 'icomplete-backward-completions))
    (unless (version< emacs-version "28.1")
      ;; An enhanced ‘icomplete-mode’ that emulates ‘ido-mode’.  This global
      ;; minor mode makes minibuffer completion behave more like ‘ido-mode’
      ;; than regular ‘icomplete-mode’.
      ;; Only available in Emacs 28.1+
      (fido-vertical-mode 1))))

;;; ido
;; The ido.el package by KimStorm lets you interactively do things
;; with buffers and files. As an example, while searching for a file
;; with C-x C-f, ido can helpfully suggest the files whose paths are
;; closest to your current string, allowing you to find your files
;; more quickly.
;; https://www.emacswiki.org/emacs/InteractivelyDoThings

;; Ido - interactive do - switches between buffers and opens files and
;; directories with a minimum of keystrokes.
(use-package ido
  :if (version< emacs-version "28.1")
  :config
  (progn
    (ido-mode 1)
    ;; show choices vertically
    (setf (nth 2 ido-decorations) "\n")
    ;; show any name that has the chars you typed
    (setq ido-enable-flex-matching t)
    ;; use current pane for newly opened file
    (setq ido-default-file-method 'selected-window)
    ;; use current pane for newly switched buffer
    (setq ido-default-buffer-method 'selected-window)))

;;; iy-go-to-char
;; Provide the ability to go from point to the first occurence of a
;; specified character and then continue to the next and subsequent
;; occurences.
;; https://www.emacswiki.org/emacs/IyGoToChar
(use-package iy-go-to-char
  :disabled
  :ensure t
  :bind
    (("C-c m" . iy-go-to-char)
     ("C-c M" . iy-go-to-char-backward)))

;;; lua-mode
;; Provide support for editing lua code
(use-package lua-mode
  :disabled
  :ensure t
  :mode "\\.lua\\'")

;;; magit
;; Magit is an interface to the version control system Git,
;; implemented as an Emacs package. Magit aspires to be a complete Git
;; porcelain. While we cannot (yet) claim that Magit wraps and
;; improves upon each and every Git command, it is complete enough to
;; allow even experienced Git users to perform almost all of their
;; daily version control tasks directly from within Emacs. While many
;; fine Git clients exist, only Magit and Git itself deserve to be
;; called porcelains.
;; https://www.emacswiki.org/emacs/Magit
(use-package magit
  :ensure t)
  ;; :config
  ;; (progn
    ;; show full screen magit-status
    ;; (defadvice magit-status (around magit-fullscreen activate)
    ;; 	(window-configuration-to-register :magit-fullscreen)
    ;; 	ad-do-it
    ;; 	(delete-other-windows))

    ;; restore windows when quit magit-status
    ;; (defun magit-quit-session ()
    ;; 	"Restore the previous window configuration and kills the magit buffer"
    ;; 	(interactive)
    ;; 	(kill-buffer)
    ;; 	(jump-to-register :magit-fullscreen))

    ;; use q to quit magit session
    ;; (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

    ;; cycle through whitspace handling
    ;; (defun magit-toggle-whitespace ()
    ;; 	(interactive)
    ;; 	(if (member "-w" magit-diff-options)
    ;; 	    (magit-dont-ignore-whitespace)
    ;; 	  (magit-ignore-whitespace)))

    ;; (defun magit-ignore-whitespace ()
    ;; 	(interactive)
    ;; 	(add-to-list 'magit-diff-options "-w")
    ;; 	(magit-refresh))

    ;; (defun magit-dont-ignore-whitespace ()
    ;; 	(interactive)
    ;; 	(setq magit-diff-options (remove "-w" magit-diff-options))
    ;; 	(magit-refresh))

    ;; use W to cycle through whitespace handling when diffing
    ;; (define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)

    ;; do not show data loss warning
  ;; (setq magit-last-seen-setup-instructions "1.4.0"))

;;; malabar-mode
;; Provide support for editing java source and integration with Maven
;; for handling projects.
;; https://github.com/m0smith/malabar-mode
(when (executable-find "mvn")
  (use-package malabar-mode
    :mode "\\.java\\'"
    :config
    (progn
      (setq semantic-default-submodes
	    '(global-semantic-idle-scheduler-mode
	      global-semanticdb-minor-mode
	      global-semantic-idle-summary-mode
	      global-semantic-mru-bookmark-mode))
      (semantic-mode 1)
      (setq malabar-groovy-lib-dir "~/lib/malabar/lib"))))

;;; markdown-mode
;; Edit markdown files
;; https://jblevins.org/projects/markdown-mode/
(use-package markdown-mode
  :ensure t
  :mode "\\.\\(text\\|markdown\\|md\\|mdw\\|mdt\\)$")

;;; neotree
;; A emacs tree plugin like NerdTree for Vim.
;; https://github.com/jaypei/emacs-neotree
(use-package neotree
  :disabled
  :ensure t)

;;; omnisharp
;; Provide support for editing C Sharp code.
;; https://github.com/OmniSharp/omnisharp-emacs
(use-package omnisharp
  :disabled
  :if (and (>= emacs-major-version 24)(>= emacs-minor-version 4))
  :ensure t
  :config
  (progn
    (setq omnisharp-server-executable-path "~/git/OmniSharpServer/OmniSharb/bin/Debug")
    (add-hook 'csharp-mode-hook 'omnisharp-mode)))

;;; powershell
;; Provide an powershell shell buffer when on windows.
;; https://github.com/jschaf/powershell.el
(when (eq system-type 'windows-nt)
  (use-package powershell
    :ensure t
    :config
    (require 'powershell nil t)))

;;; smex
;; Provide a smart M-x enhancement for Emacs using Ido.
(use-package smex
  :disabled
  :ensure t
  :bind
  (("M-x" . smex)
   ("M-X" . smex-major-mode-commands)
   ("C-c M-x" . execute-extended-command))
  :config
  (smex-initialize))

;;; counsel, flx, swiper
;; The package swiper includes ivy-mode. 'Ivy is a generic completion
;; method for Emacs, similar to icomplete-mode. It aims to be more
;; efficient, more simple, and more pleasant to use than the
;; alternatives. It's also highly customizable and very small.'

;; Check if 'ag' is installed
(unless (executable-find "ag")
  (message "%s" "executable: ag not found!, counsel-ag will not work."))

(use-package flx
  :disabled
  :ensure t)

(use-package counsel
  :disabled
  :ensure t)

(use-package swiper
  :disabled
  :ensure t
  :bind
  (("C-s" . swiper)
   ("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("C-c g" . counsel-git)
   ("C-c j" . counsel-git-grep)
   ("C-c k" . counsel-ag)
   ("C-c l" . counsel-locate)
   ("C-c u" . counsel-unicode-char)
   ("C-c M-x" . execute-extended-command))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
	'((t . ivy--regex-fuzzy))))

;;; deeper-blue-theme
(use-package deeper-blue-theme
  :disabled
  :if (not window-system)
  :init
  (load-theme 'deeper-blue))

;;; vs-light-theme
(use-package vs-light-theme
  :if window-system
  :ensure t)

;;; vs-dark-theme
(use-package vs-dark-theme
  :if window-system
  :ensure t)

;;; undo-tree
;; Provides a visulization to the undo buffer
(use-package undo-tree
  :disabled
  :ensure t
  :config
  (progn
    (global-undo-tree-mode)))

;;; unicode-fonts
;; provide emoticon support in emacs. very important indeed.
(use-package unicode-fonts
  :disabled
  :ensure t
  :config
  (require 'unicode-fonts)
  ;; (setq unicode-fonts-block-font-mapping
  ;; 	'(("Emoticons"
  ;; 	   ("Apple Color Emoji" "Symbola" "Quivira")))
  ;; 	unicode-fonts-fontset-names '("fontset-default"))
  ;; Add Apple Emoji support
  (when (member "Apple Color Emoji" (font-family-list))
    (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))
  (unicode-fonts-setup))

;;; vbnet-mode
;; http://www.emacswiki.org/emacs/download/vbnet-mode.el

;; Only download the library if it does not allready exist. Updates will be done manualy
;; (unless (mrb:auto-install-library-exists-p "vbnet-mode.el")
;;   (mrb:auto-install-from-url
;;    "vbnet-mode.el"
;;    "https://raw.githubusercontent.com/MrXcitement/vbnet-mode/master"))

;; (use-package vbnet-mode
;;   :mode "\\.\\(frm\\|bas\\|cls\\|vb\\)$")

;;; web-mode
;; Configure the web mode major mode.
;; web-mode.el is an autonomous emacs major-mode for editing web templates.
;; HTML documents can embed parts (CSS / JavaScript) and blocks (client / server side).
;; http://web-mode.org/
(use-package web-mode
  :disabled
  :ensure t

  ;; :mode
  ;; (("\\.html?\\'" . web-mode)
  ;; ("\\.css\\'" . web-mode)
  ;; ("\\.js\\'" . web-mode))

  :bind
  (("C-c C-v" . browse-url-of-buffer)
   ("C-M-;" . comment-dwim))

  :config
  (progn
    (add-hook 'web-mode-hook
      (lambda ()
	;;; set the indention for markup, code and css
	(let ((indent-offset 2))
	  (setq web-mode-markup-indent-offset indent-offset)
	  (setq web-mode-code-indent-offset indent-offset)
	  (setq web-mode-css-indent-offset indent-offset))
	;;(setq web-mode-enable-current-column-highlight t)
	;;(setq web-mode-enable-current-element-highlight t)

	;;; setup auto completion
       	(add-to-list
	 'web-mode-ac-sources-alist
	 '("css" . (ac-source-css-property
		    ac-source-words-in-buffer)))

	(add-to-list
	 'web-mode-ac-sources-alist
	 ;; attribute-value better to be first
	 '("html" . (ac-source-html-attribute-value
		     ac-source-html-tag
		     ac-source-html-attribute)))

	(auto-complete-mode t)

	;;; setup yas snippet behaviour
	(yas-minor-mode-on)
	(yas-activate-extra-mode 'html-mode)))

    (add-hook 'web-mode-before-auto-complete-hooks
      (lambda ()
    	(let ((web-mode-cur-language
    	       (web-mode-language-at-pos)))
    	  (if (string= web-mode-cur-language "javascript")
    	      (yas-activate-extra-mode 'javascript-mode)
    	    (yas-deactivate-extra-mode 'javascript-mode))
    	  (if (string= web-mode-cur-language "css")
    	      (yas-activate-extra-mode 'css-mode)
    	    (yas-deactivate-extra-mode 'css-mode)))))
    ))

;;; yasnippet
;; Provide a snippet/template engine
(use-package yasnippet
  :ensure)

(provide 'packages)
;;; end of packages.el
