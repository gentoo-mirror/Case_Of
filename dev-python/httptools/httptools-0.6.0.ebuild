# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10,11} )
LLHTTP_COMMIT='3523423483a61179f47cc7ff0da012fb6f81ec1b'

inherit distutils-r1

DESCRIPTION="Fast HTTP Parser"
HOMEPAGE="https://github.com/MagicStack/httptools"
SRC_URI="https://github.com/MagicStack/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/nodejs/llhttp/archive/${LLHTTP_COMMIT}.tar.gz -> llhttp-${LLHTTP_COMMIT}.tar.gz"

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
	cp -r "${WORKDIR}/llhttp-${LLHTTP_COMMIT}"/* "${S}"/vendor/llhttp/ || die
	default
}

distutils-r1_python_compile() {
	esetup.py build build_ext --use-system-http-parser
}
