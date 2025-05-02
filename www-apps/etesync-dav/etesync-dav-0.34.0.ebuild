# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A CalDAV and CardDAV adapter for EteSync"
HOMEPAGE="https://www.etesync.com https://github.com/etesync/etesync-dav"
SRC_URI="https://github.com/etesync/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/etebase-py[${PYTHON_USEDEP}]
	dev-python/etesync[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-wtf[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=www-apps/radicale-3.0.3[${PYTHON_USEDEP}]
	<www-apps/radicale-3.5[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/wheel[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/${P}-Fix-radicale-compatibility.patch" )
