;; init.el --- Emacs configuration



;; install packages
;; --------------------------------------

;; Manually run the following command after having updated
;; the list of package-archives:
;; (package-refresh-contents)

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
    exec-path-from-shell
    elpy
    pyenv-mode
    multiple-cursors
    ido-vertical-mode
    smex
    pcre2el
    magit
;    material-theme
    solarized-theme
    )
  )

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
(column-number-mode t)             ;; add column number
(tool-bar-mode -1)                 ;; remove tool bar
(toggle-scroll-bar -1)             ;; remove scrollbar
(show-paren-mode t)                ;; highlight matching parenthesis
;; Remove useless whitespace before saving
(add-hook 'before-save-hook 'whitespace-cleanup)
;; On Mac, the 'fn' key should behave as the ctrl key
(setq ns-function-modifier 'control)
;; Use shell's $PATH
(exec-path-from-shell-copy-env "PATH")



;; Visible bell
;; --------------------------------------

(setq visible-bell nil
      ring-bell-function 'flash-mode-line)

(defun flash-mode-line ()
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))



;; Theme
;; --------------------------------------

;; Tron theme (doesn't display properly elpy completion)
;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;(setq tron-legacy-dark-fg-bright-comments t)
;(setq tron-legacy-vivid-cursor t)
;(load-theme `tron-legacy t)

;(load-theme 'solarized-light t)
(load-theme 'solarized-dark t)
;(load-theme 'material-light t)
;(load-theme 'material t)

;; Ensure that the mode-line of the active buffer is clearly visible.
;(custom-set-faces
; '(mode-line ((((class color) (min-colors 89)) (:inverse-video unspecified
;                                                :underline nil
;                                                :foreground "#fdf6e3"
;                                                :background "#b58900")))))



;; magit
;; --------------------------------------

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch)



;; enable elpy (enhanced python mode)
;; --------------------------------------

;; Packages to install: ipython jedi autopep8 flake8 importmagic yapf

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
(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))

;; to try in case of ^G
;(setq elpy-shell-echo-output nil
;      python-shell-interpreter "ipython"
;      python-shell-interpreter-args "--simple-prompt -c exec('__import__(\\'readline\\')') -i")



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



;; Find file&line at point
;; --------------------------------------

;; Look for a file name possibly followed by a line number.
;; Supported formats are:
;;  1- /Path/to/file:33
;;  2- /Path/to/file <anything-in-between> line 33
;;
;; C-x p: prefilled find-file + goto line.

(defun find-line-number-on-line()
  "Search for a pattern like ' line XXX' to determine the line number."
  (let* ((line (thing-at-point 'line t))
	 (line-number-string
	  (and (string-match " line:? +[0-9]+" line)
	       (substring line (+ 6 (match-beginning 0)) (match-end 0)))))
    line-number-string))

(defun find-line-number-after-colon()
  "Search for line number just after file separated by a ':'."
  (let* ((string (ffap-string-at-point))
	 (name
	  (or (condition-case nil
		  (and (not (string-match "//" string)) ; foo.com://bar
		       (substitute-in-file-name string))
		(error nil))
	      string))
	 (line-number-string
	  (and (string-match ":[0-9]+" name)
	       (substring name (1+ (match-beginning 0)) (match-end 0)))))
    line-number-string))

(defvar ffap-file-at-point-line-number nil
  "Variable to hold line number from the last `ffap-file-at-point' call.")

(defadvice ffap-file-at-point (after ffap-store-line-number activate)
  "Search `ffap-string-at-point' for a line number pattern and
save it in `ffap-file-at-point-line-number' variable."
  (let* ((line-number-string
	  (or (find-line-number-after-colon)
	      (find-line-number-on-line)))
	 (line-number
	  (and line-number-string
	       (string-to-number line-number-string))))
    ; Store the line number in ffap-file-at-point-line-numbe
    (if (and line-number (> line-number 0))
	(setq ffap-file-at-point-line-number line-number)
      (setq ffap-file-at-point-line-number nil))))

(defadvice find-file-at-point (after ffap-goto-line-number activate)
  "If `ffap-file-at-point-line-number' is non-nil goto this line."
  (when ffap-file-at-point-line-number
    (goto-line ffap-file-at-point-line-number)
    (setq ffap-file-at-point-line-number nil)))

;; Find file at point
(global-set-key (kbd "C-x p") 'find-file-at-point)



;; Better key bindings to change window
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
 '(custom-safe-themes
   (quote
    ("c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "39c9976a6483229aa6af04dccb2eceb4a3ac43d08f862099f60375511fd5ad9f" "ab7c93cc873a7717f2b78d2185f00e5e60e6759714253e3f6afb11271d36833f" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "732b807b0543855541743429c9979ebfb363e27ec91e82f463c91e68c772f6e3" "a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" default)))
 '(package-selected-packages
   (quote
    (vscode-dark-plus-theme solarized-theme smex pyenv-mode pcre2el multiple-cursors material-theme magit ido-vertical-mode exec-path-from-shell elpy better-defaults)))
 '(safe-local-variable-values
   (quote
    ((eval pyvenv-activate
	   (shell-command-to-string "poetry env info --path"))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
