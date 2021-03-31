;;;; nx-kaomoji.lisp

(in-package #:nx-kaomoji)

(defun parse-kaomojis ()
  (let* ((kao-json (cl-json:decode-json-from-source
                    (asdf:system-relative-pathname
                     :nx-kaomoji "kaomoji/data/jp.json"))))
    (alexandria:mappend #'(lambda (category)
                            (let ((category-name (alexandria:assoc-value category :name))
                                  (counter 0))
                              (mapcar
                               #'(lambda (entry)
                                   (make-instance
                                    'nyxt:autofill
                                    :key (prog1 (str:concat (str:downcase category-name)
                                                            (format nil "~d" counter))
                                           (incf counter))
                                    :name (alexandria:assoc-value entry :description)
                                    :fill (alexandria:assoc-value entry :emoticon)))
                               (alexandria:assoc-value category :entries))))
                        (alexandria:assoc-value kao-json :categories))))

(defvar *kaomojis* (parse-kaomojis))

(in-package #:nyxt)

(define-class kaomoji-source (prompter:source)
  ((prompter:name "Kaomojis")
   (prompter:must-match-p t)
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
