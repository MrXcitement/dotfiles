;;; early-init.el --- Early initialization -*- lexical-binding: t -*-

;; Mike Barker <mike@thebarkers.com>
;; Created: November 23rd, 2025
;; Updated: August 11th, 2026

;;; Inspiration
;; `minimal-emacs.d' github project by James Cherti
;; https://github.com/jamescherti/minimal-emacs.d

;;; Commentary:
;; This file is an attempt to speed up my Emacs' startup time.
;; Most of the current code has been taken directly from the
;; `minimal-emacs.d' project. I have changed the names of variables
;; and functions to use `my-' instead of `minimal-emacs-'.

;;; Documentation:
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Init-File.html
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Early-Init-File.html
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Startup-Summary.html
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Init-File.html#index-early-init-file

;;; History:
;; See my dotfiles and emacs folder
;; https://github.com/MrXcitement/dotfiles/tree/main/dot_config/emacs

;;; Code:

;;; Internal variables

;; Backup `gc-cons-threshold' and `gc-cons-percentage' before startup.
(defvar my-backup-gc-cons-threshold gc-cons-threshold)
(defvar my-backup-gc-cons-percentage gc-cons-percentage)

;; Temporarily raise the garbage collection threshold to its maximum value.
;; It will be restored later to controlled values.
(if noninteractive
    (setq gc-cons-threshold 268435456) ; 256 Mb
  (setq gc-cons-threshold most-positive-fixnum))
(setq gc-cons-percentage 1.0)

;;; Variables

