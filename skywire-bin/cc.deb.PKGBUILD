# Maintainer: Moses Narrow <moe_narrow@use.startmail.com>
# Maintainer: Rudi [KittyCash] <rudi@skycoinmail.com>
_projectname=skycoin
pkgname=skywire
_pkgname=${pkgname}
_githuborg=${_projectname}
pkgdesc="Skywire Mainnet Node implementation. Binary Release. Debian package"
#set to native architecture with dpkg
_pkgarch=$(dpkg --print-architecture)
_pkgarches=('armhf' 'arm64' 'amd64')
#leave arch package as any
arch=('any')
#manually version for now
_pkgver='0.5.1'
_tag_ver=v${_pkgver}
pkgver=${_pkgver}
#pkgver='autogenerated'
#pkgrel keeps getting reset when build is run
_pkgrel=14
#pkgrel=11
pkgrel=${_pkgrel}
_pkggopath="github.com/${_githuborg}/${_pkgname}"
url="https://${_pkggopath}"
license=()
#make deps for every architecture are included here..
makedepends=('dpkg') # 'git' 'go' 'musl' 'kernel-headers-musl' 'aarch64-linux-musl' 'arm-linux-gnueabihf-musl') #'aarch64-linux-musl' 'arm-linux-gnueabihf-musl' 'skycoin-keyring')
depends=()
_debdeps=""
#_debdeps=""
_scripts="skywire-deb-scripts"
#source=("git+${url}.git#branch=${BRANCH:-develop}"
#build to needed commit because of develop branch instability
#source=("git+${url}.git" ##branch=${BRANCH:-develop}"
_binarchive=("${_pkgname}-${_tag_ver}-linux")
_release_url=("${url}/releases/download/${_tag_ver}/${_binarchive}")
source=(
"${_release_url}-amd64.tar.gz"
"${_release_url}-arm64.tar.gz"
"${_release_url}-arm.tar.gz"
"${_scripts}.tar.gz"
)
noextract=(
"${_binarchive}-amd64.tar.gz"
"${_binarchive}-arm64.tar.gz"
"${_binarchive}arm.tar.gz"
)
sha256sums=('c661fb78caa9dae961800069b188f8035b36cc151fe5665c8eb59c16da7c5781'
            'bc5c2227de16bc71d16c73cafcdf071c9f6c40f715d9c5416bea66dcc5659eed'
            '0fa0e5d00d7ac0eedd55efcf19e1e7fba9b0efc5b690d8ce27536f10e4a5f830'
            '3b2d0ec5c2b0c19ea4a73bec061b27eac7caa36108fa322279dad46290bdf132')

build() {
  for i in ${_pkgarches[@]}; do
    msg2 "_pkgarch=$i"
    local _pkgarch=$i

    _msg2 'creating the DEBIAN/control files'
    #create control file for the debian package
    echo "Package: skywire-bin" > ${srcdir}/${_pkgarch}.control
    echo "Version: ${_pkgver}-${_pkgrel}" >> ${srcdir}/${_pkgarch}.control
    echo "Priority: optional" >> ${srcdir}/${_pkgarch}.control
    echo "Section: web" >> ${srcdir}/${_pkgarch}.control
    echo "Architecture: ${_pkgarch}" >> ${srcdir}/${_pkgarch}.control
    #echo "Depends: ${_debdeps}" >> ${srcdir}/${_pkgarch}.control
    echo "Provides: ${pkgname}" >> ${srcdir}/${_pkgarch}.control
    echo "Maintainer: the-skycoin-project" >> ${srcdir}/${_pkgarch}.control
    echo "Description: ${pkgdesc}" >> ${srcdir}/${_pkgarch}.control

  done
}

