;;; package --- recent opened file with revision
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 50
      recentf-exclude '("tmp/" "ssh:"))
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(provide 'bq-recentf)
