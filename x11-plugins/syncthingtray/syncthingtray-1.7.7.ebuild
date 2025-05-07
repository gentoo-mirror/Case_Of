# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Tray application for Syncthing"
HOMEPAGE="https://github.com/Martchus/syncthingtray"
SRC_URI="https://github.com/Martchus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde qml static-libs systemd webengine"

RDEPEND="
	dev-libs/openssl:=
	dev-libs/boost:=
	dev-libs/qtforkawesome:=
	dev-libs/qtutilities:=
	dev-qt/qtbase:6=[gui,network,widgets]
	dev-qt/qtsvg:6=
	kde? (
		kde-frameworks/kio:6=
		kde-plasma/libplasma:6=
	)
	qml? ( dev-qt/qtdeclarative:6= )
	systemd? ( dev-qt/qtbase:6=[dbus] )
	webengine? ( dev-qt/qtwebengine:6= )
"
IDEPEND="
	dev-util/desktop-file-utils
"
DEPEND="${RDEPEND}
	kde? (
		kde-frameworks/extra-cmake-modules:=
	)
	dev-qt/qttools:6=
"

RESTRICT="mirror test" #tests want to access network

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE:STRING=Release
		-DBUILD_SHARED_LIBS:BOOL=$(usex !static-libs)
		-DWEBVIEW_PROVIDER="$(usex webengine webengine none)"
		-DJS_PROVIDER="$(usex qml qml none)"
		-DSYSTEMD_SUPPORT=$(usex systemd)
		-DNO_FILE_ITEM_ACTION_PLUGIN=$(usex !kde)
		-DNO_PLASMOID=$(usex !kde)
		-DCONFIGURATION_NAME:STRING="qt6"
		-DCONFIGURATION_DISPLAY_NAME="Qt 6"
		-DCONFIGURATION_PACKAGE_SUFFIX_QTUTILITIES:STRING="-qt6"
		-DLIB_SYNCTHING_CONNECTOR_CONFIGURATION_TARGET_SUFFIX:STRING="qt6"
		-DSYNCTHINGFILEITEMACTION_CONFIGURATION_TARGET_SUFFIX:STRING="qt6"
		-DLIB_SYNCTHING_MODEL_CONFIGURATION_TARGET_SUFFIX:STRING="qt6"
		-DSYNCTHINGPLASMOID_CONFIGURATION_TARGET_SUFFIX:STRING="qt6"
		-DSYNCTHINGWIDGETS_CONFIGURATION_TARGET_SUFFIX:STRING="qt6"
		-DSYNCTHINGCTL_CONFIGURATION_TARGET_SUFFIX:STRING="qt6"
		-DSYNCTHINGTRAY_CONFIGURATION_TARGET_SUFFIX:STRING="qt6"
		-DQT_PACKAGE_PREFIX:STRING='Qt6'
		-DKF_PACKAGE_PREFIX:STRING='KF6'
	)

	cmake_src_configure
}
