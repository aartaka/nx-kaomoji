;;;; package.lisp

(defpackage #:nx-kaomoji
  (:use #:cl)
  (:import-from #:nyxt
                #:define-class
                #:define-mode
                #:define-command
                #:autofill
                #:autofill-name
                #:autofill-fill)
  (:export #:kaomoji-fill
           #:*kaomojis*
           #:parse-kaomojis))
