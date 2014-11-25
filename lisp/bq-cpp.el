;; CPP settings

;; Problem List
;; smartparens
(defconst demo-packages
  '(anzu
    company
    ede
    duplicate-thing
    ggtags
    helm
    helm-gtags
    helm-swoop
    function-args
    clean-aindent-mode
    comment-dwim-2
    dtrt-indent
    ws-butler
    iedit
    yasnippet
    sml-mode
    projectile
    volatile-highlights
    undo-tree
    zygospore))

(defun install-packages ()
  "Install all required packages."
  (interactive)
  (unless package-archive-contents
    (package-refresh-contents))
  (dolist (package demo-packages)
    (unless (package-installed-p package)
      (package-install package))))

(install-packages)

;; this variables must be set before load helm-gtags
;; you can change to any prefix key of your choice
(setq helm-gtags-prefix-key "\C-cg")

(add-to-list 'load-path "~/.emacs.d/lisp")

(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)



;; The Imenu facility offers a way to find the major definitions, such as function
;; definitions, variable definitions in a file by name. ggtags can integrate Imenu:

(setq-local imenu-create-index-function #'ggtags-build-imenu-index)



;; ----------------------------------------------------------------------
;; setup-editing.el options
;; ----------------------------------------------------------------------
;; GROUP: Editing -> Editing Basics

(setq global-mark-ring-max 5000         ; increase mark ring to contains 5000 entries
      mark-ring-max 5000                ; increase kill ring to contains 5000 entries
      mode-require-final-newline t      ; add a newline to end of file
      tab-width 4                       ; default to 4 visible spaces to display a tab
      )

(add-hook 'sh-mode-hook (lambda ()
                          (setq tab-width 4)))

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

(delete-selection-mode)
(global-set-key (kbd "RET") 'newline-and-indent)

;; GROUP: Editing -> Killing
(setq kill-ring-max 5000 ; increase kill-ring capacity
      kill-whole-line t  ; if NIL, kill whole line and move the next line up
      )

;; show whitespace in diff-mode
(add-hook 'diff-mode-hook (lambda ()
                            (setq-local whitespace-style
                                        '(face
                                          tabs
                                          tab-mark
                                          spaces
                                          space-mark
                                          trailing
                                          indentation::space
                                          indentation::tab
                                          newline
                                          newline-mark))
                            (whitespace-mode 1)))

;; Package: volatile-highlights
;; GROUP: Editing -> Volatile Highlights
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; Package: clean-aindent-mode
;; GROUP: Editing -> Indent -> Clean Aindent
(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)


