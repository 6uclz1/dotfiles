
;; Language Environment

(set-locale-environment nil)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

(setq inhibit-startup-message t)

;; Do not make backup
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq delete-auto-save-files t)

(setq-default tab-width 4 indent-tabs-mode nil)

(column-number-mode t)

(global-linum-mode t)

(global-hl-line-mode t)

(show-paren-mode 1)

(setq scroll-conservatively 1)

(setq pc-select-selection-keys-only t)

(defalias 'yes-or-no-p 'y-or-n-p)

;; No Beep
(setq ring-bell-function 'ignore)


(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(add-to-list 'package-archives  '("marmalade" . "http://marmalade-repo.org/packages/") t)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)
