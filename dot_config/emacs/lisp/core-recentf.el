;;; init-recentf.el --- Initialize the recentf package -*- lexical-binding: t -*-

;; Author: Mike Barker
;; Maintainer: Mike Barker
;; Version: 0.1.0

;;; Commentary:

;; Use this package to initialize the recentf internal Emacs package

;;; Code:
(require 'recentf)

;; Replace `find-file-read-only' keybinding with recentf.
(global-set-key (kbd "C-x C-r") 'recentf-open)

;; enable recent files mode.
(recentf-mode t)

; 50 files ought to be enough.
(setq recentf-max-saved-items 50)

(provide 'init-recentf)

;;; init-recentf.el ends here
