# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Legacy mode: DISTUTILS_USE_PEP517 should not be set.
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{8..12} )
LLHTTP_COMMIT='caed04d6c1251e54c642bddfc7d0330af234f0d3'

inherit distutils-r1

DESCRIPTION="Fast HTTP Parser"
HOMEPAGE="https://github.com/MagicStack/httptools"
SRC_URI="https://github.com/MagicStack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/nodejs/llhttp/archive/${LLHTTP_COMMIT}.tar.gz -> llhttp-${LLHTTP_COMMIT}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RESTRICT="test"

RDEPEND="
	net-libs/http-parser
"
BDEPEND="
	>=dev-python/cython-0.29.14[${PYTHON_USEDEP}]
"
DEPEND="
	${BDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

PATCHES="${FILESDIR}/${PN}-0.6.1-cython3.patch"

src_prepare() {
	sed -e "s:../../vendor/http-parser/http_parser.h:${EPREFIX}/usr/include/http_parser.h:" -i ${PN}/parser/cparser.pxd || die
	cp -r "${WORKDIR}/llhttp-${LLHTTP_COMMIT}"/* "${S}"/vendor/llhttp/ || die
	default
}

distutils-r1_python_compile() {
	esetup.py build build_ext --inplace --use-system-http-parser
}
