;;; init.el --- My Emacs initialization file

;; Mike Barker <mike@thebarkers.com>
;; October 10, 2007

;;; Commentary:

;;; History

;;; Code:

;;; Emacs version checks
(let ((minver-err 26)   ; Too old, error and exit.
      (minver-warn 27)) ; Might not work, need to manually load the early-init.el
  (cond
   ((< emacs-major-version minver-err)
    (error "Your Emacs v%s is too old -- this config requires v%s or higher"
           emacs-version minver-err))
   ((< emacs-major-version minver-warn)
    (message "Your Emacs v%s is old -- this configuration may not work as expected since Emacs is < v%s."
             emacs-version minver-warn)
    (load-file "early-init.el"))))

;;; Customize

;; Save customizations in a seperate `custome.el' file
(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; When you press 'q' to quit a customize buffer, it will be killed not juts burried
(setq custom-buffer-done-kill t)

;;; Dired

;; Highlight the current line when in dired mode.
(add-hook 'dired-mode-hook
	  (lambda() (hl-line-mode 1)))

;;; Environment

;; Darwin (mac os x) environment setup here...
(when (eq system-type 'darwin)
  ;; Force the current directory to be the users home dir
  (setq default-directory "~/")

  ;; Use the provided elisp version of ls
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))

;; Linux environment here...
(when (eq system-type 'linux))

;; Windows environment here...
(when (eq system-type 'windows-nt))

;;; Eshell
;; Create an eshell prompt that includes git status

;; Git helper functions
(defun my-git-p ()
  "Is git installed and the cwd is a git project."
  (> (length (and (eshell-search-path "git")
		  (locate-dominating-file default-directory ".git"))) 0))

(defun my-git-status-cmd ()
  "Run the git status command in the cwd."
  (split-string (shell-command-to-string
		 "git status --porcelain")))

(defun my-git-branch-cmd ()
  "Run the git branch command in the cwd and return a list of branches."
  (split-string
   (shell-command-to-string "git branch --no-color")
   "\n" 'omit-nulls))

(require 'cl-lib)
(defun my-git-branch-name ()
  "Get the current branch name in the cwd."
  (cl-loop for branch in (my-git-branch-cmd)
           when (string-prefix-p "*" branch)
           return (substring branch 2)
           finally return "no branch"))

;; (defun my-git-branch-name ()
;;   "Get the current branch name in the cwd."
;;   (let ((git-branches (my-git-branch-cmd)))
;;     (if (> (length git-branches) 0)
;; 	(dolist (branch git-branches)
;; 	  (when (string-prefix-p "*" branch)
;; 	    (return (substring branch 2 nil))))
;;       (concat "no branch"))))

;; Configure the prompt
(defun my-prompt-tilde-for-home (dir)
  "Returns a path with the home directory replaced with a tilde"
  (let* ((home (expand-file-name (getenv "HOME")))
	 (home-len (length home)))
    (if (and (>= (length dir) home-len)
	     (equal home (substring dir 0 home-len)))
	(concat "~" (substring dir home-len)) dir)))

(defun my-prompt-git-branch-name ()
  "Return the current git branch as a string,
or the empty string if cwd is not in a git repo,
or the git command is not found."
  (if (my-git-p)
      (let ((git-output (my-git-branch-name)))
	(when (> (length git-output) 0)
	  (concat "(" git-output ")")))
    (concat "")))

(defun my-prompt-root-or-user ()
  "Different prompt chars for root or user."
  (if (= (user-uid) 0) "#" "$"))

(defun my-prompt-function ()
  (concat
   (user-login-name)
   "@"
   (car (split-string (system-name) "\\."))
   ": "
   (my-prompt-tilde-for-home(eshell/pwd))
   " "
   (my-prompt-git-branch-name)
   "\n"
   (my-prompt-root-or-user)
   " "))

;; Needed for colors to have an effect
(setopt eshell-highlight-prompt nil)

;; Needed to tweek for completion to work
(setopt eshell-prompt-regexp "^[^#$\n]*[#$] ")

;; History settings
;; make sure the history vars are defined
(setopt eshell-history-size 1024)
(if (boundp 'eshell-save-history-on-exit)
    (setopt eshell-save-history-on-exit t))
(if (boundp 'ehsell-ask-to-save-history)
    (setopt eshell-ask-to-save-history 'always))

;; Set the prompt function
(setopt eshell-prompt-function 'my-prompt-function)

;; Configure cua mode to allow selection of text only.
;; This allows the C-x,c,v keys to retain their original functionality
;; but allow cua rectangle selection.
(cua-selection-mode 1)

;; Compilation output, next/previous error. (<alt-{page up/page down}>)
(global-set-key (kbd "<M-prior>") 'previous-error)
(global-set-key (kbd "<M-next>")  'next-error)

;; Move to window support (<C-c-{up,down,left,right}>)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;; Darwin (Mac OS X) key mappings
(when (eq system-type 'darwin)
  (global-set-key [kp-delete] 'delete-char)       ; Make fn-del delete forward
  (global-set-key (kbd "s-=") 'text-scale-increase)
  (global-set-key (kbd "s--") 'text-scale-decrease)
  (global-set-key (kbd "s-0") (lambda () (interactive) (text-scale-set 0))))

;; Linux key mappings
(when (eq system-type 'linux))

;; Windows key mappings
(when (eq system-type 'windows-nt))

;;; Lock Buffers
(save-excursion
  (set-buffer "*scratch*")
  (emacs-lock-mode 'kill)
  (set-buffer "*Messages*")
  (emacs-lock-mode 'kill))

;;; Packages

;; Advice for 'package-install to change it to handle file-error signals.
(defun my-package-install-advice (orig-func &rest args)
"Advice for 'package-install to change how it handles file-error signals.

- If package-install does not signal an error:  just exit like normal.
- If package-install signals a file-error: refresh the package-archive and try package-install again.
- If package-install signals any other error: the signal is passed on.
- If the second package-install signals any error: the signal passed on.

This should fix errors where the package-archive has not been refreshed in a while and has become stale with invalid package version information.

Use the following commands to add/remove the advice:
(advice-add 'package-install :around #'my-package-install-advice)
(advice-remove 'package-install #'my-package-install-advice)"
  (condition-case err
      (apply orig-func args)
    (file-error
     (progn
       (message "Error: %S" err)
       (package-refresh-contents)
       (apply orig-func args)))))

;; Add advice to 'package-install to handle a file-error when installing a package
(advice-add 'package-install :around #'my-package-install-advice)

;; Get a package's description from a package name
(defun my-package-desc (package)
  "Given a PACKAGE name, return the package's description."
  (car (cdr (assq 'neotree package-alist))))

;; Delete a package
(defun my-package-delete (package)
  "Given a PACKAGE name, delete the package."
  (package-delete (my-package-desc package))
  (package-initialize))

;; Install a package, but only if it is not allready installed
(defun my-package-install (package)
  "Given a PACKAGE name, install the package."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))

;; Initialize the package-archives to be used.
; (setq package-archives '(("gnu"   . "http://elpa.gnu.org/packages/")
; 			 ("melpa" . "http://melpa.org/packages/")))
(setq package-archives '(("melpa"        . "https://melpa.org/packages/")
                         ("gnu"          . "https://elpa.gnu.org/packages/")
                         ("nongnu"       . "https://elpa.nongnu.org/nongnu/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))
(setq package-archive-priorities '(("gnu"    . 99)
                                   ("nongnu" . 80)
                                   ("melpa"  . 70)
                                   ("melpa-stable" . 50)))
;; Higlight the selected package
(add-hook 'package-menu-mode-hook (lambda() (hl-line-mode 1)))

;; Initialize the package manager and installed packages.
(when (< emacs-major-version 27)
  (package-initialize))

;; Bootstrap `use-package'

