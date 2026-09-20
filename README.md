# trivial-wait

Wrappers over what a platform gives for waiting. Two halves, each its own
system:

- `trivial-wait/poll` — wait for file descriptors to become ready.
- `trivial-wait/notify` — watch files and directories for changes.

```lisp
(asdf:load-system "trivial-wait")

(trivial-wait.poll:wait (list descriptor) :timeout 5)

(trivial-wait.notify:watch (list #p"src/") (lambda () (print :changed)))
```

## Docs

- [Polling descriptors](docs/poll.md)
- [Watching files](docs/notify.md)
- [Backends](docs/backends.md)

## License

```
trivial-wait
Copyright (C) 2026 George Watson

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
```
