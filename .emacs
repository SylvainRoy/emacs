;;
;; ==== Emacs config filel ====
;;

;; Packages to install with this .emacs:
;;  - ido-vertical
;;  - ido-ubiquitous
;;  - multiple-cursors
;;  - smex


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


;; == Package sources ==

;; Adding more sources of packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))


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


;; == Evaluate elisp in place

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
 '(custom-enabled-themes (quote (wombat)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
