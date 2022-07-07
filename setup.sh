#!/usr/bin/env bash
dir="${HOME}/.dm"
url="https://github.com/aivoicesystems"

echo "Installing development manager into ${dir}"

if [ -e "${dir}" ]
then
  echo "There already is a ${dir}"
  echo "The installation can't continue"
  exit 1
fi

if ! which git >/dev/null
then
  echo "This setup script requires git to be installed"
  echo "The installation can't continue"
  exit 1
fi
if ! which dart >/dev/null
then
  echo "This development manager requires dart to be installed"
  echo "The installation can't continue"
  exit 1
fi

mkdir "${dir}"
cd "${dir}"
mkdir bin src
cd src

pkg() {
  local name="$1"
  echo "...$name"
  git clone -q "${url}/${name}.git" || fail "can't clone ${name}"
  cd "${name}" || fail "can't cd to $(pwd)/${name}"
  dart pub get >/dev/null || fail "can't run dart pub get in $(pwd)"
  cd ..
}

echo "Fetching packages into $(pwd)"
pkg aiv_dev
pkg aiv_lib
pkg aiv_server
pkg dm

echo "Setting up symbolic links"
ln -s dm/setup/src/.vscode .
cd ../bin
ln -s ../src/dm/setup/bin/* .
cd ..

echo "The development manager is now set up in ${dir}"
case ":${PATH}:" in
  *:${dir}/bin:*)
    ;;
  *)
    echo "Be sure to include ${dir}/bin in your PATH"
    ;;
esac

exit 0
