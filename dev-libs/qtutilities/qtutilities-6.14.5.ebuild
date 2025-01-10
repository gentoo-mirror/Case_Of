# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Common Qt related C++ classes and routines used by my applications such as dialogs, widgets and models"
HOMEPAGE="https://github.com/Martchus/qtutilities"
SRC_URI="https://github.com/Martchus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+qt6 static-libs"

RDEPEND="
	!qt6? (
		dev-qt/qtcore:5=
		dev-qt/qtdbus:5=
		dev-qt/qtgui:5=
		dev-qt/qttest:5=
		dev-qt/qtwidgets:5=
	)
	qt6? (
		dev-qt/qtbase:6=[dbus,gui,widgets]
	)
	dev-libs/cpp-utilities
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	!qt6? (
		dev-qt/linguist-tools:5=
	)
	qt6? (
		dev-qt/qttools:6=[linguist]
		dev-qt/qtdeclarative:6=
	)
"

RESTRICT="mirror test"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DBUILD_SHARED_LIBS:BOOL=$(usex !static-libs)
	)

	if use qt6 ; then
		mycmakeargs+=(
			-DCONFIGURATION_NAME:STRING="qt6"
			-DCONFIGURATION_DISPLAY_NAME="Qt 6"
			-DCONFIGURATION_TARGET_SUFFIX:STRING="qt6"
			-DQT_PACKAGE_PREFIX:STRING='Qt6'
		)
	fi

	cmake_src_configure
}
