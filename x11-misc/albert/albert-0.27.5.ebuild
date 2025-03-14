# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake python-single-r1 xdg

DESCRIPTION="A fast and flexible keyboard launcher"
HOMEPAGE="https://albertlauncher.github.io/"

I18N_COMMIT="d673298e7f945ce36fc9eea1642ff3def7f96357"
PLUGINS_COMMIT="2cacd9be71488ffdb3616ccf695954e8a9089d18"
PYTHON_EXTENSIONS_COMMIT="41f93b9506dacb6414ed7bad2826d13c97020bed"
PYBIND11_COMMIT="a2e59f0e7065404b44dfe92a28aca47ba1378dc4"
QHOTKEY_COMMIT="a68a5f03d89b5edf3c10f18cbf7e072f0726282b"
QNOTIFICATION_COMMIT="5370789111dadf97119ef7a42d64ef9aff3d79d7"

SRC_URI="
	https://github.com/albertlauncher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/albertlauncher/i18n/archive/${I18N_COMMIT}.tar.gz -> ${PN}-i18n-${I18N_COMMIT}.tar.gz
	https://github.com/albertlauncher/plugins/archive/${PLUGINS_COMMIT}.tar.gz -> ${PN}-plugins-${PLUGINS_COMMIT}.tar.gz
	https://codeload.github.com/QtCommunity/QNotification/tar.gz/${QNOTIFICATION_COMMIT} -> ${PN}-qnotification-${QNOTIFICATION_COMMIT}.tar.gz
	https://codeload.github.com/QtCommunity/QHotkey/tar.gz/${QHOTKEY_COMMIT} -> ${PN}-qhotkey-${QHOTKEY_COMMIT}.tar.gz
	python? ( https://codeload.github.com/pybind/pybind11/tar.gz/${PYBIND11_COMMIT} -> ${PN}-pybind11-${PYBIND11_COMMIT}.tar.gz )
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
	python? (
		$(python_gen_cond_dep 'dev-python/urllib3[${PYTHON_USEDEP}]')
		${PYTHON_DEPS}
	)
"

src_prepare() {
	mv "${WORKDIR}"/i18n-${I18N_COMMIT}/* "${S}"/i18n || die
	mv "${WORKDIR}"/plugins-${PLUGINS_COMMIT}/* "${S}"/plugins || die
	mv "${WORKDIR}"/QHotkey-${QHOTKEY_COMMIT}/* "${S}"/lib/QHotkey || die
	mv "${WORKDIR}"/QNotification-${QNOTIFICATION_COMMIT}/* "${S}"/lib/QNotification || die
	if use python; then
		mv "${WORKDIR}"/pybind11-${PYBIND11_COMMIT}/* "${S}"/plugins/python/pybind11 || die
	fi
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
