# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit prefix

DESCRIPTION="Utility to change the binutils version being used"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"
IUSE=""

# We also RDEPEND on sys-apps/findutils which is in base @system
RDEPEND="sys-apps/gentoo-functions"

S=${WORKDIR}

src_install() {
	newbin "${FILESDIR}"/${PN}-${PV} ${PN}
	use prefix && eprefixify "${ED}"/usr/bin/${PN}
	sed -i "s:@PV@:${PVR}:g" "${ED}"/usr/bin/${PN} || die
	newbin "${FILESDIR}"/ld-wrapper.sh ld-wrapper.sh
	use prefix && eprefixify "${ED}"/usr/bin/ld-wrapper.sh
	doman "${FILESDIR}"/${PN}.8

	insinto /usr/share/eselect/modules
	doins "${FILESDIR}"/binutils.eselect
}

pkg_preinst() {
	# Force a refresh when upgrading from an older version that symlinked
	# in all the libs & includes that binutils-libs handles. #528088
	if has_version "<${CATEGORY}/${PN}-5" ; then
		local bc current
		bc="${ED}/usr/bin/binutils-config"
		if current=$("${bc}" -c) ; then
			"${bc}" "${current}"
		fi
	fi
}
