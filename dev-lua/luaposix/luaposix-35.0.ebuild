# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Bindings for POSIX APIs"
HOMEPAGE="https://luaposix.github.io/luaposix/ https://github.com/luaposix/luaposix"
SRC_URI="https://github.com/luaposix/luaposix/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-lang/lua:0=
	dev-lua/bit32"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	./build-aux/luke package="${PN}" version="${PV}" \
		CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die
}

src_install() {
        local my_libdir="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)"
        local my_luadir="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"

	./build-aux/luke install \
		PREFIX="${ED}/usr" \
                INST_LIBDIR="${ED}${my_libdir#${EPREFIX%/}}" \
                INST_LUADIR="${ED}${my_luadir#${EPREFIX%/}}" \
		|| die

	dodoc -r doc NEWS.md README.md
}
