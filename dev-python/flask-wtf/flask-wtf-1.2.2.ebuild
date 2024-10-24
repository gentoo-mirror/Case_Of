# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Simple integration of Flask and WTForms"
HOMEPAGE="https://flask-wtf.readthedocs.io/"
SRC_URI="https://github.com/pallets-eco/flask-wtf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/wtforms[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs \
	dev-python/pallets-sphinx-themes \
	dev-python/sphinxcontrib-log-cabinet \
	dev-python/sphinx-issues
distutils_enable_tests pytest

python_install_all() {
	use examples && dodoc -r examples
	distutils-r1_python_install_all
}
