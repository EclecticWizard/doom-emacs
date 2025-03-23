;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrains Mono" :size 16 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 17))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/Vault/org/")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;; Load ox-pandoc for Org mode
(use-package! ox-pandoc
  :after org
  :config
  ;; Add Pandoc backend to Org mode
  (add-to-list 'org-export-backends 'pandoc))
;;
;;
;; Configure Pandoc export options for DOCX
(setq org-pandoc-options-for-docx
      '((standalone . t)          ;; Create a standalone document
        (toc . nil)))             ;; Disable table of contents
;;
;;
;; Load org-download
(use-package! org-download
  :config
  ;; Set the directory where images will be stored
  (setq org-download-image-dir "~/org-images")
  ;; Set the method for pasting images from the clipboard
  (setq org-download-screenshot-method "wl-copy -t image/png")
  ;; Optional: Bind the `yank-media` command to a key combination
  (map! :after org
        :map org-mode-map
        :localleader
        "v" #'org-download-yank))
;;
;;
(use-package! obsidian
  :after org
  :init
  :config
  ;;(obsidian-specify-path obsidian-directory)
  (global-obsidian-mode t)
  :custom
  ;; location of obsidian vault
  (obsidian-directory "~/Documents/Vault/") ;; Change this!

  ;; Default location for new notes from `obsidian-capture'
  (obsidian-inbox-directory "/Second Brain/0. Inbox")
  ;; Templates
  (obsidian-templates-directory "/Second Brain/4. Archive/Templates")
  (obsidian-daily-note-template "Daily template.md")

  ;; Useful if you're going to be using wiki links
  (markdown-enable-wiki-links t)


  ;; These bindings are only suggestions; it's okay to use other bindings
  :bind (:map obsidian-mode-map
              ;; Create note
              ("C-c C-n" . obsidian-capture)
              ;; If you prefer you can use `obsidian-insert-wikilink'
              ("C-c C-l" . obsidian-insert-link)
              ;; Open file pointed to by link at point
              ("C-c C-o" . obsidian-follow-link-at-point)
              ;; Open a different note from vault
              ("C-c C-p" . obsidian-jump)
              ;; Follow a backlink for the current file
              ("C-c C-b" . obsidian-backlink-jump)))


(use-package org
  :ensure t
  :config
  (setq org-agenda-files (append org-agenda-files '("~/Documents/Vault/org/agenda.org"))))

(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package nerd-icons :defer t)
(use-package nerd-icons-dired
  :commands (nerd-icons-dired-mode))
(setq dired-sidebar-theme 'nerd-icons)

;; Load elfeed-org
(after! elfeed
;; Initialize elfeed-org
;; This hooks up elfeed-org to read the configuration when elfeed
;; is started with =M-x elfeed=
   (elfeed-org)

;; Optionally specify a number of files containing elfeed
;; configuration. If not set then the location below is used.
;; Note: The customize interface is also supported.
  (setq rmh-elfeed-org-files (list "~/Documents/Vault/org/elfeed.org")))

;; org-roam
(use-package! org-roam
  :custom
  (org-roam-directory "~/Documents/Vault/org/")
  :config
  (org-roam-setup))

;; Keybinds
(global-set-key (kbd "M-p") 'ace-window)


;; Fixes
;; Go
(defun go--is-go-asm ()
  "Temporary fix for go-asm-mode detection."
  nil)  ;; Always return nil for now
