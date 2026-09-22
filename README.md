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

```text
The MIT License (MIT)

Copyright (c) 2026 George Watson

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
