#!/bin/sh

RELEASE="${RELEASE:-1}"

whereami=$(dirname $0)

if [ ! -f "$(which rpmbuild)" ];         then echo "please install 'rpm-build' rpm and try again" ; exit 1 ; fi
if [ ! -f "$(which spectool)" ];         then echo "please install 'rpmdevtools' rpm and try again" ; exit 1 ; fi
if [ ! -f "$(which rpmdev-setuptree)" ]; then echo "please install 'rpmdevtools' rpm and try again" ; exit 1 ; fi
if [ ! -f "$(which wget)" ];             then echo "please install 'wget' rpm and try again" ; exit 1 ; fi

# Might create ~/rpmbuild, or it might use an existing build %{_topdir}
# named in ~/.rpmmacros
/usr/bin/rpmdev-setuptree

wget -O $HOME/rpmbuild/SOURCES/runit-2.3.1.tar.gz https://github.com/izzyleung/runit/archive/refs/tags/2.3.1-patched.tar.gz

SPECS=$(rpm --eval "%{_specdir}")
SOURCES=$(rpm --eval "%{_sourcedir}")
cp -f "${whereami}/runit.spec" "$SPECS"
cp -f "${whereami}/runsvdir-start.service"    "$SOURCES"
/usr/bin/spectool -C "$SOURCES" -g "${whereami}/runit.spec "

PATH=/usr/bin:/bin
rpmbuild -bb "$SPECS/runit.spec" \
    --define "release ${RELEASE}"
