;;;; -*- mode: lisp -*-
;;;;
;;;; Copyright (c) 2013, Georgia Tech Research Corporation
;;;; All rights reserved.
;;;;
;;;; Author(s): Neil T. Dantam <ntd@gatech.edu>
;;;; Georgia Tech Humanoid Robotics Lab
;;;; Under Direction of Prof. Mike Stilman <mstilman@cc.gatech.edu>
;;;;
;;;;
;;;; This file is provided under the following "BSD-style" License:
;;;;
;;;;
;;;;   Redistribution and use in source and binary forms, with or
;;;;   without modification, are permitted provided that the following
;;;;   conditions are met:
;;;;
;;;;   * Redistributions of source code must retain the above copyright
;;;;     notice, this list of conditions and the following disclaimer.
;;;;
;;;;   * Redistributions in binary form must reproduce the above
;;;;     copyright notice, this list of conditions and the following
;;;;     disclaimer in the documentation and/or other materials provided
;;;;     with the distribution.
;;;;
;;;;   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
;;;;   CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
;;;;   INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
;;;;   MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;;;;   DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
;;;;   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;;;;   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
;;;;   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
;;;;   USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
;;;;   AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;;;;   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
;;;;   ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;;;;   POSSIBILITY OF SUCH DAMAGE.


(in-package :amino-ffi)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; CALL BY REFERENCING ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro with-reference ((var value type) &body body)
  (with-gensyms (ptr)
    `(let ((,ptr ,value))
       (cffi:with-foreign-object (,var ',type)
         (setf (cffi:mem-ref ,var ',type) ,ptr)
         ,@body))))

(defmacro def-ref-type (name value-type)
  `(progn
     (define-foreign-type ,name ()
       ()
       (:simple-parser ,name)
       (:actual-type :pointer))
     (defmethod expand-to-foreign-dyn (value var body (type ,name))
       (append (list 'with-reference (list var value ',value-type))
                     body))))

(def-ref-type int-ref-t :int)
(def-ref-type double-ref-t :double)
(def-ref-type float-ref-t :float)
(def-ref-type size-ref-t size-t)
(def-ref-type char-ref-t :uint8)


;;;;;;;;;;;;;;;;;;;;;
;;; FOREIGN ARRAY ;;;
;;;;;;;;;;;;;;;;;;;;;

;; an un-offset foreign array
(define-foreign-type foreign-array-t ()
  ()
  (:simple-parser foreign-array-t)
  (:actual-type :pointer))

(defmethod expand-to-foreign-dyn (value var body (type foreign-array-t))
  `(with-pointer-to-vector-data (,var ,value)
     ,@body))
