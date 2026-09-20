;;;; poll.lisp — poll(2), the fallback every unix has

(in-package #:trivial-wait.poll)

#+unix
(progn
  (defconstant +pollin+ #x0001)
  (defconstant +pollout+ #x0004)
  (defconstant +pollerr+ #x0008)
  (defconstant +pollhup+ #x0010)
  (defconstant +pollnval+ #x0020)

  (cffi:defcstruct pollfd
    (descriptor :int)
    (events :short)
    (revents :short))

  (cffi:defcfun ("poll" %poll) :int
    (descriptors :pointer)
    (count #+darwin :unsigned-int #-darwin :unsigned-long)
    (milliseconds :int))

  (defun %interest (events)
    (ecase events
      (:input +pollin+)
      (:output +pollout+)
      (:both (logior +pollin+ +pollout+))))

  (defun %readiness (revents)
    (loop for (bit flag) in (list (list +pollin+ :input) (list +pollout+ :output)
                                  (list +pollerr+ :error) (list +pollhup+ :hangup)
                                  (list +pollnval+ :invalid))
          unless (zerop (logand revents bit))
            collect flag))

  (defun %poll-wait (descriptors events timeout)
    (let ((count (length descriptors))
          (interest (%interest events)))
      (cffi:with-foreign-object (array '(:struct pollfd) count)
        (loop for descriptor in descriptors
              for index from 0
              for entry = (cffi:mem-aptr array '(:struct pollfd) index)
              do (setf (cffi:foreign-slot-value entry '(:struct pollfd)
                                                'descriptor)
                       descriptor
                       (cffi:foreign-slot-value entry '(:struct pollfd) 'events)
                       interest
                       (cffi:foreign-slot-value entry '(:struct pollfd) 'revents)
                       0))
        (let ((ready (%poll array count (if timeout
                                            (round (* timeout 1000))
                                            -1))))
          (when (plusp ready)
            (loop for descriptor in descriptors
                  for index from 0
                  for entry = (cffi:mem-aptr array '(:struct pollfd) index)
                  for revents = (cffi:foreign-slot-value entry '(:struct pollfd)
                                                         'revents)
                  unless (zerop revents)
                    collect (cons descriptor (%readiness revents)))))))))
