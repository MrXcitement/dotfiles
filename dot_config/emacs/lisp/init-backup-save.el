;;; init-backup-save.el --- Initialize save, autosave and backup settings

;; Mike Barker <mike@thebarkers.com>
;; November 23rd, 2025

;;; Commentary:
;; Initialize the save, autosave and backup of files

;;; History:
;; 2025.11.23
;; - Created

;;; Code:

;; Remove trailing whitespace from lines when saving files
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Set the temp directory to be a directory in the users home
;; directory. ~/tmp/emacs
(let ((temp-directory (expand-file-name "~/tmp/emacs/")))

  ;; make the temp directory
  (make-directory temp-directory t)

  ;; Backup files to the temp directory
  (setq backup-by-copying t)
  (setq backup-directory-alist
      `((".*" . ,temp-directory)
        (,tramp-file-name-regexp nil)))

  ;; Auto save files to the temp directory
  (setq auto-save-list-file-prefix
	(concat temp-directory "auto-saves-"))

  (setq auto-save-file-name-transforms
	`(("\\`/?\\([^/]*/\\)*\\([^/]*\\)\\'" ,temp-directory t))))

(provide 'init-backup-save)
;;; init-backup-save.el ends here.
