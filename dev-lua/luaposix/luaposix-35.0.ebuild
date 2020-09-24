# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Bindings for POSIX APIs"
HOMEPAGE="https://luaposix.github.io/luaposix/ https://github.com/luaposix/luaposix"
SRC_URI="https://github.com/luaposix/luaposix/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86 ~arm64"
IUSE="luajit"

RDEPEND="dev-lang/lua:* dev-lua/bit32"
BDEPEND="virtual/pkgconfig ${RDEPEND}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${PV}"

src_compile() {
	lua build-aux/luke || die
}

src_install() {
	lua build-aux/luke PREFIX=${ED}/usr install

	default
}
