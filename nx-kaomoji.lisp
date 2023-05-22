;;;; nx-kaomoji.lisp

(in-package #:nx-kaomoji)

#+nyxt-2
(define-class kaomoji (autofill)
  ()
  (:export-class-name-p t)
  (:export-accessor-names-p t)
  (:accessor-name-transformer (hu.dwim.defclass-star:make-name-transformer name))
  (:documentation "An inherited `nyxt:autofill' to define custom prompt-buffer attributes."))

(defun parse-kaomojis ()
  (let ((emoticons (mapcar (alexandria:curry #'str:split (string #\Tab))
                           (uiop:read-file-lines
                            (asdf:system-relative-pathname
                             :nx-kaomoji "splatmoji/data/emoticons/emoticons.tsv"))))
        (counter 0))
    (alexandria:mappend #'(lambda (em)
                            (let ((emoticon (first em))
                                  (tags (mapcar #'str:trim (str:split "," (second em)))))
                              (incf counter)
                              (if (serapeum:single tags)
                                  (list (make-instance #+nyxt-2 'kaomoji
                                                       #+nyxt-3 'autofill
                                                       :name (first tags) :fill emoticon))
                                  (mapcar #'(lambda (tag)
                                              (make-instance #+nyxt-2 'kaomoji
                                                             #+nyxt-3 'autofill
                                                             :name tag :fill emoticon))
                                          tags))))
                        emoticons)))

(defvar *kaomojis* (parse-kaomojis))
#+nyxt-2
(define-class kaomoji-source (prompter:source)
  ((prompter:name "Kaomojis")
   (prompter:constructor *kaomojis*)
   (prompter:actions
    (list
     (make-command autofill* (autofills)
                   (let* ((selected-fill (first autofills))
                          (fill (autofill-fill selected-fill))
                          (value (if (functionp fill) (funcall fill) fill)))
                     (nyxt:%paste :input-text value))))))
  (:export-class-name-p t))
#+nyxt-3
(define-class kaomoji-source (autofill-source)
  ((prompter:name "Kaomojis")
   (prompter:constructor *kaomojis*))
  (:export-class-name-p t))

#+nyxt-2
(defmethod prompter:object-attributes ((kaomoji kaomoji))
  `(("Name" ,(autofill-name kaomoji))
    ("Fill" ,(let ((f (autofill-fill kaomoji)))
               (typecase f
                 (string (write-to-string f))
                 (t "function"))))))
#+nyxt-3
(defmethod prompter:object-attributes ((kaomoji autofill) (source kaomoji-source))
  `(("Name" ,(autofill-name kaomoji))
    ("Fill" ,(write-to-string (autofill-fill kaomoji)))))

(define-command-global refresh-kaomojis ()
  "Refresh the kaomojis list."
  (setf *kaomojis* (parse-kaomojis)))

(define-command-global kaomoji-fill ()
  "Autofill the currently focused input field with the chosen Kaomoji."
  (prompt
   :prompt "Kaomoji"
   :sources (make-instance 'kaomoji-source)))
