;;; core-keymaps.el --- Initialize global and system specific key maps

;; Mike Barker <mike@thebarkers.com>
;; Created: November 24th, 2025
;; Updated: August 9th, 2026

;;; Commentary:
;; Put keymaps that should be available in any emacs session regardless
;; of the system in the `Global' section. Any system specific ones go into
;; `darwin', `linux' or `windows-nt' sections.

;; History:
;; See my dotfiles repo and the emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:
(use-package emacs
  :straight nil
  :bind
  ;; Rebind C-g to use the modified my-keyboard-quit
  (("C-g" . my-keyboard-quit)
   ;; Compilation output, next/previous error. (<alt-{page up/page down}>)
   ("<M-prior>" . previous-error)
   ("<M-next>"  . next-error)
   ;; Move to window support (<C-c-{up,down,left,right}>)
   ("C-c <left>"  . windmove-left)
   ("C-c <right>" . windmove-right)
   ("C-c <up>"    . windmove-up)
   ("C-c <down>"  . windmove-down)
   ;; Configure mouse-3 ffap bindings as documented here:
   ;; https://www.gnu.org/software/emacs/manual/html_node/emacs/FFAP.html
   ("C-S-<mouse-1>" . ffap-at-mouse)
   ("C-S-<mouse-3>" . ffap-menu))

  :config
  ;; Make C-g a little more helpful
  ;; https://protesilaos.com/codelog/2024-11-28-basic-emacs-configuration/
  (defun my-keyboard-quit ()
    "Do-What-I-Mean behaviour for a general `keyboard-quit'.

The generic `keyboard-quit' does not do the expected thing when
the minibuffer is open.  Whereas we want it to close the
minibuffer, even without explicitly focusing it.

The DWIM behaviour of this command is as follows:

- When the region is active, disable it.
- When a minibuffer is open, but not focused, close the minibuffer.
- When the Completions buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
    (interactive)
    (cond
     ((region-active-p)
      (keyboard-quit))
     ((derived-mode-p 'completion-list-mode)
      (delete-completion-window))
     ((> (minibuffer-depth) 0)
      (abort-recursive-edit))
     (t
      (keyboard-quit))))

  ;; Configure cua mode to allow selection of text only.
  ;; This allows the C-x,c,v keys to retain their original functionality
  ;; but allow cua rectangle selection.
  (cua-selection-mode 1))

;; Darwin (Mac OS X) key bindings
(use-package emacs
  :straight nil
  :if (eq system-type 'darwin)
  :bind
  (([kp-delete] . delete-char)       ; Make fn-backspace delete forward
   ("s-="       . text-scale-increase)
   ("s--"       . text-scale-decrease)
   ("s-0"       . (lambda () (interactive) (text-scale-set 0)))))

;; Linux key mappings
(use-package emacs
  :straight nil
  :if (eq system-type 'linux))

;; Windows key mappings
(use-package emacs
  :straight nil
  :if (eq system-type 'windows-nt))

(provide 'core-keymaps)
;;; core-keymaps.el ends here.
