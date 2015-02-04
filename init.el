;;; init.el --- Where all stuff starts - BINGQING

;; PERCULL's version checking
(let ((minver 23))
  (unless (>= emacs-major-version minver)
    (error "BINGQING, v%s" minver)
  )
)
;; path to the setting files
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Enable with t if you prefer
(defconst *spell-check-support-enabled* nil)

(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-a-linux* (eq system-type 'gnu/linux))
(defconst *is-a-win* (eq system-type 'ms-dos))
;;---------------------------------------------------------------------
;; Bootstrap config from PURCELL
;;----------------------------------------------------------------------
(require 'init-compat)
(require 'init-utils)
;; Must com before elpa, as it may provide package.el
(require 'init-site-lisp)
;; Machinery for installing required packages
(require 'init-elpa)
;; Set up $PATH
(require 'init-exec-path)


;;----------------------------------------------------------------------
;; Enable mepla
;;----------------------------------------------------------------------
;; (require 'package)
;; (add-to-list 'package-archives
;;   '("melpa" . "http://melpa.milkbox.net/packages/") t)
;;----------------------------------------------------------------------
;; Load configurations and specific features recommended by PURCELL
;;----------------------------------------------------------------------

;; wgrep provides to edit grep buffer and to apply the changes to
;; the file buffer.
(require-package 'wgrep)
;; Set project-local variables from a file
(require-package 'project-local-variables)
;; Diminished modes are minor modes with no modeline display
(require-package 'diminish)
(require-package 'scratch)
;; log keyboard commands to buffer
(require-package 'mwe-log-commands)

;;----------------------------------------------------------------------
;;; PURCELL Part

;; ido mode config
(require 'init-ido)
;; related to console and frame hooks???
(require 'init-frame-hooks)
;; some key bindings about ???
(require 'init-xterm)
;; gui settings; line numbers/menu bar etc..
(require 'init-gui-frames)
;; dired
(require 'init-dired)
;; advanced search
(require 'init-isearch)
(require 'grep)
;; Nicer naming of buffers for files with identical names
(require 'uniquify)
;; fullframe/ibuffer etc...
(require 'init-ibuffer)
;; syntax checking
(require 'init-flycheck)
;; expand the word before the cursor
(require 'init-hippie-expand)
;; windows manipulations
(require 'init-windows)
;; save/restore sessions
(require 'init-sessions)
(require 'init-fonts)
(require 'init-mmm)
;; (require 'init-auto-complete)

(require 'init-editing-utils)
;;(require 'setup-helm)

;;----------------------------------------------------------------------
;; Themes
;;----------------------------------------------------------------------
(require-package 'zenburn-theme)
(load-theme 'zenburn t)


;;----------------------------------------------------------------------

;;; My Configuration
(require 'bq-recentf)
(require 'bq-yasnippet)
(require 'bq-auto-complete)
(require 'bq-fill-column-indicator)
(require 'bq-python)
(require 'bq-editing-ui)
(require 'bq-highlight-current-line)
(require 'bq-cpp)
(require 'bq-org)
(require 'bq-treeview)
(provide 'init)
