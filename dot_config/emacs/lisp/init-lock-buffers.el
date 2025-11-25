;;; init-lock-buffers.el --- Protect system buffers

;; Mike Barker <mike@thebarkers.com>
;; Nuvember 24th, 2025

;;; Commentary:
;; Lock the `*scratch*' and `*Messages*' buffers so they can not be killed.

;;; History:
;; 2025.11.24
;; - Created.

;;; Code:

(save-excursion
  (set-buffer "*scratch*")
  (emacs-lock-mode 'kill)
  (set-buffer "*Messages*")
  (emacs-lock-mode 'kill))

(provide 'init-lock-buffers)
;;; init-lock-buffers.el
