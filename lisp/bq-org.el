(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)


(setq org-agenda-files (list "~/org/work.org"
                             "~/org/home.org"))


(provide 'bq-org)
