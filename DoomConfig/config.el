;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;;;
;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!

;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Hidemaro Fujinami"
      user-mail-address "hdmrf.fjnm@gmail.com")
;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; test
(setq doom-font (font-spec :family "Iosevka Nerd Font" :size 14)
      doom-big-font (font-spec :family "Iosevka Nerd Font" :size 14))
      ;; doom-variable-pitch-font (font-spec :family "Avenir Next" :size 14))
;; (setq doom-unicode-font (font-spec :name "DejaVu Sans Mono" :size 14))
(setq +helm-posframe-text-scale 0)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-one)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/Dropbox/Org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
;; (setq-default evil-escape-key-sequence "fd")
(setq evil-escape-key-sequence "fd")

;; charcter setsetting
;; ========================
(set-language-environment-charset "UTF-8")
;; (setq locale-coding-system 'utf-8)
;; (prefer-coding-system 'utf-8)
;; (setq default-file-name-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (set-keyboard-coding-system 'utf-8)
;; jp font
;; (set-fontset-font t 'japanese-jisx0208 (font-spec :family "Noto Sans CJK JP" :height 100))
(set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Noto Sans CJK JP" :height 100))
(set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0208 (font-spec :family "Noto Sans CJK JP" :size 26))
(set-fontset-font (frame-parameter nil 'font) 'katakana-jisx0201 (font-spec :family "Noto Sans CJK JP" :size 26))

;; global
;; =========================
(setq-default comment-start "# ")
(setq visual-line-mode t)
;; highlight trailing whitespace
(setq-default show-trailing-whitespace t)
;; delete character without yanking
(map! :n "x" #'delete-char)
;; window  size
;; (set-frame-size (selected-frame) 600 600 nil t)
;; make sure that the weekdays in the time stamps of org mode files in the agenda
;; appear in english
(setq system-time-locale "C")

;; set jl to <Right>
(defun my-j ()
  (interactive)
  (let* ((initial-key ?j)
         ;; (final-key ?j)
         (timeout 0.5)
         (event (read-event nil nil timeout)))
    (if event
        ;; timeout met
        (cond ((and (characterp event) (= event ?l)) (forward-char))
              ((and (characterp event) (= event ?j)) (evil-open-below 1))
              ((and (characterp event) (= event ?k)) (emmet-expand-line ()))
              (t
               (insert initial-key)
               (push event unread-command-events)))
      ;; timeout exceeded
      (insert initial-key))))
(map!
 :i "j" 'my-j)

;; window settings
;; (defun reset-frame-parameter (frame)
  ;; (sleep-for 0.1)
  ;; (set-frame-parameter frame 'height 32))
;; (add-hook 'after-make-frame-functions #'reset-frame-parameter)

;; org basic settings
;; ===========================
(setq
 org-ellipsis " ▾ "
 org-tags-column -80
 org-superstar-headline-bullets-list '("◎" "○" "●"))

(after! org
  (custom-theme-set-faces
  'user
  `(org-level-1 ((t (:inherit default :weight bold :height 1.2 :foreground "#3a8578"))))
  `(org-level-2 ((t (:inherit default :weight bold :height 1.1 :foreground "#57c2b0"))))
  `(org-level-3 ((t (:inherit default :weight bold :height 1.1 :foreground "#b0d1d0"))))
  `(org-level-4 ((t (:inherit default :weight bold :height 1.0 :foreground "#eaebd5"))))
  `(org-level-5 ((t (:inherit default :weight normal :height 0.9 :foreground "#E4CD81"))))
  `(org-level-6 ((t (:inherit default :weight normal :height 0.9 :foreground "#D4B996"))))
  `(org-level-7 ((t (:inherit default :weight normal :height 0.8 :foreground "#B1B3B3"))))
  `(org-level-8 ((t (:inherit default :weight normal :height 0.8 :foreground "#A2A2A1")))))
  (evil-define-key 'normal org-mode-map (kbd "<tab>") #'org-cycle)
  (add-hook! org-mode  (visual-line-mode t))
  (add-hook! 'org-mode-hook (lambda () (org-superstar-mode 1)))
  (map! :map org-mode-map
        :n "M-j" #'org-metadown
        :n "M-k" #'org-metaup))

;; org-capture
(after! org
  (setq org-default-notes-file (concat org-directory "6_scrap.org")))

;; org-super-agenda
(use-package org-super-agenda
  :after org-agenda
  :init
  (setq org-super-agenda-groups '((:name "Today"
                                   :time-grid t
                                   :scheduled today)
                                  (:name "Due today"
                                   :deadline today)
                                  (:name "Important"
                                   :priority "A")
                                  (:name "Overdue"
                                   :deadline past)
                                  (:name "Due soon"
                                   :deadline future)))
  :config
  (org-super-agenda-mode)
  (setq org-agenda-time-grid
        '((daily today require-timed)
          (0900 01000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400)
          "-"
    "----------------")))

;; ;; org-clock
;; ====================
;;   (global-set-key (kbd "C-c O") #'org-clock-out)
;;   (setq org-clock-out-remove-zero-time-clocks t)
;;   (setq org-clock-out-when-done t)
;;   (setq org-clock-mode-line-total 'current)
;;   (defun my:org-clock-out-and-save-when-exit ()
;;     (if (boundp 'org-clocking-p)
;;       (when (org-clocking-p)
;;         (org-clock-out)
;;         (save-some-buffers t))))
;;  (add-hook 'kill-emacs-hook #'my:org-clock-out-and-save-when-exit))

;; recursive narrow
(after! recursive-narrow
  :ensure t)

;; slime
;; (use-package! slime
;;   :defer t
;;   :init
;;   (setq inferior-lisp-program "sbcl")
;;   :config
;;   (set-repl-handler! 'lisp-mode #'sly-mrepl)
;;   (set-eval-handler! 'lisp-mode #'sly-eval-regionl)
;;   (set-lookup-handlers! 'lisp-mode
;;     :definition #'sly-edit-definition
;;     :documentation #'sly-describe-symbol))

;;  (add-hook 'lisp-mode-hook #'rainbow-delimiters-mode))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (extempore-mode recursive-narrow org-super-agenda evil-escape))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:inherit default :weight bold :height 1.2 :foreground "#7AE7C7"))))
 '(org-level-2 ((t (:inherit default :weight bold :height 1.1 :foreground "#75BAA5"))))
 '(org-level-3 ((t (:inherit default :weight bold :height 1.1 :foreground "#6B998B"))))
 '(org-level-4 ((t (:inherit default :weight bold :height 1.0 :foreground "#F0F0C9"))))
 '(org-level-5 ((t (:inherit default :weight normal :height 0.9 :foreground "#E4CD81"))))
 '(org-level-6 ((t (:inherit default :weight normal :height 0.9 :foreground "#D4B996"))))
 '(org-level-7 ((t (:inherit default :weight normal :height 0.8 :foreground "#B1B3B3"))))
 '(org-level-8 ((t (:inherit default :weight normal :height 0.8 :foreground "#A2A2A1")))))
