
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory com
(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(package-initialize)

;;
;; General emacs
;;

(setq inhibit-startup-screen t)
(fset 'yes-or-no-p 'y-or-n-p)


(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

(setq default-directory "/home/schles/dev")

;;(desktop-save-mode 1)
(global-linum-mode 1)
(show-paren-mode 1)
;; (setq show-paren-delay 0)


(defadvice linum-update-window (around linum-dynamic activate)
  (let* ((w (length (number-to-string
                     (count-lines (point-min) (point-max)))))
         (linum-format (concat " %" (number-to-string w) "d ")))
    ad-do-it))

(require 'hlinum)
(hlinum-activate)

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; load themes
(add-to-list 'custom-theme-load-path' "~/.emacs.d/themes/")



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "d8f76414f8f2dcb045a37eb155bfaa2e1d17b6573ed43fb1d18b936febc7bbc2" "98cc377af705c0f2133bb6d340bf0becd08944a588804ee655809da5d8140de6" default)))
 '(package-selected-packages
   (quote
    (git-gutter-fringe ## git-gutter rainbow-delimiters magit smart-mode-line flx-ido auctex js3-mode web-mode undo-tree hlinum spacegray-theme flycheck-irony flycheck company-c-headers company-irony irony-eldoc projectile ag dumb-jump auto-complete irony yasnippet))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight ((t (:background "#343d46" :foreground "#ffffff" :inverse-video nil :underline nil)))))

;; load theme
(load-theme 'spacegray t)

;; change font of modeline
(set-face-attribute 'mode-line nil :font "DejaVu Sans Mono-11")


;; flex ido mode
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)
(add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets")
;; dumb-jump
(dumb-jump-mode t)


;;
;; Linter
;;

(require 'flycheck)

(global-flycheck-mode t)

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))



;;
;; Compilation
;;

(setq special-display-buffer-names
      `(("*compilation*" . ((name . "*compilation*")
                            ,@default-frame-alist
                            (left . (- 1))
                            (top . 0)))))


(setq compilation-scroll-output t)

;;
;; C / C++
;;


;; Irony Mode
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)


;; company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)


;; set company backends

(add-to-list 'company-backends 'company-c-headers)
(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
(setq company-backends (delete 'company-semantic company-backends))

(require 'company-irony-c-headers)
(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers company-irony)))



;; load scripts?
(add-to-list 'load-path "~/.emacs.d/lisp")

;;
;; Keybindings
;;


(global-set-key (kbd "C-c g") 'dumb-jump-go)
(global-set-key (kbd "C-c p") 'dumb-jump-back)
(global-set-key [f8] 'recompile)


(global-set-key (kbd "M-b") 'ido-switch-buffer)
(global-set-key (kbd "M-B") 'ido-switch-buffer-other-window)

(global-set-key (kbd "M-w") 'other-window)
(global-set-key (kbd "M-W") 'other-frame)

(global-set-key (kbd "C-c o") 'ff-find-other-file)

(global-set-key (kbd "M-f") 'ido-find-file)
(global-set-key (kbd "M-F") 'ido-find-file-other-window)

(global-set-key (kbd "M-u") 'undo)

(global-set-key (kbd "M-k") 'kill-buffer)

(global-set-key (kbd "M-s") 'save-buffer)


(global-set-key (kbd "C-w") 'kill-ring-save)
(global-set-key (kbd "C-q") 'kill-region)
(global-set-key (kbd "C-f") 'yank)

(global-set-key (kbd "C-SPC") 'company-complete)


;;
;; Modeline
;;



(setq-default mode-line-format (list

				;; size of file
				" ( "
				(propertize "%p" 'face 'font-lock-constant-face)
				" / "
				(propertize "%I" 'face 'font-lock-constant-face) ;; size
				" )    "
				
				;; the buffer name; the file name as a tool tip
				'(:eval (propertize "%b " 'face 'font-lock-keyword-face
						    'help-echo (buffer-file-name)))


				;; Buffer changed, read only?
				'(:eval (propertize "%*"
						    'face 'font-lock-warning-face
						    'help-echo "Buffer has been modified"))

				"   "
				
				" ( "
				;; line and column
				"%02l"  ":" "%02c" 
				" ) "

				
				"   "
				
				'(:eval (propertize "%m" 'face 'font-lock-string-face
						    'help-echo buffer-file-coding-system))


				`(flycheck-mode flycheck-mode-line) 
				
				"   "
				
				`(vc-mode vc-mode)

				"   "

				mode-line-misc-info
   
   )
)





;;
;; Web Config
;;

(require 'web-mode)

(require 'json)


