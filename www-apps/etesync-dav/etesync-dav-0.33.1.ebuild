# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

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
	<www-apps/radicale-3.4.0[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/wheel[${PYTHON_USEDEP}]"

PATCHES=("$FILESDIR"/${PN}-0.32.1-radicale-3.2.2.patch)

S="${WORKDIR}/${P}"

pkg_postinst() {
	if has_version "=www-apps/radicale-3.2.2"; then
		ewarn "www-apps/radicale-3.2.2 is known to not work with Etesync DAV bridge."
		ewarn "To make it work, please apply the upstream following patch to Radicale:"
		ewarn "    https://github.com/Kozea/Radicale/commit/3094bc393602c056f659e04e642addebb5ff95b4.patch"
		ewarn "To do this, you can just copy the patch to the following path:"
		ewarn "    /etc/portage/patches/www-apps/radicale-3.2.2/radicale-3.2.2-fix-version-for-release.patch"
		ewarn "and then rebuild Radicale:"
		ewarn "    emerge --oneshot www-apps/radicale"
	fi
}
