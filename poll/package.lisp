(defpackage #:trivial-wait.poll
  (:use #:cl)
  (:local-nicknames (#:kq #:trivial-wait.kqueue))
  (:export #:backend #:wait #:ready-p))
