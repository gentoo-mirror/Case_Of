# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10,11} )

inherit distutils-r1

DESCRIPTION="Pypandoc provides a thin wrapper for pandoc, a universal document converter"
HOMEPAGE="
	https://github.com/JessicaTegner/pypandoc
	https://pypi.org/project/pypandoc/
"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-text/pandoc-2.11
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
"
DEPEND="
	${RDEPEND}
	dev-python/installer[${PYTHON_USEDEP}]
	>=dev-python/pandocfilters-1.5.0[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/poetry-core[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.25.0[${PYTHON_USEDEP}]
"

python_test() {
	# Skip tests. Wants: internet access
	sed -i -e 's:test_basic_conversion_from_http_url:_&:' tests.py || die
	# Skip tests. Wants: nonexistent font
	sed -i -e 's:test_pdf_conversion:_&:' tests.py || die

	"${EPYTHON}" tests.py || die "Tests fail with ${EPYTHON}"
}
