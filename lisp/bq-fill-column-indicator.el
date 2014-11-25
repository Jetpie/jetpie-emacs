;;; package --- fill-column-indicator

(require-package 'fill-column-indicator)

(define-globalized-minor-mode
 global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode t)

;; (setq fci-rule-width 1)
;; (setq fci-rule-color "orange")


(provide 'bq-fill-column-indicator)
