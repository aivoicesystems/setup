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

echo "Setting up the development manager in ${dir}"

mkdir "${dir}" || "can't create ${dir}"

cd "${dir}" || fail "can't cd to ${dir}??"

mkdir bin src || fail "can't create bin or src directory in $(pwd)"

cd src || fail "can't cd to $(pwd)/src??"

pkg() {
  local name="$1"
  echo "$name"
  git clone -q "${url}/${name}.git" || fail "can't clone ${name}"
  cd "${name}" || fail "can't cd to $(pwd)/${name}"
  dart pub get >/dev/null || fail "can't run dart pub get in $(pwd)"
  cd ..
}

echo "Fetching packages into $(pwd)"
pkg aiv_test
pkg aiv_lib
pkg aiv_server
pkg dm

echo "Setting up symbolic links"
ln -s dm/setup/.vscode .
cd ../bin
ln -s ../src/dm/setup/bin/* .

echo "The development manager is now set up in ${dir}"
case ":${PATH}:" in
  *:${dir}/bin:*)
    ;;
  *)
    echo "Be sure to include ${dir}/bin in your PATH"
    ;;
esac

exit 0
