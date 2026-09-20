;;;; wait.lisp — the poll half's only entry points

(in-package #:trivial-wait.poll)

(defun backend ()
  "The backend WAIT uses here: :kqueue, :poll, or nil where neither exists."
  (cond #+darwin ((kq:supported-p) :kqueue)
        #+unix (t :poll)
        (t nil)))

(defun wait (descriptors &key timeout (events :input))
  "Wait for any of DESCRIPTORS to be ready, up to TIMEOUT seconds, or
forever if TIMEOUT is nil. EVENTS is :input, :output or :both. Returns
each ready descriptor as (descriptor . readiness), where readiness holds
any of :input, :output, :error, :hangup and :invalid."
  (declare (ignorable descriptors timeout events))
  (when descriptors
    (ecase (backend)
      #+darwin (:kqueue (%kqueue-wait descriptors events timeout))
      #+unix (:poll (%poll-wait descriptors events timeout))
      ((nil) (error "No descriptor polling backend on this platform.")))))

(defun ready-p (descriptor &key (events :input))
  "Whether DESCRIPTOR is ready now, without waiting."
  (cdr (assoc descriptor (wait (list descriptor) :timeout 0 :events events))))
