# Polling descriptors

`trivial-wait/poll` waits for file descriptors to become ready.

```lisp
(trivial-wait.poll:wait (list a b) :timeout 5 :events :input)
;; => ((3 :input))
```

| Call | Value |
|---|---|
| `(wait descriptors &key timeout events)` | Each ready descriptor as `(descriptor . readiness)`. |
| `(ready-p descriptor &key events)` | The readiness of one descriptor now, without waiting. |
| `(backend)` | The [backend](backends.md) in use: `:kqueue` or `:poll`. |

`timeout` is in seconds; nil waits forever and 0 returns at once. `events`
is `:input`, `:output` or `:both`, and applies to every descriptor in the
call.

Readiness is a list holding any of `:input`, `:output`, `:error`, `:hangup`
and `:invalid`. A descriptor that is not ready is left out of the result.

`wait` signals an error where the platform has no backend.
