;;;; nx-kaomoji.lisp

(in-package #:nx-kaomoji)

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
                                  (list (make-instance
                                         'kaomoji
                                         :name (first tags)
                                         :fill emoticon))
                                  (mapcar #'(lambda (tag)
                                              (make-instance
                                               'nyxt:autofill
                                               :name tag
                                               :fill emoticon))
                                          tags))))
                        emoticons)))

(defmethod prompter:object-attributes ((kaomoji kaomoji))
  `(("Name" ,(autofill-name kaomoji))
    ("Fill" ,(let ((f (autofill-fill kaomoji)))
               (typecase f
                 (string (write-to-string f))
                 (t "function"))))))

(defvar *kaomojis* (parse-kaomojis))

(define-class kaomoji-source (prompter:source)
  ((prompter:name "Kaomojis")
   (prompter:constructor *kaomojis*)
   (prompter:actions
    (list (make-command autofill* (autofills)
            (let ((selected-fill (first autofills)))
              (cond ((stringp (autofill-fill selected-fill))
                     (%paste :input-text (autofill-fill selected-fill)))
                    ((functionp (autofill-fill selected-fill))
                     (%paste :input-text (funcall (autofill-fill selected-fill))))))))))
  (:export-class-name-p t))

(define-command-global refresh-kaomojis ()
  "Refresh the kaomojis list."
  (setf *kaomojis* (parse-kaomojis)))

(define-command-global kaomoji-fill ()
  "Autofill the currently focused input field with the chosen Kaomoji."
  (prompt
   :prompt "Kaomoji"
   :sources (make-instance 'kaomoji-source)))
