;; init.el --- Emacs configuration



;; install packages
;; --------------------------------------

(require 'package)
(add-to-list 'package-archives
       '("melpa" . "https://melpa.org/packages/") t)

;; activate all packages
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; define list of packages to install
(defvar myPackages
  '(better-defaults
    material-theme
    exec-path-from-shell
    elpy
    pyenv-mode
    multiple-cursors
    ido-vertical-mode
    smex
    pcre2el))

;; install all packages in list
(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; Use shell's $PATH
(exec-path-from-shell-copy-env "PATH")



;; basic customization
;; --------------------------------------

(setq inhibit-startup-message t)   ;; hide the startup message
(setq initial-scratch-message "")  ;; scratch is an empty buffer
(load-theme 'material t)           ;; load material theme
(column-number-mode t)             ;; add column number
(tool-bar-mode -1)                 ;; remove tool bar
;; Remove useless whitespace before saving
(add-hook 'before-save-hook 'whitespace-cleanup)
;; On Mac, the 'fn' key should behave as the ctrl key
(setq ns-function-modifier 'control)



;; enable elpy (enhanced python mode)
;; --------------------------------------

;; C-c C-c: eval selection / buffer in (i)python shell
;; C-c C-z: launch (i)python shell
;; M-Tab: propose completion
;;   M-n / M-p: move through the various proposition
;; C-c C-d: display doc
;; M-.: goto definition

(elpy-enable)
(pyenv-mode)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")
(setq elpy-shell-echo-output nil)


;; multiple cursors
;; --------------------------------------

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



;; ido & smex configuration
;; --------------------------------------

;; memo:
;;  - C-j when enter should not use proposed choice
;;  - C-f to revert to 'old' find-file
;;  - C-b to revert to 'old' find-buffer
;;  - C-s / C-r to go forward/backward in the list of options
;;  - //, ~/ can be used in ido

(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; ido display choices vertically
(add-hook 'ido-setup-hook (lambda () (ido-vertical-mode 1)))

;; activate all packages
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; define list of packages to install
(defvar myPackages
  '(better-defaults
    material-theme
    exec-path-from-shell
    elpy
    pyenv-mode
    multiple-cursors
    ido-vertical-mode
    smex
    pcre2el
    ))

;; install all packages in list
(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; Use shell's $PATH
(exec-path-from-shell-copy-env "PATH")



;; basic customization
;; --------------------------------------

(setq inhibit-startup-message t)   ;; hide the startup message
(setq initial-scratch-message "")  ;; scratch is an empty buffer
(load-theme 'material t)           ;; load material theme
(column-number-mode t)             ;; add column number
(tool-bar-mode -1)                 ;; remove tool bar
;; Remove useless whitespace before saving
(add-hook 'before-save-hook 'whitespace-cleanup)
;; On Mac, the 'fn' key should behave as the ctrl key
(setq ns-function-modifier 'control)



;; enable elpy (enhanced python mode)
;; --------------------------------------

(elpy-enable)
(pyenv-mode)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")



;; multiple cursors
;; --------------------------------------

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



;; ido & smex configuration
;; --------------------------------------

;; memo:
;;  - C-j when enter should not use proposed choice
;;  - C-f to revert to 'old' find-file
;;  - C-b to revert to 'old' find-buffer
;;  - //, ~/ can be used in ido

(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; ido display choices vertically
(add-hook 'ido-setup-hook (lambda () (ido-vertical-mode 1)))
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

(autoload 'smex "smex"
  "Smex is a M-x enhancement for Emacs, it provides a convenient interface to
your recently and most frequently used commands.")

(global-set-key (kbd "M-x") 'smex)



;; perl like reg exp
;; --------------------------------------

;; == Perl like reg exp ==
;; Reminder: C-q C-j to insert new line in mini buffer
(global-set-key [(meta %)] 'pcre-query-replace-regexp)



;; elisp config
;; --------------------------------------

;; Key-binding to join lines
(global-set-key (kbd "M-j")
		(lambda ()
		  (interactive)
		  (join-line -1)))

;; Evaluate elisp in place
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



;; better key bindings to change window
;; --------------------------------------

(defun frame-bck()
  (interactive)
  (other-window -1))

(define-key (current-global-map) (kbd "M-o") 'other-window)
(define-key (current-global-map) (kbd "M-S-o") 'frame-bck)



;; Sticky mode
;; --------------------------------------

(define-minor-mode sticky-buffer-mode
  "Make the current window always display this buffer."
  nil " sticky" nil
  (set-window-dedicated-p (selected-window) sticky-buffer-mode))

(define-key (current-global-map) (kbd "C-S-o") 'sticky-buffer-mode)



;; backup file management
;; --------------------------------------

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



;; DO NOT EDIT BELOW THIS POINT
;; --------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (pyenv-mode elpy exec-path-from-shell material-theme better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
