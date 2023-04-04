# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORKAWESOME_PV="1.2.0"

inherit cmake

DESCRIPTION="Library that bundles ForkAwesome for use within Qt applications"
HOMEPAGE="https://github.com/Martchus/qtforkawesome"
SRC_URI="https://github.com/Martchus/qtforkawesome/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ForkAwesome/Fork-Awesome/archive/refs/tags/${FORKAWESOME_PV}.tar.gz -> Fork-Awesome-${FORKAWESOME_PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="dev-perl/YAML-LibYAML
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-libs/qtutilities"
RDEPEND="${DEPEND}
	media-libs/freetype:2[brotli]"

RESTRICT="mirror"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS:BOOL=$(usex !static-libs)
		-DBUILDIN_TRANSLATIONS:BOOL=ON
		-DFORK_AWESOME_FONT_FILE="${WORKDIR}/Fork-Awesome-${FORKAWESOME_PV}/fonts/forkawesome-webfont.woff2"
		-DFORK_AWESOME_ICON_DEFINITIONS="${WORKDIR}/Fork-Awesome-${FORKAWESOME_PV}/src/icons/icons.yml"
	)
	cmake_src_configure
}
