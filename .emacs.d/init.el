;; Language Environment
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

(setq inhibit-startup-message t)

;; Do not make backup
(setq make-backup-files nil)
(setq delete-auto-save-files t)

(setq-default tab-width 4 indent-tabs-mode nil)

(menu-bar-mode -1)

(tool-bar-mode -1)

(global-hl-line-mode t)

(show-paren-mode 1)

(setq scroll-conservatively 1)

(setq pc-select-selection-keys-only t)

(defalias 'yes-or-no-p 'y-or-n-p)

;; No Beep
(setq ring-bell-function 'ignore)
