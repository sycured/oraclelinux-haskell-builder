#!/bin/bash
set -xe

mkimg=$(buildah from docker.io/oraclelinux:8)
buildah config --author='sycured' "$mkimg"
buildah config --label Name='oraclelinux-haskell-builder' "$mkimg"
buildah run "$mkimg" -- useradd -m hsk
buildah run "$mkimg" -- dnf upgrade -y
buildah run "$mkimg" -- dnf install glibc-langpack-en gcc tar -y
buildah config --env LANG="en_US.UTF8" --env LC_ALL="en_US.UTF8" "$mkimg"
buildah run "$mkimg" -- bash -c "curl -sSL https://get.haskellstack.org/ | sh"
buildah run "$mkimg" -- rm -rf /var/cache/dnf/*
buildah config --user='hsk' "$mkimg"
buildah config --workingdir='/home/hsk' "$mkimg"
buildah commit --squash "$mkimg" "oraclelinux-haskell-builder"
buildah rm "$mkimg"