(defvar my-ui-features '()
  "List of user interface features to enable in minimal Emacs setup.
This variable holds a list of Emacs UI features that can be enabled:
- context-menu (Enables the context menu in graphical environments.)
- tool-bar (Enables the tool bar in graphical environments.)
- menu-bar (Enables the menu bar in graphical environments.)
- dialogs (Enables both file dialogs and dialog boxes.)
- tooltips (Enables tooltips.)")

(defvar my-frame-title-format "%b – Emacs"
  "Template for displaying the title bar of visible and iconified frame.")

(defvar my-debug (bound-and-true-p init-file-debug)
  "Non-nil to enable debug.")

(defvar my-optimize-startup-gc t
  "If non-nil, increase `gc-cons-threshold' during startup to reduce pauses.
After Emacs finishes loading, `gc-cons-threshold' is restored to the value
stored in `my-gc-cons-threshold'.")

(defvar my-gc-cons-threshold (* 32 1024 1024)
  "Value to which `gc-cons-threshold' is set after Emacs startup.
Ignored if `my-optimize-startup-gc' is nil.")

(defvar my-gc-cons-percentage gc-cons-percentage
  "Value to which `gc-cons-percentage' is set after Emacs startup.
Ignored if `my-optimize-startup-gc' is nil.")

(defvar my-gc-cons-threshold-restore-delay nil
  "Number of seconds to wait before restoring `gc-cons-threshold'.")

(defvar my-optimize-file-name-handler-alist t
  "Enable optimization of `file-name-handler-alist'.
When non-nil, this variable activates optimizations to reduce file name handler
lookups during Emacs startup.")

(defvar my-disable-mode-line-during-startup t
  "Disable the mode line during startup.
This reduces visual clutter and slightly enhances startup performance. The
tradeoff is that the mode line is hidden during the startup phase.")

(defvar my-package-initialize-and-refresh t
  "Whether to automatically initialize and refresh packages.
When set to non-nil, Emacs will automatically call `package-initialize' and
`package-refresh-contents' to set up and update the package system.")

(defvar my-inhibit-redisplay-during-startup nil
  "Suppress redisplay during startup to improve performance.
This prevents visual updates while Emacs initializes. The tradeoff is that you
won't see the progress or activities during the startup process.")

(defvar my-inhibit-message-during-startup nil
  "Suppress startup messages for a cleaner experience.
This slightly enhances performance. The tradeoff is that you won't be informed
of the progress or any relevant activities during startup.")

(defvar my-user-directory user-emacs-directory
  "Directory beneath my.d files are placed.
Note that this should end with a directory separator.")

(defun my--remove-el-file-suffix (filename)
  "Remove the Elisp file suffix from FILENAME and return it (.el, .el.gz...)."
  (let ((suffixes (mapcar (lambda (ext) (concat ".el" ext))
                          load-file-rep-suffixes)))
    (catch 'done
      (dolist (suffix suffixes filename)
        (when (string-suffix-p suffix filename)
          (setq filename (substring filename 0 (- (length suffix))))
          (throw 'done t))))
    filename))

(defun my-load-user-init (filename)
  "Execute a file of Lisp code named FILENAME."
  (let ((init-file (expand-file-name filename
                                     my-user-directory)))
    (if (not my-load-compiled-init-files)
        (load init-file :no-error (not my-debug) :nosuffix)
      ;; Remove the file suffix (.el, .el.gz, etc.) to let the `load' function
      ;; select between .el and .elc files.
      (setq init-file (my--remove-el-file-suffix init-file))
      (load init-file :no-error (not my-debug)))))

(setq custom-theme-directory
      (expand-file-name "themes/" my-user-directory))

(setq custom-file (expand-file-name "custom.el" my-user-directory))

;;; Garbage collection

;; Garbage collection significantly affects startup times.
;; This setting delays garbage collection during startup but will be
;; reset later.

(defun my--restore-gc-values ()
  "Restore garbage collection values to my-gc-cons values."
  (setq gc-cons-threshold my-gc-cons-threshold)
  (setq gc-cons-percentage my-gc-cons-percentage))

(defun my--restore-gc ()
  "Restore garbage collection settings."
  (if (and (bound-and-true-p my-gc-cons-threshold-restore-delay)
           ;; In noninteractive mode, the event loop does not run
           (not noninteractive))
      ;; Defer garbage collection during initialization to avoid 2 collections.
      (run-with-timer my-gc-cons-threshold-restore-delay nil
                      #'my--restore-gc-values)
    (my--restore-gc-values)))

(if my-optimize-startup-gc
    ;; `gc-cons-threshold' is managed by my.d
    (add-hook 'emacs-startup-hook #'my--restore-gc 105)
  ;; gc-cons-threshold is not managed by my.d.
  (when (= gc-cons-threshold most-positive-fixnum)
    (setq gc-cons-threshold my--backup-gc-cons-threshold)
    (setq gc-cons-percentage my--backup-gc-cons-percentage)))

;;; Native compilation and Byte compilation

(unless (and (featurep 'native-compile)
             (fboundp 'native-comp-available-p)
             (native-comp-available-p))
  ;; Deactivate the `native-compile' feature if it is not available
  (setq native-comp-jit-compilation nil)
  (setq features (delq 'native-compile features)))

(setq native-comp-warning-on-missing-source my-debug
      native-comp-async-report-warnings-errors (or my-debug 'silent))

(setq jka-compr-verbose my-debug)
(setq byte-compile-warnings my-debug
      byte-compile-verbose my-debug)

;;; Miscellaneous

(set-language-environment "UTF-8")

(setq process-adaptive-read-buffering nil)

;; Don't ping things that look like domain names.
(setq ffap-machine-p-known 'reject)

(setq warning-minimum-level (if my-debug :warning :error))

;; Establish a strict baseline for suppressed warnings.
;; - defvaralias: Emacs emits warnings when an alias is defined for a variable
;;   that already exists. In modern, lazy-loaded configurations, this occurs
;;   frequently and is almost always benign.
;; - lexical-binding: Emacs warns about third-party packages that lack
;;   lexical-binding. Because end users cannot easily fix upstream source code,
;;   these warnings create noise without providing actionable value.
(setq warning-suppress-types '((defvaralias) (lexical-binding)))
(setq warning-inhibit-types '((files missing-lexbind-cookie)))

(when my-debug
  (setq message-log-max 16384))

;; Disable warnings from the legacy advice API. They aren't useful.
(setq ad-redefinition-action 'accept)

;;; Performance: Miscellaneous options

;; A second, case-insensitive pass over `auto-mode-alist' is time wasted.
;; No second pass of case-insensitive search over auto-mode-alist.
(setq auto-mode-case-fold nil)

(unless my-debug
  ;; Unset command line options irrelevant to the current OS. These options
  ;; are still processed by `command-line-1` but have no effect.
  (unless (eq system-type 'darwin)
    (setq command-line-ns-option-alist nil))
  (unless (memq initial-window-system '(x pgtk))
    (setq command-line-x-option-alist nil)))

(unless noninteractive
  ;; In PGTK, this timeout introduces latency. Reducing it from the default 0.1
  ;; improves responsiveness of childframes and related packages.
  (when (boundp 'pgtk-wait-for-event-timeout)
    (setq pgtk-wait-for-event-timeout 0.001))

  ;; Font compacting can be very resource-intensive, especially when rendering
  ;; icon fonts on Windows. This will increase memory usage.
  (setq inhibit-compacting-font-caches t)

  ;; Resizing the Emacs frame can be costly when changing the font. Disable this
  ;; to improve startup times with fonts larger than the system default.
  (setq frame-resize-pixelwise t)

  ;; Without this, Emacs will try to resize itself to a specific column size
  (setq frame-inhibit-implied-resize t)

  ;; Reduce *Message* noise at startup. An empty scratch buffer (or the
  ;; dashboard) is more than enough, and faster to display.
  (setq inhibit-startup-screen t
        inhibit-startup-echo-area-message user-login-name)
  (setq initial-buffer-choice nil
        inhibit-startup-buffer-menu t
        inhibit-x-resources t)

  ;; Disable startup screens and messages
  (setq inhibit-splash-screen t)

  ;; Disable bidirectional text scanning for a modest performance boost.
  (setq-default bidi-display-reordering 'left-to-right
                bidi-paragraph-direction 'left-to-right)

  ;; Give up some bidirectional functionality for slightly faster re-display.
  (setq bidi-inhibit-bpa t)

  ;; Remove "For information about GNU Emacs..." message at startup
  (advice-add 'display-startup-echo-area-message :override #'ignore)

  ;; Suppress the vanilla startup screen completely. We've disabled it with
  ;; `inhibit-startup-screen', but it would still initialize anyway.
  (advice-add 'display-startup-screen :override #'ignore))

;;; Performance: File-name-handler-alist

(defvar my--old-file-name-handler-alist (default-toplevel-value
					       'file-name-handler-alist))

(defun my--respect-file-handlers (fn args-left)
  "Respect file handlers.
FN is the function and ARGS-LEFT is the same argument as `command-line-1'.
Emacs processes command-line files very early in startup. These files may
include special paths like TRAMP paths, so restore `file-name-handler-alist' for
this stage of initialization."
  (let ((file-name-handler-alist (if args-left
                                     my--old-file-name-handler-alist
                                   file-name-handler-alist)))
    (funcall fn args-left)))

(defun my--restore-file-name-handler-alist ()
  "Restore `file-name-handler-alist'."
  (set-default-toplevel-value
   'file-name-handler-alist
   ;; Merge instead of overwrite to preserve any changes made since startup.
   (delete-dups (append file-name-handler-alist
                        my--old-file-name-handler-alist))))

(when (and my-optimize-file-name-handler-alist
           (not my-debug)
           (not noninteractive))
  ;; Determine the state of bundled libraries using calc-loaddefs.el. If
  ;; compressed, retain the gzip handler in `file-name-handler-alist`. If
  ;; compiled or neither, omit the gzip handler during startup for improved
  ;; startup and package load time.
  (set-default-toplevel-value
   'file-name-handler-alist
   (if (locate-file-internal "calc-loaddefs.el" load-path)
       nil
     (list (rassq 'jka-compr-handler
                  my--old-file-name-handler-alist))))

  ;; Ensure the new value persists through any current let-binding.
  (put 'file-name-handler-alist 'initial-value
       my--old-file-name-handler-alist)

  ;; Emacs processes command-line files very early in startup. These files may
  ;; include special paths TRAMP. Restore `file-name-handler-alist'.
  (advice-add 'command-line-1 :around #'my--respect-file-handlers)

  (add-hook 'emacs-startup-hook #'my--restore-file-name-handler-alist
            101))

;;; Performance: Inhibit redisplay

(defun my--reset-inhibit-redisplay ()
  "Reset inhibit redisplay."
  (setq-default inhibit-redisplay nil)
  (remove-hook 'post-command-hook #'my--reset-inhibit-redisplay))

(when (and my-inhibit-redisplay-during-startup
           (not noninteractive)
           (not my-debug))
  ;; Suppress redisplay and redraw during startup to avoid delays and
  ;; prevent flashing an unstyled Emacs frame.
  (setq-default inhibit-redisplay t)
  (add-hook 'post-command-hook #'my--reset-inhibit-redisplay -100))

;;; Performance: Inhibit message

(defun my--reset-inhibit-message ()
  "Reset inhibit message."
  (setq-default inhibit-message nil)
  (remove-hook 'post-command-hook #'my--reset-inhibit-message))

(when (and my-inhibit-message-during-startup
           (not noninteractive)
           (not my-debug))
  (setq-default inhibit-message t)
  (add-hook 'post-command-hook #'my--reset-inhibit-message -100))

;;; Performance: Disable mode-line during startup

(defvar-local my--hidden-mode-line nil
  "Store the buffer-local value of `mode-line-format' during startup.")

(when (and my-disable-mode-line-during-startup
           (not noninteractive)
           (not my-debug))
  (put 'mode-line-format
       'initial-value (default-toplevel-value 'mode-line-format))
  (setq-default mode-line-format nil)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (local-variable-p 'mode-line-format)
        (setq my--hidden-mode-line mode-line-format)
        (setq mode-line-format nil)))))

;;; Restore values

(defun my--startup-load-user-init-file (fn &rest args)
  "Advice to reset `mode-line-format'. FN and ARGS are the function and args."
  (unwind-protect
      ;; Start up as normal
      (apply fn args)
    ;; If we don't undo inhibit-{message, redisplay} and there's an error, we'll
    ;; see nothing but a blank Emacs frame.
    (when my-inhibit-message-during-startup
      (setq-default inhibit-message nil))
    (when my-inhibit-redisplay-during-startup
      (setq-default inhibit-redisplay nil))
    ;; Restore the mode-line
    (when my-disable-mode-line-during-startup
      (unless (default-toplevel-value 'mode-line-format)
        (setq-default mode-line-format (get 'mode-line-format
                                            'initial-value)))
      (dolist (buf (buffer-list))
        (with-current-buffer buf
          (when (local-variable-p 'my--hidden-mode-line)
            (setq mode-line-format my--hidden-mode-line)
            (kill-local-variable 'my--hidden-mode-line)))))))

(advice-add 'startup--load-user-init-file :around
            #'my--startup-load-user-init-file)

;;; UI elements

(defun my--setup-toolbar (&rest _)
  "Setup the toolbar."
  (when (fboundp 'tool-bar-setup)
    (advice-remove 'tool-bar-setup #'ignore)
    (when (bound-and-true-p tool-bar-mode)
      (funcall 'tool-bar-setup))))

(unless noninteractive
  (setq frame-title-format my-frame-title-format
        icon-title-format my-frame-title-format)

  ;; I intentionally avoid calling `menu-bar-mode', `tool-bar-mode', and
  ;; `scroll-bar-mode' because manipulating frame parameters can trigger or queue
  ;; a superfluous and potentially expensive frame redraw at startup, depending
  ;; on the window system. The variables must also be set to `nil' so users don't
  ;; have to call the functions twice to re-enable them.
  (unless (memq 'menu-bar my-ui-features)
    (push '(menu-bar-lines . 0) default-frame-alist)
    (unless (memq window-system '(mac ns))
      (setq menu-bar-mode nil)))

  (when (fboundp 'tool-bar-setup)
    ;; Temporarily override the tool-bar-setup function to prevent it from
    ;; running during the initial stages of startup
    (advice-add 'tool-bar-setup :override #'ignore)

    (advice-add 'startup--load-user-init-file :after
                #'my--setup-toolbar))

  (unless (memq 'tool-bar my-ui-features)
    (push '(tool-bar-lines . 0) default-frame-alist)
    (setq tool-bar-mode nil))

  (setq default-frame-scroll-bars 'right)
  (push '(vertical-scroll-bars) default-frame-alist)
  (push '(horizontal-scroll-bars) default-frame-alist)
  (setq scroll-bar-mode nil)

  (unless (memq 'tooltips my-ui-features)
    (when (bound-and-true-p tooltip-mode)
      (tooltip-mode -1)))

  ;; Disable GUIs because they are inconsistent across systems, desktop
  ;; environments, and themes, and they don't match the look of Emacs.
  (unless (memq 'dialogs my-ui-features)
    (setq use-file-dialog nil)
    (setq use-dialog-box nil)))

;;; Security

(setq gnutls-verify-error t)  ; Prompts if there are cert issues
(setq tls-checktrust gnutls-verify-error)  ; Ensure SSL/TLS connections checks
(setq gnutls-min-prime-bits 3072)  ; Stronger GnuTLS encryption


;;; Use package

;; This results in a more compact output that emphasizes performance
;; (setq use-package-expand-minimally t)
;; (setq use-package-minimum-reported-time (if my-debug 0 0.1))
;; (setq use-package-verbose my-debug)
;; (setq use-package-always-ensure (not noninteractive))
;; (setq use-package-enable-imenu-support t)

;;; package.el

(setq package-enable-at-startup nil)  ; Let the init.el file handle this
;; (setq package-quickstart-file
;;       (expand-file-name "package-quickstart.el" user-emacs-directory))
;; (setq package-archives '(("melpa"        . "https://melpa.org/packages/")
;;                          ("gnu"          . "https://elpa.gnu.org/packages/")
;;                          ("nongnu"       . "https://elpa.nongnu.org/nongnu/")
;;                          ("melpa-stable" . "https://stable.melpa.org/packages/")))
;; (setq package-archive-priorities '(("gnu"    . 99)
;;                                    ("nongnu" . 80)
;;                                    ("melpa"  . 70)
;;                                    ("melpa-stable" . 50)))

;;; --- old config ---

;; After emacs has started...
;; Tell us how long it took to start and how many times the GC ran
;; Reset the GC threshold to 8KB
;; (add-hook 'emacs-startup-hook
;;           (lambda ()
;;             (setq gc-cons-threshold my-backup-gc-cons-threshold)
;;             (setq gc-cons-percentage my-backup-gc-cons-percentage)
;;             (message "Emacs ready in %.2f seconds with %d garbage collections."
;;                      (float-time (time-subtract after-init-time before-init-time))
;;                      gcs-done)
;;             ))

;; Local variables:
;; byte-compile-warnings: (not free-vars)
;; End:

;;; early-init.el ends here

