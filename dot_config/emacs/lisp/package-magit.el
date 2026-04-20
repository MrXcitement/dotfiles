;;; packages-magit.el --- Install and configure the `magit' package.

;; Mike Barker <mike@thebarkers.com>
;; Created: May 15, 2015
;; Updated: December 23rd, 2025

;;; Commentary:
;; Magit is an interface to the version control system Git,
;; implemented as an Emacs package. Magit aspires to be a complete Git
;; porcelain. While we cannot (yet) claim that Magit wraps and
;; improves upon each and every Git command, it is complete enough to
;; allow even experienced Git users to perform almost all of their
;; daily version control tasks directly from within Emacs. While many
;; fine Git clients exist, only Magit and Git itself deserve to be
;; called porcelains.
;; https://www.emacswiki.org/emacs/Magit

;;; Code:
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(provide 'packages-magit)
