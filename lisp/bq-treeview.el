;;; tree view using neo tree

(require-package 'neotree)
(global-set-key [f8] 'neotree-toggle)

(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (ffip-project-root))
        (file-name (buffer-file-name)))
    (if project-dir
        (progn
          (neotree-dir project-dir)
          (neotree-find file-name))
      (message "Could not find git project root."))))

;; (define-key map (kbd "C-c C-p") 'neotree-project-dir)

(provide 'bq-treeview)
