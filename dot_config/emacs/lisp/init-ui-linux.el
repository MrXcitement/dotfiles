;;; init-ui-linux.el --- initialze the user interface on Linux systems

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: Decmeber 4th, 2025

;;; Commentary:
;; Initialize the user interface on Linux systems

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; Frame configuration for `windows' systems.
(defun mrb-after-make-frame-linux(&optional frame)
  "Configure a new FRAME (default: selected frame) on `linux' system"

  ;; When the frame is GUI
  (when (display-graphic-p)

    ;; Font customization
    (when (member "Monospace" (font-family-list))
      (set-face-font 'default "Monospace 11"))))

;; Only customize when on GNU/Linux system
(when (eq system-type 'gnu/linux)

  ;; Hook make frame to apply `linux' specific configuration
  (add-hook 'after-make-frame-functions 'mrb-after-make-frame-linux)

  ;; Emacs not started in `daemon' mode.
  (unless (daemonp)
    (mrb-after-make-frame-linux)))

(provide 'init-ui-linux)
;;; End of init-ui-linux
