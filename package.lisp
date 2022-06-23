;;;; package.lisp

#+nyxt-2
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
  (:import-from #:nyxt
                #:autofill
                #:autofill-name
                #:autofill-fill)
  (:export #:kaomoji-fill
           #:*kaomojis*
           #:parse-kaomojis))

#+nyxt-3
(nyxt:define-package #:nx-kaomoji
    (:import-from #:nyxt/autofill-mode
                  #:autofill
                  #:autofill-name
                  #:autofill-fill)
  (:export #:kaomoji-fill
           #:*kaomojis*
           #:parse-kaomojis))
