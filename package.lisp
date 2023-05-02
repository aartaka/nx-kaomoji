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
  (:import-from
   #+(or 3-pre-release-1 3-pre-release-2 3-pre-release-3 3-pre-release-4 3-pre-release-5 3-pre-release-6)
   #:nyxt/autofill-mode
   #-(or 3-pre-release-1 3-pre-release-2 3-pre-release-3 3-pre-release-4 3-pre-release-5 3-pre-release-6)
   #:nyxt/mode/autofill
   #:autofill
   #:autofill-name
   #:autofill-fill
   #:autofill-source)
  (:export #:kaomoji-fill
           #:*kaomojis*
           #:parse-kaomojis))
