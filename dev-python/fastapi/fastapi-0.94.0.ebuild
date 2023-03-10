# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="High performance, easy to learn, fast to code, ready for production"
HOMEPAGE="https://fastapi.tiangolo.com/ https://github.com/tiangolo/fastapi"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT=0
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

BDEPEND=">=dev-python/hatchling-1.13.0[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
	>=dev-python/starlette-0.26.0[${PYTHON_USEDEP}]
"
