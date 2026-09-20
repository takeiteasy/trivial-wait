;;;; pipe.lisp — a pipe to make a descriptor ready with

(in-package #:trivial-wait/tests)

(cffi:defcfun ("pipe" %pipe) :int (descriptors :pointer))
(cffi:defcfun ("write" %write) :long (descriptor :int) (buffer :pointer)
  (count :unsigned-long))
(cffi:defcfun ("close" %close) :int (descriptor :int))

(defun make-pipe ()
  "(values read-end write-end)."
  (cffi:with-foreign-object (ends :int 2)
    (unless (zerop (%pipe ends))
      (error "pipe(2) failed"))
    (values (cffi:mem-aref ends :int 0) (cffi:mem-aref ends :int 1))))

(defun fill-pipe (descriptor)
  (cffi:with-foreign-object (byte :unsigned-char)
    (setf (cffi:mem-ref byte :unsigned-char) 42)
    (%write descriptor byte 1)))

(defmacro with-pipe ((read write) &body body)
  `(multiple-value-bind (,read ,write) (make-pipe)
     (declare (ignorable ,read ,write))
     (unwind-protect (progn ,@body)
       (%close ,read)
       (%close ,write))))
