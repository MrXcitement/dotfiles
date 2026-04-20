;;; init-server.el --- Initialize the server

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th. 2025
;; Updated: December 4th, 2025

;;; Commentary:
;; Start the server whenever the main emacs app is run as a `gui' If
;; you need to make any system specific settings for the server to
;; run, make them in the provided system sections.

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Darwin (Mac OS X)
(when (eq system-type 'darwin))

;; Gnu/linux
(when (eq system-type 'gnu/linux))

;; Windows
(when (eq system-type 'windows-nt))

;; When running as a GUI
;; Start a server for client processes, but only if one is not already running
(when (window-system)
  (load "server")
  (unless (server-running-p)
    (server-start)))

(provide 'init-server)
;;; init-server.el ends here.
