# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake gnome2

DESCRIPTION="EteSync plugin for Evolution"
HOMEPAGE="https://gitlab.gnome.org/GNOME/evolution-etesync"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/json-glib
	dev-libs/libgee
	gnome-extra/evolution-data-server
	mail-client/evolution
	net-libs/libetebase"

src_prepare() {
	cmake_src_prepare
	gnome2_src_prepare
}

src_configure() {
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}
