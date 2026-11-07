# Shell utilities

## `update_cache.zsh`

Source this file in zsh, then call:

```sh
update_cache cache_file VAR OTHER_VAR
update_cache -u cache_file VAR
update_cache -a cache_file
```

The default form updates or appends named variables. `-u` only updates existing
entries. `-a` updates entries whose variables are set in the calling shell.

Caches contain `NAME=VALUE` assignments, whitespace, and shell comments. Quoted
values may span multiple lines. Shell commands, declarations such as `export`,
and backslash-newline continuations are rejected without changing
the cache. Cache contents are parsed without executing them. Updated assignments
are compared with their canonical serialization, so older quoting is normalized.

Values use minimal quoting: printable values use POSIX-compatible shell syntax;
control characters use zsh's `$'...'` syntax to keep new assignments on one line.
Arrays and associative arrays are rejected, including in `-a` mode. Variable names
beginning with `_update_cache_` are reserved and cannot be requested.

Updates are serialized using a persistent `cache_file.lock` sidecar, and the cache
is replaced atomically after a successful write. Do not remove the lock file while
updates may be running. Symlinks are resolved before locking and replacing the
target. Existing file permission bits are preserved; new caches are private to
their owner. Temporary files are removed on errors and handled signals.
