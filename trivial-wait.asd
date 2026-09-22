(defsystem "trivial-wait"
  :description "Wrappers over what a platform gives for waiting: descriptor
readiness and filesystem events."
  :author "George Watson"
  :license "MIT"
  :version "0.1.0"
  :depends-on ("trivial-wait/poll" "trivial-wait/notify")
  :in-order-to ((test-op (test-op "trivial-wait/tests"))))

(defsystem "trivial-wait/kqueue"
  :description "The kqueue calls both halves share."
  :author "George Watson"
  :license "MIT"
  :version "0.1.0"
  :depends-on ("cffi")
  :pathname "kqueue/"
  :serial t
  :components ((:file "package")
               (:file "kqueue")))

(defsystem "trivial-wait/poll"
  :description "Wait for descriptors to become ready."
  :author "George Watson"
  :license "MIT"
  :version "0.1.0"
  :depends-on ("cffi" "trivial-wait/kqueue")
  :pathname "poll/"
  :serial t
  :components ((:file "package")
               (:file "poll")
               (:file "kqueue")
               (:file "wait"))
  :in-order-to ((test-op (test-op "trivial-wait/poll/tests"))))

(defsystem "trivial-wait/notify"
  :description "Watch files and directories for changes."
  :author "George Watson"
  :license "MIT"
  :version "0.1.0"
  :depends-on ("cffi" "uiop" "bordeaux-threads" "trivial-wait/kqueue")
  :pathname "notify/"
  :serial t
  :components ((:file "package")
               (:file "files")
               (:file "kqueue")
               (:file "scan")
               (:file "watch"))
  :in-order-to ((test-op (test-op "trivial-wait/notify/tests"))))

(defsystem "trivial-wait/tests"
  :depends-on ("trivial-wait/poll/tests" "trivial-wait/notify/tests")
  :in-order-to ((test-op (test-op "trivial-wait/poll/tests")
                         (test-op "trivial-wait/notify/tests"))))

(defsystem "trivial-wait/tests/harness"
  :description "The package and descriptor helpers the suites share."
  :depends-on ("trivial-wait" "fiveam" "cffi" "bordeaux-threads")
  :pathname "tests/"
  :serial t
  :components ((:file "package")
               (:file "pipe")))

(defsystem "trivial-wait/poll/tests"
  :depends-on ("trivial-wait/poll" "trivial-wait/tests/harness")
  :pathname "tests/"
  :components ((:file "poll"))
  :perform (test-op (o c)
             (unless (symbol-call :fiveam :run! :trivial-wait/poll)
               (error "trivial-wait/poll tests failed"))))

(defsystem "trivial-wait/notify/tests"
  :depends-on ("trivial-wait/notify" "trivial-wait/tests/harness" "uiop")
  :pathname "tests/"
  :components ((:file "notify"))
  :perform (test-op (o c)
             (unless (symbol-call :fiveam :run! :trivial-wait/notify)
               (error "trivial-wait/notify tests failed"))))
