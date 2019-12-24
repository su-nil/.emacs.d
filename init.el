;;; User details
(setq user-full-name "Sunil KS"
      user-mail-address "kslvsunil@gmail.com")

(require 'server)
(if (not (server-running-p)) (server-start))

;; Garbage collection threshold and large file warning
(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)

;; Disable backup files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files
(add-to-list 'exec-path "/usr/local/bin")

;;; UI

;; toggle off
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(show-paren-mode 1)

;; toggle on
(display-time-mode 1)
(global-hl-line-mode +1)
(column-number-mode t)
(size-indication-mode t)

;; disable startup screen
(setq inhibit-startup-screen t)
;; (add-hook 'after-init-hook 'org-agenda-list)
(setq initial-buffer-choice
      (lambda ()
	(org-agenda-list 1)
	(delete-other-windows)
	(get-buffer "*Org Agenda*")))

;; disable emacs error sounds instead enable visible bell
(setq ring-bell-function 'ignore)
(setq visible-bell t)

;; Highlight the whole expression when cursor is on the bracket
(setq show-paren-style 'expression)
;; font
(add-to-list 'default-frame-alist '(font . "Victor Mono-13"))

;; frame size on start-up
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)

;; titlebar for MacOS
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-proxy-icon  nil)
(setq frame-title-format nil)

;; unset keys
;; (global-unset-key (kbd "q"))
(global-set-key (kbd "C-;") 'comment-line)
;; make things easy
(fset 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode t)
(add-hook 'before-save-hook 'whitespace-cleanup)

;; prog-mode hooks
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; org settings
;; (setq org-agenda-files '("~/Documents/org/"))

;;; PACKAGE
(require 'package)
(setq package-archives
      '(("org" . "http://orgmode.org/elpa/")
	      ("gnu" . "http://elpa.gnu.org/packages/")
	      ("melpa" . "https://melpa.org/packages/")
	      ("melpa-stable" . "http://stable.melpa.org/packages/")))
(package-initialize)
(setq package-enable-at-startup nil)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; install and config packages
(use-package diminish
  :ensure t)

(use-package use-package-chords
  :ensure t
  :config
  (key-chord-mode 1))

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

(use-package expand-region
  :ensure t
  :bind
  (("C--" . er/contract-region)
   ("C-=" . er/expand-region)))

(use-package helm
  :ensure t
  :defer t
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
	helm-autoresize-min-height 20
	helm-move-to-line-cycle-in-source t)
  :config
  (helm-mode 1))

(use-package helm-ag
  :ensure t)

(use-package helm-swoop
  :ensure t
  :defer 2
  :init
  (setq helm-swoop-split-with-multiple-windows t
	helm-swoop-split-direction 'split-window-vertically
	helm-swoop-speed-or-color t))

(use-package helm-projectile
  :ensure t
  :defer 2)

(use-package which-key
  :ensure t
  :defer 0.2
  :diminish which-key-mode
  :init
  (setq which-key-separator " ➜ "
	which-key-prefix-prefix "+"
	which-key-add-column-padding 2
	which-key-sort-order 'which-key-prefix-then-key-order
	which-key-idle-delay 0.01)
  :config
  (which-key-mode 1))

;; custom keybindings
(use-package general
  :ensure t
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "SPC" '(helm-M-x :which-key "M-x")
   "TAB" '(ace-window :which-key "ace-window")
   "'"   '(eshell :which-key "terminal")

   ;; Buffer
   "b"   '(:ignore t :which-key "buffers")
   "bp"  '(previous-buffer :which-key "previous-buffer")
   "bn"  '(next-buffer :which-key "next-buffer")
   "bb"  '(helm-buffers-list :which-key "helm-buffers-list")
   "bd"  '(kill-this-buffer :which-key "kill-this-buffer")
   "bx"  '(kill-buffer-and-window :which-key "kill-buffer-and-window")
   "bN"  '(evil-buffer-new :which-key "evil-buffer-new")
   "bq"  '(read-only-mode :which-key "read-only-mode")
   "bs"  '(save-buffer :which-key "save-buffer")

   "d" '(:ignore t :which-key "treemacs")
   "dd" '(treemacs :which-key "treemacs")


   ;; File
   "f"   '(:ignore t :which-key "files")
   "ff"  '(helm-find-files :which-key "find files")
   "fw"  '(evil-write :which-key "evil-write")
   "fi"  '((lambda () (interactive) (find-file user-init-file)) :which-key "edit init file")
   "fo"  '(find-file-other-window :which-key "find-file-other-window")

   ;; Frame
   "F"    '(:ignore t :which-key "frame")
   "Ff"   '(make-frame :which-key "make-frame")
   "Fd"   '(delete-frame :which-key "delete-frame")

   ;; Git
   "g"   '(:ignore t :which-key "git")
   "gb"  '(magit-branch :which-key "magit-branch")
   "gc"  '(magit-clone :whcih-key "magit-clone")
   "gs"  '(magit-status :which-key "magit-status")
   "gi"  '(magit-init :which-key "magit-init")
   "gS"  '(magit-stage-file :which-key "magit-stage-file")
   "gU"  '(magit-unstage-file :which-key "magit-unstage-file")
   "gp"  '(magit-pull :which-key "magit-pull")
   "gP"  '(magit-push :which-key "magit-push")
   "gt"  '(magit-stash :which-key "magit-stash")
   "gm"  '(magit-merge :which-key "magit-merge")

   ;; Jump to definition
   "j"   '(:ignore t :which-key "dumb-jump")
   "jj"  '(dumb-jump-go :which-key "dumb-jump-go")
   "jp"  '(dumb-jump-back :which-key "dumb-jump-back")
   "jo"  '(dumb-jump-go-other-window :which-key "dumb-jump-go-other-window")

   ;; Quit
   "k"   '(:ignore t :which-key "quit")
   "kk"  '(kill-emacs :which-key "kill-emacs")

   ;; org mode
   "o"  '(:ignore t :which-key "org")

   ;; projects
   "p"   '(:ignore t :which-key "projects")
   "pf"  '(helm-projectile-find-file :which-key "helm-projectile-find-file")
   "pp"  '(helm-projectile :which-key "helm-projectile")
   "ps"  '(helm-projectile-switch-project :which-key "helm-projectile-switch-project")
   "pd"  '(helm-projectile-find-dir :which-key "helm-projectile-find-dir")
   "pg"  '(helm-projectile-grep :which-key "helm-projectile-grep")

   ;; Search
   "s"   '(:ignore t :which-key "search")
   "ss"  '(helm-swoop-without-pre-input :which-key "helm-swoop-without-pre-input")
   "si"  '(helm-swoop :which-key "helm-swoop")

   ;; Toggle
   "t"   '(:ignore t :which-key "toggle")
   "tr"  '(rainbow-delimiters-mode :which-key "rainbow-delimiter-mode")

   ;; Window
   "w"   '(:ignore t :which-key "windows")
   "wl"  '(evil-window-right :which-key "evil-window-right")
   "wh"  '(evil-window-left :which-key "evil-window-left")
   "wk"  '(evil-window-up :which-key "evil-window-up")
   "wj"  '(evil-window-down :which-key "evil-window-down")
   "w/"  '(split-window-right :which-key "split-window-right")
   "w-"  '(split-window-below :which-key "split-window-below")
   "wd"  '(delete-window :which-key "delete-window")
   "wo"  '(delete-other-windows :which-key "delete-other-windows")

   ;; Zoom
   "z"  '(:ignore t :which-key "zoom")
   "z=" '(text-scale-increase :which-key "text-scale-increase")
   "z-" '(text-scale-decrease :which-key "text-scale-decrease")))

(use-package paredit
  :defer t
  :ensure t
  :init
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
  (add-hook 'clojure-mode-hook 'paredit-mode)
  (add-hook 'cider-repl-mode 'paredit-mode)
  (add-hook 'lisp-interaction-mode-hook 'paredit-mode)
  (add-hook 'ielm-mode-hook 'paredit-mode)
  (add-hook 'lisp-mode-hook 'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook 'paredit-mode))

(use-package flycheck
  :defer t
  :ensure t
  :diminish flycheck-mode)

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clj-refactor
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'clj-refactor-mode))

(use-package clojure-mode
  :defer t
  :ensure t
  :mode
  (("\\.clj\\'" . clojure-mode)
   ("\\.edn\\'" . clojure-mode))
  :config
  (require 'flycheck-clj-kondo))

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

(use-package aggressive-indent
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'aggressive-indent-mode))

(use-package rainbow-delimiters
  :ensure t
  :defer 2
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package company
  :defer 2
  :ensure t
  :diminish company-mode
  :hook
  (after-init . global-company-mode))

(use-package magit
  :ensure t
  :defer t)

(use-package projectile
  :ensure t
  :defer t
  :diminish projectile-mode
  :config
  (projectile-mode 1)
  (setq projectile-use-git-grep 1)
  (setq projectile-switch-project-action 'helm-projectile-find-file))

(use-package all-the-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-snazzy t)
  ;; (doom-themes-visual-bell-config)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package ace-window
  :ensure t
  :defer t)

(use-package dumb-jump
  :ensure t
  :defer 5
  :init
  (dumb-jump-mode 1)
  :config
  (setq dumb-jump-selector 'helm))

(use-package golden-ratio
  :ensure t
  :defer t
  :init
  (golden-ratio-mode 1)
  :config
  (add-to-list 'golden-ratio-extra-commands 'ace-window)
  (setq golden-ratio-recenter t))

(use-package org
  :ensure t
  :defer t
  :mode
  ("\\.org" . org-mode))

(use-package yaml-mode
  :defer t
  :ensure t
  :mode
  (("\\.yml\\'" . yaml-mode)))

(use-package treemacs
  :defer t
  :ensure t)

(use-package treemacs-evil
  :defer t
  :ensure t)

(use-package treemacs-projectile
  :defer t
  :ensure t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" default)))
 '(golden-ratio-mode t)
 '(package-selected-packages
   (quote
    (treemacs-projectile treemacs-evil treemacs yaml-mode move-text zoom dumb-jump helm-ag helm-projectile clj-refactor all-the-icons-dired helm-cider magit flycheck-clj-kondo golden-ratio expand-region doom-themes helm-swoop general which-key helm monokai-theme monokai evil-escape evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; custom-set-faces was added by Custom.
;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.


;; (use-package monokai-theme
;;  :ensure t
;;  :init
;;  :config
;;  (load-theme 'monokai t))

;; Parinfer ;;
;; (use-package parinfer
;;   :defer t
;;   :ensure t
;;   :bind
;;   (("C-," . parinfer-toggle-mode))
;;   :init
;;   (progn
;;     (setq parinfer-extensions)
;;     '(defaults       ; should be included.
;;       pretty-parens  ; different paren styles for different modes.
;;       evil           ; If you use Evil.
;;       paredit        ; Introduce some paredit commands.
;;       smart-tab      ; C-b & C-f jump positions and smart shift with tab & S-tab.
;;       smart-yank)   ; Yank behavior depend on mode.
;;     (add-hook 'clojure-mode-hook 'parinfer-mode)
;;     (add-hook 'emacs-lisp-mode-hook 'parinfer-mode)
;;     (add-hook 'common-lisp-mode-hook 'parinfer-mode)
;;     (add-hook 'scheme-mode-hook 'parinfer-mode)
;;     (add-hook 'lisp-mode-hook 'parinfer-mode)))


;;  (use-package undo-tree
;;   :ensure t
;;   :chords (("uu" . undo-tree-visualize))
;;   :diminish undo-tree-mode
;;   :config
;;   (global-undo-tree-mode 1))

;; (use-package move-text
;;   :ensure t
;;   :defer 5
;;   :config
;;   (move-text-default-bindings))
