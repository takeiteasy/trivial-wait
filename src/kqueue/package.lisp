(defpackage #:trivial-wait.kqueue
  (:use #:cl)
  (:export #:supported-p
           #:+filter-read+ #:+filter-write+ #:+filter-vnode+ #:+filter-user+
           #:+flag-add+ #:+flag-enable+ #:+flag-clear+ #:+flag-oneshot+
           #:+flag-eof+ #:+flag-error+
           #:+note-trigger+ #:+note-vnode+
           #:open-queue #:close-queue #:set-event #:change #:wake #:wait))
