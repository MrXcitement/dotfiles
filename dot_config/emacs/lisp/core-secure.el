;;; core-secure.el --- Configure security settings -*- lexical-binding: t -*-

;; Mike Barker <mike@thebarkers.com>
;; Created: January 29th, 2026
;; Updated: January 29th, 2026

;;; Commentary:

;; Setup any security related settings here.
;; for example: auth-source, EasyPG assistand (epa), etc.

;;; Code:

(setq epa-pinentry-mode 'loopback)

(provide 'core-secure)
;;; core-secure.el ends here