;; PACKAGE: dtrt-indent
(require 'dtrt-indent)
(dtrt-indent-mode 1)
(setq dtrt-indent-verbosity 0)
;
;; ;; Customized functions
;; (defun prelude-move-beginning-of-line (arg)
;;   "Move point back to indentation of beginning of line.
;; Move point to the first non-whitespace character on this line.
;; If point is already there, move to the beginning of the line.
;; Effectively toggle between the first non-whitespace character and
;; the beginning of the line.
;; If ARG is not nil or 1, move forward ARG - 1 lines first. If
;; point reaches the beginning or end of the buffer, stop there."
;;   (interactive "^p")
;;   (setq arg (or arg 1))

;;   ;; Move lines first
;;   (when (/= arg 1)
;;     (let ((line-move-visual nil))
;;       (forward-line (1- arg))))

;;   (let ((orig-point (point)))
;;     (back-to-indentation)
;;     (when (= orig-point (point))
;;       (move-beginning-of-line 1))))

;; (global-set-key (kbd "C-a") 'prelude-move-beginning-of-line)

;; (defadvice kill-ring-save (before slick-copy activate compile)
;;   "When called interactively with no active region, copy a single
;; line instead."
;;   (interactive
;;    (if mark-active (list (region-beginning) (region-end))
;;      (message "Copied line")
;;      (list (line-beginning-position)
;;            (line-beginning-position 5)))))

;; (defadvice kill-region (before slick-cut activate compile)
;;   "When called interactively with no active region, kill a single
;;   line instead."
;;   (interactive
;;    (if mark-active (list (region-beginning) (region-end))
;;      (list (line-beginning-position)
;;            (line-beginning-position 5)))))

;; ;; kill a line, including whitespace characters until next non-whiepsace character
;; ;; of next line
;; (defadvice kill-line (before check-position activate)
;;   (if (member major-mode
;;               '(emacs-lisp-mode scheme-mode lisp-mode
;;                                 c-mode c++-mode objc-mode
;;                                 latex-mode plain-tex-mode))
;;       (if (and (eolp) (not (bolp)))
;;           (progn (forward-char 1)
;;                  (just-one-space 0)
;;                  (backward-char 1)))))

;; ;; taken from prelude-editor.el
;; ;; automatically indenting yanked text if in programming-modes
;; (defvar yank-indent-modes
;;   '(LaTeX-mode TeX-mode)
;;   "Modes in which to indent regions that are yanked (or yank-popped).
;; Only modes that don't derive from `prog-mode' should be listed here.")

;; (defvar yank-indent-blacklisted-modes
;;   '(python-mode slim-mode haml-mode)
;;   "Modes for which auto-indenting is suppressed.")

;; (defvar yank-advised-indent-threshold 1000
;;   "Threshold (# chars) over which indentation does not automatically occur.")

;; (defun yank-advised-indent-function (beg end)
;;   "Do indentation, as long as the region isn't too large."
;;   (if (<= (- end beg) yank-advised-indent-threshold)
;;       (indent-region beg end nil)))

;; (defadvice yank (after yank-indent activate)
;;   "If current mode is one of 'yank-indent-modes,
;; indent yanked text (with prefix arg don't indent)."
;;   (if (and (not (ad-get-arg 0))
;;            (not (member major-mode yank-indent-blacklisted-modes))
;;            (or (derived-mode-p 'prog-mode)
;;                (member major-mode yank-indent-modes)))
;;       (let ((transient-mark-mode nil))
;;         (yank-advised-indent-function (region-beginning) (region-end)))))

;; (defadvice yank-pop (after yank-pop-indent activate)
;;   "If current mode is one of `yank-indent-modes',
;; indent yanked text (with prefix arg don't indent)."
;;   (when (and (not (ad-get-arg 0))
;;              (not (member major-mode yank-indent-blacklisted-modes))
;;              (or (derived-mode-p 'prog-mode)
;;                  (member major-mode yank-indent-modes)))
;;     (let ((transient-mark-mode nil))
;;       (yank-advised-indent-function (region-beginning) (region-end)))))

;; ;; prelude-core.el
;; (defun indent-buffer ()
;;   "Indent the currently visited buffer."
;;   (interactive)
;;   (indent-region (point-min) (point-max)))

;; ;; prelude-editing.el
;; (defcustom prelude-indent-sensitive-modes
;;   '(coffee-mode python-mode slim-mode haml-mode yaml-mode)
;;   "Modes for which auto-indenting is suppressed."
;;   :type 'list)

;; (defun indent-region-or-buffer ()
;;   "Indent a region if selected, otherwise the whole buffer."
;;   (interactive)
;;   (unless (member major-mode prelude-indent-sensitive-modes)
;;     (save-excursion
;;       (if (region-active-p)
;;           (progn
;;             (indent-region (region-beginning) (region-end))
;;             (message "Indented selected region."))
;;         (progn
;;           (indent-buffer)
;;           (message "Indented buffer.")))
;;       (whitespace-cleanup))))

;; (global-set-key (kbd "C-c i") 'indent-region-or-buffer)

;; ;; add duplicate line function from Prelude
;; ;; taken from prelude-core.el
;; (defun prelude-get-positions-of-line-or-region ()
;;   "Return positions (beg . end) of the current line
;; or region."
;;   (let (beg end)
;;     (if (and mark-active (> (point) (mark)))
;;         (exchange-point-and-mark))
;;     (setq beg (line-beginning-position))
;;     (if mark-active
;;         (exchange-point-and-mark))
;;     (setq end (line-end-position))
;;     (cons beg end)))

;; ;; smart openline
;; (defun prelude-smart-open-line (arg)
;;   "Insert an empty line after the current line.
;; Position the cursor at its beginning, according to the current mode.
;; With a prefix ARG open line above the current line."
;;   (interactive "P")
;;   (if arg
;;       (prelude-smart-open-line-above)
;;     (progn
;;       (move-end-of-line nil)
;;       (newline-and-indent))))

;; (defun prelude-smart-open-line-above ()
;;   "Insert an empty line above the current line.
;; Position the cursor at it's beginning, according to the current mode."
;;   (interactive)
;;   (move-beginning-of-line nil)
;;   (newline-and-indent)
;;   (forward-line -1)
;;   (indent-according-to-mode))

;; (global-set-key (kbd "M-o") 'prelude-smart-open-line)
;; (global-set-key (kbd "M-o") 'open-line)
;; ----------------------------------------------------------------------
;; END
;; ----------------------------------------------------------------------


(windmove-default-keybindings)

;; function-args
;; (require 'function-args)
;; (fa-config-default)
;; (define-key c-mode-map  [(tab)] 'moo-complete)
;; (define-key c++-mode-map  [(tab)] 'moo-complete)

;; company
(require 'company)
;; (add-hook 'after-init-hook 'global-company-mode)
;; (delete 'company-semantic company-backends)
;; (define-key c-mode-map  [(control tab)] 'company-complete)
;; (define-key c++-mode-map  [(control tab)] 'company-complete)


;; company-c-headers
(add-to-list 'company-backends 'company-c-headers)


;; hs-minor-mode for folding source code
(add-hook 'c-mode-common-hook 'hs-minor-mode)



(require 'ede)
(global-ede-mode)

(ede-cpp-root-project "imagesearch"
                      :file "/home/bingqingqu/programming_practice/workspace/imagesearch/Makefile"
                      :include-path '("/src") ;; add more include
                      ;; paths here
                      :system-include-path '("/home/bingqingqu/user-libs/vlfeat/vlfeat-0.9.19"))
(add-hook 'c++-mode-hook
          (lambda () (setq flycheck-clang-include-path
                           (list (expand-file-name "/home/bingqingqu/user-libs/vlfeat/vlfeat-0.9.19")))))
;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq
 c-default-style "ellemtel" ;; set style to "linux"
 )
(setq-default c-basic-offset 4)

(global-set-key (kbd "RET") 'newline-and-indent)  ; automatically indent when press RET

;; activate whitespace-mode to view all whitespace characters
(global-set-key (kbd "C-c w") 'whitespace-mode)

;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1)))

;; ;; use space to indent by default
;; (setq-default indent-tabs-mode nil)

;; ;; set appearance of a tab that is represented by 4 spaces
;; (setq-default tab-width 4)

;; Compilation
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

;; setup GDB
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

;; Package: clean-aindent-mode
(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

;; ;; Package: dtrt-indent
;; (require 'dtrt-indent)
;; (dtrt-indent-mode 1)

;; Package: ws-butler
(require 'ws-butler)
(add-hook 'prog-mode-hook 'ws-butler-mode)

;; Package: projejctile
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)

;; Package: yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; Package zygospore
(global-set-key (kbd "C-x 1") 'zygospore-toggle-delete-other-windows)


(provide 'bq-cpp)
