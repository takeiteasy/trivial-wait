(defpackage #:trivial-wait.notify
  (:use #:cl)
  (:local-nicknames (#:kq #:trivial-wait.kqueue))
  (:export #:backend #:native-p #:watch))
