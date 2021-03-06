# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="Fast HTTP Parser"
HOMEPAGE="https://github.com/MagicStack/httptools"
SRC_URI="https://github.com/MagicStack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	net-libs/http-parser
"
DEPEND="
	>=dev-python/cython-0.29.14[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

src_prepare() {
	sed -e "s:../../vendor/http-parser/http_parser.h:${EPREFIX}/usr/include/http_parser.h:" -i ${PN}/parser/cparser.pxd || die
	sed -e 's/Cython==0\.29\.14/Cython>=0.29.14/' -i setup.py || die
	default
}

distutils-r1_python_compile() {
	esetup.py build build_ext --use-system-http-parser
}
