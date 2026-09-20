;;;; kqueue.lisp — descriptor readiness through kqueue

(in-package #:trivial-wait.poll)

#+darwin
(defun %kqueue-wait (descriptors events timeout)
  "One-shot registrations, so the queue is empty again when WAIT returns."
  (let ((queue (kq:open-queue)))
    (when queue
      (unwind-protect
           (let ((filters (ecase events
                            (:input (list kq:+filter-read+))
                            (:output (list kq:+filter-write+))
                            (:both (list kq:+filter-read+ kq:+filter-write+))))
                 (registration (logior kq:+flag-add+ kq:+flag-oneshot+)))
             (dolist (descriptor descriptors)
               (dolist (filter filters)
                 (kq:change queue descriptor filter registration 0)))
             (let ((ready '()))
               (loop for (ident filter event-flags) in (kq:wait queue
                                                          (* (length descriptors)
                                                             (length filters))
                                                          timeout)
                     for readiness = (append
                                      (when (eql filter kq:+filter-read+)
                                        '(:input))
                                      (when (eql filter kq:+filter-write+)
                                        '(:output))
                                      (unless (zerop (logand event-flags
                                                             kq:+flag-error+))
                                        '(:error))
                                      (unless (zerop (logand event-flags
                                                             kq:+flag-eof+))
                                        '(:hangup)))
                     do (let ((entry (assoc ident ready)))
                          (if entry
                              (setf (cdr entry)
                                    (union (cdr entry) readiness))
                              (push (cons ident readiness) ready))))
               (nreverse ready)))
        (kq:close-queue queue)))))
