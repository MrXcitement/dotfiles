;;; core-eshell-prompt.el --- Configure the emacs shell prompt

;; Mike Barker <mike@thebarkers.com>
;; Created: March 7th, 2026
;; Updated: August 9th, 2026

;;; Commentary:
;; Create the eshell prompt, include git status
;; Ideas and code where provided by:
;; https://www.modernemacs.com/post/custom-eshell/

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

(require 'cl-lib)

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

(defun my-git-branch-name ()
  "Get the current branch name in the cwd."
  (cl-loop for branch in (my-git-branch-cmd)
           when (string-prefix-p "*" branch)
           return (substring branch 2)
           finally return "no branch"))

;; Prompt sections
(defun my-prompt-tilde-for-home (dir)
  "Returns a path with the home directory replaced with a tilde"
  (let* ((home (expand-file-name (getenv "HOME")))
	 (home-len (length home)))
    (if (and (>= (length dir) home-len)
	     (equal home (substring dir 0 home-len)))
	(concat "~" (substring dir home-len)) dir)))

(defun my-prompt-git-branch ()
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
  (if (= (user-uid) 0) "# " "$ "))

;; Configure the prompt
(defmacro my-with-face (STR &rest PROPS)
  "Return STR propertized with PROPS."
  `(propertize ,STR 'face (list ,@PROPS)))

(defmacro my-prompt-section (NAME ICON FORM &rest PROPS)
  "Build eshell prompt section NAME with ICON prepended to evaled FORM with PROPS."
  `(setq ,NAME
	 (lambda () (when ,FORM
		      (my-with-face (concat ,ICON my-prompt-section-delim ,FORM) ,@PROPS)))))

(defun my-prompt-section-acc (acc x)
  "Accumulator for evaluating and concatenating my-prompt-section."
  (let ((result (funcall x)))
    (if result
        (if (string= acc "")
            result
          (concat acc my-prompt-sep result))
      acc)))

(defun my-prompt-function ()
  "Build `eshell-prompt-function'"
  (concat my-prompt-header
          (cl-reduce 'my-prompt-section-acc my-prompt-funcs :initial-value "")
          "\n"
          (my-prompt-root-or-user)))

(my-prompt-section my-prompt-user-host
		    ""
		    (concat
		     (user-login-name)
		     "@"
		     (car (split-string (system-name) "\\.")))
		    '(:foreground "green"))

(my-prompt-section my-prompt-dir
		    "\xf07c"  ;  (faicon folder)
		    (abbreviate-file-name (eshell/pwd))
		    '(:foreground "gold" :bold ultra-bold :underline t))

(my-prompt-section my-prompt-git
		    "\xe907"  ;  (git icon)
		    (my-prompt-git-branch)
		    '(:foreground "pink"))

(setq my-prompt-sep " ")
(setq my-prompt-section-delim " ")
(setq my-prompt-header "")
(setq my-prompt-funcs (list my-prompt-user-host my-prompt-dir my-prompt-git))

;; Needed for colors to have an effect
(customize-set-variable 'eshell-highlight-prompt nil)

;; Needed to tweek for completion to work
(customize-set-variable 'eshell-prompt-regexp "^[^#$\n]*[#$] ")

;; Set the prompt function
(customize-set-variable 'eshell-prompt-function 'my-prompt-function)

(provide 'core-eshell-prompt)
