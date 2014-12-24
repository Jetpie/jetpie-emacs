;;; python --- main configurations for python mode

;; python mode
(require 'python-mode)
;; (setq ipython-command "/usr/bin/ipython2")
;; (require 'ipython)

; use IPythonn
(setq-default py-shell-name "ipython")
(setq-default py-which-bufname "IPython")
; use the wx backend, for both mayavi and matplotlib
(setq py-python-command-args
  '("--gui=wx" "--pylab=wx" "-colors" "Linux"))
(setq py-force-py-shell-name-p t)

(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code
   "from IPython.core.completerlib import module_completion"
 python-shell-completion-module-string-code
   "';'.join(module_completion('''%s'''))\n"
 python-shell-completion-string-code
   "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

; switch to the interpreter after executing code
(setq py-shell-switch-buffers-on-execute-p t)
(setq py-switch-buffers-on-execute-p t)
; split windows
(setq py-split-windows-on-execute-p nil)
; try to automagically figure out indentation
(setq py-smart-indentation t)


(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
                ("SConscript\\'" . python-mode))
              auto-mode-alist))


;; -----------------------------
;; emacs IPython notebook config
;; -----------------------------
; IPython notebook
(require-package 'websocket)
(require-package 'request)
;; update ein2
(require-package 'ein)
(require 'ein)

; shortcut function to load notebooklist
(defun load-ein ()
  (ein:notebooklist-load)
  (interactive)
  (ein:notebooklist-open))

; use autocompletion, but don't start to autocomplete after a dot
;; (setq ein:complete-on-dot -1)
(setq ein:use-auto-complete 1)

; set python console args
(setq ein:console-args
      (if (eq system-type 'darwin)
          '("--gui=osx" "--matplotlib=osx" "--colors=Linux")
        (if (eq system-type 'gnu/linux)
            '("--gui=wx" "--matplotlib=wx" "--colors=Linux"))))

; timeout settings
(setq ein:query-timeout 1000)

;; (require-package 'epc)
;; (require-package 'deferred)

(require-package 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)

(setq jedi:complete-on-dot t)                 ; optional

(setq jedi:environment-virtualenv
      (list "virtualenv" "--system-site-packages"))





; keybingdings
;; (eval-after-load 'python
;;   '(define-key python-mode-map (kbd "C-c !") 'python-shell-switch-to-shell))
;; (eval-after-load 'python
;;   '(define-key python-mode-map (kbd "C-c |") 'python-shell-send-region))
;; (require-package 'pip-requirements)

(provide 'bq-python)
