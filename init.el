;;
;; ==== Emacs config filel ====
;;

;; Packages to install with this .emacs:
;;  - ido-vertical
;;  - ido-ubiquitous
;;  - multiple-cursors
;;  - smex
;;  - pcre2el
;;  - yasnippet
;;  - elpy
;;  - ein


;; == Misc customizations ==

;; Line numbers are good.  Getting column numbering as well is better.
(column-number-mode t)

;; Position of the vertical scrollbar.
(set-scroll-bar-mode 'right)

; No more tool bar
(tool-bar-mode -1)

;; Emacs usually has a splash screen on startup.  Let's get rid of
;; that and start with a blank buffer.
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

;; Remove useless whitespace before saving
(add-hook 'before-save-hook 'whitespace-cleanup)

;; On Mac, the 'fn' key should behave as the ctrl key
(setq ns-function-modifier 'control)

;; == Package sources ==

;; Adding more sources of packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))


;; == Ein ==

;; memo:
;;  - Start by "M-X ein:notebook-list-open"
;;  - then, everyting's in the menus


;; == Multiple Cursors ==

;; memo:
;;  - `mc/insert-numbers`: Insert increasing numbers for each cursor, top to bottom.
;;  - Sometimes you end up with cursors outside of your view. You can
;;    scroll the screen to center on each cursor with `C-v` and `M-v`.
;;  - If you get out of multiple-cursors-mode and yank - it will yank only
;;    from the kill-ring of main cursor. To yank from the kill-rings of
;;    every cursor use yank-rectangle, normally found at C-x r y.

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


;; == Perl like reg exp ==
;; Reminder: C-q C-j to insert new line in mini buffer
(global-set-key [(meta %)] 'pcre-query-replace-regexp)



;; == Better completion with Ido ==

;; memo:
;;  - C-j when enter should not use proposed choice

(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; ido display choices vertically
(add-hook 'ido-setup-hook (lambda () (ido-vertical-mode 1)))

;; wider usage of ido
(add-hook 'ido-setup-hook (lambda () (ido-ubiquitous-mode 1)))


;; == Smex ==

(autoload 'smex "smex"
  "Smex is a M-x enhancement for Emacs, it provides a convenient interface to
your recently and most frequently used commands.")

(global-set-key (kbd "M-x") 'smex)


;; == Join lines ==

;; Key-binding to join lines
(global-set-key (kbd "M-j")
		(lambda ()
		  (interactive)
		  (join-line -1)))


;; == snippets ==

; todo: refine snippets. Use .yas-parents files to have a root directory for all mode for e.g. email, name, etc.
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))
(add-hook 'after-init-hook 'init-yasnippet-hook)
(defun init-yasnippet-hook ()
  (require 'yasnippet)
  (yas-global-mode 1)
  )


;; == Evaluate elisp in place ==

(defun eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
	     (current-buffer))
    (error (message "Invalid expression")
	   (insert (current-kill 0)))))

(global-set-key (kbd "C-S-j")
		'eval-and-replace)


;; == Better key bindings to change window ==

(defun frame-bck()
  (interactive)
  (other-window -1))

(define-key (current-global-map) (kbd "M-o") 'other-window)
(define-key (current-global-map) (kbd "M-S-o") 'frame-bck)


;; == Sticky mode ==

(define-minor-mode sticky-buffer-mode
  "Make the current window always display this buffer."
  nil " sticky" nil
  (set-window-dedicated-p (selected-window) sticky-buffer-mode))

(global-set-key [pause] 'sticky-buffer-mode)


;; == Auto load mode ==

;; Auto load html mode with .tmpl files
(setq auto-mode-alist
      (nconc
       '(("\\.tmpl$" . html-mode))
       auto-mode-alist))


;; == recent files mode ==

(recentf-mode 1) ; keep a list of recently opened files
(global-set-key (kbd "<f7>") 'recentf-open-files)
(recentf-open-files) ; start with recent files screen


;; == Activate elpy (a better python mode) ==
(package-initialize)
(elpy-enable)
(elpy-use-ipython)


;; == Backup file management ==

; Locate all backup files in one place.
(defvar user-temporary-file-directory "~/.emacs-autosaves/")
(make-directory user-temporary-file-directory t)
;; (setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
	(tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))


;; == Do not edit below this point ==

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes (quote (misterioso)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 98 :width normal)))))
