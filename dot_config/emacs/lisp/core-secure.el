;;; core-secure.el --- Configure security settings -*- lexical-binding: t -*-

;; Mike Barker <mike@thebarkers.com>
;; Created: January 29th, 2026
;; Updated: August 13th, 2026

;;; Commentary:
;; Setup any security related settings here.
;; For example: auth-source, EasyPG assistand (epa), etc.
;; auth-sources.el, epg-config.el, files.el

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; This directs gpg-agent to use the minibuffer for passphrase entry
(setq epg-pinentry-mode 'loopback)

;; By default, Emacs stores sensitive authinfo credentials as unencrypted text
;; in your home directory. Use GPG to encrypt the authinfo file for enhanced
;; security.
(setq auth-sources (list "~/.authinfo.gpg"))


;; Protect the system from code injection vulnerabilities when browsing files.
;; Disabling local 'eval' expressions ensures that opening a malicious project
;; or third-party script cannot execute arbitrary Lisp code on your machine.
(setq enable-local-eval nil)

(provide 'core-secure)
;;; core-secure.el ends here
