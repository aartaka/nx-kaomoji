;;;; package.lisp

(defpackage #:nx-kaomoji
  (:use #:cl)
  (:import-from #:nyxt
                #:define-class
                #:define-mode
                #:define-command-global
                #:autofill
                #:autofill-name
                #:autofill-fill
                #:prompt
                #:%paste
                #:make-command)
  (:export #:kaomoji-fill
           #:*kaomojis*
           #:parse-kaomojis))
