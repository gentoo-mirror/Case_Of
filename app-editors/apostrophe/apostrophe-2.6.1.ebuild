# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )

inherit distutils-r1 gnome2-utils meson xdg

DESCRIPTION="A distraction free Markdown editor for GNU/Linux made with GTK+"
HOMEPAGE="https://apps.gnome.org/app/org.gnome.gitlab.somas.Apostrophe"
SRC_URI="https://gitlab.gnome.org/somas/apostrophe/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-text/gspell[introspection]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pypandoc[${PYTHON_USEDEP}]
	dev-python/python-levenshtein[${PYTHON_USEDEP}]
	gnome-base/gsettings-desktop-schemas
	>=gui-libs/libhandy-1.6.1:1[introspection]
	net-libs/webkit-gtk[introspection]
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
"
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/sassc
	dev-libs/glib
	dev-libs/gobject-introspection
	sys-devel/gettext
"
DEPEND="
	gnome-base/gsettings-desktop-schemas
	test? ( dev-libs/appstream-glib )
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
