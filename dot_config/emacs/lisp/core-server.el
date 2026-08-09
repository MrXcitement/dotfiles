;;; core-server.el --- Initialize the server

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th. 2025
;; Updated: August 8th, 2026

;;; Commentary:
;; Start the server whenever the main emacs app is run as a `gui' If
;; you need to make any system specific settings for the server to
;; run, make them in the provided system sections.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
;;; Configure server
(use-package emacs
  :config
  ;; When running as a GUI
  ;; Start a server for client processes, but only if one is not already running
  (when (window-system)
    (load "server")
    (unless (server-running-p)
      (server-start))))

(provide 'core-server)
;;; core-server.el ends here.
