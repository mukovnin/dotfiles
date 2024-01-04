(require 'package)

;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa"        . "http://melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize nil)

(unless (package-installed-p 'use-package)
  (message "EMACS install use-package.el")
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; PACKAGES

(use-package multiple-cursors
    :bind (("C-S-c C-S-c" . mc/edit-lines)
           ("C->" . mc/mark-next-like-this)
           ("C-<" . mc/mark-previous-like-this)
           ("C-c C-<" . mc/mark-all-like-this)))

(use-package char-fold
  :custom
  (char-fold-symmetric t)
  (search-default-mode #'char-fold-to-regexp))

(use-package reverse-im
  :ensure t ; install `reverse-im' using package.el
  :demand t ; always load it
  :after char-fold ; but only after `char-fold' is loaded
  :bind
  ("M-T" . reverse-im-translate-word) ; fix a word in wrong layout
  :custom
  (reverse-im-char-fold t) ; use lax matching
  (reverse-im-read-char-advice-function #'reverse-im-read-char-include)
  (reverse-im-input-methods '("russian-computer")) ; translate these methods
  :config
  (reverse-im-mode t)) ; turn the mode on

(use-package neotree
    :bind ([f8] . neotree-toggle)
    :init (setq neo-theme 'ascii
                neo-window-width 40
                neo-smart-open t))

(use-package ediff
    :config (setq-default ediff-highlight-all-diffs nil)
    (setq ediff-window-setup-function 'ediff-setup-windows-plain
          ediff-split-window-function 'split-window-horizontally
          ediff-combination-pattern '("" A "" B "" Ancestor)))

(use-package magit
    :config (setq magit-ediff-dwim-show-on-hunks t
                  magit-log-margin '(t "%Y-%m-%d %H:%M " magit-log-margin-width t 18)
                  magit-blame-echo-style 'margin)
    :bind (("C-x g" . magit-status)
           ("C-c g" . magit-file-dispatch)))

(use-package helm
    :init (progn
            (setq helm-candidate-number-limit 100
                  helm-idle-delay 0.0
                  helm-input-idle-delay 0.01
                  helm-yas-display-key-on-candidate t
                  helm-quick-update t
                  helm-split-window-in-side-p t
                  helm-M-x-requires-pattern nil)
            (helm-mode))
    :bind (([f2] . helm-mini)
           ("C-x b" . helm-buffers-list)
           ("M-y" . helm-show-kill-ring)
           ("M-x" . helm-M-x)
           ("C-x C-f" . helm-find-files)
           ("M-s o" . helm-occur)
           ("C-c h r" . helm-register)
           ("C-c h b" . helm-resume)
           ("C-c h a" . helm-do-ag))
    :config (setq helm-command-prefix-key "C-c h"
                  helm-split-window-in-side-p t
                  helm-move-to-line-cycle-in-source t
                  helm-ff-search-library-in-sexp t
                  helm-scroll-amount 8
                  helm-M-x-requires-pattern 0
                  helm-ff-file-name-history-use-recentf t
                  helm-buffer-max-length nil)
    (helm-mode 1)
    (helm-autoresize-mode 1)
    :ensure helm)
             
(use-package helm-ag)

(use-package helm-projectile
 :config
 (helm-projectile-on))

(use-package cmake-mode)
(use-package qml-mode)
(use-package rust-mode)
 
;; (use-package lsp-mode
;;     :commands lsp
;;     :hook ((c-mode . lsp-deferred)
;;            (c++-mode . lsp-deferred)
;;            (rust-mode . lsp-deferred))
;;     :config
;;     (setq lsp-keymap-prefix "C-c l")
;;     (setq lsp-diagnostic-package :none)
;;     (setq lsp-prefer-flymake nil)
;;     (setq lsp-enable-file-watchers nil)
;;     (setq lsp-clients-clangd-args '("--completion-style=detailed")))

(use-package eglot)
(add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(c++-mode . ("clangd" "--completion-style=detailed"))))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(c-mode . ("clangd" "--completion-style=detailed"))))
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)

(use-package yasnippet
    :hook (after-init . yas-global-mode))

(use-package company
    :config (setq company-idle-delay 0
                  company-echo-delay 0
                  company-tooltip-align-annotations t
                  company-minimum-prefix-length 2)
    :hook (after-init . global-company-mode))

(use-package projectile
    :bind-keymap ("C-c p" . projectile-command-map)
    :init (setq projectile-switch-project-action #'projectile-dired)
    :config (projectile-mode +1))
 
(use-package highlight-symbol
    :init (setq highlight-symbol-idle-delay 0.1)
    :hook (prog-mode . highlight-symbol-mode))
 
(use-package ace-jump-mode
    :commands ace-jump-mode
    :init
    :bind ("C-." . ace-jump-mode))
 
(use-package ace-mc
 :bind (("C-," . ace-mc-add-multiple-cursors)
        ("C-M-," . ace-mc-add-single-cursor)))
 
(use-package rainbow-delimiters
    :hook (prog-mode . rainbow-delimiters-mode))

(use-package expand-region
    :bind ("C-=" . er/expand-region))

(use-package nyan-mode
    :config (nyan-mode))

(use-package modus-themes
    :config (load-theme 'modus-operandi t))

;; --------------------------------------------------------

(defun my-find-file-check-make-large-file-read-only-hook ()
  "If a file is over a given size, make the buffer read only."
  (when (> (buffer-size) (* 1024 1024))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (fundamental-mode)))
(add-hook 'find-file-hook 'my-find-file-check-make-large-file-read-only-hook)

(setq lisp-indent-function  'common-lisp-indent-function)
(add-hook 'c-mode-hook (lambda () (c-toggle-comment-style -1)))

;(setq-default cursor-type 'bar)

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq truncate-partial-width-windows t)
(setq use-dialog-box nil)
(setq redisplay-dont-pause t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(show-paren-mode t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(column-number-mode t)
(size-indication-mode t)
(global-auto-revert-mode t)
(global-hl-line-mode +1)
(winner-mode 1)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq scroll-step               1)
(setq scroll-margin            10)
(setq scroll-conservatively 10000)

(setq echo-keystrokes 0.01)

(setq-default indent-tabs-mode nil)
(setq-default tab-width          4)
(setq-default c-basic-offset     4)
(setq-default standart-indent    4)
(setq-default lisp-body-indent   2)

(define-key global-map (kbd "M-g") 'goto-line)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-S-s") 'isearch-forward-symbol-at-point)
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

(setq display-time-24hr-format t)
(display-time-mode             t)
(size-indication-mode          t)

;; Easy transition between buffers: M-arrow-keys
(if (equal nil (equal major-mode 'org-mode))
    (windmove-default-keybindings 'meta))
    
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
      (load custom-file))
