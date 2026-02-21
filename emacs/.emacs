;;;; PRE CONFIG
;; 01:10:21
;; github.com/rexim/dotfiles
;; en.wikipedia.org/wiki/S-expression
;; TO DO github.com/rexim/simpc
;; TO DO custom splash screen (or default/default+)
;; TO DO github.com/tsoding/cm
;; TO DO magit.vc/manual/magit
;; TO DO make a function that(if all-the-fonts fonts aren't installed(install them))

;; PRE-CONFIG
(setq custom-file "~/emacs/.emacs.custom.el") ;; is the custom file
(load custom-file)                            ;; loads the custom file
(add-to-list 'default-frame-alist '(fullscreen . maximized))


;; ENSURE (+) PACKAGES
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/:")
			 ("elpa" . "https://elpa.gnu.org/packages/")
			 ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package evil          :ensure t :config)
(use-package doom-modeline :ensure t)
(use-package all-the-icons :ensure t)
(use-package doom-themes   :ensure t)


;; CLANG INDENTING
(setq c-default-style "linux"
      c-basic-offset 4)


;; STYLING
(load-theme 'doom-one)

;;;; MODES
(menu-bar-mode 0)                             ;; no menu bar
(tool-bar-mode 0)                             ;; no tool bar
(scroll-bar-mode 0)                           ;; no scroll bar
;(whitespace-mode 1)                          ;; whitespace mode
(electric-pair-mode 1)                        ;; closing brackets
(global-display-line-numbers-mode)            ;; line numbers
(ido-mode 1)                                  ;; IDO mode
(evil-mode 1)                                 ;; vim binds
(doom-modeline-mode)                          ;; doom emacs line (WIP)
    (setq doom-modeline-hud nil)              ;; doom modeline hud
    (setq doom-modeline-buffer-encoding nil)  ;; doom modeline buffer encoding (?)
    (setq doom-modeline-minor-modes nil)      ;; doom modeline minor modes (~)
