# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11,12} )

inherit cmake python-single-r1 xdg

DESCRIPTION="A fast and flexible keyboard launcher"
HOMEPAGE="https://albertlauncher.github.io/"

I18N_COMMIT="a8346c93bde7853e541ca95dcfab9d4fbcb87677"
PLUGINS_COMMIT="1406019cd47146e5210759814408c18c9f7e6bc8"
PYTHON_EXTENSIONS_COMMIT="faeddafbb1cb6781549ac789adf338c97491dc6c"

SRC_URI="
	https://github.com/albertlauncher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/albertlauncher/i18n/archive/${I18N_COMMIT}.tar.gz -> ${PN}-i18n-${I18N_COMMIT}.tar.gz
	https://github.com/albertlauncher/plugins/archive/${PLUGINS_COMMIT}.tar.gz -> ${PN}-plugins-${PLUGINS_COMMIT}.tar.gz
	python-extensions? ( https://github.com/albertlauncher/python/archive/${PYTHON_EXTENSIONS_COMMIT}.tar.gz -> ${PN}-python-extensions-${PYTHON_EXTENSIONS_COMMIT}.tar.gz )
"

LICENSE="all-rights-reserved"	# unclear licensing #766129
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +python +python-extensions"

REQUIRED_USE="
	python-extensions? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RESTRICT="mirror bindist"

BDEPEND="
	dev-qt/qttools:6[linguist]
"
DEPEND="${RDEPEND}
	python? ( $(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]') )
	x11-base/xorg-proto"
RDEPEND="
	app-arch/libarchive:=
	dev-libs/qhotkey[qt6]
	dev-qt/qt5compat:6[qml]
	dev-qt/qtbase:6[concurrent,dbus,gui,network,sql,sqlite,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtscxml:6[qml]
	dev-qt/qtsvg:6
	sci-libs/libqalculate:=
	python? (
		$(python_gen_cond_dep 'dev-python/urllib3[${PYTHON_USEDEP}]')
		${PYTHON_DEPS}
	)
"

PATCHES=("${FILESDIR}/${PN}-0.22.4-use-system-qhotkey-libraries-and-headers.patch")

src_prepare() {
	mv "${WORKDIR}"/i18n-${I18N_COMMIT}/* "${S}"/i18n || die
	mv "${WORKDIR}"/plugins-${PLUGINS_COMMIT}/* "${S}"/plugins || die
	if use python-extensions; then
		mv "${WORKDIR}"/python-${PYTHON_EXTENSIONS_COMMIT}/* "${S}"/plugins/python/plugins || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DEBUG=$(usex debug)
		-DBUILD_PYTHON=$(usex python)
	)

	cmake_src_configure
}
