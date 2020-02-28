(setq gc-cons-threshold 100000000)

;; Initialize package
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; save config changes to custom.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; make use-package available
(require 'use-package)

;; *****************************************************
;; some keybindings

(global-set-key (kbd "M-a") 'execute-extended-command)
(global-set-key (kbd "M-\\") 'toggle-comment-on-line)
(global-set-key (kbd "M-c") 'copy-region-as-kill)
(global-set-key (kbd "M-y") 'yank)
(global-set-key (kbd "C-k") 'kill-whole-line)
(global-set-key (kbd "M-J") 'backward-word)
(global-set-key (kbd "M-L") 'forward-word)
(global-set-key (kbd "M-i") 'previous-line)
(global-set-key (kbd "M-k") 'next-line)
(global-set-key (kbd "M-I") 'previous-line)
(global-set-key (kbd "M-K") 'next-line)
(global-set-key (kbd "M-o") 'other-window)

(defun toggle-comment-on-line ()
      (interactive)
      (let ((start (line-beginning-position))
            (end (line-end-position)))
        (when (or (not transient-mark-mode) (region-active-p))
          (setq start (save-excursion
                        (goto-char (region-beginning))
                        (beginning-of-line)
                        (point))
                end (save-excursion
                      (goto-char (region-end))
                      (end-of-line)
                      (point))))
        (comment-or-uncomment-region start end)))

(defalias 'i 'indent-region)
(defalias 'mb 'mark-whole-buffer)
(defalias 'k 'kill-this-buffer)

;; ***********************************************
;; Theme

(use-package monokai-theme
  :ensure t
  :init
  (load-theme 'monokai t))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))


;; *****************************************************
;; Mac specific stuff

(defconst *is-a-mac* (eq system-type 'darwin))
(when *is-a-mac*
  (set-fontset-font
   t 'symbol
   (font-spec :family "Apple Color Emoji") nil 'prepend)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'super)
  (setq ns-function-modifier 'hyper)
  (defvar Monaco-font '(:family "Monaco" :size 10))
  (set-frame-font (apply 'font-spec Monaco-font) nil t))

;; bars and little things
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (and (not *is-a-mac*) (fboundp 'menu-bar-mode))
  (menu-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(blink-cursor-mode -1)
(setq ring-bell-function #'ignore
      inhibit-startup-screen t
      initial-major-mode 'emacs-lisp-mode
      initial-scratch-message ";; MAGIC \n")
(fset 'yes-or-no-p #'y-or-n-p)
(fset 'display-startup-echo-area-message #'ignore)

(line-number-mode t)
(column-number-mode t)
(global-auto-revert-mode t)
(setq-default fill-column 80)


;; Auto insert matching delimiters
(use-package elec-pair
  :config
  (electric-pair-mode +1))

;; Highlight matching parentheses
(use-package paren
  :config
  (show-paren-mode +1)
  (set-face-background 'show-paren-match (face-background 'default))
  (set-face-foreground 'show-paren-match "hot pink"))

;; Neotree
(setq byte-compile-warnings '(mapcar))
(use-package neotree
  :ensure t
  :defines helm-split-window-inside-p
  :bind
  ("<f8>" . neotree-toggle)
  :config
  (setq neo-theme 'ascii
	neo-smart-open nil
	neo-show-hidden-files t
	neo-auto-indent-point t
	neo-auto-refresh t
	neo-force-change-root t
	neo-toggle-window-keep-p t)
  :custom-face
  (neo-dir-link-face ((t (:foreground "hot pink"))))
  (neo-root-dir-face ((t (:background "gray16" :foreground "light sea green")))))
(setq byte-compile-warnings t)


;; Magit
(use-package magit
  :ensure t
  :init
  (defalias 'gs 'magit-status))

;; Rainbow
(use-package rainbow-mode
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-mode))

;; use shift + arrow keys to switch between visible buffers
(use-package windmove
  :config
  (windmove-default-keybindings))

;; highlight current line
(use-package hl-line
  :config
  (global-hl-line-mode +1))

(use-package hydra
  :defer t
  :ensure t
  :config
  (set-face-attribute 'hydra-face-blue nil :foreground "hot pink"))

;; Avy jumping :D
(use-package avy
  :ensure t
  :bind (("M-g" . #'hydra-avy-jump/body))
  :config
  (setq avy-background t)
  (defhydra hydra-avy-jump (:color blue)
    "Avy"
    ("c" avy-goto-char "char")
    ("w" avy-goto-word-or-subword-1 "word")
    ("l" avy-goto-line "line"))
  :custom-face
  (avy-lead-face ((t (:background "hot pink" :foreground "gray16"))))
  (avy-lead-face-0 ((t (:background "light sea green" :foreground "gray16")))))


;; Backups and autoloads
;; (setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
;; (setq delete-old-versions -1)
;; (setq version-control t)
;; (setq vc-make-backup-files t)
;; (setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; exec-path-from-shell
;; (use-package exec-path-from-shell
;;   :ensure t
;;   :defer t
;;   :config
;;   (when *is-a-mac*
;;     (exec-path-from-shell-initialize)))



;; (setq scroll-margin 0
;;       scroll-conservatively 100000
;;       scroll-preserve-screen-position 1)





