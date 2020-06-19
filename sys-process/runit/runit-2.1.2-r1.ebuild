# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

DESCRIPTION="A UNIX init scheme with service supervision"
HOMEPAGE="http://smarden.org/runit/"
SRC_URI="http://smarden.org/runit/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

# remove runtime dependency on openrc
RDEPEND=""

S=${WORKDIR}/admin/${P}/src

src_prepare() {
	default

	# we either build everything or nothing static
	sed -i -e 's:-static: :' Makefile
}

src_configure() {
	use static && append-ldflags -static

	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_install() {
	into /
	dobin $(<../package/commands)
	dodir /sbin
	mv "${ED}"/bin/{runit-init,runit,utmpset} "${ED}/sbin/" || die "dosbin"

	DOCS=( ../package/{CHANGES,README,THANKS,TODO} )
	HTML_DOCS=( ../doc/*.html )
	einstalldocs
	doman ../man/*.[18]

	# install default scripts
	dodir /etc/runit
	insinto /etc/runit
	doins "${FILESDIR}/functions"
	doins -r "${FILESDIR}/core-services"
	exeinto /etc/runit
	doexe "${FILESDIR}/ctrlaltdel"
	doexe "${FILESDIR}/1"
	doexe "${FILESDIR}/2"
	doexe "${FILESDIR}/3"

	# install default services
	cp -r "${FILESDIR}/services" "${ED}/etc/sv"

	# set default SVDIR
	insinto /etc/env.d
	doins "${FILESDIR}/20runit"

	# setup default runlevel
	dodir "/etc/runit/runsvdir/default" || die
	dosym "default" "/etc/runit/runsvdir/current" || die
	dosym "../etc/runit/runsvdir/current" "/var/service" || die
}

pkg_postinst() {
	ewarn "To make sure sv works correctly in your currently open"
	ewarn "shells, please run the following command:"
	ewarn
	ewarn "source /etc/profile"
	ewarn

	ewarn "This version of runit still uses ${EROOT}/var/service"
	ewarn "as the current service directory, as opposed to"
	ewarn "${EROOT}/etc/serivce"
	ewarn

	ewarn "Remember to enable agentty-* services, for example:"
	ewarn
	ewarn "ln -snf ${EROOT}/etc/sv/agetty-tty1 ${EROOT}/var/service/"
	ewarn
}
