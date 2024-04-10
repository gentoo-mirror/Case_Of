# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORKAWESOME_PV="1.2.0"

inherit cmake

DESCRIPTION="Library that bundles ForkAwesome for use within Qt applications"
HOMEPAGE="https://github.com/Martchus/qtforkawesome"
SRC_URI="https://github.com/Martchus/qtforkawesome/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ForkAwesome/Fork-Awesome/archive/refs/tags/${FORKAWESOME_PV}.tar.gz -> Fork-Awesome-${FORKAWESOME_PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt6 static-libs"

DEPEND="
	dev-perl/YAML-LibYAML
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
	)
	qt6? (
		dev-qt/qtbase:6[gui]
		dev-qt/qtdeclarative:6
	)
	dev-libs/qtutilities[qt6=]
"
RDEPEND="${DEPEND}
	media-libs/freetype:2[brotli]"

RESTRICT="mirror test"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS:BOOL=$(usex !static-libs)
		-DBUILTIN_TRANSLATIONS:BOOL=ON
		-DFORK_AWESOME_FONT_FILE="${WORKDIR}/Fork-Awesome-${FORKAWESOME_PV}/fonts/forkawesome-webfont.woff2"
		-DFORK_AWESOME_ICON_DEFINITIONS="${WORKDIR}/Fork-Awesome-${FORKAWESOME_PV}/src/icons/icons.yml"
	)

	if use qt6 ; then
		mycmakeargs+=(
			-DCONFIGURATION_NAME:STRING="qt6"
			-DCONFIGURATION_DISPLAY_NAME="Qt 6"
			-DCONFIGURATION_TARGET_SUFFIX:STRING="qt6"
			-DCONFIGURATION_PACKAGE_SUFFIX_QTUTILITIES:STRING="-qt6"
			-DQT_PACKAGE_PREFIX:STRING='Qt6'
		)
	fi

	cmake_src_configure
}
