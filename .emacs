; No more tool bar
(tool-bar-mode -1)

;; Emacs usually has a splash screen on startup.  Let's get rid of
;; that and start with a blank buffer.
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

; Temporary files cluttering up the space are annoying.  Here's how we
; can deal with them -- create a directory in your home directory, and
; save to there instead!  No more random ~ files.
(defvar user-temporary-file-directory
  "~/.emacs-autosaves/")
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
        (tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

;; Line numbers are good.  Getting column numbering as well is better.
(column-number-mode t)

;; Position of the vertical scrollbar. Useful for left-handers.
(set-scroll-bar-mode 'right)

;; Auto load html mode with .tmpl files
(setq auto-mode-alist
      (nconc
       '(("\\.tmpl$" . html-mode))
       auto-mode-alist))

;; Adding more sources of packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;; multiple-cursors.el
(eval-after-load "multiple-cursors-autoloads"
  '(progn
     (if (require 'multiple-cursors nil t)
	 (progn
	   (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
	   (global-set-key (kbd "C-,") 'mc/mark-next-like-this)
	   (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
	   (global-set-key (kbd "C-c C-,") 'mc/mark-all-like-this)
	   )
       (warn "multiple-cursors was not found.")
       )))
