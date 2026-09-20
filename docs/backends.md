# Backends

Each half picks the best backend the platform has.

| Platform | `poll` | `notify` |
|---|---|---|
| macOS | kqueue | kqueue |
| Linux | poll(2) | scan |
| FreeBSD, NetBSD, OpenBSD | poll(2) | scan |
| Windows | none | scan |

`(trivial-wait.poll:backend)` and `(trivial-wait.notify:backend)` name the
one in use.

## Fallbacks

`poll(2)` is available on every unix and needs no state between calls, so it
serves where nothing better is bound yet.

The scan backend reads each watched file on a timer and compares its
contents, so a change within the same second as the last scan is still seen.
It costs a read of every watched file per interval.

## Unbound backends

epoll, inotify, IOCP and ReadDirectoryChangesW are not bound yet, nor are
the BSD kqueue layouts: `struct kevent` differs on each BSD, so each needs
its own binding, tested on the platform. See the
[tracker](https://todo.sr.ht/~takeiteasy/trivial-wait).
