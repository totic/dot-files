;; check syntax ruby

(require 'flymake)

;; I don't like the default colors :)
(set-face-background 'flymake-errline "red4")
(set-face-background 'flymake-warnline "dark slate blue")

;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
	 (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))

(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook 'ruby-mode-hook
          '(lambda ()
	     
	     ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
	     (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
		 (flymake-mode))
	     ))




;;auto-fill-mode is evil

;; PYTHON START
;;(load-file "~/.emacs.d/emacs-for-python/epy-init.el")

;; (add-to-list 'load-path "~/.emacs.d/emacs-for-python/") ;; tell where to load the various files
;; (require 'epy-setup) ;; It will setup other loads, it is required!
;; (require 'epy-python) ;; If you want the python facilities [optional]
;; (require 'epy-completion) ;; If you want the autocompletion settings [optional]
;; (require 'epy-editing) ;; For configurations related to editing [optional]
;; (require 'epy-bindings) ;; For my suggested keybindings [optional]
;; PYTHON END

(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/emacs.d/lisp/")

(setq backup-directory-alist '(("." . ".~")))
(setq visible-bell t)			; no beeping


(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)


;; uniquify changes conflicting buffer names from file<2> etc
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::
;;                   GIT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::
(setq global-auto-revert-mode t)


(defun purge-obsolete-buffers()
  (interactive)
  "Kill all buffers that are visiting a file, but whose file no longer exists."
  (let (victims)
    (mapc
     (lambda (b)
       (with-current-buffer b
         (cond

          ;; an ordinary file-visiting buffer
          ((and buffer-file-name
                (not (file-exists-p buffer-file-name)))
           (setq victims (cons buffer-file-name victims))
           (kill-buffer b))

          ;; maybe a dired buffer
          ((not (file-exists-p default-directory))
           (setq victims (cons (format "Buffer %s in directory %s" (buffer-name) default-directory) victims))
           (kill-buffer b)))))
     (buffer-list))
    (if victims
        (message "Killed %S" victims)
      (message "No obsolete buffers; did nothing."))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ace mode https://github.com/winterTTr/ace-jump-mode/wiki
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/ace-jump-mode/")
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Colors in command line
(ansi-color-for-comint-mode-on) 
;; (set-face-font 'default "-xos4-terminus-medium-r-normal-*-12-120-72-72-c-60-iso8859-*")
(set-cursor-color "red")

(add-to-list 'load-path "/Users/federico/.emacs.d/emacs-goodies-el-30.3/elisp/emacs-goodies-el")


(add-to-list 'load-path "/Users/federico/.emacs.d/color-theme-6.6.0/")

(require 'color-theme)

(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))


;;Iswitchb mode
(iswitchb-mode 1)


(defun iswitchb-local-keys ()
  (mapc (lambda (K) 
	  (let* ((key (car K)) (fun (cdr K)))
	    (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
	'(("<right>" . iswitchb-next-match)
	  ("<left>"  . iswitchb-prev-match)
	  ("<up>"    . ignore             )
	  ("<down>"  . ignore             ))))
(add-hook 'iswitchb-define-mode-map-hook 'iswitchb-local-keys)

;;Winner
(winner-mode t)


;;CEDET
(load-file "/Users/federico/.emacs.d/cedet-1.0/common/cedet.el")
(global-ede-mode 1)		; Enable the Project management system
(semantic-load-enable-code-helpers) ; Enable prototype help and smart completion 
(global-srecode-minor-mode 1)     

;;ECB
(add-to-list 'load-path
	     "/Users/federico/.emacs.d/ecb")

(load-file "/Users/federico/.emacs.d/ecb/ecb.el")

(require 'ecb)

(setq ri-ruby-script "/Users/federico/.emacs.d/ri-emacs.rb")
(autoload 'ri "/Users/federico/.emacs.d/ri-ruby.el" nil t)

(add-hook 'ruby-mode-hook (lambda ()
			    (local-set-key 'f1 'ri)
			    (local-set-key "\M-\C-i" 'ri-ruby-complete-symbol)
			    (local-set-key 'f4 'ri-ruby-show-args)
			    ))


;;Rinari


(require 'ido)
(ido-mode t)
     
(add-to-list 'load-path "/Users/federico/.emacs.d/rinari")
(require 'rinari)


;;Yasnippet
;;(add-to-list 'load-path
;;            "/Users/federico/.emacs.d/yasnippet-0.6.1c/yasnippet.el")

;;(require 'yasnippet-bundle)

;;(require 'yasnippet) ;; not yasnippet-bundle
;;(setq yas/root-directory 
;;            "/Users/federico/.emacs.d/yasnippet-0.6.1c/snippets/")


;;(yas/initialize)
;;(yas/load-directory 
;;  "/Users/federico/.emacs.d/yasnippet-0.6.1c/snippets/")

(require 'setnu)
					;(require 'linum+)

;;;;;;;;;;;AUTO INDENT


;;;.........



					;(require 'ecb-autoloads)



;;IDO MODE HI!
					;(require 'ido)
					;(ido-mode t)

;;(add-to-list 'load-path "~/emacs.d/tramp/lisp/")
;;(require 'tramp)
					;(setq tramp-default-method "scp")

;;(setq inhibit-startup-message t)


;;(add-to-list 'load-path "~/.emacs.d/php-mode-1.5.0/")
;;(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
;;(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
;;(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
;;(require 'php-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; RUBY ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts." t)
(setq auto-mode-alist  (cons '(".rb$" . ruby-mode) auto-mode-alist))
;;(setq auto-mode-alist  (cons '(".rhtml$" . html-mode) auto-mode-alist))

;; totic29, C-h v load-path RET

(add-to-list 'load-path "~/.emacs.d/ruby-mode")
(require 'ruby-mode)


;;(setq load-path (cons (expand-file-name "~/.emacs.d/rails-reloaded") load-path))
;;(require 'rails-autoload)


;;(require 'ruby-electric)

;;(add-to-list 'load-path "~/.emacs.d/plugins")
;;(require 'yasnippet-bundle)

;;(add-to-list 'load-path "~/.emacs.d/rinari")
;;(require 'rinari)

;;(require 'ruby-block)
;;(ruby-block-mode t)
;;(setq ruby-block-highlight-toggle 'overlay)
;;(setq ruby-block-highlight-toggle 'minibuffer)
;;(setq ruby-block-highlight-toggle t)


;;(defun ruby-eval-buffer () (interactive)
;;    "Evaluate the buffer with ruby."
;;   (shell-command-on-region (point-min) (point-max) "ruby"))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Minimap
;;(require 'minimap)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;w3m


;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/apel-10.7/"))
;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/flim-1.14.6/"))
;; ;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/emacs-w3m-1.4.4/"))

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/W3m/emacs-w3m/"))
;; ;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/w3m-not/emacs-w3m"))
;; (require 'w3m-load)
;; (require 'mime-w3m)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Browswer

;;(load-file "~/.emacs.d/cedet-1.0pre6/common/cedet.el")
;;(global-ede-mode 1)

;;(add-to-list 'load-path "~/.emacs.d/ecb-2.40/")

;;(load-file "~/.emacs.d/ecb-2.40/ecb.el")



;;(require 'ecb)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(delete-selection-mode 1)

(show-paren-mode 1)

(require 'saveplace)
(setq-default save-place t)

;;(icomplete-mode 99)

;;(partial-completion-mode t)

(defun reload-my-dot-emacs-file () "" (interactive "")
  (load "~/.emacs"))
(global-set-key [?\M-r] 'reload-my-dot-emacs-file)

(fset 'yes-or-no-p 'y-or-n-p)

(setq font-lock-maximum-decoration t)

(savehist-mode t)
;;(tool-bar-mode -1)
(menu-bar-mode -1)

;; (load "folding-config")

;;< dabbrev
(define-key global-map (read-kbd-macro "M-RET") 'hippie-expand)
					;(setq dabbrev-search-these-buffers-only '("thesis\.bibkeys"))
(setq dabbrev-case-fold-search nil)
;;> 


(global-set-key [?\C-j] 'fill-paragraph)
(global-set-key [?\M-g] 'goto-line)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Javascript mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(autoload 'javascript-mode "javascript" nil t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Java mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Latex mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; /Users/federico/.emacs.d/auctex

(add-to-list 'load-path (expand-file-name "~/.emacs.d/auctex/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/auctex/preview/"))

(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

(require 'tex-mik)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
;;(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs backups
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Turn off the annoying default backup behaviour
(if (file-directory-p "~/.emacs.d/backup")
    (setq backup-directory-alist '(("." . "~/.emacs.d/backup")))
  (message "Directory does not exist: ~/.emacs.d/backup"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Icicles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/icicles/"))
;;(require 'icicles)
;;(icy-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-to-list 'gnus-secondary-select-methods '(nnimap "gmail"
;;                                  (nnimap-address "imap.gmail.com")
;;                                  (nnimap-server-port 993)
;;                                  (nnimap-stream ssl)))

;; (add-to-list 'load-path "/path/to/kill-ring-search")

(autoload 'kill-ring-search "kill-ring-search"
  "Search the kill ring in the minibuffer."
  (interactive))

(global-set-key "\M-\C-y" 'kill-ring-search)


;; (require 'flymake)

;; ;; I don't like the default colors :)
;; (set-face-background 'flymake-errline "red4")
;; (set-face-background 'flymake-warnline "dark slate blue")

;; ;; Invoke ruby with '-c' to get syntax checking
;; (defun flymake-ruby-init ()
;;   (let* ((temp-file   (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;; 	  (local-file  (file-relative-name
;;                        temp-file
;;                        (file-name-directory buffer-file-name))))
;;     (list "ruby" (list "-c" local-file))))

;; (push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
;; (push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

;; (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

;; (add-hook 'ruby-mode-hook
;;           '(lambda ()
;; 	     ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
;; 	     (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
;; 		 (flymake-mode))
;; 	     ))
;; (custom-set-variables
;;   ;; custom-set-variables was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  '(ecb-options-version "2.40"))
;; (custom-set-faces
;;   ;; custom-set-faces was added by Custom.
;;   ;; If you edit it by hand, you could mess it up, so be careful.
;;   ;; Your init file should contain only one such instance.
;;   ;; If there is more than one, they won't work right.
;;  )
;;(custom-set-variables
;; custom-set-variables was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
;; '(safe-local-variable-values (quote ((encoding . utf-8)))))
;; (custom-set-faces
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
;; '(mode-line ((t (:background "wheat" :foreground "red" :family "neep")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(gud-gdb-command-name "gdb --annotate=1")
 '(large-file-warning-threshold nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(put 'downcase-region 'disabled nil)


;; EMACS _ ECLIM


;;(add-to-list 'load-path (expand-file-name "/Users/federico/.emacs.d/emacs-eclim/"))
;; only add the vendor path when you want to use the libraries provided with emacs-eclixm
;;(add-to-list 'load-path (expand-file-name "/Users/federico/.emacs.d/emacs-eclim/vendor"))
;;(require 'eclim)

;;b(setq eclim-auto-save t)
;;(global-eclim-mode)