;;; init-keymaps.el --- Initialize global and system specific key maps

;; Mike Barker <mike@thebarkers.com>
;; November 24th, 2025
;; December 3rd, 2025

;;; Commentary:
;; Put keymaps that should be available in any emacs session regardless
;; of the system in the `Global' section. Any system specific ones go into
;; `darwin', `linux' or `windows-nt' sections.

;;; Code:

;;; Global key mappings

;; Make C-g a little more helpful
;; https://protesilaos.com/codelog/2024-11-28-basic-emacs-configuration/
(defun my-keyboard-quit-dwim ()
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

(define-key global-map (kbd "C-g") #'my-keyboard-quit-dwim)

;; Configure cua mode to allow selection of text only.
;; This allows the C-x,c,v keys to retain their original functionality
;; but allow cua rectangle selection.
(cua-selection-mode 1)

;; Compilation output, next/previous error. (<alt-{page up/page down}>)
(global-set-key (kbd "<M-prior>") 'previous-error)
(global-set-key (kbd "<M-next>")  'next-error)

;; Move to window support (<C-c-{up,down,left,right}>)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;; Darwin (Mac OS X) key mappings
(when (eq system-type 'darwin)
  (global-set-key [kp-delete] 'delete-char)       ; Make fn-del delete forward
  (global-set-key (kbd "s-=") 'text-scale-increase)
  (global-set-key (kbd "s--") 'text-scale-decrease)
  (global-set-key (kbd "s-0") (lambda () (interactive) (text-scale-set 0))))

;; Linux key mappings
(when (eq system-type 'linux))

;; Windows key mappings
(when (eq system-type 'windows-nt)
  (global-set-key (kbd "C-<mouse-1>") 'browse-url-at-mouse))

(provide 'init-keymaps)
;;; init-keymaps.el ends here.
