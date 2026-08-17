;;; package-exec-path-from-shell.el --- Install and configure the `exec-path-from-shell' package.

;; Mike Barker <mike@thebarkers.com>
;; Created: March 16th, 2023
;; Updated: August 9th, 2026

;;; Commentary:
;; On a Darwin (macOS) system, copy environment variables from the
;; user's shell by asking your shell to print out the variables of
;; interest, then copying them into the Emacs environment.
;; See: https://github.com/purcell/exec-path-from-shell

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
;; (use-package exec-path-from-shell
;;   :if (eq system-type 'darwin)
;;   :ensure t
;;   :config
;;   ;; Only run exec-path-from-shell-initialize when PATH has not
;;   ;; allready been injected
;;   (unless (bound-and-true-p ns-emacs-plus-injected-path)
;;     (exec-path-from-shell-initialize)))

(use-package exec-path-from-shell
  :if (and (or (display-graphic-p) (daemonp))
           (eq system-type 'darwin)) ; macOS only
  :demand t
  :functions exec-path-from-shell-initialize
  :config
  (dolist (var '("TMPDIR"
                 "SSH_AUTH_SOCK" "SSH_AGENT_PID"
                 "GPG_AGENT_INFO"
                 ;; "FZF_DEFAULT_COMMAND" "FZF_DEFAULT_OPTS" ; fzf
                 ;; "VIRTUAL_ENV" ; Python
                 ;; "GOPATH" "GOROOT" "GOBIN" ; Go
                 ;; "CARGO_HOME" "RUSTUP_HOME" ; Rust
                 ;; "NVM_DIR" "NODE_PATH" ; Node/JS
                 "LANG" "LC_CTYPE"))
    (add-to-list 'exec-path-from-shell-variables var))
  
  ;; Initialize
  (exec-path-from-shell-initialize))

(provide 'package-exec-path-from-shell)
