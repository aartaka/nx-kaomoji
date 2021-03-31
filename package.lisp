;;;; package.lisp

(defpackage #:nx-kaomoji
  (:use #:cl)
  (:import-from #:nyxt
                #:define-class
                #:define-mode
                #:define-command
                #:autofill)
  (:export #:kaomoji-fill
           #:*kaomojis*
           #:parse-kaomojis))
