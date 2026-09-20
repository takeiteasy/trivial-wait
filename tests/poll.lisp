(in-package #:trivial-wait/tests)

(in-suite :trivial-wait/poll)

(test a-backend-is-available
  (is (member (poll:backend) '(:kqueue :poll))
      "~a has no descriptor polling backend" (poll:backend)))

(test nothing-to-wait-on-returns-nothing
  (is (null (poll:wait '() :timeout 0))))

(test a-quiet-descriptor-is-not-ready
  (with-pipe (read write)
    (is (null (poll:wait (list read) :timeout 0)))
    (is (null (poll:ready-p read)))))

(test a-written-pipe-reads-as-ready
  (with-pipe (read write)
    (fill-pipe write)
    (let ((ready (poll:wait (list read) :timeout 1)))
      (is (equal (list read) (mapcar #'car ready)))
      (is (member :input (cdr (first ready)))))
    (is (member :input (poll:ready-p read)))))

(test a-pipe-waits-until-it-is-written
  (with-pipe (read write)
    (let ((writer (bt2:make-thread (lambda ()
                                     (sleep 0.2)
                                     (fill-pipe write)))))
      (is (equal (list read) (mapcar #'car (poll:wait (list read)
                                                      :timeout 5))))
      (bt2:join-thread writer))))

(test only-the-ready-descriptor-comes-back
  (with-pipe (quiet-read quiet-write)
    (with-pipe (read write)
      (fill-pipe write)
      (is (equal (list read)
                 (mapcar #'car (poll:wait (list quiet-read read)
                                          :timeout 1)))))))

(test a-write-end-is-ready-to-write
  (with-pipe (read write)
    (is (member :output (poll:ready-p write :events :output)))))

(test a-timeout-that-passes-returns-nothing
  (with-pipe (read write)
    (is (null (poll:wait (list read) :timeout 0.1)))))
