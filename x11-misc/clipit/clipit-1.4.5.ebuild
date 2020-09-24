# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools gnome2-utils xdg-utils

DESCRIPTION="Lightweight GTK+ clipboard manager. Fork of Parcellite."
HOMEPAGE="http://gtkclipit.sourceforge.net https://github.com/CristianHenzel/ClipIt"
SRC_URI="https://github.com/CristianHenzel/ClipIt/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/ClipIt-${PV}"

LICENSE="GPL-3"
SLOT="0"
IUSE="nls +gtk3 appindicator"

REQUIRED_USE="appindicator? ( gtk3 )"

COMMON_DEPENDS="
	!gtk3? ( >=x11-libs/gtk+-2.10:2 )
	gtk3? (
		x11-libs/gtk+:3
		appindicator? ( dev-libs/libappindicator:3 )
	)
	>=dev-libs/glib-2.14
"
DEPEND="${COMMON_DEPENDS}
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)
"
RDEPEND="${COMMON_DEPENDS}
	x11-misc/xdotool
"

src_prepare(){
	default_src_prepare
	eautoreconf
}

src_configure(){
	econf \
		$(use_enable nls) \
		$(use_enable appindicator) \
		$(use_with gtk3)
}

pkg_preinst(){
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
