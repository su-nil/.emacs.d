(setq user-full-name "Sunil KS"
      user-mail-address "kslvsunil@gmail.com")

(require 'server)
(if (not (server-running-p)) (server-start))

;; Garbage collection threshold and large file warning
(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)
(setq inhibit-compacting-font-caches t)

;; minimal UI
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)

(display-time-mode 1)
(global-hl-line-mode +1)
(column-number-mode t)
(size-indication-mode t)
;; (doom-modeline-mode 1)


;; Ease of Life
(fset 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode t)
(add-hook 'before-save-hook 'whitespace-cleanup)

;; disable startup screen
(setq inhibit-startup-screen t)

;; font
(add-to-list 'default-frame-alist '(font . "Victor Mono-15"))

;; frame size on start-up
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)

;; titlebar for MacOS
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-proxy-icon  nil)
(setq frame-title-format nil)

;; Prog mode hooks
(add-hook 'prog-mode-hook 'display-line-numbers-mode)


;;;; PACKAGE ;;;;
(require 'package)
(setq package-archives '(("org" . "http://orgmode.org/elpa/")
			 ("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
					   ("melpa-stable" . "http://stable.melpa.org/packages/")))
(package-initialize)
(setq package-enable-at-startup nil)

;; Bootstrap `use-package`
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(require 'diminish)
;; (require 'doom-modeline)

(use-package diminish
  :ensure t)

;; Evil
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(use-package evil-escape
  :ensure t
  :init
  (setq-default evil-escape-key-sequence "df"
		evil-escape-unordered-key-sequence "true")
  :config
  (evil-escape-mode 1))

;; Theme
 (use-package monokai-theme
  :ensure t
  :init
  :config
  (load-theme 'monokai t))

;; Helm
(use-package helm
  :ensure t
  :diminish helm-mode
  :init
  (setq helm-M-x-fuzzy-match t
	helm-mode-fuzzy-match t
	helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-match t
	helm-locate-fuzzy-match t
	helm-semantic-fuzzy-match t
	helm-imenu-fuzzy-match t
	helm-completion-in-region-fuzzy-match t
	helm-candidate-number-list 150
	helm-split-window-in-side-p t
	helm-move-to-line-cycle-in-source t
	helm-echo-input-in-header-line t
	helm-autoresize-max-height 0
	helm-autoresize-min-height 20)
  :config
  (helm-mode 1))



;; Which Key
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode 1))

;; Custom keybinding
(use-package general
  :ensure t
  :config (general-define-key
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "M-SPC"
  ;; "/"   '(counsel-rg :which-key "ripgrep") ; You'll need counsel package for this
  "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
  "SPC" '(helm-M-x :which-key "M-x")
  "ff"  '(helm-find-files :which-key "find files")
  ;; Buffers
  "bb"  '(helm-buffers-list :which-key "buffers list")
  ;; Window
  "wl"  '(windmove-right :which-key "move right")
  "wh"  '(windmove-left :which-key "move left")
  "wk"  '(windmove-up :which-key "move up")
  "wj"  '(windmove-down :which-key "move bottom")
  "w/"  '(split-window-right :which-key "split right")
  "w-"  '(split-window-below :which-key "split bottom")
  "wd"  '(delete-window :which-key "delete window")
  ;; Others
  "at"  '(ansi-term :which-key "open terminal")
))

;;;; Clojure ;;;;

;; Parinfer ;;
(use-package parinfer
  :defer t
  :ensure t
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
	  '(defaults       ; should be included.
	    pretty-parens  ; different paren styles for different modes.
	    evil           ; If you use Evil.
	    ;; lispy          ; If you use Lispy. With this extension, you should install Lispy and do not enable lispy-mode directly.
	    paredit        ; Introduce some paredit commands.
	    smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
	    smart-yank))   ; Yank behavior depend on mode.
    (add-hook 'clojure-mode-hook 'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook 'parinfer-mode)
    (add-hook 'common-lisp-mode-hook 'parinfer-mode)
    (add-hook 'scheme-mode-hook 'parinfer-mode)
    (add-hook 'lisp-mode-hook 'parinfer-mode)))

;; Paredit ;;
(use-package paredit
  :defer t
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
  (add-hook 'clojure-mode-hook 'paredit-mode)
  (add-hook 'lisp-interaction-mode-hook 'paredit-mode)
  (add-hook 'ielm-mode-hook 'paredit-mode)
  (add-hook 'lisp-mode-hook 'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook 'paredit-mode))

;; Clojure mode ;;
(use-package clojure-mode
  :defer t
  :ensure t
  :mode (("\\.clj\\'" . clojure-mode)
	 ("\\.edn\\'" . clojure-mode))
  :init
  ;; (add-hook 'clojure-mode-hook #'yas-minor-mode)
  ;; (add-hook 'clojure-mode-hook #'linum-mode)
  ;; (add-hook 'clojure-mode-hook #'subword-mode)
  (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode))

;; Cider ;;
(use-package cider
  :ensure t
  :defer t
  :init (add-hook 'cider-mode-hook #'clj-refactor-mode)
  :diminish subword-mode
  :config
  (setq nrepl-log-messages t
	cider-repl-display-in-current-window t
	cider-repl-use-clojure-font-lock t
	cider-prompt-save-file-on-load 'always-save
	cider-font-lock-dynamically '(macro core function var)
	nrepl-hide-special-buffers t
	cider-overlays-use-font-lock t)
  (cider-repl-toggle-pretty-printing))

;; Rainbow delimiteers ;;
(use-package rainbow-delimiters
  :defer t
  :ensure t
  :init
  (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode))

(use-package avy
  :ensure t
  :bind
  ("C-s" . avy-goto-char)
  :config
  (setq avy-background t))

(use-package company
  :defer t
  :ensure t
  :diminish company-mode
  :config
  (add-hook 'after-init-hook #'global-company-mode))

(use-package flycheck
  :defer t
  :ensure t
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package magit
  :defer t
  :bind (("C-M-g" . magit-status))
  :init)

(use-package projectile
  :ensure t
  :diminish projectile-mode
  :bind
  (("C-c p f" . helm-projectile-find-file)
   ("C-c p p" . helm-projectile-switch-project)
   ("C-c p s" . projectile-save-project-buffers))
  :config
  (projectile-mode +1)
)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package all-the-icons)

;; Disable backup files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

;; Remove bell sound
(setq visible-bell t)
(setq ring-bell-function 'ignore)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default)))
 '(package-selected-packages
   (quote
    (magit general which-key helm monokai-theme monokai evil-escape evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
