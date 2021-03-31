;;;; nx-kaomoji.asd

(asdf:defsystem #:nx-kaomoji
  :description "Describe nx-kaomoji here"
  :author "Artyom Bologov"
  :license  "BSD 2-clause"
  :version "0.9"
  :serial t
  :depends-on (#:nyxt)
  :components ((:file "package")
               (:file "nx-kaomoji")))
