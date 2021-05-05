;;;; nx-kaomoji.asd

(asdf:defsystem #:nx-kaomoji
  :description "Describe nx-kaomoji here"
  :author "Artyom Bologov"
  :license  "BSD 2-clause"
  :version "1.0"
  :serial t
  :depends-on (#:nyxt)
  :components ((:file "package")
               (:file "nx-kaomoji")))
