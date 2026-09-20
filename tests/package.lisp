(defpackage #:trivial-wait/tests
  (:use #:cl #:fiveam)
  (:local-nicknames (#:poll #:trivial-wait.poll)
                    (#:notify #:trivial-wait.notify)))

(in-package #:trivial-wait/tests)

(def-suite :trivial-wait/poll)
(def-suite :trivial-wait/notify)
