;;; core-hideshow.el --- Configure the `hs-minor-mode' package.

;; Mike Barker <mike@thebarkers.com>
;; Created: October 23, 2014
;; Updated: August 17th, 2026

;;; Commentary:
;; Hideshow mode is a buffer-local minor mode that allows you to
;; selectively display portions of a program, which are referred to as
;; blocks. Type M-x hs-minor-mode to toggle this minor mode (see Minor
;; Modes).
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Hideshow.html

;;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;; toggle hiding block on/off
;; will revert to using selective display if it fails
(defun my-toggle-hiding (column)
      (interactive "P")
      (if hs-minor-mode
          (if (condition-case nil
                  (hs-toggle-hiding)
                (error t))
              (hs-show-all))
        (my-toggle-selective-display column)))

;; toggle selective display of to the current column
(defun my-toggle-selective-display (column)
      (interactive "P")
      (set-selective-display
       (or column
           (unless selective-display
             (1+ (current-column))))))

;; rules used to handle hiding nxml sections
(defun my-nxml-forward-sexp-func (pos)
  (my-nxml-forward-element))

(defun my-nxml-forward-element ()
  (let ((nxml-sexp-element-flag)
  	(outline-regexp "\\s *<\\([h][1-6]\\|html\\|body\\|head\\)\\b"))
    (setq nxml-sexp-element-flag (not (looking-at "<!--")))
    (unless (looking-at outline-regexp)
      (condition-case nil
  	  (nxml-forward-balanced-item 1)
  	(error nil)))))

;; initialize and configure the `hideshow.el' system package
(use-package hideshow
  :bind
  (("C-c =" . my-toggle-hiding)
   ("C-c +" . my-toggle-selective-display))

  :init
  (progn
    ;; hook into the following major modes
    (add-hook 'c-mode-common-hook   'hs-minor-mode)
    (add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
    (add-hook 'java-mode-hook       'hs-minor-mode)
    (add-hook 'lisp-mode-hook       'hs-minor-mode)
    (add-hook 'perl-mode-hook       'hs-minor-mode)
    (add-hook 'sh-mode-hook         'hs-minor-mode)
    (add-hook 'nxml-mode-hook       'hs-minor-mode)
    (add-hook 'html-mode-hook       'hs-minor-mode))

  :config
  (progn
    ;; nxml-mode config to hide/show blocks
    (add-to-list 'hs-special-modes-alist
		 '(nxml-mode
		   "<!--\\|<[^/>]>\\|<[^/][^>]*[^/]>"
		   ""
		   "<!--"                        ; won't work on its own; uses syntax table
		   my-nxml-forward-sexp-func
		   nil                           ; my-nxml-hs-adjust-beg-func
		   ))

    ;; html-mode config to hide/show blocks
    (add-to-list 'hs-special-modes-alist
		 '(html-mode
		   "<!--\\|<[^/>]>\\|<[^/][^>]*"
		   "</\\|-->"
		   "<!--"
		   sgml-skip-tag-forward
		   nil))))

(provide 'core-hideshow)
