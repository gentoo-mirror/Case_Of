# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson

DESCRIPTION="Todo application for those who prefer simplicity"
HOMEPAGE="https://github.com/mrvladus/Errands"
SRC_URI="https://github.com/mrvladus/Errands/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0"

RESTRICT="mirror"

RDEPEND="
	app-crypt/libsecret
	dev-python/caldav
	dev-python/icalendar
	dev-python/pygobject
	gui-libs/libadwaita
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/Errands-${PV}"

src_install() {
	meson_src_install
	chmod +x "${ED}/usr/bin/errands" || die
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
