# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="French grammar checker extension for LibreOffice."
HOMEPAGE="https://grammalecte.net/"
SRC_URI="https://grammalecte.net/${PN}/oxt/${PN^}-fr-v${PV}.oxt"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="
	|| (
		app-office/libreoffice
		app-office/libreoffice-bin
		app-office/libreoffice-bin-debug
	)
"

S="${WORKDIR}"

src_unpack() {
	unzip -q "${DISTDIR}/${A}" -d "${PN}" || die "Unzip failed."
}

src_install() {
	find "${S}/${PN}" \( -type d -exec chmod 755 {} \; \) -o \( -type f -exec chmod 644 {} \; \) || die "Setting permissions failed."
	insinto "/usr/$(get_libdir)/libreoffice/share/extensions"
	doins -r "${S}/${PN}"
}
