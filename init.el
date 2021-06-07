(setq package-enable-at-startup nil)
(setq package-archives '(("gnu"   . "http://elpa.emacs-china.org/gnu/")
                           ("melpa" . "http://elpa.emacs-china.org/melpa/")))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(setq custom-file "~/.config/emacs-custom.el")

(setq mac-option-modifier 'super
      mac-command-modifier 'meta
      x-hyper-keysym 'super)

(setq-default tab-width 2)

(use-package recentf
  :hook (after-init . recentf-mode))

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'after-init-hook #'auto-save-mode)
(add-hook 'after-init-hook #'auto-save-visited-mode)
(add-hook 'after-init-hook #'winner-mode)

;; (use-package winner
;;   :hook (after-init . winner-mode))

(use-package global-auto-revert-mode
  :hook (after-init . global-auto-revert-mode))

;;; tool completion
;; (use-package orderless
;;   :ensure t
;;   :custom (completion-styles '(orderless)))

;; (use-package vertico
;;   :ensure t
;;   :hook (after-init . vertico-mode)
;;   :config
;;   (vertico-mode))

;; (use-package corfu
;;   :ensure t
;;   :bind (:map corfu-map
;;               ("TAB" . corfu-next)
;;               ("S-TAB" . corfu-previous))
;;   :config
;;   (corfu-global-mode)
;;   (setq corfu-cycle t))

;; (use-package dabbrev
;;   :bind (("M-/" . dabbrev-completion)
;; 	 ("C-M-/" . dabbrev-expand)))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

(use-package savehist
  :hook (after-init . savehist-mode))

;; (use-package emacs
;;   :init
;;   ;; Add prompt indicator to `completing-read-multiple'.
;;   (defun crm-indicator (args)
;;     (cons (concat "[CRM] " (car args)) (cdr args)))
;;   (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

;;   ;; Grow and shrink minibuffer
;;   ;;(setq resize-mini-windows t)

;;   ;; Do not allow the cursor in the minibuffer prompt
;;   (setq minibuffer-prompt-properties
;;         '(read-only t cursor-intangible t face minibuffer-prompt))
;;   (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;;   ;; Enable recursive minibuffers
;;   (setq enable-recursive-minibuffers t))

;;; tool auto completion
;; (use-package company
;;   :ensure t
;;   :hook (after-init . global-company-mode)
;;   :config
;;   (setq company-idle-delay 0.1))

;;; tool snippet
;; (use-package yasnippet
;;   :ensure t
;;   :hook (after-init . yas-global-mode))

;;; tool projectile
(use-package projectile
  :ensure t
  :hook (after-init . projectile-mode)
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;;; tool which-key
(use-package which-key
  :ensure t
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.1
	which-key-idle-secondary-delay 0))

;;; tool undo-tree
(use-package undo-tree
  :ensure t
  :hook (after-init . global-undo-tree-mode)
  :config
  (setq undo-tree-auto-save-history t))

;;; tool magit
(use-package magit
  :ensure t
  :commands (magit-status))

;; TODO: gist-list doesn't work

(use-package gist
  :ensure t
  :commands (gist-list))

;;; tools restart-emacs
(use-package restart-emacs
  :ensure t
  :commands (restart-emacs))

;;; lsp-mode
(use-package lsp-mode
  :ensure t
  :init
  (add-hook 'go-mode-hook #'lsp-deferred))

(defun open-emacs-config ()
  (interactive)
  (find-file (concat user-emacs-directory "init.el")))

(use-package exec-path-from-shell
  :ensure t
  :when (featurep 'cocoa)
  :hook (after-init . exec-path-from-shell-initialize))

;;; lang lisp
(use-package lispy
  :ensure t
  :init
  (add-hook 'emacs-lisp-mode-hook #'lispy-mode))

;;; lang go-mode
(use-package go-mode
  :ensure t
  :mode ("\\.go\\'" "\\.api\\'")
  :init
  (add-hook 'go-mode-hook (lambda ()
			   (setq tab-width 2)
			   )))

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;;; lang org-mode
;; (use-package org-fancy-priorities
;;   :ensure t
;;   :hook (org-mode . org-fancy-priorities-mode)
;;   :config
;;   (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))

(use-package org
  :commands (org-mode)
  :init
  (setq org-directory "~/org/"
	org-agenda-files `(,org-directory)
	org-agenda-include-diary t
	org-default-notes-file "~/org/notes.org"
	org-todo-keywords '((sequence "TODO" "WIP" "|" "DONE"))
	org-stuck-projects '("+PROJECT/-MAYBE-DONE" ("NEXT" "TODO" "WIP") nil "\\<IGNORE\\>")
	org-link-abbrev-alist '(("google" . "https://google.com/search?q=%s")
				("rfcdoc" . "https://www.rfc-editor.org/rfc/rfc%s.html"))
	org-refile-targets '((nil :maxlevel . 5)
			     (org-agenda-files :maxlevel . 2))
	org-refile-use-outline-path t
	org-outline-path-complete-in-steps nil
	org-indent-indentation-per-level 1
	)
  
  
  
  (defun org-summary-todo (n-done n-not-done)
    "Switch entry to DONE when all subentries are done, to TODO otherwise."
    (let (org-log-done org-log-states)	; turn off logging
      (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

  (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
  :config
  (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
  )

(use-package org-capture
  :commands (org-capture)
  :config
  (let ((task-file "~/org/task.org"))
    (add-to-list 'org-capture-templates `("r" "Book Reading Task" entry (file+olp ,task-file "Reading" "Book") "* TODO %^{书名}\n%u\n" :clock-in t :clock-resume t :no-save t))
    (add-to-list 'org-capture-templates `("w" "Work Task" entry (file+headline ,task-file "Work") "* TODO %^{任务名}\n%u\n" :clock-in t :clock-resume t :no-save t))
    (add-to-list 'org-capture-templates `("i" "Inbox Item" entry (file+headline ,task-file "Inbox") "* TODO %^{任务名}\n%u\n%a\n"  :no-save t))))

(define-key global-map (kbd "C-c a") #'org-agenda)
(define-key global-map (kbd "C-c c") #'org-capture)

(defun open-org-files ()
  "open org files"
  (interactive)
  (let ((default-directory "~/org/"))
    (call-interactively 'find-file)))

;; (use-package org-bullets
;;   :ensure t
;;   :hook (org-mode . org-bullets-mode))

;; (use-package sis
;;   :ensure t
;;   :config
;;   (sis-ism-lazyman-config
;;    "com.apple.keylayout.US"
;;    "com.sogou.inputmethod.sogou.pinyin"))

(use-package valign
  :ensure t
  :hook (org-mode . valign-mode))

(use-package plantuml-mode
  :ensure t
  :mode ("\\.uml\\'")
  :config
  (setq plantuml-jar-path "~/plantuml.jar"
	      plantuml-default-exec-mode 'jar
        tab-stop 2)
  (org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))
  (setq org-plantuml-jar-path (expand-file-name "~/plantuml.jar"))
  
  )

(use-package rime
	:ensure t
	:custom
	(default-input-method "rime"))


(use-package sis
	:ensure t
	:config
	(sis-ism-lazyman-config nil "rime" 'native))
