# CI

CI runs SBCL and ECL on Linux for every code change.

| Trigger | Jobs |
|---|---|
| Push to `trunk` or pull request | SBCL and ECL |
| Docs-only change | None |
| Manual dispatch | SBCL, ECL, or both |

New pushes cancel the previous run for the same branch or pull request.

```sh
gh workflow run ci.yml -f lisp=ecl
```

[`.build.yml`](../.build.yml) also runs SBCL on Linux on every push to the sr.ht
mirror.

Run `tests/test.sh sbcl` locally before pushing; the same script runs in CI.
