#!/bin/bash
#re-archive the scripts and update the checksums, etc.
#NOTE THAT THIS EXPECTS THE SCRIPTS HAVE BEEN EDITED LOCALLY
#git pull and tar -xf skywire-scripts.tar.gz before commiting and pushing
#tar -hczvf skywire-scripts.tar.gz skywire-scripts
#reset the pkgver to autogenerated
_version=$(git ls-remote --tags --refs --sort="version:refname" https://github.com/skycoin/skywire.git | tail -n1)
_version=${_version##*/}
_version=${_version%%-*}
_version=${_version//v/}
#Uncomment to use release candidates or pre-releases for testing
#get release candidate version from source repo
#_vrc=$(git ls-remote --tags --refs --sort="version:refname" https://github.com/skycoin/skywire.git | tail -n1 | grep -- -rc)
#if [[ $_vrc != "" ]]; then
#	_vrc="-${_vrc##*-}"
#fi
#get release candidate version from source repo
#_vrc=$(git ls-remote --tags --refs --sort="version:refname" https://github.com/skycoin/skywire.git | tail -n1 | grep -- -pr)
#if [[ $_vrc != "" ]]; then
#	_vrc="-${_vrc##*-}"
#fi
echo ${_version}
echo ${_vrc}
echo "updating checksums and version for PKGBUILD"
sed -i "s/^pkgver=.*/pkgver='${_version}'/" PKGBUILD && sed -i "s/^_rc=.*/_rc='${_vrc}'/" PKGBUILD && updpkgsums
[[ -f cc.deb.PKGBUILD ]] && echo "updating checksums and version for cc.deb.PKGBUILD" && sed -i "s/^pkgver=.*/pkgver='${_version}'/" cc.deb.PKGBUILD && sed -i "s/^_rc=.*/_rc='${_vrc}'/" cc.deb.PKGBUILD && updpkgsums cc.deb.PKGBUILD && _ccdebPKGBUILD="cc.deb.PKGBUILD"
[[ -f cc.dev.PKGBUILD ]] && echo "updating checksums and version for cc.dev.PKGBUILD" && sed -i "s/^pkgver=.*/pkgver='${_version}'/" cc.dev.PKGBUILD && sed -i "s/^_rc=.*/_rc='${_vrc}'/" cc.dev.PKGBUILD && updpkgsums cc.dev.PKGBUILD && _ccdebPKGBUILD="cc.dev.PKGBUILD"
[[ -f deb.PKGBUILD ]] &&echo "updating checksums and version for deb.PKGBUILD" && sed -i "s/^pkgver=.*/pkgver='${_version}'/" deb.PKGBUILD && sed -i "s/^_rc=.*/_rc='${_vrc}'/" deb.PKGBUILD  && updpkgsums deb.PKGBUILD && _debPKGBUILD="deb.PKGBUILD"
[[ -f dev.PKGBUILD ]] && echo "updating checksums and version for dev.PKGBUILD" && sed -i "s/^pkgver=.*/pkgver='autogenerated'/" dev.PKGBUILD && updpkgsums dev.PKGBUILD && _devPKGBUILD="dev.PKGBUILD"
[[ -f git.PKGBUILD ]] && echo "updating checksums and version for git.PKGBUILD" && sed -i "s/^pkgver=.*/pkgver='autogenerated'/" git.PKGBUILD && updpkgsums git.PKGBUILD && _gitPKGBUILD="git.PKGBUILD"
echo "creating .SRCINFO"
makepkg --printsrcinfo > .SRCINFO
#sha256sum skywire-scripts.tar.gz
echo "don't forget to increment pkgrel if you edited the PKGBUILD"
echo
echo "git add -f ${_debPKGBUILD} ${_ccdebPKGBUILD} ${_devPKGBUILD} ${_gitPKGBUILD} PKGBUILD .SRCINFO skywire-autoconfig com.skywire.Skywire.desktop com.skywirevpn.SkywireVPN.desktop skywirevpn.png skywire.png skywire.service skywire-autoconfig.service postinst.sh prerm.sh updates.sh test.sh"
echo 'git commit -m " "'
