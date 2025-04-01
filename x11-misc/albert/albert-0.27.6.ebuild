# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake python-single-r1 xdg

DESCRIPTION="A fast and flexible keyboard launcher"
HOMEPAGE="https://albertlauncher.github.io/"

SRC_URI="
	https://github.com/albertlauncher/${PN}/releases/download/v${PV}/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="all-rights-reserved"	# unclear licensing #766129
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="mirror bindist"

BDEPEND="
	dev-qt/qttools:6=[linguist]
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
RDEPEND="
	app-arch/libarchive:=
	dev-libs/libxml2:=
	dev-qt/qt5compat:6=[qml]
	dev-qt/qtbase:6=[concurrent,dbus,gui,network,sql,sqlite,widgets]
	dev-qt/qtdeclarative:6=
	dev-qt/qtscxml:6=[qml]
	dev-qt/qtsvg:6=
	sci-libs/libqalculate:=
	$(python_gen_cond_dep 'dev-python/urllib3[${PYTHON_USEDEP}]')
	${PYTHON_DEPS}
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DEBUG=$(usex debug)
	)

	cmake_src_configure
}
