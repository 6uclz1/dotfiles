;;;;;;;;;;;;;;;;;;;;;;;;;;
;         ini.el         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun set-exec-path-from-shell-PATH ()
    "Set up Emacs' `exec-path' and PATH environment variable to match that used by the user's shell.

This is particularly useful under Mac OSX, where GUI apps are not started from a shell."
    (interactive)
    (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
      (setenv "PATH" path-from-shell)
      (setq exec-path (split-string path-from-shell path-separator))))
(set-exec-path-from-shell-PATH)

(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))


(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync)

;; Emacs Default Settings
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Do not make backup
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq delete-auto-save-files t)

;; yes is 'y' no is 'n'
(defalias 'yes-or-no-p 'y-or-n-p)

;; Highlight Cursor
;; (global-hl-line-mode t)
;; (custom-set-faces '(hl-line ((t (:background "dark gray")))))
;; (setq hl-line-face 'underline) ; 下線（ただしアンダーバーが見えない）

;; No beep No Life
(setq ring-bell-function 'ignore)

;; indent 4.
;; Do not use tab, 4 spaces.
(setq tab-width 4)
(setq-default indent-tabs-mode nil)

;; Undo is "C-z"
(define-key global-map (kbd "C-z") 'undo)

;; ディレクトリ閲覧中にrを押すとファイル名の編集などができる wdired モード
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)


;; El-get packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; auto-conplete
(el-get-bundle auto-complete)
;; auto-complete が発動するキー
;; (ac-set-trigger-key "TAB")
;; 補完が出るまでの時間
;; (setq ac-quick-help-delay 0.5)

;; solarized
(el-get-bundle color-theme-solarized)
(load-theme 'solarized t)

;; markdown-mode
(el-get-bundle markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; c++
;; 参考 http://futurismo.biz/archives/3071
;; clangを利用した補完をしてくれるclang-complete
;; (el-get-bundle auto-complete-clang)

;; web-mode
(el-get-bundle web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))
;; web-mode indent
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   4)
  (setq web-mode-css-offset    4)
  (setq web-mode-script-offset 4)
  (setq web-mode-php-offset    4)
  (setq web-mode-java-offset   4)
  (setq web-mode-asp-offset    4)
  (setq indent-tabs-mode t)
  (setq tab-width 4))
(add-hook 'web-mode-hook 'web-mode-hook)
;; scala.htmlだけはweb-mode-htmlで正しく表示できないので、html-modeをつかう
;; ただしhtml-modeでも
(add-to-list 'auto-mode-alist '("\\.scala.html$" . html-mode))
