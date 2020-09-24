# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson xdg

DESCRIPTION="A distraction free Markdown editor for GNU/Linux made with GTK+"
HOMEPAGE="https://somas.pages.gitlab.gnome.org/apostrophe"
SRC_URI="https://gitlab.gnome.org/somas/apostrophe/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-text/gspell
	dev-libs/gobject-introspection
	dev-python/regex
	dev-python/pycairo
	dev-python/pyenchant
	dev-python/pygobject
	dev-python/pypandoc
	dev-python/python-levenshtein
	gnome-base/gsettings-desktop-schemas
	net-libs/webkit-gtk
"
DEPEND="gnome-base/gsettings-desktop-schemas"

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
