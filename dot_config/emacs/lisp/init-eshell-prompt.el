;;; init-eshell-prompt.el --- Configure the emacs shell prompt

;; Mike Barker <mike@thebarkers.com>
;; Created: March 7th, 2026
;; Updated:

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
(defun mrb/git-p ()
  "Is git installed and the cwd is a git project."
  (> (length (and (eshell-search-path "git")
		  (locate-dominating-file default-directory ".git"))) 0))

(defun mrb/git-status-cmd ()
  "Run the git status command in the cwd."
  (split-string (shell-command-to-string
		 "git status --porcelain")))

(defun mrb/git-branch-cmd ()
  "Run the git branch command in the cwd and return a list of branches."
  (split-string
   (shell-command-to-string "git branch --no-color")
   "\n" 'omit-nulls))

(defun mrb/git-branch-name ()
  "Get the current branch name in the cwd."
  (cl-loop for branch in (mrb/git-branch-cmd)
           when (string-prefix-p "*" branch)
           return (substring branch 2)
           finally return "no branch"))

;; Prompt sections
(defun mrb/prompt-tilde-for-home (dir)
  "Returns a path with the home directory replaced with a tilde"
  (let* ((home (expand-file-name (getenv "HOME")))
	 (home-len (length home)))
    (if (and (>= (length dir) home-len)
	     (equal home (substring dir 0 home-len)))
	(concat "~" (substring dir home-len)) dir)))

(defun mrb/prompt-git-branch ()
  "Return the current git branch as a string,
or the empty string if cwd is not in a git repo,
or the git command is not found."
  (if (mrb/git-p)
      (let ((git-output (mrb/git-branch-name)))
	(when (> (length git-output) 0)
	  (concat "(" git-output ")")))
    (concat "")))

(defun mrb/prompt-root-or-user ()
  "Different prompt chars for root or user."
  (if (= (user-uid) 0) "# " "$ "))

;; Configure the prompt
(defmacro mrb/with-face (STR &rest PROPS)
  "Return STR propertized with PROPS."
  `(propertize ,STR 'face (list ,@PROPS)))

(defmacro mrb/prompt-section (NAME ICON FORM &rest PROPS)
  "Build eshell prompt section NAME with ICON prepended to evaled FORM with PROPS."
  `(setq ,NAME
	 (lambda () (when ,FORM
		      (mrb/with-face (concat ,ICON mrb/prompt-section-delim ,FORM) ,@PROPS)))))

(defun mrb/prompt-section-acc (acc x)
  "Accumulator for evaluating and concatenating mrb/prompt-section."
  (let ((result (funcall x)))
    (if result
        (if (string= acc "")
            result
          (concat acc mrb/prompt-sep result))
      acc)))

(defun mrb/prompt-function ()
  "Build `eshell-prompt-function'"
  (concat mrb/prompt-header
          (cl-reduce 'mrb/prompt-section-acc mrb/prompt-funcs :initial-value "")
          "\n"
          (mrb/prompt-root-or-user)))

(mrb/prompt-section mrb/prompt-user-host
		    ""
		    (concat
		     (user-login-name)
		     "@"
		     (car (split-string (system-name) "\\.")))
		    '(:foreground "green"))

(mrb/prompt-section mrb/prompt-dir
		    "\xf07c"  ;  (faicon folder)
		    (abbreviate-file-name (eshell/pwd))
		    '(:foreground "gold" :bold ultra-bold :underline t))

(mrb/prompt-section mrb/prompt-git
		    "\xe907"  ;  (git icon)
		    (mrb/prompt-git-branch)
		    '(:foreground "pink"))

(setq mrb/prompt-sep " ")
(setq mrb/prompt-section-delim " ")
(setq mrb/prompt-header "")
(setq mrb/prompt-funcs (list mrb/prompt-user-host mrb/prompt-dir mrb/prompt-git))

;; Needed for colors to have an effect
(customize-set-variable 'eshell-highlight-prompt nil)

;; Needed to tweek for completion to work
(customize-set-variable 'eshell-prompt-regexp "^[^#$\n]*[#$] ")

;; Set the prompt function
(customize-set-variable 'eshell-prompt-function 'mrb/prompt-function)

(provide 'init-eshell-prompt)
