(setq user-full-name "David Mohl")
(setq user-mail-address "emacs@davemail.io")

(setq exec-path (append exec-path '("/usr/local/bin")))
(require 'cl)

;; set up melpa
(require 'package)

;; update package list if not available
(when (not package-archive-contents)
    (package-refresh-contents))

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
;;(package-refresh-contents)

;; done with melpa

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package use-package-chords
  :ensure t
  :config
  (key-chord-mode 1))

(use-package swiper :ensure t)
(use-package counsel :ensure t)
(use-package counsel-projectile :ensure t)

(use-package projectile
  :ensure t
  :config
  (projectile-mode 1))

(use-package ivy
  :ensure t
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  (setq ivy-display-style 'fancy)
  (ivy-mode 1))


(use-package evil
  :ensure t
  :config
  (evil-mode 1))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package company
  :ensure t
  :config
  (company-mode)
  (define-key company-active-map (kbd "C-n") 'company-select-next-or-abort)
  (define-key company-active-map (kbd "C-p") 'company-select-previous-or-abort))

(use-package exec-path-from-shell :ensure t)

(use-package seoul256-theme
    :ensure t
    :config (load-theme 'seoul256 t))

;; linum-relative is very slow on performance
;; (use-package linum-relative
;;   :ensure t
;;   :config (linum-relative-global-mode))

;; syntax
(use-package flycheck
  :ensure t
  :config (global-flycheck-mode))

;; languages
(use-package go-mode :ensure t
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

(use-package flycheck-gometalinter
  :ensure t
  :config
  (progn
    (flycheck-gometalinter-setup)))
(use-package company-go
  :ensure t
  :config
  (add-hook 'go-mode-hook (lambda ()
			    (set (make-local-variable 'company-backends) '(company-go))
			    (company-mode))))


;; take gopath from users shell settings
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "GOPATH")
  (exec-path-from-shell-copy-env "PATH"))

;; start emacs server
(server-start)

;; hide startup screen
(setq inhibit-startup-screen t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-linum-mode 1)

;; font
(set-frame-font "Operator Mono 15" nil t)

;; highlight current line
(global-hl-line-mode 1)

;;Exit insert mode by pressing j and then j quickly
(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "fd" 'evil-normal-state)

;; switch buffer
(define-key evil-normal-state-map  " bb" 'ivy-switch-buffer)
(define-key evil-normal-state-map  (kbd "C-b") 'ivy-switch-buffer)

;; project stuff
(define-key evil-normal-state-map  " pf" 'counsel-projectile-find-file)
(define-key evil-normal-state-map  " p/" 'counsel-projectile-ag)
(define-key evil-normal-state-map  (kbd "C-p") 'counsel-projectile-find-file)

(define-key projectile-mode-map  " pf" 'counsel-projectile-find-file)
(define-key projectile-mode-map  " p/" 'counsel-projectile-ag)
(define-key projectile-mode-map  (kbd "C-p") 'counsel-projectile-find-file)

(define-key evil-normal-state-map  " ff" 'counsel-projectile)

;; switch to last tab
(defun switch-to-last-buffer ()
  (interactive)
  (switch-to-buffer nil))

(define-key evil-normal-state-map  (kbd "SPC TAB") 'switch-to-last-buffer)

;; close ivy with esc
(define-key ivy-minibuffer-map [escape] 'minibuffer-keyboard-quit)
(define-key swiper-map [escape] 'minibuffer-keyboard-quit)

;; ----------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-hl-line-mode t)
 '(ivy-mode t)
 '(package-selected-packages
   (quote
    (exec-path-from-shell company-go flycheck-gometalinter go-mode flycheck counsel-projectile projectile counsel ivy company company-mode evil-surround linum-relative seoul256-theme use-package-chords spacemacs-theme evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Operator Mono" :foundry "nil" :slant normal :weight normal :height 150 :width normal)))))
