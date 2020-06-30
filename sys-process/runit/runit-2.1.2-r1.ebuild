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

	# default runlevel
	dodir "/etc/runit/runsvdir/default" || die
	dosym "default" "/etc/runit/runsvdir/current" || die
	dosym "../etc/runit/runsvdir/current" "/var/service" || die

	# default SVDIR
	dodir "/etc/sv"
	insinto "/etc/env.d"
	doins "${FILESDIR}/20runit"
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

	ewarn "Unlike Gentoo's official runit distribution,"
	ewarn "no default services or bootup scripts have been installed."
	ewarn "Create services in /etc/sv, and symlink them to /var/service."
	ewarn "You are on your own."
	ewarn
}