;; Install and configure the `use-package' package.
(when (< emacs-major-version 28)
  (my-package-install 'use-package))

(require 'use-package nil t)
(setq use-package-expand-minimally t)

;; Bootstrap `auto-install'

;; Install and configure the `auto-install' package.
;; Check if the auto installed library exists
;; (defun my-auto-install-library-exists-p (library-name)
;;   "Given a LIBRARY-NAME check if it exists."
;;   (file-exists-p (format "%s/%s" auto-install-directory library-name)))

;; Install from url helper function
;; (defun my-auto-install-from-url (library-name library-url)
;;   "Given a LIBRARY-NAME and LIBRARY-URL, use auto-install to install the library."
;;   (auto-install-from-url (format "%s/%s" library-url library-name)))

;; (my-package-install 'auto-install)
;; (require 'auto-install nil t)

;; Do not prompt to save auto-installed libraries
;; (setq auto-install-save-confirm nil)

;; Set the auto-install download directory
;; (setq auto-install-directory
;;       (expand-file-name "auto-install/" user-emacs-directory))

;; If auto-install-directory is not in the load-path, add it
;; (unless (member auto-install-directory load-path)
;;   (add-to-list 'load-path auto-install-directory))

;;; AutoSave, Backup, Save
;; Remove trailing whitespace from lines when saving files
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Set the temp directory to be a directory in the users home
;; directory. ~/tmp/emacs
(let ((my-temp-directory (expand-file-name "~/tmp/emacs/")))

  ;; make the temp directory
  (make-directory my-temp-directory t)

  ;; Backup files to the temp directory
  (setq backup-by-copying t)
  (setq backup-directory-alist
      `((".*" . ,my-temp-directory)
        (,tramp-file-name-regexp nil)))

  ;; Auto save files to the temp directory
  (setq auto-save-list-file-prefix
	(concat my-temp-directory "auto-saves-"))

  (setq auto-save-file-name-transforms
	`(("\\`/?\\([^/]*/\\)*\\([^/]*\\)\\'" ,my-temp-directory t))))

;;; Server
;; Darwin (Mac OS X)
(when (eq system-type 'darwin))

;; Gnu/linux
(when (eq system-type 'gnu/linux))

;; Windows
(when (eq system-type 'windows-nt)
  (setq server-auth-dir (getenv "TMP")))

;; When running as a GUI
;; Start a server for client processes, but only if one is not already running
(when (window-system)
  (load "server")
  (unless (server-running-p)
    (server-start)))

;;; Spelling
(when (executable-find "hunspell")
  (setq ispell-program-name "hunspell")

  (when (eq system-type 'darwin)
    (setenv "DICTIONARY" "en_US"))

  (when (eq system-type 'windows-nt)
    (setq ispell-local-dictionary-alist
	  '((nil "[[:alpha:]]" "[^[:alpha:]]" "[']" t ("-d" "en_US") nil utf-8))))

  ;; Turn flyspell programming mode on
  ;; (add-hook 'emacs-lisp-mode-hook
  ;; 	  (lambda () (flyspell-prog-mode)))
  ;; (add-hook 'python-mode-hook
  ;; 	  (lambda () (flyspell-prog-mode)))
  )

;;; UI
;; UI settings
(blink-cursor-mode -1)
(column-number-mode t)
(show-paren-mode t)

;; Whitespace display configuration
(setq whitespace-line-column 80 whitespace-style
      '(face newline space-mark tab-mark newline-mark trailing lines-tail))

;; Apply theme based on system appearance
(defun my-apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (interactive)
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'vs-light t))
    ('dark (load-theme 'vs-dark t))))

;; Apply light theme
(defun my-apply-theme-light ()
  "Apply the light theme"
  (interactive)
  (my-apply-theme 'light))

;; Apply dark theme
(defun my-apply-theme-dark ()
  "Apply the dark theme"
  (interactive)
  (my-apply-theme 'dark))

;; Any GUI/TUI configuration
(defun my-any-after-make-frame (&optional frame)
  "Configure a new FRAME (default: selected frame) on any system"

  ;; Display the menubar in GUI and hide in TUI frames
  (let ((lines (if (display-graphic-p frame) 1 0)))
    (set-frame-parameter frame 'menu-bar-lines lines)))

;; Add hook to configure new frames either GUI or TUI
(add-hook 'after-make-frame-functions 'my-any-after-make-frame)

;; Emacs was started normally
(unless (daemonp)
  (my-any-after-make-frame))

;;; UI Darwin (macOS)
(when (eq system-type 'darwin)

  ;; Frame configuration for `darwin'
  (defun my-after-make-frame-darwin(&optional frame)
    "Configure a new FRAME (default: selected frame) on `darwin' system"

    ;; When the frame is GUI
    (when (display-graphic-p)

      ;; set key to toggle fullscreen mode
      (global-set-key (kbd "s-<return>") 'toggle-frame-fullscreen)

      ;; set default font
      (when (member "FiraCode Nerd Font" (font-family-list))
	(set-frame-font "FiraCode Nerd Font" t t))

      ;; raise Emacs using AppleScript."
      (ns-do-applescript "tell application \"Emacs\" to activate")))

  ;; Hook make frame to apply `darwin' specific configuration
  (add-hook 'after-make-frame-functions 'my-after-make-frame-darwin)

  ;; Hook to change theme based on system appearence
  (add-hook 'ns-system-appearance-change-functions #'my-apply-theme)

  ;; Emacs not started in `daemon' mode.
  (unless (daemonp)
    (my-after-make-frame-darwin)))

;;; UI Linux
(when (eq system-type 'gnu/linux)

  ;; Frame configuration for `windows' systems.
  (defun my-after-make-frame-linux(&optional frame)
    "Configure a new FRAME (default: selected frame) on `linux' system"

    ;; When the frame is GUI
    (when (display-graphic-p)

      ;; Font customization
      (when (member "Monospace" (font-family-list))
	(set-face-font 'default "Monospace 11"))))

  ;; Hook make frame to apply `linux' specific configuration
  (add-hook 'after-make-frame-functions 'my-after-make-frame-linux)

  ;; Emacs not started in `daemon' mode.
  (unless (daemonp)
    (my-after-make-frame-linux)))

;;; UI Windows
(when (eq system-type 'windows-nt)

  ;; Frame configuration for `windows' systems.
  (defun my-after-make-frame-windows(&optional frame)
    "Configure a new FRAME (default: selected frame) on `windows' system"

    ;; When the frame is GUI
    (when (display-graphic-p)

      ;; Font customization
      (when (member "Lucida Console" (font-family-list))
	(set-face-font 'default "Lucida Console 10"))))

  ;; Hook make frame to apply `windows' specific configuration
  (add-hook 'after-make-frame-functions 'my-after-make-frame-windows)

  ;; Emacs not started in `daemon' mode.
  (unless (daemonp)
    (my-after-make-frame-windows)))

;;; Load 3rd party packages
;; add `lisp' dir in emacs init dir, to load path
(add-to-list 'load-path (concat user-emacs-directory "lisp/" ))
(require 'packages)

(provide 'init)
;;; end of init.el
