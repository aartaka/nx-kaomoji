;;;; package.lisp

(defpackage #:nx-kaomoji
  (:use #:cl)
  (:import-from #:nyxt
                #:define-class
                #:define-mode
                #:define-command-global
                #:prompt
                #:%paste
                #:make-command
                #:lambda-command)
  #+nyxt-2
  (:import-from #:nyxt
                #:autofill
                #:autofill-name
                #:autofill-fill)
  #+nyxt-3
  (:import-from #:nyxt/autofill-mode
                #:autofill
                #:autofill-name
                #:autofill-fill)
  (:export #:kaomoji-fill
           #:*kaomojis*
           #:parse-kaomojis))
