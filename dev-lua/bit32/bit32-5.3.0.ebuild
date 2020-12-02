# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Based on bit32 ebuild from lua overlay

EAPI="5"

inherit toolchain-funcs

DESCRIPTION="A Lua5.2+ bit manipulation library"
HOMEPAGE="https://github.com/keplerproject/lua-compat-5.2"
SRC_URI="https://github.com/keplerproject/lua-compat-5.2/archive/bitlib-${PV}.tar.gz"
READMES=( README.md )

RDEPEND="dev-lang/lua:0="
BDEPEND="virtual/pkgconfig
	${RDEPEND}"
DEPEND="${RDEPEND}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x64-macos"
IUSE=""

S="${WORKDIR}/lua-compat-5.2-bitlib-${PV}"

src_compile() {
	local MY_PN="lbitlib"

	$(tc-getCC) ${CFLAGS} -fPIC -Ic-api -c -o ${MY_PN}.o ${MY_PN}.c || die

	if [[ ${CHOST} == *darwin* ]]; then
		$(tc-getCC) ${LDFLAGS} -bundle -undefined dynamic_lookup -fPIC -o ${PN}.so ${MY_PN}.o || die
	else
		$(tc-getCC) ${LDFLAGS} -shared -fPIC -o ${PN}.so ${MY_PN}.o || die
	fi
}

src_install() {
	local MY_LUALIBDIR="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)"

	insinto "${MY_LUALIBDIR#${EPREFIX%/}}"
	doins "${PN}.so"
}
