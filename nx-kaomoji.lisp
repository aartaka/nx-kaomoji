;;;; nx-kaomoji.lisp

(in-package #:nx-kaomoji)

(defun parse-kaomojis ()
  (let ((emoticons (cl-csv:read-csv
                    (uiop:read-file-string
                     (asdf:system-relative-pathname
                      :nx-kaomoji "splatmoji/data/emoticons/emoticons.tsv"))
                    :separator #\Tab :escape nil :quote nil))
        (counter 0))
    (alexandria:mappend #'(lambda (em)
                            (let ((emoticon (first em))
                                  (tags (mapcar #'str:trim (str:split "," (second em)))))
                              (incf counter)
                              (if (serapeum:single tags)
                                  (list (make-instance
                                         'nyxt:autofill
                                         :key (str:concat (first tags) (format nil "~d" counter))
                                         :name (first tags)
                                         :fill emoticon))
                                  (mapcar #'(lambda (tag)
                                              (make-instance
                                               'nyxt:autofill
                                               :key (str:concat tag (format nil "~d" counter))
                                               :name tag
                                               :fill emoticon))
                                          tags))))
                        emoticons)))

(defvar *kaomojis* (parse-kaomojis))

(in-package #:nyxt)

(define-class kaomoji-source (prompter:source)
  ((prompter:name "Kaomojis")
   (prompter:constructor nx-kaomoji:*kaomojis*)
   (prompter:actions
    (list (make-command autofill* (autofills)
            (let ((selected-fill (first autofills)))
              (cond ((stringp (autofill-fill selected-fill))
                     (%paste :input-text (autofill-fill selected-fill)))
                    ((functionp (autofill-fill selected-fill))
                     (%paste :input-text (funcall (autofill-fill selected-fill))))))))))
  (:export-class-name-p t))

(define-command kaomoji-fill ()
  "Autofill the currently focused input field with the chosen Kaomoji."
  (prompt
   :prompt "Kaomoji"
   :sources (make-instance 'kaomoji-source)))
