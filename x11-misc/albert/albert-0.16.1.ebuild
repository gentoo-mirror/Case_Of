# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLUGINS_HASH="029bd8ccb58c4452bd82ab42be8739f1639e42d4"
PYBIND11_VERSION="2.2.4"
PYTHON_COMPAT=( python{2_7,3_{6,7,8}} )

inherit cmake-utils python-single-r1 xdg-utils

DESCRIPTION="Desktop agnostic launcher (with Python extensions support)"
HOMEPAGE="https://albertlauncher.github.io/"
# plugins is a git submodule. the hash is taken from the submodule reference in the ${PV} tag.
SRC_URI="https://github.com/albertlauncher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/albertlauncher/plugins/archive/${PLUGINS_HASH}.tar.gz -> ${P}-plugins.tar.gz
https://github.com/pybind/pybind11/archive/v${PYBIND11_VERSION}.tar.gz -> pybind11-${PYBIND11_VERSION}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/muParser
	dev-qt/qtcharts:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="${RDEPEND}"

src_prepare() {
	mv "${WORKDIR}"/plugins-${PLUGINS_HASH}/* "${S}"/plugins/ || die
	mv "${WORKDIR}"/pybind11-${PYBIND11_VERSION}/* "${S}"/plugins/python/pybind11/ || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DEBUG=$(usex debug)
		-DBUILD_VIRTUALBOX=OFF #plugin needs virtualbox installed to build, untested
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
