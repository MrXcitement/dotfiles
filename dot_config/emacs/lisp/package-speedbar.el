;;; package-speedbar.el --- Configure the speedbar -*- lexical-binding: t -*-

;; Author: Mike Barker
;; Maintainer: Mike Barker
;; Version: 0.0.1
;; Package-Requires: (emacs > v30.x)
;; Homepage: homepage
;; Keywords: keywords


;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


;;; Commentary:

;; A simple configuration that changes speedbar to prefer running in
;; window attached to the current buffer. Previously to Emacs 31 the
;; only option you had was to run in it's own frame.

;;; Code:

(use-package speedbar
  :ensure nil
  :if (> emacs-major-version 30)
  :commands (speedbar)
  :config
  ;; By setting `speedbar-prefer-window' to true the `speedbar' will
  ;; show up in a window attached to the current buffer. If it is not
  ;; defined or set to `nil' then the `speedbar' will display in a
  ;; seperate frame.
  (setq speedbar-prefer-window t)
  (setq speedbar-window-default-width 120)

  ;; Turn off bitmap icons by setting `speedbar-use-image-button-alist' to `nil'
  (setq speedbar-use-images nil))

(provide 'package-speedbar)

;;; package-speedbar.el ends here
