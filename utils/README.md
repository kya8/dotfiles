# Zsh utilities

Source `update_cache.zsh` to define `update_cache`:

```zsh
source /path/to/dotfiles/utils/update_cache.zsh

server='localhost'
token='a value with spaces and $special characters'
update_cache ~/.cache/example server token
source ~/.cache/example
```

The parent directory of the cache file must already exist. New and changed values
use `$'...'` quoting, with escapes for newlines and other control characters so
each assignment stays on one line. Existing entries keep their order; new entries
are appended. Unrelated lines are preserved, and the cache is read as text without
executing it.

Existing values are compared after removing shell quotes and escapes. For example,
`token="a b"`, `token='a b'`, and `token=a\ b` are all left unchanged when `token`
is `a b`. Parameter and command substitutions in the file are not evaluated.
If nothing changes, the existing file is not rewritten.

- `update_cache cache_file var ...` updates or adds the named variables.
- `update_cache -u cache_file var ...` updates existing entries only.
- `update_cache -a cache_file` updates existing keys whose shell variables are
  set, leaving entries for unset variables alone. Variable names are not accepted.
  It can be combined with `-u`.

Options precede the filename; use `--` for filenames starting with `-`. A missing
file is created, including in `-a` and `-u` modes. Explicitly named variables must
have valid identifiers and be set; an empty value counts as set. Invalid arguments
return status 2, and unset variables or file errors return status 1. Argument and
variable validation happens before the cache is written.