package() {

for i in ${_pkgarches[@]}; do
msg2 "_pkgarch=${i}"
local _pkgarch=${i}

if [[ $_pkgarch == "amd64" ]] ; then
  rm -rf ${srcdir}/skywire-visor ${srcdir}/skywire-cli ${srcdir}/apps
  rm -rf ${pkgdir}/test && mkdir -p ${pkgdir}/test && cd ${pkgdir}/test
  tar -xf ${srcdir}/${_pkgname}-${_tag_ver}-linux-amd64.tar.gz
fi

if [[ $_pkgarch == "arm64" ]] ; then
  rm -rf ${srcdir}/skywire-visor ${srcdir}/skywire-cli ${srcdir}/apps #not sure if it will error here
  rm -rf ${pkgdir}/test && mkdir -p ${pkgdir}/test && cd ${pkgdir}/test
  tar -xf ${srcdir}/${_pkgname}-${_tag_ver}-linux-arm64.tar.gz
fi

if [[ $_pkgarch == "armhf" ]] ; then
  rm -rf ${srcdir}/skywire-visor ${srcdir}/skywire-cli ${srcdir}/apps #not sure if it will error here
  rm -rf ${pkgdir}/test && mkdir -p ${pkgdir}/test && cd ${pkgdir}/test
  tar -xf ${srcdir}/${_pkgname}-${_tag_ver}-linux-arm.tar.gz
fi

_msg2 'creating dirs'
#set up to create a .deb package
_debpkgdir="${_pkgname}-bin-${pkgver}-${_pkgrel}-${_pkgarch}"
_pkgdir="${pkgdir}/${_debpkgdir}"
_skydir="opt/skywire"
_skyapps="${_skydir}/apps"
_skyscripts="${_skydir}/scripts"
_systemddir="etc/systemd/system"
_skybin="${_skydir}/bin"
[[ -d ${_pkgdir} ]] && rm -rf ${_pkgdir}
mkdir -p ${_pkgdir}/usr/bin ${_pkgdir}/usr/bin/apps
#tls autoconfig
mkdir -p ${_pkgdir}/${_skydir}/ssl
#other dirs must be created or the visor will create them at runtime with weird permissions
mkdir -p ${_pkgdir}/${_skydir}/local
mkdir -p ${_pkgdir}/${_skydir}/dmsgpty
mkdir -p ${_pkgdir}/${_skydir}/${_pkgname}    #needed?
#mkdir -p ${_pkgdir}/${_skydir}/skycache    #local package repository
mkdir -p ${_pkgdir}/${_skydir}/transport_logs
mkdir -p ${_pkgdir}/${_skydir}/scripts

cd $_pkgdir


#loop to install the binaries
#_skywirebins=$( ls ${srcdir}/go/bin.${_pkgarch} )
#for i in ${_skywirebins}; do
#  _msg2 "$i"
#done
_msg3 'skywire-visor'
 install -Dm755 ${pkgdir}/test/${_pkgname}-visor ${_pkgdir}/${_skybin}/${_pkgname}-visor
 ln -rTsf ${_pkgdir}/${_skybin}/${_pkgname}-visor ${_pkgdir}/usr/bin/${_pkgname}-visor
 ln -rTsf ${_pkgdir}/${_skybin}/${_pkgname}-visor ${_pkgdir}/usr/bin/${_pkgname}
 chmod +x ${_pkgdir}/usr/bin/${_pkgname}-visor ${_pkgdir}/usr/bin/${_pkgname}
_msg3 'skywire-cli'
install -Dm755 ${pkgdir}/test/${_pkgname}-cli ${_pkgdir}/${_skybin}/${_pkgname}-cli
ln -rTsf ${_pkgdir}/${_skybin}/${_pkgname}-cli ${_pkgdir}/usr/bin/${_pkgname}-cli
chmod +x ${_pkgdir}/usr/bin/${_pkgname}-cli
_msg2 'installing app binaries'
_msg3 'skychat'
install -Dm755 ${pkgdir}/test/apps/skychat ${_pkgdir}/${_skyapps}/skychat
ln -rTsf ${_pkgdir}/${_skyapps}/skychat ${_pkgdir}/usr/bin/apps/skychat
chmod +x ${_pkgdir}/usr/bin/apps/skychat
_msg3 'skysocks'
install -Dm755 ${pkgdir}/test/apps/skysocks ${_pkgdir}/${_skyapps}/skysocks
ln -rTsf ${_pkgdir}/${_skyapps}/skysocks ${_pkgdir}/usr/bin/apps/skysocks
chmod +x ${_pkgdir}/usr/bin/apps/skysocks
_msg3 'skysocks-client'
install -Dm755 ${pkgdir}/test/apps/skysocks-client ${_pkgdir}/${_skyapps}/skysocks-client
ln -rTsf ${_pkgdir}/${_skyapps}/skysocks-client ${_pkgdir}/usr/bin/apps/skysocks-client
chmod +x ${_pkgdir}/usr/bin/apps/skysocks-client
_msg3 'vpn-client'
install -Dm755 ${pkgdir}/test/apps/vpn-client ${_pkgdir}/${_skyapps}/vpn-client
ln -rTsf ${_pkgdir}/${_skyapps}/vpn-client ${_pkgdir}/usr/bin/apps/vpn-client
chmod +x ${_pkgdir}/usr/bin/apps/vpn-client
_msg3 'vpn-server'
install -Dm755 ${pkgdir}/test/apps/vpn-server ${_pkgdir}/${_skyapps}/vpn-server
ln -rTsf ${_pkgdir}/${_skyapps}/vpn-server ${_pkgdir}/usr/bin/apps/vpn-server
chmod +x ${_pkgdir}/usr/bin/apps/vpn-server

_msg2 'installing scripts'


_msg2 'installing scripts'
_skywirescripts=$( ls ${srcdir}/${_scripts}/${_pkgname} )
for i in ${_skywirescripts}; do
  _install2 ${srcdir}/${_scripts}/${_pkgname}/${i} ${_skyscripts}
done

_msg2 'Correcting symlink names'
ln -rTsf ${_pkgdir}/${_skybin}/${_pkgname}-visor ${_pkgdir}/usr/bin/${_pkgname}
ln -rTsf ${_pkgdir}/${_skybin}/${_pkgname}-visor ${_pkgdir}/usr/bin/${_pkgname}-hypervisor
#ln -rTsf ${_pkgdir}/${_skyapps}/* ${_pkgdir}/usr/bin/apps/

_msg2 'installing skywire systemd services'
install -Dm644 ${srcdir}/${_scripts}/systemd/${_pkgname}.service ${_pkgdir}/${_systemddir}/${_pkgname}.service
install -Dm644 ${srcdir}/${_scripts}/systemd/${_pkgname}-visor.service ${_pkgdir}/${_systemddir}/${_pkgname}-visor.service
#this is to overwrites any previous file not provided by this package
install -Dm644 ${srcdir}/${_scripts}/systemd/${_pkgname}.service ${_pkgdir}/${_systemddir}/${_pkgname}-hypervisor.service
install -Dm644 ${srcdir}/${_scripts}/systemd/${_pkgname}-firstboot.service ${_pkgdir}/${_systemddir}/${_pkgname}-firstboot.service
install -Dm644 ${srcdir}/${_scripts}/systemd/${_pkgname}-visor-firstboot.service ${_pkgdir}/${_systemddir}/${_pkgname}-visor-firstboot.service

_msg2 'installing tls key and certificate generation scripts'
#install -Dm755 ${srcdir}/${_pkgname}/static/skywire-manager-src/ssl/generate-1.sh ${pkgdir}/${_skydir}/ssl/generate.sh
install -Dm755 ${srcdir}/${_scripts}/ssl/generate.sh ${_pkgdir}/${_skydir}/ssl/generate.sh
ln -rTsf ${_pkgdir}/${_skydir}/ssl/generate.sh ${_pkgdir}/usr/bin/skywire-tls-gen
#install -Dm644 ${srcdir}/${_pkgname}/static/skywire-manager-src/ssl/certificate.cnf ${pkgdir}/${_skydir}/ssl/certificate.cnf
install -Dm644 ${srcdir}/${_scripts}/ssl/certificate.cnf ${_pkgdir}/${_skydir}/ssl/certificate.cnf

_msg2 'installing skywire control file and install scripts'
install -Dm755 ${srcdir}/${_pkgarch}.control ${_pkgdir}/DEBIAN/control
install -Dm755 ${srcdir}/${_scripts}/postinst.sh ${_pkgdir}/DEBIAN/postinst
#install -Dm755 ${srcdir}/${_scripts}/postrm.sh ${_pkgdir}/DEBIAN/postrm

_msg2 'creating the debian package'
#create the debian package!
cd $pkgdir
dpkg-deb --build -z9 ${_debpkgdir}
mv *.deb ../../
done
#exit so the arch package doesn't get built
exit
}

_install2() {
_binname="${1##*/}"
_binname="${_binname%%.*}"
install -Dm755 ${1} ${_pkgdir}/${2}/${_binname}
ln -rTsf ${_pkgdir}/${2}/${_binname} ${_pkgdir}/usr/bin/${_binname}
chmod +x ${_pkgdir}/usr/bin/${_binname}
}

_msg2() {
	(( QUIET )) && return
	local mesg=$1; shift
	printf "${BLUE}  ->${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@"
}

_msg3() {
(( QUIET )) && return
local mesg=$1; shift
printf "${BLUE}  -->${ALL_OFF}${BOLD} ${mesg}${ALL_OFF}\n" "$@"
}
