;;; init-environment.el --- Initialize the system environment

;; Mike Barker <mike@thebarkers.com>
;; November 24th, 2025

;;; Commentary:
;; Configure environment settings

;;; History:
;; 2025.11.24
;; - Created.

;;; Code:

;; Darwin (mac os x) environment setup here...
(when (eq system-type 'darwin)
  ;; Force the current directory to be the users home dir
  (setq default-directory "~/")

  ;; Use the provided elisp version of ls
  (require 'ls-lisp)
  (setq ls-lisp-use-insert-directory-program nil))

;; Linux environment here...
(when (eq system-type 'linux))

;; Windows environment here...
(when (eq system-type 'windows-nt)
  ;; Force the current directory to be the users home dir
  (setq default-directory "~/"))

(provide 'init-environment)
;;; init-environment.el ends here.
