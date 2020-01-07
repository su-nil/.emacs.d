;; turn up the memory threshold to prevent garbage collection from running during startup
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.8)

;; https://blog.d46.us/advanced-emacs-startup/
(defvar default--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; http://bling.github.io/blog/2016/01/18/why-are-you-changing-gc-cons-threshold/
;; Avoid garbage collection when minibuffer is open
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 16777216))

(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

  ;; Move custom-config to a seperate file
;; (setq custom-file "~/.emacs.d/custom.el")

  ;;load all customizations from config.org

  ;;load manual customizations
;; (load custom-file 'noerror)

  ;; load user customizations
;; (when (file-exists-p "~/.emacs.d/init-user.el")
;;   (setq user-custom-file "~/.emacs.d/init-user.el")
;;   (load user-custom-file))

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
(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

;; (load-file "~/.emacs.d/config.elc")
  ;;reset gc values to something reasonable after startup
(add-hook 'emacs-startup-hook
		(lambda ()
	    (setq gc-cons-threshold 16777216 gc-cons-percentage 0.1)
	    (setq file-name-handler-alist default--file-name-handler-alist)))
