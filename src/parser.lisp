(in-package #:web-cc)


(defparameter *top-level-rule* 'number)


(defun parse-number (num)
  (let ((n (parse-number:parse-real-number num)))
    (if (floatp n) n (float n))))

(defun parse (expression &optional (result :number))
  (case result
    (:number (eval (esrap:parse *top-level-rule* expression)))
    (:tree (values (esrap:parse *top-level-rule* expression)))))


;; Grammar rules
(defrule digit (character-ranges (#\0 #\9)))
(defrule digits (+ digit))

(defrule number (or exponentfloat pointfloat digits)
  (:text t)
  (:function parse-number))

(defrule pointfloat (or (and (? digits) "." digits)
                        (and digits ".")))

(defrule exponentfloat (and (or pointfloat digits)
                            (or "e" "E")
                            (? (or "+" "-"))
                            digits))
