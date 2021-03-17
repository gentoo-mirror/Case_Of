# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 gnome2-utils meson xdg

DESCRIPTION="A distraction free Markdown editor for GNU/Linux made with GTK+"
HOMEPAGE="https://somas.pages.gitlab.gnome.org/apostrophe"
SRC_URI="https://gitlab.gnome.org/somas/apostrophe/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REGUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-text/gspell
	dev-libs/gobject-introspection
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pypandoc[${PYTHON_USEDEP}]
	dev-python/python-levenshtein[${PYTHON_USEDEP}]
	gnome-base/gsettings-desktop-schemas
	gui-libs/libhandy:1
	net-libs/webkit-gtk
"
DEPEND="
	${PYTHON_DEPS}
	gnome-base/gsettings-desktop-schemas
"

S="${WORKDIR}/${PN}-v${PV}"

src_test() {
	glib-compile-schemas "${BUILD_DIR}"/data
	GSETTINGS_SCHEMA_DIR="${BUILD_DIR}"/data
	meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
