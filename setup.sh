#!/usr/bin/env bash
dir="${HOME}/.dm"
url="https://github.com/aivoicesystems"

fail() {
  echo "$0: $@" >&2
  exit 1
}

[ ! -d "${dir}" ] || fail "${dir} already exists"

which git >/dev/null || fail "this setup script needs git to work"
which dart >/dev/null || fail "this setup script needs dart to work"

mkdir "${dir}" || "can't create ${dir}"

cd "${dir}" || fail "can't cd to ${dir}??"

mkdir bin src || fail "can't create bin or src directory in $(pwd)"

cd src || fail "can't cd to $(pwd)/src??"

pkg() {
  local name="$1"

  git clone "${url}/${name}.git" || fail "can't clone ${name}"
  cd "${name}" || fail "can't cd to $(pwd)/${name}"
  dart pub get || fail "can't run dart pub get in $(pwd)"
  cd ..
}

pkg aiv_test
pkg aiv_lib
pkg aiv_server
pkg dm

ln -s dm/setup/bin/* ../bin
