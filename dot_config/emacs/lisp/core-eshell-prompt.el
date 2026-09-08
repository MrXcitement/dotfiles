;;; core-eshell-prompt.el --- Configure the eshell prompt

;; Mike Barker <mike@thebarkers.com>
;; Created: September 8th, 2026
;; Updated: 

;;; Commentary:
;; Configure the eshell prompt.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; (require 'subr-x)

;;; Git helper functions

;; (defun my-git-p ()
;;   "Is git installed and the cwd is a git project."
;;   (> (length (and (eshell-search-path "git")
;; 		  (locate-dominating-file default-directory ".git"))) 0))

;; (defun my-git-branch-name ()
;;   "Get the current branch name in the cwd."
;;   (let ((branch (string-trim (shell-command-to-string "git branch --no-color --show-current"))))
;;     (if (string-empty-p branch)
;;         "no branch"
;;       branch)))

;;; Configure the prompt

;; (setq my-eshell-prompt-sep " ")
;; (setq my-eshell-prompt-section-delim " ")

;; (defun my-eshell-prompt-character ()
;;   "The prompt `character'"
;;   (if (zerop (user-uid)) "\n# " "\n$ "))

;; (defun my-eshell-prompt-directory ()
;;   "The current `directory', abbreviated if in HOME directory."
;;   (concat
;;    ;"\xf07c"  ;  (faicon folder)
;;    ;my-eshell-prompt-section-delim
;;    (abbreviate-file-name (eshell/pwd))))

;; (defun my-eshell-prompt-git-branch ()
;;   "Return the current git branch as a string,
;; or the empty string if cwd is not in a git repo,
;; or the git command is not found."
;;   (when (my-git-p)
;;     (concat
;;      my-eshell-prompt-section-delim
;;      "\xe0a0"  ;  (git icon)
;;      my-eshell-prompt-section-delim
;;      (my-git-branch-name))))

;; (defun my-eshell-prompt-git-status ()
;;   "Return a Starship.rs-like Git status summary string for Eshell.
;; Returns nil if the current directory is not inside a Git repository."
;;   (with-temp-buffer
;;     ;; Execute git status with porcelain v2 format
;;     (when (zerop (process-file "git" nil '(t nil) nil "status" "--porcelain=v2" "--branch"))
;;       (let ((git-output (buffer-string))
;;             (ahead 0)
;;             (behind 0)
;;             (staged 0)
;;             (modified 0)
;;             (deleted 0)
;;             (renamed 0)
;;             (untracked 0)
;;             (conflicted 0)
;;             (stashed 0))
;; 
;;         ;; Check for stashes
;;         (with-temp-buffer
;;           (when (zerop (process-file "git" nil '(t nil) nil "stash" "list"))
;;             (let ((stash-str (buffer-string)))
;;               (unless (string-empty-p stash-str)
;;                 (setq stashed (length (split-string stash-str "\n" t)))))))
;; 
;;         ;; Parse status output
;;         (dolist (line (split-string git-output "\n" t))
;;           (cond
;;            ;; Branch ahead/behind count: # branch.ab +<ahead> -<behind>
;;            ((string-prefix-p "# branch.ab " line)
;;             (when (string-match "# branch.ab \\+\\([0-9]+\\) -\\([0-9]+\\)" line)
;;               (setq ahead (string-to-number (match-string 1 line)))
;;               (setq behind (string-to-number (match-string 2 line)))))
;; 
;;            ;; Untracked files: ? <path>
;;            ((string-prefix-p "? " line)
;;             (setq untracked (1+ untracked)))
;; 
;;            ;; Unmerged / Conflicts: u ...
;;            ((string-prefix-p "u " line)
;;             (setq conflicted (1+ conflicted)))
;; 
;;            ;; Tracked ordinary changes: 1 <XY> ...
;;            ((string-prefix-p "1 " line)
;;             (let ((x (aref line 2))
;;                   (y (aref line 3)))
;;               (unless (eq x ?.) (setq staged (1+ staged)))
;;               (when (eq y ?M)   (setq modified (1+ modified)))
;;               (when (or (eq x ?D) (eq y ?D)) (setq deleted (1+ deleted)))))
;; 
;;            ;; Renamed or copied entries: 2 <XY> ...
;;            ((string-prefix-p "2 " line)
;;             (setq staged (1+ staged))
;;             (setq renamed (1+ renamed))
;;             (let ((y (aref line 3)))
;;               (when (eq y ?M) (setq modified (1+ modified)))
;;               (when (eq y ?D) (setq deleted (1+ deleted)))))))
;; 
;;         ;; Construct status symbols matching Starship defaults
;;         (let ((status-parts '()))
;;           (when (> conflicted 0) (push "=" status-parts))
;;           (when (> stashed 0)    (push "$" status-parts))
;;           (when (> staged 0)     (push "+" status-parts))
;;           (when (> modified 0)   (push "!" status-parts))
;;           (when (> renamed 0)    (push "»" status-parts))
;;           (when (> deleted 0)    (push "✘" status-parts))
;;           (when (> untracked 0)  (push "?" status-parts))
;; 
;;           ;; Format ahead/behind branch info
;;           (let ((status-str (apply #'concat (nreverse status-parts)))
;;                 (ab-str ""))
;;             (cond
;;              ((and (> ahead 0) (> behind 0))
;;               (setq ab-str (format "⇕⇡%d⇣%d" ahead behind)))
;;              ((> ahead 0)
;;               (setq ab-str (format "⇡%d" ahead)))
;;              ((> behind 0)
;;               (setq ab-str (format "⇣%d" behind))))
;; 
;;             ;; Return formatted string or empty string if repo is clean
;;             (if (and (string-empty-p status-str) (string-empty-p ab-str))
;;                 ""
;;               (format " [%s%s]" status-str ab-str))))))))

;; (defun my-eshell-prompt-function ()
;;   "Build `eshell-prompt-function'"
;;   (concat
;;    (propertize (my-eshell-prompt-directory)
;;                'face `(:foreground "systemTealColor" :weight bold))
;;    (propertize (or (my-eshell-prompt-git-branch) "")
;;                'face `(:foreground "systemPurpleColor" :weight bold))
;;    (propertize (or (my-eshell-prompt-git-status) "")
;;                'face '(:foreground "systemRedColor" :weight bold))
;;    (propertize (my-eshell-prompt-character)
;;                'face `(:foreground "systemGreenColor" :weight bold)
;;                'rear-nonsticky '(face))))

;; Needed for colors to have an effect
;; (customize-set-variable 'eshell-highlight-prompt nil)

;; Needed to tweek for completion to work
;; (customize-set-variable 'eshell-prompt-regexp "^[^#$\n]* [#$] ")

;; Set the prompt function
;; (customize-set-variable 'eshell-prompt-function #'my-eshell-prompt-function)

(provide 'core-eshell-prompt)
;;; core-eshell-prompt.el ends here.
